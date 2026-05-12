USE master;
GO

IF DB_ID('CovidMedallionPOC') IS NULL
BEGIN
    CREATE DATABASE CovidMedallionPOC;
END
GO

USE CovidMedallionPOC;
GO

IF SCHEMA_ID('bronze') IS NULL EXEC('CREATE SCHEMA bronze');
IF SCHEMA_ID('silver') IS NULL EXEC('CREATE SCHEMA silver');
IF SCHEMA_ID('gold') IS NULL EXEC('CREATE SCHEMA gold');
IF SCHEMA_ID('control') IS NULL EXEC('CREATE SCHEMA control');
GO

IF OBJECT_ID('gold.vw_spread_risk_daily','V') IS NOT NULL DROP VIEW gold.vw_spread_risk_daily;
IF OBJECT_ID('gold.vw_audit_trust','V') IS NOT NULL DROP VIEW gold.vw_audit_trust;
IF OBJECT_ID('silver.vw_mobility','V') IS NOT NULL DROP VIEW silver.vw_mobility;
IF OBJECT_ID('silver.vw_demographics','V') IS NOT NULL DROP VIEW silver.vw_demographics;
IF OBJECT_ID('silver.vw_lawatlas_policy','V') IS NOT NULL DROP VIEW silver.vw_lawatlas_policy;
IF OBJECT_ID('silver.vw_us_counties_2022','V') IS NOT NULL DROP VIEW silver.vw_us_counties_2022;
IF OBJECT_ID('silver.vw_epidemiology','V') IS NOT NULL DROP VIEW silver.vw_epidemiology;
IF OBJECT_ID('silver.vw_hospitalizations','V') IS NOT NULL DROP VIEW silver.vw_hospitalizations;
IF OBJECT_ID('silver.vw_deaths','V') IS NOT NULL DROP VIEW silver.vw_deaths;
GO

DROP TABLE IF EXISTS bronze.epidemiology;
DROP TABLE IF EXISTS bronze.hospitalizations;
DROP TABLE IF EXISTS bronze.deaths;
DROP TABLE IF EXISTS bronze.mobility;
DROP TABLE IF EXISTS bronze.demographics;
DROP TABLE IF EXISTS bronze.lawatlas_emergency_declarations;
DROP TABLE IF EXISTS bronze.us_counties_2022;
GO

CREATE TABLE bronze.epidemiology (
    date_col NVARCHAR(100) NULL,
    location_key NVARCHAR(100) NULL,
    new_confirmed NVARCHAR(100) NULL,
    new_deceased NVARCHAR(100) NULL,
    new_recovered NVARCHAR(100) NULL,
    new_tested NVARCHAR(100) NULL,
    cumulative_confirmed NVARCHAR(100) NULL,
    cumulative_deceased NVARCHAR(100) NULL,
    cumulative_recovered NVARCHAR(100) NULL,
    cumulative_tested NVARCHAR(100) NULL
);

CREATE TABLE bronze.hospitalizations (
    date_col NVARCHAR(100) NULL,
    location_key NVARCHAR(100) NULL,
    new_hospitalized_patients NVARCHAR(100) NULL,
    cumulative_hospitalized_patients NVARCHAR(100) NULL,
    current_hospitalized_patients NVARCHAR(100) NULL,
    new_intensive_care_patients NVARCHAR(100) NULL,
    cumulative_intensive_care_patients NVARCHAR(100) NULL,
    current_intensive_care_patients NVARCHAR(100) NULL,
    new_ventilator_patients NVARCHAR(100) NULL,
    cumulative_ventilator_patients NVARCHAR(100) NULL,
    current_ventilator_patients NVARCHAR(100) NULL
);

CREATE TABLE bronze.deaths (
    country NVARCHAR(200) NULL,
    placename NVARCHAR(300) NULL,
    frequency NVARCHAR(100) NULL,
    start_date NVARCHAR(100) NULL,
    end_date NVARCHAR(100) NULL,
    year_col NVARCHAR(100) NULL,
    month_col NVARCHAR(100) NULL,
    week_col NVARCHAR(100) NULL,
    deaths NVARCHAR(100) NULL,
    expected_deaths NVARCHAR(100) NULL,
    excess_deaths NVARCHAR(100) NULL,
    baseline NVARCHAR(500) NULL
);

