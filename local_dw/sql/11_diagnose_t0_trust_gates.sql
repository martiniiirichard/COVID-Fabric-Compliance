USE CovidMedallionPOC;
GO

/* Deaths rows with unparseable DateKey */
SELECT TOP 100
    country,
    placename,
    frequency,
    start_date,
    end_date,
    year_col,
    month_col,
    week_col,
    deaths,
    TRY_CONVERT(date, start_date) AS parsed_start_date,
    TRY_CONVERT(INT, FORMAT(TRY_CONVERT(date, start_date), 'yyyyMMdd')) AS parsed_datekey
FROM bronze.deaths
WHERE TRY_CONVERT(date, start_date) IS NULL
ORDER BY country, year_col, month_col, week_col;
GO

SELECT
    country,
    frequency,
    COUNT(*) AS null_datekey_rows
FROM bronze.deaths
WHERE TRY_CONVERT(date, start_date) IS NULL
GROUP BY country, frequency
ORDER BY null_datekey_rows DESC, country;
GO

/* US counties rows with missing/non-conformant GeoKey */
SELECT TOP 100
    date_col,
    county,
    state,
    fips,
    cases,
    deaths,
    RIGHT('00000' + NULLIF(LTRIM(RTRIM(fips)), ''), 5) AS parsed_geokey
FROM bronze.us_counties_2022
WHERE RIGHT('00000' + NULLIF(LTRIM(RTRIM(fips)), ''), 5) IS NULL
ORDER BY state, county, date_col;
GO

SELECT
    state,
    county,
    COUNT(*) AS null_geokey_rows
FROM bronze.us_counties_2022
WHERE RIGHT('00000' + NULLIF(LTRIM(RTRIM(fips)), ''), 5) IS NULL
GROUP BY state, county
ORDER BY null_geokey_rows DESC, state, county;
GO
