USE CovidMedallionPOC;
GO

IF SCHEMA_ID('semantic') IS NULL EXEC('CREATE SCHEMA semantic');
GO

CREATE OR ALTER VIEW semantic.vw_metric_contracts AS
SELECT
    'INCIDENCE_DAILY' AS metric_id,
    'Daily New Confirmed Cases' AS metric_name,
    'One row represents one date and geography in the Google epidemiology source.' AS grain,
    'silver.vw_epidemiology.NewConfirmed' AS source_logic,
    'Additive across date and geography; validate against bronze.epidemiology row count and null DateKey/GeoKey checks.' AS reconciliation_rule,
    'POC' AS certification_state
UNION ALL
SELECT
    'MORTALITY_DAILY',
    'Daily New Deceased',
    'One row represents one date and geography in the Google epidemiology source.',
    'silver.vw_epidemiology.NewDeceased',
    'Additive across date and geography; compare against cumulative trend direction and audit null checks.',
    'POC'
UNION ALL
SELECT
    'HOSPITAL_PRESSURE',
    'Current Hospitalized Patients',
    'One row represents one date and geography in the Google hospitalizations source.',
    'silver.vw_hospitalizations.CurrentHospitalized',
    'Snapshot metric; do not sum across dates without explicit period logic.',
    'POC'
UNION ALL
SELECT
    'MOBILITY_WORKPLACE',
    'Workplace Mobility Index',
    'One row represents one date and geography in the mobility source.',
    'silver.vw_mobility.MobilityWorkplaces',
    'Average over selected period; validate DateKey/GeoKey completeness.',
    'POC'
UNION ALL
SELECT
    'TRUST_GATE',
    'POC Trust Gate Status',
    'One row represents one source object validation summary.',
    'gold.vw_audit_trust',
    'T2 requires loaded rows > 0 and zero null DateKey/GeoKey rows for critical daily facts.',
    'POC';
GO

CREATE OR ALTER VIEW semantic.vw_daily_kpi_summary AS
SELECT
    g.DateKey,
    g.GeoKey,
    g.[Date],
    g.NewConfirmed,
    g.NewDeceased,
    g.CumulativeConfirmed,
    g.CumulativeDeceased,
    g.CurrentHospitalized,
    g.CurrentICU,
    g.CurrentVentilator,
    g.MobilityWorkplaces,
    g.MobilityResidential,
    g.Population,
    CASE
        WHEN g.Population IS NULL OR g.Population = 0 THEN NULL
        ELSE (g.NewConfirmed / NULLIF(g.Population, 0)) * 100000.0
    END AS NewConfirmedPer100k,
    CASE
        WHEN g.NewConfirmed IS NULL OR g.NewConfirmed = 0 THEN NULL
        ELSE g.NewDeceased / NULLIF(g.NewConfirmed, 0)
    END AS DailyFatalityRatio,
    CASE
        WHEN g.CurrentHospitalized IS NULL THEN NULL
        WHEN g.CurrentHospitalized >= 1000 THEN 'High'
        WHEN g.CurrentHospitalized >= 250 THEN 'Elevated'
        ELSE 'Monitor'
    END AS HospitalPressureBand
FROM gold.vw_spread_risk_daily g;
GO

CREATE OR ALTER VIEW semantic.vw_trust_gate_status AS
SELECT
    object_name,
    row_count,
    null_datekey_rows,
    null_geokey_rows,
    CASE
        WHEN row_count = 0 THEN 'T0'
        WHEN null_datekey_rows = 0 AND null_geokey_rows = 0 THEN 'T2'
        WHEN null_datekey_rows <= row_count * 0.01
         AND null_geokey_rows <= row_count * 0.01 THEN 'T1'
        ELSE 'T0'
    END AS trust_gate,
    CASE
        WHEN row_count = 0 THEN 'No loaded rows.'
        WHEN null_datekey_rows = 0 AND null_geokey_rows = 0 THEN 'Loaded and key checks passed.'
        WHEN null_datekey_rows <= row_count * 0.01
         AND null_geokey_rows <= row_count * 0.01 THEN 'Loaded with minor key warnings.'
        ELSE 'Key completeness issue requires remediation.'
    END AS trust_gate_reason
FROM gold.vw_audit_trust;
GO

CREATE OR ALTER VIEW semantic.vw_powerbi_poc_dataset AS
SELECT
    k.DateKey,
    k.GeoKey,
    k.[Date],
    k.NewConfirmed,
    k.NewDeceased,
    k.CurrentHospitalized,
    k.CurrentICU,
    k.MobilityWorkplaces,
    k.MobilityResidential,
    k.Population,
    k.NewConfirmedPer100k,
    k.DailyFatalityRatio,
    k.HospitalPressureBand
FROM semantic.vw_daily_kpi_summary k;
GO

SELECT * FROM semantic.vw_trust_gate_status;
SELECT TOP 100 * FROM semantic.vw_powerbi_poc_dataset ORDER BY [Date] DESC;
SELECT * FROM semantic.vw_metric_contracts;
GO