CREATE TABLE bronze.mobility (
    date_col NVARCHAR(100) NULL,
    location_key NVARCHAR(100) NULL,
    mobility_retail_and_recreation NVARCHAR(100) NULL,
    mobility_grocery_and_pharmacy NVARCHAR(100) NULL,
    mobility_parks NVARCHAR(100) NULL,
    mobility_transit_stations NVARCHAR(100) NULL,
    mobility_workplaces NVARCHAR(100) NULL,
    mobility_residential NVARCHAR(100) NULL
);

CREATE TABLE bronze.demographics (
    location_key NVARCHAR(100) NULL,
    population NVARCHAR(100) NULL,
    population_male NVARCHAR(100) NULL,
    population_female NVARCHAR(100) NULL,
    population_rural NVARCHAR(100) NULL,
    population_urban NVARCHAR(100) NULL,
    population_largest_city NVARCHAR(100) NULL,
    population_clustered NVARCHAR(100) NULL,
    population_density NVARCHAR(100) NULL,
    human_development_index NVARCHAR(100) NULL,
    population_age_00_09 NVARCHAR(100) NULL,
    population_age_10_19 NVARCHAR(100) NULL,
    population_age_20_29 NVARCHAR(100) NULL,
    population_age_30_39 NVARCHAR(100) NULL,
    population_age_40_49 NVARCHAR(100) NULL,
    population_age_50_59 NVARCHAR(100) NULL,
    population_age_60_69 NVARCHAR(100) NULL,
    population_age_70_79 NVARCHAR(100) NULL,
    population_age_80_and_older NVARCHAR(100) NULL
);

CREATE TABLE bronze.us_counties_2022 (
    date_col NVARCHAR(100) NULL,
    county NVARCHAR(300) NULL,
    state NVARCHAR(200) NULL,
    fips NVARCHAR(100) NULL,
    cases NVARCHAR(100) NULL,
    deaths NVARCHAR(100) NULL
);

