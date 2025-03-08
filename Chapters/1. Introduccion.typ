= Introducción

En la actualidad, la seguridad en internet es un aspecto fundamental para cualquier empresa, organización o usuario que administre un sitio web. Los servidores web, encargados de gestionar y distribuir el contenido en la red, son uno de los principales objetivos de los ciberdelincuentes. Ataques como inyecciones de código, accesos no autorizados, ataques de denegación de servicio (DDoS) y robo de información son algunas de las amenazas que pueden comprometer la estabilidad y la seguridad de un servidor web mal configurado. @cenzic2014

Apache es uno de los servidores web más utilizados en el mundo gracias a su código abierto, flexibilidad y amplia comunidad de soporte. Sin embargo, su popularidad también lo convierte en un blanco frecuente de ataques. Para garantizar su funcionamiento seguro, es imprescindible implementar configuraciones adecuadas, reforzar el acceso a los datos y aplicar medidas de protección contra posibles vulnerabilidades.

En este documento, se analizarán las mejores prácticas para la instalación y configuración de un servidor web Apache seguro. Se abordarán aspectos clave como la protección del acceso, el uso de certificados SSL/TLS, la configuración de seguridad en el servidor y el monitoreo de posibles amenazas. Con estas medidas, se busca garantizar la integridad, confidencialidad y disponibilidad de los servicios web, ofreciendo una experiencia más segura tanto para los administradores como para los usuarios finales.


== Ataques más comunes
Un servidor web expuesto a internet puede ser objetivo de numerosos ataques cibernéticos. Los atacantes buscan explotar vulnerabilidades en la configuración del servidor, el software utilizado o el código de las aplicaciones web alojadas. A continuación, se describen algunos de los ataques más comunes y su funcionamiento.

=== Inyección SQL
Este ataque ocurre cuando un atacante introduce comandos SQL maliciosos en un formulario web o en una URL vulnerable para manipular la base de datos del servidor. Puede permitir el robo de información confidencial, la modificación de datos o incluso el borrado de registros.

=== Cross-Site Scripting (XSS)
Este ataque consiste en inyectar scripts maliciosos en páginas web vistas por otros usuarios. Puede ser usado para robar cookies, redirigir tráfico a sitios fraudulentos o modificar el contenido de la página.

Esto puede ocurrir por ejemplo, si un sitio web permite ingresar comentarios sin sanitizar la entrada, un atacante puede insertar código JavaScript que se ejecutará en el navegador de otros usuarios al visitar la página.

=== Ataques de Fuerza Bruta
Este tipo de ataque intenta adivinar credenciales de acceso mediante la prueba sistemática de combinaciones de usuario y contraseña. Existen herramientas automáticas que realizan miles de intentos por segundo para encontrar credenciales válidas.

=== Denegación de Servicio (DoS) y Ataques Distribuidos (DDoS)
En estos ataques, un atacante sobrecarga el servidor con una gran cantidad de solicitudes, dejándolo inaccesible para usuarios legítimos. En los ataques DDoS, la carga proviene de múltiples dispositivos comprometidos (botnets).
