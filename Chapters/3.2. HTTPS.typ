== Uso de HTTPS y certificados SSL/TLS
El protocolo HTTPS (HyperText Transfer Protocol Secure) es una versión segura de HTTP que utiliza SSL/TLS (Secure Sockets Layer / Transport Layer Security) para cifrar la comunicación entre el servidor web y los clientes. Implementar HTTPS en Apache es fundamental para proteger la información sensible y evitar ataques como la intercepción de datos (Man-in-the-Middle).

=== Instalación de módulos SSL en Apache
Antes de habilitar HTTPS, es necesario asegurarse de que el módulo SSL está instalado y activado. En la @instalacion-modulos, ya se instaló el módulo `mod_ssl` para habilitar conexiones seguras.

Se puede ejecutar el siguiente comando para verificar si SSL está habilitado en Apache:

Ejemplo para David.

```bash
apachectl -M | grep ssl
```
Si devuelve `ssl_module (shared)`, significa que el módulo está activo.

=== Obtener un certificado SSL
Para habilitar HTTPS, se necesita un certificado SSL/TLS. Existen varias opciones para obtener un certificado, pero para este entorno de pruebas se creará un certificado autofirmado.

Para generar un certificado autofirmado, ejecutar el siguiente comando:
```bash
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/apache-selfsigned.key -out /etc/ssl/certs/apache-selfsigned.crt
```

=== Configurar Apache para usar HTTPS
Después de obtener el certificado, es necesario modificar la configuración de Apache para habilitar HTTPS. Para ello, se crea un nuevo `VirtualHost` en el archivo de configuración de Apache.

Este es un ejemplo de configuración para un `VirtualHost` que escucha en el puerto 443 (HTTPS) y utiliza el certificado autofirmado:

```bash
<VirtualHost *:443>
    ServerAdmin admin@example.com
    ServerName localhost
    DocumentRoot /var/www/html

    SSLEngine on
    SSLCertificateFile /etc/ssl/certs/apache-selfsigned.crt
    SSLCertificateKeyFile /etc/ssl/private/apache-selfsigned.key

    <FilesMatch "\.(cgi|shtml|phtml|php)$">
        SSLOptions +StdEnvVars
    </FilesMatch>

    <Directory /var/www/html>
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

=== Redirigir todo el tráfico HTTP a HTTPS
Para asegurarse de que todas las conexiones se realicen por HTTPS, crear un nuevo `VirtualHost` que redirija el tráfico HTTP al puerto 443 (HTTPS).

```bash
<VirtualHost *:80>
    ServerName localhost
    Redirect permanent / https://localhost/
</VirtualHost>
```
Guardar los cambios y reiniciar Apache:

```bash
sudo systemctl restart apache2
```
=== Configuración segura de SSL/TLS
Para mejorar la seguridad del protocolo TLS, se recomienda realizar algunas configuraciones en el fichero de configuración de Apache visto en la @configuracion-apache2.conf:

- Deshabilitar versiones obsoletas de SSL/TLS (como TLS 1.0 y 1.1):

  ```bash
  SSLProtocol -all +TLSv1.2 +TLSv1.3
  ```
- Configurar cifrados seguros:
  ```bash
  SSLCipherSuite HIGH:!aNULL:!MD5:!3DES
  SSLHonorCipherOrder on
  ```
- Habilitar HSTS (HTTP Strict Transport Security), para evitar que los navegadores carguen el sitio sin HTTPS:
  ```bash
  Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains"
  ```
