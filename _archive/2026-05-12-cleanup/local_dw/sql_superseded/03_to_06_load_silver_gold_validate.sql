USE CovidMedallionPOC;
GO

/* Step 3: load Bronze */
TRUNCATE TABLE bronze.epidemiology;
BULK INSERT bronze.epidemiology
FROM 'C:\Users\marti\Documents\Codex\COVID-Fabric-Compliance\local_dw\layers\bronze\epidemiology.csv'
WITH (FIRSTROW = 2, FORMAT = 'CSV', FIELDQUOTE = '"', ROWTERMINATOR = '0x0a', TABLOCK, KEEPNULLS, CODEPAGE = '65001');

TRUNCATE TABLE bronze.hospitalizations;
BULK INSERT bronze.hospitalizations
FROM 'C:\Users\marti\Documents\Codex\COVID-Fabric-Compliance\local_dw\layers\bronze\hospitalizations.csv'
WITH (FIRSTROW = 2, FORMAT = 'CSV', FIELDQUOTE = '"', ROWTERMINATOR = '0x0a', TABLOCK, KEEPNULLS, CODEPAGE = '65001');

TRUNCATE TABLE bronze.deaths;
BULK INSERT bronze.deaths
FROM 'C:\Users\marti\Documents\Codex\COVID-Fabric-Compliance\local_dw\layers\bronze\deaths.csv'
WITH (FIRSTROW = 2, FORMAT = 'CSV', FIELDQUOTE = '"', ROWTERMINATOR = '0x0a', TABLOCK, KEEPNULLS, CODEPAGE = '65001');

TRUNCATE TABLE bronze.mobility;
BULK INSERT bronze.mobility
FROM 'C:\Users\marti\Documents\Codex\COVID-Fabric-Compliance\local_dw\layers\bronze\mobility.csv'
WITH (FIRSTROW = 2, FORMAT = 'CSV', FIELDQUOTE = '"', ROWTERMINATOR = '0x0a', TABLOCK, KEEPNULLS, CODEPAGE = '65001');

TRUNCATE TABLE bronze.demographics;
BULK INSERT bronze.demographics
FROM 'C:\Users\marti\Documents\Codex\COVID-Fabric-Compliance\local_dw\layers\bronze\demographics.csv'
WITH (FIRSTROW = 2, FORMAT = 'CSV', FIELDQUOTE = '"', ROWTERMINATOR = '0x0a', TABLOCK, KEEPNULLS, CODEPAGE = '65001');

TRUNCATE TABLE bronze.lawatlas_emergency_declarations;
BULK INSERT bronze.lawatlas_emergency_declarations
FROM 'C:\Users\marti\Documents\Codex\COVID-Fabric-Compliance\local_dw\layers\bronze\lawatlas-emergency-declarations.csv'
WITH (FIRSTROW = 2, FORMAT = 'CSV', FIELDQUOTE = '"', ROWTERMINATOR = '0x0a', TABLOCK, KEEPNULLS, CODEPAGE = '65001');

TRUNCATE TABLE bronze.us_counties_2022;
BULK INSERT bronze.us_counties_2022
FROM 'C:\Users\marti\Documents\Codex\COVID-Fabric-Compliance\local_dw\layers\bronze\us-counties-2022.csv'
WITH (FIRSTROW = 2, FORMAT = 'CSV', FIELDQUOTE = '"', ROWTERMINATOR = '0x0a', TABLOCK, KEEPNULLS, CODEPAGE = '65001');
GO

SELECT 'bronze.epidemiology' AS table_name, COUNT(*) AS row_count FROM bronze.epidemiology
UNION ALL SELECT 'bronze.hospitalizations', COUNT(*) FROM bronze.hospitalizations
UNION ALL SELECT 'bronze.deaths', COUNT(*) FROM bronze.deaths
UNION ALL SELECT 'bronze.mobility', COUNT(*) FROM bronze.mobility
UNION ALL SELECT 'bronze.demographics', COUNT(*) FROM bronze.demographics
UNION ALL SELECT 'bronze.lawatlas_emergency_declarations', COUNT(*) FROM bronze.lawatlas_emergency_declarations
UNION ALL SELECT 'bronze.us_counties_2022', COUNT(*) FROM bronze.us_counties_2022;
GO

