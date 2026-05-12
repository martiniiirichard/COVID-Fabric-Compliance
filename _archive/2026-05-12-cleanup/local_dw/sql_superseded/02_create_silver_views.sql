USE CovidMedallionPOC;
GO

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