CREATE TABLE bronze.lawatlas_emergency_declarations (
    date_col NVARCHAR(100) NULL,
    location_key NVARCHAR(100) NULL,
    lawatlas_mitigation_policy NVARCHAR(100) NULL,
    lawatlas_state_emergency NVARCHAR(100) NULL,
    lawatlas_emerg_statewide NVARCHAR(100) NULL,
    lawatlas_travel_requirement NVARCHAR(100) NULL,
    lawatlas_traveler_type_all_people_entering_the_state NVARCHAR(100) NULL,
    lawatlas_traveler_type_travelers_from_specified_states NVARCHAR(100) NULL,
    lawatlas_traveler_type_travelers_from_specified_countries NVARCHAR(100) NULL,
    lawatlas_traveler_type_general_international_travelers NVARCHAR(100) NULL,
    lawatlas_traveler_type_all_air_travelers NVARCHAR(100) NULL,
    lawatlas_requirement_type_traveler_must_self_quarantine NVARCHAR(100) NULL,
    lawatlas_requirement_type_traveler_must_inform_others_of_travel NVARCHAR(100) NULL,
    lawatlas_requirement_type_checkpoints_must_be_established NVARCHAR(100) NULL,
    lawatlas_requirement_type_travel_requirement_must_be_posted NVARCHAR(100) NULL,
    lawatlas_travel_statewide NVARCHAR(100) NULL,
    lawatlas_home_requirement NVARCHAR(100) NULL,
    lawatlas_home_except_engaging_in_essential_business_activities NVARCHAR(100) NULL,
    lawatlas_home_except_obtaining_necessary_supplies NVARCHAR(100) NULL,
    lawatlas_home_except_accessing_emergency_services NVARCHAR(100) NULL,
    lawatlas_home_except_caring_for_a_person_outside_the_home NVARCHAR(100) NULL,
    lawatlas_home_except_caring_for_a_pet_outside_the_home NVARCHAR(100) NULL,
    lawatlas_home_except_engaging_in_outdoor_activities NVARCHAR(100) NULL,
    lawatlas_home_except_attending_religious_services NVARCHAR(100) NULL,
    lawatlas_home_except_engaging_in_essential_health_care_services NVARCHAR(100) NULL,
    lawatlas_home_statewide NVARCHAR(100) NULL,
    lawatlas_curfew_reg NVARCHAR(100) NULL,
    lawatlas_mask_requirement NVARCHAR(100) NULL,
    lawatlas_mask_statewide NVARCHAR(100) NULL,
    lawatlas_business_close NVARCHAR(100) NULL,
    lawatlas_business_type_all_non_essential_businesses NVARCHAR(100) NULL,
    lawatlas_business_type_non_essential_retail_businesses NVARCHAR(100) NULL,
    lawatlas_business_type_entertainment_businesses NVARCHAR(100) NULL,
    lawatlas_business_type_personal_service_businesses NVARCHAR(100) NULL,
    lawatlas_business_type_restaurants NVARCHAR(100) NULL,
    lawatlas_business_type_bars NVARCHAR(100) NULL,
    lawatlas_business_type_fitness_centers NVARCHAR(100) NULL,
    lawatlas_essential_def_appliance_stores NVARCHAR(100) NULL,
    lawatlas_essential_def_convenience_stores NVARCHAR(100) NULL,
    lawatlas_essential_def_gas_stations NVARCHAR(100) NULL,
    lawatlas_essential_def_grocery_stores NVARCHAR(100) NULL,
    lawatlas_essential_def_gun_stores NVARCHAR(100) NULL,
    lawatlas_essential_def_hardware_stores NVARCHAR(100) NULL,
    lawatlas_essential_def_liquor_stores NVARCHAR(100) NULL,
    lawatlas_essential_def_pharmacies NVARCHAR(100) NULL,
    lawatlas_essential_def_marijuana_dispensaries NVARCHAR(100) NULL,
    lawatlas_essential_def_pet_stores NVARCHAR(100) NULL,
    lawatlas_essential_def_type_of_essential_retail_business_is_not_specified NVARCHAR(100) NULL,
    lawatlas_essential_def_no_restriction_on_retail_businesses NVARCHAR(100) NULL,
    lawatlas_business_statewide NVARCHAR(100) NULL,
    lawatlas_rest_restrict NVARCHAR(100) NULL,
    lawatlas_service_type_takeout NVARCHAR(100) NULL,
    lawatlas_service_type_delivery NVARCHAR(100) NULL,
    lawatlas_service_type_limited_on_site_service NVARCHAR(100) NULL,
    lawatlas_rest_statewide NVARCHAR(100) NULL,
    lawatlas_schools_requirement NVARCHAR(100) NULL,
    lawatlas_schools_type_private_elementary_schools NVARCHAR(100) NULL,
    lawatlas_schools_type_private_secondary_schools NVARCHAR(100) NULL,
    lawatlas_schools_type_public_elementary_schools NVARCHAR(100) NULL,
    lawatlas_schools_type_public_secondary_schools NVARCHAR(100) NULL,
    lawatlas_schools_type_colleges_and_universities NVARCHAR(100) NULL,
    lawatlas_schools_type_technical_schools NVARCHAR(100) NULL,
    lawatlas_schools_type_type_of_school_not_specified NVARCHAR(100) NULL,
    lawatlas_schools_statewide NVARCHAR(100) NULL,
    lawatlas_gathering_ban NVARCHAR(100) NULL,
    lawatlas_gathering_type NVARCHAR(100) NULL,
    lawatlas_gathering_statewide NVARCHAR(100) NULL,
    lawatlas_med_restrict NVARCHAR(100) NULL,
    lawatlas_med_except_delay_would_threaten_patients_health NVARCHAR(100) NULL,
    lawatlas_med_except_delay_would_threaten_patients_life NVARCHAR(100) NULL,
    lawatlas_med_except_procedure_needed_to_treat_emergency NVARCHAR(100) NULL,
    lawatlas_med_except_procedure_does_not_deplete_hospital_capacity NVARCHAR(100) NULL,
    lawatlas_med_except_procedure_does_not_deplete_personal_protective_equipment NVARCHAR(100) NULL,
    lawatlas_med_except_family_planning_services NVARCHAR(100) NULL,
    lawatlas_med_except_no_exception_specified NVARCHAR(100) NULL,
    lawatlas_abortion_essential_new NVARCHAR(100) NULL,
    lawatlas_med_statewide NVARCHAR(100) NULL,
    lawatlas_correct_requirement NVARCHAR(100) NULL,
    lawatlas_correct_facility_all_state_facilities NVARCHAR(100) NULL,
    lawatlas_correct_facility_all_department_of_corrections_facilities NVARCHAR(100) NULL,
    lawatlas_correct_facility_all_county_jails NVARCHAR(100) NULL,
    lawatlas_correct_facility_juvenile_detention_centers NVARCHAR(100) NULL,
    lawatlas_correct_type_intakes_suspended NVARCHAR(100) NULL,
    lawatlas_correct_type_duty_to_receive_prisoners_suspended NVARCHAR(100) NULL,
    lawatlas_correct_type_transfers_to_custody_suspended NVARCHAR(100) NULL,
    lawatlas_correct_type_release_of_inmates NVARCHAR(100) NULL,
    lawatlas_correct_type_rules_regarding_inmate_release_suspended NVARCHAR(100) NULL,
    lawatlas_correct_type_release_notice_suspended NVARCHAR(100) NULL,
    lawatlas_correct_type_cease_in_person_parole_hearings NVARCHAR(100) NULL,
    lawatlas_correct_type_develop_process_for_virtual_parole_hearings NVARCHAR(100) NULL,
    lawatlas_correct_type_visitation_suspended NVARCHAR(100) NULL,
    lawatlas_correct_statewide NVARCHAR(100) NULL,
    lawatlas_state_preempt NVARCHAR(100) NULL,
    lawatlas_action_preempt_imposing_additional_social_distancing_limitations_on_essential_business NVARCHAR(100) NULL,
    lawatlas_action_preempt_imposing_additional_restrictions_on_public_spaces NVARCHAR(100) NULL,
    lawatlas_action_preempt_restricting_scope_of_services_of_an_essential_business NVARCHAR(100) NULL,
    [lawatlas_action_preempt_expanding_the_definition_of_non-essential_business] NVARCHAR(100) NULL,
    lawatlas_action_preempt_restricting_the_hours_of_operation_of_an_essential_business NVARCHAR(100) NULL,
    lawatlas_action_preempt_imposing_restrictions_that_conflict_with_state_order NVARCHAR(100) NULL,
    lawatlas_action_preempt_restricting_the_performance_of_an_essential_function NVARCHAR(100) NULL,
    lawatlas_action_preempt_restricting_people_from_leaving_home NVARCHAR(100) NULL,
    lawatlas_action_preempt_restricting_the_operations_of_schools NVARCHAR(100) NULL,
    lawatlas_action_preempt_imposing_gathering_bans NVARCHAR(100) NULL,
    lawatlas_local_allow NVARCHAR(100) NULL
);
GO

