= Configuración de seguridad en Apache
== Configuración del archivo `apache2.conf` <configuracion-apache2.conf>

El archivo de configuración principal de Apache, `apache2.conf`, juega un papel importante en la seguridad del servidor web. Una configuración incorrecta en este archivo puede exponer el sistema a ataques. Por ello, es importante tener una configuración adecuada, ya que ayuda a minimizar riesgos y reforzar la protección del servidor.

En sistemas basados en Debian, el archivo se encuentra en *`/etc/apache2/apache2.conf`*.

=== Asegurar que Apache se ejecute con un usuario y grupo no privilegiado
Por defecto en Debian, Apache se ejecuta con el usuario `www-data` y el grupo `www-data`. Esto es importante para limitar los privilegios del servidor web y reducir el impacto de posibles vulnerabilidades. Para verificar el grupo y usuario con el que se ejecuta Apache, se puede usar el comando:

```bash
ps aux | grep apache
```

```bash
root@debian:/# ps aux | grep apache
root        3470  0.0  0.0  12984  7160 ?        Ss   11:14   0:00 /usr/sbin/apache2 -k start
www-data    3473  0.0  0.1 2004084 13348 ?       Sl   11:14   0:00 /usr/sbin/apache2 -k start
www-data    3474  0.0  0.1 2004084 13348 ?       Sl   11:14   0:00 /usr/sbin/apache2 -k start
root        3535  0.0  0.0   3324  1488 pts/0    S+   11:42   0:00 grep apache
```

Aunque el proceso principal se inicia como `root`, los procesos hijos se ejecutan como `www-data`. Si esto no es así, se puede cambiar el usuario y grupo en el fichero de configuración modificando las siguientes líneas:
```sh
User www-data
Group www-data
```

=== Ocultar la versión de Apache

De forma predeterminada, Apache envía información detallada en las respuestas HTTP, como la versión del servidor y los módulos habilitados. Esto puede ser aprovechado por atacantes para identificar vulnerabilidades específicas. Para evitarlo, se deben modificar las siguientes líneas en la configuración:

```bash
ServerTokens Prod
ServerSignature Off
```
- *`ServerTokens Prod`*: Reduce la cantidad de información sobre el servidor enviada en las cabeceras HTTP. Solo muestra "Apache" en lugar de detalles de versión y sistema operativo.
- *`ServerSignature Off`*: Desactiva la firma del servidor en las páginas de error y directorios listados.

=== Deshabilitar ficheros `.htaccess`
Los archivos `.htaccess` permiten configuraciones específicas de directorios, extendiendo la configuración global de Apache. Sin embargo, su uso puede ser un riesgo de seguridad si no se controla adecuadamente. La opción `AllowOverride` controla qué directivas presentes dentro de un fichero `.htaccess` se consideran válidas.

Se recomienda deshabilitar completamente estos ficheros en el directorio raíz del servidor::

```bash
<Directory />
    AllowOverride None
</Directory>
```
En caso de querer habilitarlo para un directorio específico, se puede hacer de la siguiente manera:

```bash
<Directory "/var/www/html">
    # Permite que los archivos .htaccess modifiquen la configuración.
    AllowOverride All
</Directory>
```

O bien si solo se desea permitir ciertas directivas:

```bash
<Directory "/var/www/html">
    AllowOverride AuthConfig Indexes
</Directory>
```

- De esta manera, solo se permiten las directivas `AuthConfig` y `Indexes` en los archivos `.htaccess` del directorio `/var/www/html`.

=== Restringir el acceso a archivos y directorios
Es importante definir permisos estrictos para evitar accesos no autorizados a archivos del servidor. Por ejemplo, bloquear el acceso a archivos de configuración sensibles, como `.htaccess`, `.env` o copias de seguridad.

Para ello se puede añadir la siguiente configuración:

```bash
<FilesMatch "^\.ht">
    Require all denied
</FilesMatch>

<FilesMatch "(\.bak|\.old|\.orig|\.backup)$">
    Require all denied
</FilesMatch>
```

