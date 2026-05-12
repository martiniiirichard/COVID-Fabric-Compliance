USE CovidMedallionPOC;
GO

SELECT
    s.name AS schema_name,
    t.name AS table_name,
    c.column_id,
    c.name AS column_name,
    ty.name AS data_type,
    c.max_length
FROM sys.tables t
JOIN sys.schemas s ON t.schema_id = s.schema_id
JOIN sys.columns c ON t.object_id = c.object_id
JOIN sys.types ty ON c.user_type_id = ty.user_type_id
WHERE s.name = 'bronze'
ORDER BY t.name, c.column_id;
GO

SELECT
    OBJECT_SCHEMA_NAME(object_id) AS schema_name,
    name AS view_name,
    OBJECT_DEFINITION(object_id) AS view_definition
FROM sys.views
WHERE OBJECT_SCHEMA_NAME(object_id) IN ('silver', 'gold')
ORDER BY schema_name, view_name;
GO
