= Instalación segura de Apache
Para garantizar la seguridad de un servidor web Apache, es fundamental comenzar con una instalación adecuada. Una configuración incorrecta desde el inicio puede dejar vulnerabilidades abiertas, facilitando ataques o comprometiendo la integridad del sistema. A continuación, se detallan los pasos esenciales para una instalación segura de Apache en un servidor Debian.

== Descarga e instalación
La primera medida de seguridad es asegurarse de obtener Apache desde fuentes oficiales o repositorios confiables del sistema operativo. Esto evita el riesgo de instalar versiones modificadas con código malicioso.

En sistemas basados en Debian, se recomienda instalar Apache desde los repositorios oficiales ejecutando:
```bash
sudo apt update && sudo apt install apache2
```
Para verificar la versión instalada de Apache, ejecutar:
```bash
apachectl -v
```

== Instalación de módulos de seguridad <instalacion-modulos>
Apache permite la instalación de módulos adicionales que refuerzan su seguridad. En este documento se utilizará el módulo `mod_ssl` para habilitar las conexiones seguras mediante HTTPS. Para activarlo, ejecutar:

```bash
sudo a2enmod ssl
```

También se utilizará el módulo `mod_headers` para configurar cabeceras HTTP personalizadas. Para habilitarlo, al igual que antes, ejecutar:
```bash
sudo a2enmod headers
```

== Instalación de PHP
Para esta demostración, se servirá un servidor web con PHP. Para instalar PHP y junto con Apache se puede ejecutar el siguiente comando:
```bash
sudo apt install php-common libapache2-mod-php
```
