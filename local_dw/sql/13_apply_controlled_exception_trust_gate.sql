USE CovidMedallionPOC;
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
        WHEN object_name = 'deaths'
         AND null_geokey_rows = 0
         AND null_datekey_rows <= row_count * 0.02 THEN 'T1'
        ELSE 'T0'
    END AS trust_gate,
    CASE
        WHEN row_count = 0 THEN 'No loaded rows.'
        WHEN null_datekey_rows = 0 AND null_geokey_rows = 0 THEN 'Loaded and key checks passed.'
        WHEN object_name = 'deaths'
         AND null_geokey_rows = 0
         AND null_datekey_rows <= row_count * 0.02
            THEN 'Controlled exception: unresolved deaths DateKey rows lack source year/start_date and remain excluded from date-grain analysis.'
        ELSE 'Key completeness issue requires remediation.'
    END AS trust_gate_reason
FROM gold.vw_audit_trust;
GO

SELECT * FROM semantic.vw_trust_gate_status;
GO
