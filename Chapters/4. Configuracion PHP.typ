= Configuración de PHP
El archivo de configuración de PHP (php.ini) controla el comportamiento del lenguaje. Su ubicación en Debian es en *`/etc/php/8.2/apache2/php.ini`*.

A continuación, se presentan las principales configuraciones de seguridad que deben modificarse:

== Deshabilitar la exposición de la versión de PHP
Para evitar que atacantes obtengan información sobre la versión de PHP, desactivar la cabecera que la expone:
```ini
expose_php = Off
```

== Restringir funciones peligrosas
Algunas funciones de PHP permiten la ejecución de comandos en el sistema, lo que puede ser aprovechado en ataques de ejecución remota de código. Se recomienda deshabilitarlas:

```ini
disable_functions = exec,passthru,shell_exec,system,proc_open,popen,curl_exec,curl_multi_exec,parse_ini_file,show_source
```
Si alguna función es necesaria para la aplicación, debe evaluarse cuidadosamente antes de habilitarla.

== Limitar el acceso a archivos fuera del directorio permitido
Para evitar que PHP acceda a archivos sensibles del sistema, se puede restringir su alcance a un directorio específico:

```ini
open_basedir = "/var/www/html/:/tmp/"
```

== Deshabilitar el uso de `allow_url_fopen` y `allow_url_include`
Estas opciones permiten incluir archivos remotos en PHP, lo que puede facilitar ataques de inclusión de archivos remotos (RFI). Se pueden desactivar estas opciones de la siguiente manera:

```ini
allow_url_fopen = Off
allow_url_include = Off
```

== Restringir la carga de archivos y el tamaño de las peticiones
Para evitar ataques que usen archivos maliciosos o denegación de servicio (DoS) mediante cargas masivas de datos, es recomendable establecer límites:

```ini
upload_max_filesize = 8M
post_max_size = 10M
```
Esto limita el tamaño de los archivos subidos a `8MB` y el tamaño total de la petición a `10MB`.

== Habilitar `error_log` y deshabilitar `display_errors`
Mostrar errores en producción puede exponer información sensible. Se recomienda registrarlos en un archivo de log en lugar de mostrarlos en pantalla:

```ini
log_errors = On
error_log = /var/log/php_errors.log
display_errors = Off
display_startup_errors = Off
```

Después de modificar `php.ini`, reiniciar Apache para aplicar los cambios:

```bash
sudo systemctl restart apache2
```
