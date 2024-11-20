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

**Ejemplos de Uso:**

*SQL*
-- usuarios disponibles del 1 al 4 Y las entidad de prueba son BranchOffice id = 3 y CostCenter id = 4  
-- Obtener permisos del usuario 3 para la entidad BranchOffice con ID 3
**EXEC GetDynamicEntityData @id_entit = 3, @id_user = 1;

  
