-- poblar permission 
DECLARE @counter INT = 1;
DECLARE @name NVARCHAR(255);
DECLARE @description NVARCHAR(MAX);
DECLARE @can_create BIT, @can_read BIT, @can_update BIT, @can_delete BIT, @can_import BIT, @can_export BIT;

-- Recorremos todas las combinaciones posibles de permisos (64 combinaciones)
WHILE @counter <= 64
BEGIN
    -- Calculamos los valores de los permisos a partir del contador (en formato binario)
    SET @can_create = (CASE WHEN @counter & 1 = 1 THEN 1 ELSE 0 END);
    SET @can_read = (CASE WHEN @counter & 2 = 2 THEN 1 ELSE 0 END);
    SET @can_update = (CASE WHEN @counter & 4 = 4 THEN 1 ELSE 0 END);
    SET @can_delete = (CASE WHEN @counter & 8 = 8 THEN 1 ELSE 0 END);
    SET @can_import = (CASE WHEN @counter & 16 = 16 THEN 1 ELSE 0 END);
    SET @can_export = (CASE WHEN @counter & 32 = 32 THEN 1 ELSE 0 END);

    -- Construir el nombre y la descripción del permiso
    SET @name = 'permi_' + CAST(@counter AS NVARCHAR(10));
    
    SET @description = 'Permiso : ';
    IF @can_create = 1 SET @description = @description + 'can_create, ';
    IF @can_read = 1 SET @description = @description + 'can_read, ';
    IF @can_update = 1 SET @description = @description + 'can_update, ';
    IF @can_delete = 1 SET @description = @description + 'can_delete, ';
    IF @can_import = 1 SET @description = @description + 'can_import, ';
    IF @can_export = 1 SET @description = @description + 'can_export, ';
    
    -- Eliminar la última coma y espacio de la descripción
    IF LEN(@description) > 2 -- Verifica si hay al menos una coma
    BEGIN
        SET @description = LEFT(@description, LEN(@description) - 2); -- Elimina la última coma y espacio
    END

    -- Insertar el registro en la tabla Permission
    INSERT INTO Permission (name, description, can_create, can_read, can_update, can_delete, can_import, can_export)
    VALUES (@name, @description, @can_create, @can_read, @can_update, @can_delete, @can_import, @can_export);

    -- Aumentar el contador
    SET @counter = @counter + 1;
END;

--se puede reemplaza por un tigger para automatizar entidades en v2
INSERT INTO EntityCatalog (entit_name, entit_descrip, entit_active,entit_config)
VALUES 
('Usuarios', 'Tabla de Usuarios', 1,'User'),
('Empresas', 'Tabla de Empresas', 1,'company'),
('Sucursales', 'Tabla de Sucursales', 1,'BranchOffice'),
('CentrosCosto', 'Tabla de Centros de Costo', 1,'CostCenter');


INSERT INTO Company (compa_name, compa_tradename, compa_doctype, compa_docnum, 
                     compa_address, compa_city, compa_state, compa_country, 
                     compa_industry, compa_phone, compa_email, compa_active)
VALUES 
('Acme Corporation', 'Acme', 'NI', '12345', 
 'Calle Principal 123', 'Ciudad', 'Estado', 'País', 
 'Tecnología', '555-1234', 'contacto@acme.com', 1),
 ('Capsule Corporation', 'Capsule', 'NI', '123455', 
 'Calle Principal 123', 'Ciudad', 'Estado', 'País', 
 'Tecnología y Desarrpññp', '555-1234', '1contacto@acme.com', 1);

-- Inserción de Usuario
INSERT INTO [User] (user_username, user_password, user_email, user_is_admin, user_is_active)
VALUES 
('Sonia perez', 'password123', 'sonia.perez1@acm22e.com', 0, 1),
('Sofia Copola', 'password1234', 'copotala@acm22e.com', 0, 1),
('juan.perez', 'password123', 'juan.perez@acme.com', 0, 1),
('Pedro Paramo', 'password123', 'pp@acme.com', 0, 1);


-- Inserción de Relación Usuario-Compañí

INSERT INTO UserCompany (user_id, company_id, useco_active)
VALUES
  ((SELECT id_user FROM [User] WHERE user_username = 'Sonia perez'),
   (SELECT id_compa FROM Company WHERE compa_name = 'Acme Corporation'), 1),
   ((SELECT id_user FROM [User] WHERE user_username = 'Sofia Copola'),
   (SELECT id_compa FROM Company WHERE compa_name = 'Acme Corporation'), 1),
   ((SELECT id_user FROM [User] WHERE user_username = 'juan.perez'),
   (SELECT id_compa FROM Company WHERE compa_name = 'Acme Corporation'), 1),
  ((SELECT id_user FROM [User] WHERE user_username = 'Pedro Paramo'),
   (SELECT id_compa FROM Company WHERE compa_name = 'Acme Corporation'), 1);


-- insert centro de costos 
INSERT INTO [Permit_System_Users].[dbo].[CostCenter] 
    ([company_id], [cosce_parent_id], [cosce_code], [cosce_name], [cosce_description], [cosce_budget], [cosce_level], [cosce_active])