Esto bloquea el acceso a archivos que comiencen con `.ht` (por ejemplo, `.htaccess`) y archivos con extensiones de copia de seguridad como `.bak`, `.old`, `.orig`, `.backup`.

=== Prevenir ataques de recorrido de directorios
Para evitar que atacantes accedan a archivos fuera del directorio web, se debe configurar adecuadamente la opción `AllowOverride` y establecer permisos en los directorios.

Asegurar que el acceso al directorio raíz esté restringido:

```bash
<Directory />
    Options None
    AllowOverride None
    Require all denied
</Directory>
```
Luego, definir permisos solo para el directorio que contiene los archivos del sitio web, por ejemplo:

```bash
<Directory "/var/www/html">
# Evita que los atacantes puedan ver el contenido de un directorio sin un index.html.
    Options Indexes FollowSymLinks

# Evita que archivos .htaccess modifiquen configuraciones globales.
    AllowOverride None

# Permite acceso solo al contenido del sitio, no a otros directorios.
    Require all granted
</Directory>
```

=== Limitar el tamaño de las solicitudes HTTP
Para evitar ataques de denegación de servicio (DoS) que envían solicitudes HTTP extremadamente grandes, se recomienda establecer límites en el tamaño de los encabezados y el cuerpo de las peticiones.

Añadir las siguientes líneas en `httpd.conf`:

```bash
# Limita el tamaño del cuerpo de la solicitud a 10 MB.
LimitRequestBody 10485760

# Restringe la cantidad de encabezados HTTP en una solicitud a 50.
LimitRequestFields 50

# Limita el tamaño de cada encabezado a 4 KB.
LimitRequestFieldSize 4094

# Restringe la longitud de la línea de solicitud HTTP a 8 KB.
LimitRequestLine 8190
```

=== Habilitar logs de seguridad
Tener acceso a los registros del servidor es fundamental para detectar intentos de ataque o actividades sospechosas. Es recomendable establecer la ubicación y nivel de detalle de los logs en la configuración.

```bash
# Define la ubicación del log de errores.
ErrorLog "/var/log/apache2/error.log"

# Establece el nivel de detalle de los logs (puede ser info, warn, error, etc.).
LogLevel warn
# Guarda registros detallados de accesos al servidor.
CustomLog "/var/log/apache2/access.log" combined
```

=== Hardening de cabeceras

Las cabeceras HTTP son una parte importante de la seguridad del servidor web. Se pueden configurar para mejorar la seguridad y proteger contra ciertos tipos de ataques. Por ejemplo, se pueden establecer cabeceras de seguridad como `X-Frame-Options`, `X-XSS-Protection`, `X-Content-Type-Options` y `Content-Security-Policy`.

- *`X-Frame-Options`*: Evita ataques de _clickjacking_, especificando si un navegador debe permitir que una página web se muestre en un `iframe`. Para configurarlo, se puede añadir la siguiente línea:
  ```bash
  Header always set X-Frame-Options "SAMEORIGIN"
  ```

- *`X-XSS-Protection`*: Activa la protección contra ataques de _cross-site scripting_ (XSS) en los navegadores más antiguos. Para habilitarlo, se puede añadir:
  ```bash
  Header always set X-XSS-Protection "1; mode=block"
  ```

- *`X-Content-Type-Options`*: Evita ataques que intentan adivinar el tipo de contenido al forzar al navegador a respetar el tipo declarado en la cabecera `Content-Type`. Para configurarlo, se puede añadir:
  ```bash
  Header always set X-Content-Type-Options "nosniff"
  ```

- *`Content-Security-Policy`*: Define las fuentes de contenido permitidas en una página web, ayudando a prevenir ataques de inyección de código. Por ejemplo, para permitir solo contenido de la misma fuente, se puede añadir:
  ```bash
  Header always set Content-Security-Policy "default-src 'self'"
  ```

=== Aplicar y verificar la configuración
Después de realizar cambios en la configuración, es importante verificar la sintaxis antes de reiniciar Apache:

```bash
apachectl configtest
```
Si no hay errores, reiniciar el servicio para aplicar las modificaciones:

```bash
sudo systemctl restart apache2
```