BULK INSERT bronze.epidemiology FROM 'C:\Users\marti\Documents\Codex\COVID-Fabric-Compliance\local_dw\layers\bronze\epidemiology.csv' WITH (FIRSTROW = 2, FORMAT = 'CSV', FIELDQUOTE = '"', ROWTERMINATOR = '0x0a', TABLOCK, KEEPNULLS, CODEPAGE = '65001');
BULK INSERT bronze.hospitalizations FROM 'C:\Users\marti\Documents\Codex\COVID-Fabric-Compliance\local_dw\layers\bronze\hospitalizations.csv' WITH (FIRSTROW = 2, FORMAT = 'CSV', FIELDQUOTE = '"', ROWTERMINATOR = '0x0a', TABLOCK, KEEPNULLS, CODEPAGE = '65001');
BULK INSERT bronze.deaths FROM 'C:\Users\marti\Documents\Codex\COVID-Fabric-Compliance\local_dw\layers\bronze\deaths.csv' WITH (FIRSTROW = 2, FORMAT = 'CSV', FIELDQUOTE = '"', ROWTERMINATOR = '0x0a', TABLOCK, KEEPNULLS, CODEPAGE = '65001');
BULK INSERT bronze.mobility FROM 'C:\Users\marti\Documents\Codex\COVID-Fabric-Compliance\local_dw\layers\bronze\mobility.csv' WITH (FIRSTROW = 2, FORMAT = 'CSV', FIELDQUOTE = '"', ROWTERMINATOR = '0x0a', TABLOCK, KEEPNULLS, CODEPAGE = '65001');
BULK INSERT bronze.demographics FROM 'C:\Users\marti\Documents\Codex\COVID-Fabric-Compliance\local_dw\layers\bronze\demographics.csv' WITH (FIRSTROW = 2, FORMAT = 'CSV', FIELDQUOTE = '"', ROWTERMINATOR = '0x0a', TABLOCK, KEEPNULLS, CODEPAGE = '65001');
BULK INSERT bronze.lawatlas_emergency_declarations FROM 'C:\Users\marti\Documents\Codex\COVID-Fabric-Compliance\local_dw\layers\bronze\lawatlas-emergency-declarations.csv' WITH (FIRSTROW = 2, FORMAT = 'CSV', FIELDQUOTE = '"', ROWTERMINATOR = '0x0a', TABLOCK, KEEPNULLS, CODEPAGE = '65001');
BULK INSERT bronze.us_counties_2022 FROM 'C:\Users\marti\Documents\Codex\COVID-Fabric-Compliance\local_dw\layers\bronze\us-counties-2022.csv' WITH (FIRSTROW = 2, FORMAT = 'CSV', FIELDQUOTE = '"', ROWTERMINATOR = '0x0a', TABLOCK, KEEPNULLS, CODEPAGE = '65001');
GO

