## Gestión de Permisos de Usuarios en SQL Server
*Descripción:*

Este repositorio contiene un conjunto de scripts SQL Server diseñados para:

Identificar permisos de usuarios: Desarrollar un procedimiento almacenado (SP) que permite determinar los permisos específicos asignados a un usuario sobre una entidad determinada dentro de un modelo relacional.
Poblar el modelo de datos: Crear un script de inserción para poblar la base de datos con datos de prueba, facilitando la validación y el desarrollo.
Consultar entidades y permisos: Implementar un SP flexible que permite consultar de manera dinámica cualquier entidad y los permisos asociados a sus registros.
Funcionalidades Clave:

Flexibilidad: El SP de consulta permite seleccionar cualquier entidad y obtener los permisos correspondientes.
Eficiencia: Los scripts están optimizados para un rendimiento eficiente, especialmente en bases de datos de gran tamaño.
Claridad: La documentación y los comentarios en los scripts facilitan la comprensión y el mantenimiento.
Estructura del Repositorio:

scripts: Contiene los scripts SQL para crear los SPs, poblar la base de datos y realizar las consultas.
documentación: Documentación adicional, como diagramas de base de datos, ejemplos de uso y consideraciones de diseño.
Uso:

Clonar el repositorio: Utiliza git clone para obtener una copia local del repositorio.
Crear la base de datos: Ejecuta el script de creación de la base de datos.
Poblar la base de datos: Ejecuta el script de inserción de datos.
Ejecutar los SPs: Utiliza SQL Server Management Studio o una herramienta similar para ejecutar los SPs con los parámetros correspondientes.
Ejemplos de Uso:

SQL
-- Obtener permisos del usuario 3 para la entidad BranchOffice con ID 3
EXEC ObtenerPermisosUsuario 3, 'BranchOffice', 3;

  
