USE CovidMedallionPOC;
GO

-- Layer A/B quick checks
SELECT 'silver.vw_epidemiology' AS object_name,
       COUNT(*) AS rows_total,
       SUM(CASE WHEN DateKey IS NULL THEN 1 ELSE 0 END) AS null_datekey,
       SUM(CASE WHEN GeoKey IS NULL OR GeoKey = '00000' THEN 1 ELSE 0 END) AS null_geokey
FROM silver.vw_epidemiology;

SELECT 'silver.vw_hospitalizations' AS object_name,
       COUNT(*) AS rows_total,
       SUM(CASE WHEN DateKey IS NULL THEN 1 ELSE 0 END) AS null_datekey,
       SUM(CASE WHEN GeoKey IS NULL OR GeoKey = '00000' THEN 1 ELSE 0 END) AS null_geokey
FROM silver.vw_hospitalizations;

SELECT 'silver.vw_deaths' AS object_name,
       COUNT(*) AS rows_total,
       SUM(CASE WHEN DateKey IS NULL THEN 1 ELSE 0 END) AS null_datekey,
       SUM(CASE WHEN GeoKey IS NULL OR GeoKey = '00000' THEN 1 ELSE 0 END) AS null_geokey
FROM silver.vw_deaths;

-- Gold checks
SELECT TOP 100 *
FROM gold.vw_spread_risk_daily
ORDER BY [Date] DESC;

SELECT *
FROM gold.vw_audit_trust;
GO