SELECT 'bronze.epidemiology' AS table_name, COUNT(*) AS row_count FROM bronze.epidemiology
UNION ALL SELECT 'bronze.hospitalizations', COUNT(*) FROM bronze.hospitalizations
UNION ALL SELECT 'bronze.deaths', COUNT(*) FROM bronze.deaths
UNION ALL SELECT 'bronze.mobility', COUNT(*) FROM bronze.mobility
UNION ALL SELECT 'bronze.demographics', COUNT(*) FROM bronze.demographics
UNION ALL SELECT 'bronze.lawatlas_emergency_declarations', COUNT(*) FROM bronze.lawatlas_emergency_declarations
UNION ALL SELECT 'bronze.us_counties_2022', COUNT(*) FROM bronze.us_counties_2022;
GO

CREATE OR ALTER VIEW silver.vw_epidemiology AS
SELECT TRY_CONVERT(INT, FORMAT(TRY_CONVERT(date, date_col), 'yyyyMMdd')) AS DateKey,
       UPPER(LTRIM(RTRIM(location_key))) AS GeoKey,
       TRY_CONVERT(date, date_col) AS [Date],
       TRY_CONVERT(FLOAT, new_confirmed) AS NewConfirmed,
       TRY_CONVERT(FLOAT, new_deceased) AS NewDeceased,
       TRY_CONVERT(FLOAT, cumulative_confirmed) AS CumulativeConfirmed,
       TRY_CONVERT(FLOAT, cumulative_deceased) AS CumulativeDeceased
FROM bronze.epidemiology;
GO

CREATE OR ALTER VIEW silver.vw_hospitalizations AS
SELECT TRY_CONVERT(INT, FORMAT(TRY_CONVERT(date, date_col), 'yyyyMMdd')) AS DateKey,
       UPPER(LTRIM(RTRIM(location_key))) AS GeoKey,
       TRY_CONVERT(date, date_col) AS [Date],
       TRY_CONVERT(FLOAT, current_hospitalized_patients) AS CurrentHospitalized,
       TRY_CONVERT(FLOAT, current_intensive_care_patients) AS CurrentICU,
       TRY_CONVERT(FLOAT, current_ventilator_patients) AS CurrentVentilator
FROM bronze.hospitalizations;
GO

CREATE OR ALTER VIEW silver.vw_deaths AS
SELECT TRY_CONVERT(INT, FORMAT(TRY_CONVERT(date, start_date), 'yyyyMMdd')) AS DateKey,
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
SELECT TRY_CONVERT(INT, FORMAT(TRY_CONVERT(date, date_col), 'yyyyMMdd')) AS DateKey,
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
SELECT UPPER(LTRIM(RTRIM(location_key))) AS GeoKey,
       TRY_CONVERT(FLOAT, population) AS Population,
       TRY_CONVERT(FLOAT, population_male) AS PopulationMale,
       TRY_CONVERT(FLOAT, population_female) AS PopulationFemale,
       TRY_CONVERT(FLOAT, population_density) AS PopulationDensity,
       TRY_CONVERT(FLOAT, human_development_index) AS HumanDevelopmentIndex
