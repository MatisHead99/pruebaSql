USE [Permit_System_Users]
GO

/****** Object:  StoredProcedure [dbo].[GetDynamicEntityData]    Script Date: 20/11/2024 04:46:46 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[GetDynamicEntityData]
    @id_entit INT,
    @id_user INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @sql NVARCHAR(MAX);
    DECLARE @tableName NVARCHAR(128);
    DECLARE @firstColumn NVARCHAR(128);

    -- Paso 1: Obtener el nombre de la tabla dinámica desde el campo entit_config
    SELECT @tableName = entit_config
    FROM EntityCatalog
    WHERE id_entit = @id_entit;

    -- Validar si el nombre de la tabla se obtuvo correctamente
    IF @tableName IS NULL
    BEGIN
        PRINT 'Error: No se encontró la tabla dinámica para el id_entit proporcionado.';
        RETURN;
    END

    -- Paso 2: Validar si la tabla existe en la base de datos
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = @tableName)
    BEGIN
        PRINT 'Error: La tabla especificada en entit_config no existe.';
        RETURN;
    END

    -- Paso 3: Obtener el nombre del primer campo de la tabla dinámica
    SELECT TOP 1 @firstColumn = COLUMN_NAME
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = @tableName
    ORDER BY ORDINAL_POSITION;

    -- Validar si se obtuvo correctamente el primer campo
    IF @firstColumn IS NULL
    BEGIN
        PRINT 'Error: No se pudo determinar el primer campo de la tabla dinámica.';
        RETURN;
    END

    -- Paso 4: Construir la consulta dinámica
    SET @sql = '
    SELECT DISTINCT
        ec.id_entit AS IDEntidad,
        ec.entit_config AS Entidad,
        u.user_username,
        r.role_name,
        p.description AS Permisos,
        t.*
    FROM EntityCatalog ec
    INNER JOIN PermiUser pu ON pu.entitycatalog_id = ec.id_entit
    INNER JOIN PermiRole pr ON pr.entitycatalog_id = ec.id_entit
    INNER JOIN UserCompany uc ON uc.id_useco = pu.usercompany_id
    INNER JOIN Company c ON c.id_compa = uc.company_id
    INNER JOIN Permission p ON p.id_permi = pr.permission_id
    INNER JOIN [Permit_System_Users].[dbo].[User] u ON u.id_user = uc.user_id
    INNER JOIN Role r ON r.id_role = pr.role_id
    INNER JOIN ' + QUOTENAME(@tableName) + ' t
        ON pr.perol_record = t.' + QUOTENAME(@firstColumn) + '
    WHERE u.id_user = @id_user
    AND ec.id_entit = @id_entit';

    -- Ejecutar la consulta dinámica
    EXEC sp_executesql @sql, N'@id_user INT, @id_entit INT', @id_user = @id_user, @id_entit = @id_entit;
END;
GO


