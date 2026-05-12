USE CovidMedallionPOC;
GO

CREATE OR ALTER VIEW gold.vw_spread_risk_daily AS
SELECT
    e.DateKey,
    e.GeoKey,
    e.[Date],
    e.NewConfirmed,
    e.NewDeceased,
    e.CumulativeConfirmed,
    e.CumulativeDeceased,
    h.CurrentHospitalized,
    h.CurrentICU,
    h.CurrentVentilator,
    CASE WHEN e.NewConfirmed IS NULL OR e.NewConfirmed = 0 THEN NULL
         ELSE e.NewDeceased / NULLIF(e.NewConfirmed,0) END AS DailyFatalityRatio
FROM silver.vw_epidemiology e
LEFT JOIN silver.vw_hospitalizations h
    ON e.DateKey = h.DateKey
   AND e.GeoKey = h.GeoKey;
GO

CREATE OR ALTER VIEW gold.vw_audit_trust AS
SELECT
    'epidemiology' AS object_name,
    COUNT(*) AS row_count,
    SUM(CASE WHEN DateKey IS NULL THEN 1 ELSE 0 END) AS null_datekey_rows,
    SUM(CASE WHEN GeoKey IS NULL OR GeoKey = '00000' THEN 1 ELSE 0 END) AS null_geokey_rows
FROM silver.vw_epidemiology
UNION ALL
SELECT
    'hospitalizations' AS object_name,
    COUNT(*) AS row_count,
    SUM(CASE WHEN DateKey IS NULL THEN 1 ELSE 0 END) AS null_datekey_rows,
    SUM(CASE WHEN GeoKey IS NULL OR GeoKey = '00000' THEN 1 ELSE 0 END) AS null_geokey_rows
FROM silver.vw_hospitalizations
UNION ALL
SELECT
    'deaths' AS object_name,
    COUNT(*) AS row_count,
    SUM(CASE WHEN DateKey IS NULL THEN 1 ELSE 0 END) AS null_datekey_rows,
    SUM(CASE WHEN GeoKey IS NULL OR GeoKey = '00000' THEN 1 ELSE 0 END) AS null_geokey_rows
FROM silver.vw_deaths;
GO
