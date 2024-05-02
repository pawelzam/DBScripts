DECLARE @sql NVARCHAR(2000)

WHILE(EXISTS(SELECT 1 from INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_TYPE='FOREIGN KEY'))
BEGIN
    SELECT TOP 1 @sql=('ALTER TABLE ' + TABLE_SCHEMA + '.[' + TABLE_NAME + '] DROP CONSTRAINT [' + CONSTRAINT_NAME + ']')
    FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_TYPE = 'FOREIGN KEY'
    EXEC(@sql)
    PRINT @sql
END

WHILE(EXISTS(SELECT * from INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'VIEW' and TABLE_NAME != 'database_firewall_rules'))
BEGIN
    SELECT TOP 1 @sql=('DROP VIEW ' + TABLE_SCHEMA + '.[' + TABLE_NAME + ']')
    FROM INFORMATION_SCHEMA.TABLES
    WHERE  TABLE_TYPE = 'VIEW' and TABLE_NAME != 'database_firewall_rules'
    EXEC(@sql)
    PRINT @sql
END

WHILE(EXISTS(select *
from sys.tables t
    left outer join sys.tables h
        on t.history_table_id = h.object_id
where t.temporal_type = 2))
BEGIN
    select TOP 1 @sql = 'ALTER TABLE ' + schema_name(t.schema_id) + '.[' + t.name + '] SET ( SYSTEM_VERSIONING = Off )'
    from sys.tables t
        left outer join sys.tables h
            on t.history_table_id = h.object_id
    where t.temporal_type = 2
    EXEC(@sql)
    PRINT @sql
END

WHILE(EXISTS(SELECT * from INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME != '__MigrationHistory' AND TABLE_NAME != 'database_firewall_rules' AND TABLE_TYPE != 'VIEW'))
BEGIN
    SELECT TOP 1 @sql=('DROP TABLE ' + TABLE_SCHEMA + '.[' + TABLE_NAME + ']')
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_NAME != '__MigrationHistory' AND TABLE_NAME != 'database_firewall_rules' 
    EXEC(@sql)
    PRINT @sql
END

while (exists(select * from sys.objects where [type] = 'P'))
begin
    SELECT top 1  @sql= 'DROP PROCEDURE [' + SCHEMA_NAME(schema_id) + '].[' + NAME + '];' from sys.objects where [type] = 'P'
    EXEC(@sql)
    PRINT @sql
end

while (exists(select * from sys.objects where [type] IN ('TF','FN')))
begin
    SELECT top 1  @sql= 'DROP FUNCTION [' + SCHEMA_NAME(schema_id) + '].[' + NAME + '];' from sys.objects where [type] IN ('TF','FN')
    EXEC(@sql)
    PRINT @sql
end