/* Step 4: create Silver views */
CREATE OR ALTER VIEW silver.vw_epidemiology AS
SELECT
    TRY_CONVERT(INT, FORMAT(TRY_CONVERT(date, date_col), 'yyyyMMdd')) AS DateKey,
    UPPER(LTRIM(RTRIM(location_key))) AS GeoKey,
    TRY_CONVERT(date, date_col) AS [Date],
    TRY_CONVERT(FLOAT, new_confirmed) AS NewConfirmed,
    TRY_CONVERT(FLOAT, new_deceased) AS NewDeceased,
    TRY_CONVERT(FLOAT, cumulative_confirmed) AS CumulativeConfirmed,
    TRY_CONVERT(FLOAT, cumulative_deceased) AS CumulativeDeceased
FROM bronze.epidemiology;
GO

CREATE OR ALTER VIEW silver.vw_hospitalizations AS
SELECT
    TRY_CONVERT(INT, FORMAT(TRY_CONVERT(date, date_col), 'yyyyMMdd')) AS DateKey,
    UPPER(LTRIM(RTRIM(location_key))) AS GeoKey,
    TRY_CONVERT(date, date_col) AS [Date],
    TRY_CONVERT(FLOAT, current_hospitalized_patients) AS CurrentHospitalized,
    TRY_CONVERT(FLOAT, current_intensive_care_patients) AS CurrentICU,
    TRY_CONVERT(FLOAT, current_ventilator_patients) AS CurrentVentilator
FROM bronze.hospitalizations;
GO

CREATE OR ALTER VIEW silver.vw_deaths AS
SELECT
    TRY_CONVERT(INT, FORMAT(TRY_CONVERT(date, start_date), 'yyyyMMdd')) AS DateKey,
    UPPER(LTRIM(RTRIM(country))) AS GeoKey,
    TRY_CONVERT(date, start_date) AS start_date,
    TRY_CONVERT(date, end_date) AS end_date,
    TRY_CONVERT(INT, year_col) AS [Year],
    TRY_CONVERT(INT, month_col) AS [Month],
    TRY_CONVERT(INT, week_col) AS [Week],
    country,
    placename,
    frequency,
    TRY_CONVERT(FLOAT, deaths) AS Deaths
FROM bronze.deaths;
GO

CREATE OR ALTER VIEW silver.vw_mobility AS
SELECT
    TRY_CONVERT(INT, FORMAT(TRY_CONVERT(date, date_col), 'yyyyMMdd')) AS DateKey,
    UPPER(LTRIM(RTRIM(location_key))) AS GeoKey,
    TRY_CONVERT(date, date_col) AS [Date],
    TRY_CONVERT(FLOAT, mobility_retail_and_recreation) AS MobilityRetailAndRecreation,
    TRY_CONVERT(FLOAT, mobility_grocery_and_pharmacy) AS MobilityGroceryAndPharmacy,
    TRY_CONVERT(FLOAT, mobility_parks) AS MobilityParks,
    TRY_CONVERT(FLOAT, mobility_transit_stations) AS MobilityTransitStations,
    TRY_CONVERT(FLOAT, mobility_workplaces) AS MobilityWorkplaces,
    TRY_CONVERT(FLOAT, mobility_residential) AS MobilityResidential
FROM bronze.mobility;
GO

CREATE OR ALTER VIEW silver.vw_demographics AS
SELECT
    UPPER(LTRIM(RTRIM(location_key))) AS GeoKey,
    TRY_CONVERT(FLOAT, population) AS Population,
    TRY_CONVERT(FLOAT, population_male) AS PopulationMale,
    TRY_CONVERT(FLOAT, population_female) AS PopulationFemale,
    TRY_CONVERT(FLOAT, population_density) AS PopulationDensity,
    TRY_CONVERT(FLOAT, human_development_index) AS HumanDevelopmentIndex,
    TRY_CONVERT(FLOAT, population_age_60_69) AS PopulationAge60To69,
    TRY_CONVERT(FLOAT, population_age_70_79) AS PopulationAge70To79,
    TRY_CONVERT(FLOAT, population_age_80_and_older) AS PopulationAge80AndOlder
FROM bronze.demographics;
GO

CREATE OR ALTER VIEW silver.vw_lawatlas_policy AS
SELECT
    TRY_CONVERT(INT, FORMAT(TRY_CONVERT(date, date_col), 'yyyyMMdd')) AS DateKey,
    UPPER(LTRIM(RTRIM(location_key))) AS GeoKey,
    TRY_CONVERT(date, date_col) AS [Date],
    TRY_CONVERT(INT, lawatlas_state_emergency) AS StateEmergency,
    TRY_CONVERT(INT, lawatlas_mask_requirement) AS MaskRequirement,
    TRY_CONVERT(INT, lawatlas_business_close) AS BusinessClose,
    TRY_CONVERT(INT, lawatlas_home_requirement) AS HomeRequirement,
    TRY_CONVERT(INT, lawatlas_gathering_ban) AS GatheringBan
