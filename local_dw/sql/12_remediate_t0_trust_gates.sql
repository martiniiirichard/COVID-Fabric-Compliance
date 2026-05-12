USE CovidMedallionPOC;
GO

/* Deaths remediation: monthly rows often have blank start_date but valid year/month. */
CREATE OR ALTER VIEW silver.vw_deaths AS
SELECT
    COALESCE(
        TRY_CONVERT(INT, FORMAT(TRY_CONVERT(date, start_date), 'yyyyMMdd')),
        TRY_CONVERT(INT, CONCAT(year_col, RIGHT('00' + NULLIF(month_col, ''), 2), '01'))
    ) AS DateKey,
    UPPER(LTRIM(RTRIM(country))) AS GeoKey,
    COALESCE(
        TRY_CONVERT(date, start_date),
        TRY_CONVERT(date, CONCAT(year_col, '-', RIGHT('00' + NULLIF(month_col, ''), 2), '-01'))
    ) AS start_date,
    TRY_CONVERT(date, end_date) AS end_date,
    TRY_CONVERT(INT, year_col) AS [Year],
    TRY_CONVERT(INT, month_col) AS [Month],
    TRY_CONVERT(INT, week_col) AS [Week],
    country,
    placename,
    frequency,
    TRY_CONVERT(FLOAT, deaths) AS Deaths,
    CASE
        WHEN TRY_CONVERT(date, start_date) IS NOT NULL THEN 'source_start_date'
        WHEN TRY_CONVERT(INT, CONCAT(year_col, RIGHT('00' + NULLIF(month_col, ''), 2), '01')) IS NOT NULL THEN 'derived_from_year_month'
        ELSE 'unresolved'
    END AS DateKeyDerivation
FROM bronze.deaths;
GO

/* US county remediation: retain unknown/special geography rows with controlled exception GeoKeys. */
CREATE OR ALTER VIEW silver.vw_us_counties_2022 AS
SELECT
    TRY_CONVERT(INT, FORMAT(TRY_CONVERT(date, date_col), 'yyyyMMdd')) AS DateKey,
    CASE
        WHEN NULLIF(LTRIM(RTRIM(fips)), '') IS NOT NULL
            THEN RIGHT('00000' + LTRIM(RTRIM(fips)), 5)
        WHEN county = 'Unknown'
            THEN CONCAT('UNK_', UPPER(REPLACE(state, ' ', '_')))
        ELSE CONCAT('SPECIAL_', UPPER(REPLACE(state, ' ', '_')), '_', UPPER(REPLACE(county, ' ', '_')))
    END AS GeoKey,
    TRY_CONVERT(date, date_col) AS [Date],
    county,
    state,
    fips,
    TRY_CONVERT(FLOAT, cases) AS Cases,
    TRY_CONVERT(FLOAT, deaths) AS Deaths,
    CASE
        WHEN NULLIF(LTRIM(RTRIM(fips)), '') IS NOT NULL THEN 'fips'
        WHEN county = 'Unknown' THEN 'unknown_county_exception'
        ELSE 'special_geography_exception'
    END AS GeoKeyDerivation
FROM bronze.us_counties_2022;
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

SELECT * FROM gold.vw_audit_trust;
SELECT DateKeyDerivation, COUNT(*) AS row_count FROM silver.vw_deaths GROUP BY DateKeyDerivation;
SELECT GeoKeyDerivation, COUNT(*) AS row_count FROM silver.vw_us_counties_2022 GROUP BY GeoKeyDerivation;
GO