VALUES 
    (1, NULL, 'CC001', 'Centro de Costo 1', 'Descripción del Centro de Costo 1', 100000, 1, 1),  
    (1, NULL, 'CC002', 'Centro de Costo 2', 'Descripción del Centro de Costo 2', 200000, 1, 1),
	(1, NULL, 'CC003', 'Centro de Costo 3', 'Descripción del Centro de Costo 3', 300000, 1, 1),
	(1, NULL, 'CC004', 'Centro de Costo 4', 'Descripción del Centro de Costo 4', 400000, 1, 1); 

----- Sucursales 

INSERT INTO [Permit_System_Users].[dbo].[BranchOffice] 
    ([company_id], [broff_name], [broff_code], [broff_address], [broff_city], [broff_state], [broff_country], [broff_phone], [broff_email], [broff_active])
VALUES 
   (1, 'Oficina Central', 'OC001', 'Calle Ficticia 123', 'Ciudad Central', 'Estado Central', 'País Central', '+1234567890', 'oficina@empresa.com', 1),  -- Primer registro
    (1, 'Sucursal Norte', 'SN001', 'Avenida Norte 456', 'Ciudad Norte', 'Estado Norte', 'País Norte', '+0987654321', 'norte@empresa.com', 1),  -- Segundo registro
	(1, 'Oficina Sur', 'OC002', 'Calle Ficticia 1234', 'Ciudad sur', 'Estado sur', 'País sur', '+12345678901', '1oficina@empresa.com', 1),  
    (1, 'Sucursal Cáli', 'SN002', 'Avenida Norte 45644', 'Ciudad cali', 'Estado oriente', 'País Norte', '+0987654321', '1norte@empresa.com', 1);
	
---insert permiUser

	Insert into  [PermiUser](  [usercompany_id],[permission_id] ,[entitycatalog_id], [peusr_include])
VALUES (    
     '1', -- Inserte idUsercompay 
    '1', -- Inserte idPermiso 
    '3', -- Inserte idEntida  3 - 4 
    '1' -- include del permiso 

),(    
     '2', -- Inserte idUsercompay 
    '4', -- Inserte idPermiso 
    '3', -- Inserte idEntida  3 - 4 
    '1' -- include del permiso 

),(    
     '3', -- Inserte idUsercompay 
    '15', -- Inserte idPermiso 
    '3', -- Inserte idEntida  3 - 4 
    '1' -- include del permiso 

), (    
     '4', -- Inserte idUsercompay 
    '15', -- Inserte idPermiso 
    '3', -- Inserte idEntida  3 - 4 
    '1' -- include del permiso 

),(    
	'1', -- Inserte idUsercompay 
    '4', -- Inserte idPermiso 
    '4', -- Inserte idEntida  3 - 4 
    '1' -- include del permiso 

),(    
     '2', -- Inserte idUsercompay 
    '19', -- Inserte idPermiso 
    '4', -- Inserte idEntida  3 - 4 
    '1' -- include del permiso 

),(    
     '3', -- Inserte idUsercompay 
    '15', -- Inserte idPermiso 
    '4', -- Inserte idEntida  3 - 4 
    '1' -- include del permiso 

), (    
     '4', -- Inserte idUsercompay 
    '19', -- Inserte idPermiso 
    '4', -- Inserte idEntida  3 - 4 
    '1' -- include del permiso 

)

--------------- insert rol 

insert into [Role] (  [company_id], [role_name], [role_code], [role_description], [role_active])
	values	( 1, 'Administrador', 'ADMIN', 'Rol de administrador del sistema', 1 ),
			( 1, 'Analista', 'Analys', 'Analista de metricas', 1 ),
			( 1, 'Revisor', 'Revisor', 'Revisor de productos', 1 ),
			( 1, 'Contador', 'Contable', 'Revisor de balances finacieros', 1)

--------------------------   
---------Insert PermiRole

INSERT INTO [PermiRole] (role_id, permission_id, entitycatalog_id, perol_include, perol_record)
VALUES 
    (1, 2, 3, 1, 1),
    (1, 4, 3, 1, 2),
    (1, 6, 4, 1, 3),
    (1, 8, 4, 1, 4),
    (2, 10, 3, 1, 4),
    (2, 12, 3, 1, 3),
    (2, 14, 4, 1, 2),
    (2, 16, 4, 1, 1),
    (3, 18, 3, 1, 1),
    (3, 20, 3, 1, 2),
    (3, 22, 4, 1, 3),
    (3, 24, 4, 1, 4),
    (4, 26, 3, 1, 4),
    (4, 28, 3, 1, 3),
    (4, 30, 4, 1, 2),
    (4, 32, 4, 1, 1);
-----------------------------------------

	INSERT INTO [PermiUserRecord] (
    [usercompany_id],
    [permission_id],
    [entitycatalog_id],
    [peusr_record],
    [peusr_include]
)
SELECT
    [usercompany_id],
    [permission_id],
    [entitycatalog_id],
    0, -- Set peusr_record to 0
    [peusr_include]
FROM [Permit_System_Users].[dbo].[PermiUser];

--------------------------

  insert into PermiRoleRecord
  ([role_id],
  [permission_id],
  [entitycatalog_id],
  [perrc_record],
  [perrc_include])

SELECT
    [role_id],
    [permission_id],
    [entitycatalog_id],
    [perol_include],
	perol_record
FROM [Permit_System_Users].[dbo].[PermiRole];