FROM bronze.demographics;
GO

CREATE OR ALTER VIEW silver.vw_lawatlas_policy AS
SELECT TRY_CONVERT(INT, FORMAT(TRY_CONVERT(date, date_col), 'yyyyMMdd')) AS DateKey,
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
SELECT TRY_CONVERT(INT, FORMAT(TRY_CONVERT(date, date_col), 'yyyyMMdd')) AS DateKey,
       RIGHT('00000' + NULLIF(LTRIM(RTRIM(fips)), ''), 5) AS GeoKey,
       TRY_CONVERT(date, date_col) AS [Date],
       county,
       state,
       TRY_CONVERT(FLOAT, cases) AS Cases,
       TRY_CONVERT(FLOAT, deaths) AS Deaths
FROM bronze.us_counties_2022;
GO

CREATE OR ALTER VIEW gold.vw_spread_risk_daily AS
SELECT e.DateKey,
       e.GeoKey,
       e.[Date],
       e.NewConfirmed,
       e.NewDeceased,
       e.CumulativeConfirmed,
       e.CumulativeDeceased,
       h.CurrentHospitalized,
       h.CurrentICU,
       h.CurrentVentilator,
       m.MobilityWorkplaces,
       m.MobilityResidential,
       d.Population,
       CASE WHEN e.NewConfirmed IS NULL OR e.NewConfirmed = 0 THEN NULL
            ELSE e.NewDeceased / NULLIF(e.NewConfirmed, 0) END AS DailyFatalityRatio
FROM silver.vw_epidemiology e
LEFT JOIN silver.vw_hospitalizations h ON e.DateKey = h.DateKey AND e.GeoKey = h.GeoKey
LEFT JOIN silver.vw_mobility m ON e.DateKey = m.DateKey AND e.GeoKey = m.GeoKey
LEFT JOIN silver.vw_demographics d ON e.GeoKey = d.GeoKey;
GO

CREATE OR ALTER VIEW gold.vw_audit_trust AS
SELECT 'epidemiology' AS object_name, COUNT(*) AS row_count, SUM(CASE WHEN DateKey IS NULL THEN 1 ELSE 0 END) AS null_datekey_rows, SUM(CASE WHEN GeoKey IS NULL OR GeoKey = '' THEN 1 ELSE 0 END) AS null_geokey_rows FROM silver.vw_epidemiology
UNION ALL SELECT 'hospitalizations', COUNT(*), SUM(CASE WHEN DateKey IS NULL THEN 1 ELSE 0 END), SUM(CASE WHEN GeoKey IS NULL OR GeoKey = '' THEN 1 ELSE 0 END) FROM silver.vw_hospitalizations
UNION ALL SELECT 'deaths', COUNT(*), SUM(CASE WHEN DateKey IS NULL THEN 1 ELSE 0 END), SUM(CASE WHEN GeoKey IS NULL OR GeoKey = '' THEN 1 ELSE 0 END) FROM silver.vw_deaths
UNION ALL SELECT 'mobility', COUNT(*), SUM(CASE WHEN DateKey IS NULL THEN 1 ELSE 0 END), SUM(CASE WHEN GeoKey IS NULL OR GeoKey = '' THEN 1 ELSE 0 END) FROM silver.vw_mobility
UNION ALL SELECT 'demographics', COUNT(*), 0, SUM(CASE WHEN GeoKey IS NULL OR GeoKey = '' THEN 1 ELSE 0 END) FROM silver.vw_demographics
UNION ALL SELECT 'lawatlas_policy', COUNT(*), SUM(CASE WHEN DateKey IS NULL THEN 1 ELSE 0 END), SUM(CASE WHEN GeoKey IS NULL OR GeoKey = '' THEN 1 ELSE 0 END) FROM silver.vw_lawatlas_policy
UNION ALL SELECT 'us_counties_2022', COUNT(*), SUM(CASE WHEN DateKey IS NULL THEN 1 ELSE 0 END), SUM(CASE WHEN GeoKey IS NULL OR GeoKey = '' THEN 1 ELSE 0 END) FROM silver.vw_us_counties_2022;
GO

SELECT * FROM gold.vw_audit_trust;
SELECT TOP 100 * FROM gold.vw_spread_risk_daily ORDER BY [Date] DESC;
GO

