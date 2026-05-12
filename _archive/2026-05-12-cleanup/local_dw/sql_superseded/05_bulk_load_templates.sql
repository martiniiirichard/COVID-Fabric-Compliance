USE CovidMedallionPOC;
GO

/*
Update file paths to your machine if needed.
These templates assume comma-separated UTF-8 CSV with header row.
*/

-- Epidemiology
TRUNCATE TABLE bronze.epidemiology;
BULK INSERT bronze.epidemiology
FROM 'C:\Users\marti\Documents\Codex\COVID-Fabric-Compliance\local_dw\layers\bronze\epidemiology.csv'
WITH (
    FIRSTROW = 2,
    FORMAT = 'CSV',
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0a',
    TABLOCK,
    KEEPNULLS,
    MAXERRORS = 1000,
    CODEPAGE = '65001'
);

-- Hospitalizations
TRUNCATE TABLE bronze.hospitalizations;
BULK INSERT bronze.hospitalizations
FROM 'C:\Users\marti\Documents\Codex\COVID-Fabric-Compliance\local_dw\layers\bronze\hospitalizations.csv'
WITH (
    FIRSTROW = 2,
    FORMAT = 'CSV',
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0a',
    TABLOCK,
    KEEPNULLS,
    MAXERRORS = 1000,
    CODEPAGE = '65001'
);

-- Deaths
TRUNCATE TABLE bronze.deaths;
BULK INSERT bronze.deaths
FROM 'C:\Users\marti\Documents\Codex\COVID-Fabric-Compliance\local_dw\layers\bronze\deaths.csv'
WITH (
    FIRSTROW = 2,
    FORMAT = 'CSV',
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0a',
    TABLOCK,
    KEEPNULLS,
    MAXERRORS = 1000,
    CODEPAGE = '65001'
);
GO

SELECT 'bronze.epidemiology' AS table_name, COUNT(*) AS row_count FROM bronze.epidemiology
UNION ALL
SELECT 'bronze.hospitalizations', COUNT(*) FROM bronze.hospitalizations
UNION ALL
SELECT 'bronze.deaths', COUNT(*) FROM bronze.deaths;
GO

