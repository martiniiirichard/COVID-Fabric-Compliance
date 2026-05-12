USE CovidMedallionPOC;
GO

SELECT
    required.table_name,
    CASE WHEN OBJECT_ID(required.object_name, 'U') IS NULL THEN 'MISSING' ELSE 'EXISTS' END AS table_status
FROM (VALUES
    ('bronze.epidemiology', 'bronze.epidemiology'),
    ('bronze.hospitalizations', 'bronze.hospitalizations'),
    ('bronze.deaths', 'bronze.deaths'),
    ('bronze.mobility', 'bronze.mobility'),
    ('bronze.demographics', 'bronze.demographics'),
    ('bronze.lawatlas_emergency_declarations', 'bronze.lawatlas_emergency_declarations'),
    ('bronze.us_counties_2022', 'bronze.us_counties_2022')
) AS required(table_name, object_name);
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
  AND t.name IN ('mobility', 'us_counties_2022')
ORDER BY t.name, c.column_id;
GO

SELECT
    'bronze.mobility expected first columns' AS check_name,
    CASE
        WHEN COL_LENGTH('bronze.mobility', 'date_col') IS NOT NULL
         AND COL_LENGTH('bronze.mobility', 'location_key') IS NOT NULL
         AND COL_LENGTH('bronze.mobility', 'mobility_workplaces') IS NOT NULL
        THEN 'PASS'
        ELSE 'FAIL'
    END AS result;
GO