FROM bronze.lawatlas_emergency_declarations;
GO

CREATE OR ALTER VIEW silver.vw_us_counties_2022 AS
SELECT
    TRY_CONVERT(INT, FORMAT(TRY_CONVERT(date, date_col), 'yyyyMMdd')) AS DateKey,
    RIGHT('00000' + NULLIF(LTRIM(RTRIM(fips)), ''), 5) AS GeoKey,
    TRY_CONVERT(date, date_col) AS [Date],
    county,
    state,
    TRY_CONVERT(FLOAT, cases) AS Cases,
    TRY_CONVERT(FLOAT, deaths) AS Deaths
FROM bronze.us_counties_2022;
GO

/* Step 5: create Gold views */
CREATE OR ALTER VIEW gold.vw_spread_risk_daily AS
SELECT
    e.DateKey, e.GeoKey, e.[Date],
    e.NewConfirmed, e.NewDeceased, e.CumulativeConfirmed, e.CumulativeDeceased,
    h.CurrentHospitalized, h.CurrentICU, h.CurrentVentilator,
    m.MobilityWorkplaces,
    m.MobilityResidential,
    d.Population,
    CASE WHEN e.NewConfirmed IS NULL OR e.NewConfirmed = 0 THEN NULL
         ELSE e.NewDeceased / NULLIF(e.NewConfirmed, 0) END AS DailyFatalityRatio
FROM silver.vw_epidemiology e
LEFT JOIN silver.vw_hospitalizations h
    ON e.DateKey = h.DateKey
   AND e.GeoKey = h.GeoKey
LEFT JOIN silver.vw_mobility m
    ON e.DateKey = m.DateKey
   AND e.GeoKey = m.GeoKey
LEFT JOIN silver.vw_demographics d
    ON e.GeoKey = d.GeoKey;
GO

CREATE OR ALTER VIEW gold.vw_audit_trust AS
SELECT 'epidemiology' AS object_name, COUNT(*) AS row_count,
       SUM(CASE WHEN DateKey IS NULL THEN 1 ELSE 0 END) AS null_datekey_rows,
       SUM(CASE WHEN GeoKey IS NULL OR GeoKey = '' THEN 1 ELSE 0 END) AS null_geokey_rows
FROM silver.vw_epidemiology
UNION ALL
SELECT 'hospitalizations', COUNT(*),
       SUM(CASE WHEN DateKey IS NULL THEN 1 ELSE 0 END),
       SUM(CASE WHEN GeoKey IS NULL OR GeoKey = '' THEN 1 ELSE 0 END)
FROM silver.vw_hospitalizations
UNION ALL
SELECT 'deaths', COUNT(*),
       SUM(CASE WHEN DateKey IS NULL THEN 1 ELSE 0 END),
       SUM(CASE WHEN GeoKey IS NULL OR GeoKey = '' THEN 1 ELSE 0 END)
FROM silver.vw_deaths
UNION ALL
SELECT 'mobility', COUNT(*),
       SUM(CASE WHEN DateKey IS NULL THEN 1 ELSE 0 END),
       SUM(CASE WHEN GeoKey IS NULL OR GeoKey = '' THEN 1 ELSE 0 END)
FROM silver.vw_mobility
UNION ALL
SELECT 'demographics', COUNT(*),
       0,
       SUM(CASE WHEN GeoKey IS NULL OR GeoKey = '' THEN 1 ELSE 0 END)
FROM silver.vw_demographics
UNION ALL
SELECT 'lawatlas_policy', COUNT(*),
       SUM(CASE WHEN DateKey IS NULL THEN 1 ELSE 0 END),
       SUM(CASE WHEN GeoKey IS NULL OR GeoKey = '' THEN 1 ELSE 0 END)
FROM silver.vw_lawatlas_policy
UNION ALL
SELECT 'us_counties_2022', COUNT(*),
       SUM(CASE WHEN DateKey IS NULL THEN 1 ELSE 0 END),
       SUM(CASE WHEN GeoKey IS NULL OR GeoKey = '' THEN 1 ELSE 0 END)
FROM silver.vw_us_counties_2022;
GO

/* Step 6: validate */
SELECT * FROM gold.vw_audit_trust;
SELECT TOP 100 * FROM gold.vw_spread_risk_daily ORDER BY [Date] DESC;
GO

