# EDA Profile - COVID Tables (Sampled)

Sample size per table: up to 20,000 rows

## colleges.csv
- Total rows (estimated): 1,947
- Columns: 9
- Rows profiled: 1,948
- Numeric columns (sample): 3
- Highest null columns (sample):
  - notes: 98.15%
  - cases_2021: 17.3%
- Date coverage (sample):
  - date: 2021-05-26 to 2021-05-26 (invalid: 0)
- Key cardinality (sample unique):
  - state: 57
  - county: 737
  - ipeds_id: 1,948

## deaths.csv
- Total rows (estimated): 7,258
- Columns: 12
- Rows profiled: 7,258
- Numeric columns (sample): 5
- Highest null columns (sample):
  - placename: 94.83%
  - expected_deaths: 82.53%
  - excess_deaths: 82.53%
  - baseline: 82.53%
  - start_date: 10.58%
- Date coverage (sample):
  - start_date: 2010-01-09 to 2020-12-23 (invalid: 0)
  - end_date: 2010-01-15 to 2020-12-29 (invalid: 0)
  - year: 2010-01-01 to 2020-01-01 (invalid: 418)

## demographics.csv
- Total rows (estimated): 21,689
- Columns: 19
- Rows profiled: 20,001
- Numeric columns (sample): 18
- Highest null columns (sample):
  - population_clustered: 99.43%
  - population_largest_city: 99.28%
  - population_rural: 99.0%
  - population_urban: 99.0%
  - population_density: 94.12%

## economy.csv
- Total rows (estimated): 404
- Columns: 4
- Rows profiled: 404
- Numeric columns (sample): 3
- Highest null columns (sample):
  - human_capital_index: 61.39%
  - gdp_per_capita_usd: 9.65%
  - gdp_usd: 7.67%

## epidemiology.csv
- Total rows (estimated): 12,525,825
- Columns: 10
- Rows profiled: 20,001
- Numeric columns (sample): 8
- Highest null columns (sample):
  - new_tested: 89.54%
  - cumulative_tested: 89.07%
  - new_recovered: 32.62%
  - cumulative_recovered: 32.47%
  - new_confirmed: 0.19%
- Date coverage (sample):
  - date: 2020-01-01 to 2022-09-15 (invalid: 0)

## facilities.csv
- Total rows (estimated): 2,639
- Columns: 16
- Rows profiled: 2,639
- Numeric columns (sample): 9
- Highest null columns (sample):
  - note: 98.48%
  - max_inmate_population_2020: 68.25%
  - latest_inmate_population: 39.64%
  - facility_city: 0.38%
  - facility_state: 0.04%
- Key cardinality (sample unique):
  - nyt_id: 2,638
  - facility_county: 956
  - facility_county_fips: 1,348
  - facility_state: 53

## facility-boundary-us-all.csv
- Total rows (estimated): 353,020
- Columns: 15
- Rows profiled: 20,001
- Numeric columns (sample): 4
- Highest null columns (sample):
  - facility_name: 0.0%
- Key cardinality (sample unique):
  - facility_place_id: 5,000
  - facility_provider_id: 5,000
  - facility_region_place_id: 2,223

## geography.csv
- Total rows (estimated): 22,130
- Columns: 8
- Rows profiled: 20,001
- Numeric columns (sample): 7
- Highest null columns (sample):
  - area_rural_sq_km: 99.15%
  - area_urban_sq_km: 99.15%
  - openstreetmap_id: 29.49%
  - elevation_m: 20.23%
  - area_sq_km: 13.4%
- Key cardinality (sample unique):
  - openstreetmap_id: 5,000

## google-search-trends.csv
- Total rows (estimated): 2,713,929
- Columns: 424
- Rows profiled: 20,001
- Numeric columns (sample): 421
- Highest null columns (sample):
  - search_trends_generalized_tonic–clonic_seizure: 100.0%
  - search_trends_photodermatitis: 75.22%
  - search_trends_viral_pneumonia: 73.61%
  - search_trends_burning_chest_pain: 65.52%
  - search_trends_hypercapnia: 65.5%
- Date coverage (sample):
  - date: 2020-01-01 to 2022-09-12 (invalid: 0)
- Key cardinality (sample unique):
  - search_trends_avoidant_personality_disorder: 140
  - search_trends_candidiasis: 530
  - search_trends_diabetic_ketoacidosis: 102
  - search_trends_epidermoid_cyst: 107
  - search_trends_hemorrhoids: 335
  - search_trends_hyperemesis_gravidarum: 95
  - search_trends_hyperhidrosis: 184
  - search_trends_hyperlipidemia: 96

## health.csv
- Total rows (estimated): 3,504
- Columns: 14
- Rows profiled: 3,504
- Numeric columns (sample): 13
- Highest null columns (sample):
  - hospital_beds_per_1000: 99.29%
  - smoking_prevalence: 95.83%
  - physicians_per_1000: 95.32%
  - nurses_per_1000: 94.86%
  - pollution_mortality_rate: 94.78%
- Key cardinality (sample unique):
  - comorbidity_mortality_rate: 128

## hospitalizations.csv
- Total rows (estimated): 1,768,485
- Columns: 11
- Rows profiled: 20,001
- Numeric columns (sample): 4
- Highest null columns (sample):
  - current_hospitalized_patients: 100.0%
  - current_intensive_care_patients: 100.0%
  - new_ventilator_patients: 100.0%
  - cumulative_ventilator_patients: 100.0%
  - current_ventilator_patients: 100.0%
- Date coverage (sample):
  - date: 0022-01-10 to 2022-06-04 (invalid: 0)

## index.csv
- Total rows (estimated): 22,963
- Columns: 15
- Rows profiled: 20,001
- Numeric columns (sample): 1
- Highest null columns (sample):
  - locality_code: 99.85%
  - locality_name: 99.85%
  - datacommons_id: 93.21%
  - subregion2_code: 7.97%
  - subregion2_name: 7.97%
- Key cardinality (sample unique):
  - place_id: 5,000
  - wikidata_id: 5,000
  - datacommons_id: 1,355

## lawatlas-emergency-declarations.csv
- Total rows (estimated): 8,364
- Columns: 104
- Rows profiled: 8,364
- Numeric columns (sample): 92
- Highest null columns (sample):
  - lawatlas_requirement_type_traveler_must_self_quarantine: 100.0%
  - lawatlas_requirement_type_traveler_must_inform_others_of_travel: 100.0%
  - lawatlas_requirement_type_checkpoints_must_be_established: 100.0%
  - lawatlas_requirement_type_travel_requirement_must_be_posted: 100.0%
  - lawatlas_business_type_all_non_essential_businesses: 100.0%
- Date coverage (sample):
  - date: 2020-01-20 to 2020-07-01 (invalid: 0)
- Key cardinality (sample unique):
  - lawatlas_state_emergency: 2
  - lawatlas_emerg_statewide: 2
  - lawatlas_traveler_type_all_people_entering_the_state: 2
  - lawatlas_traveler_type_travelers_from_specified_states: 2
  - lawatlas_travel_statewide: 1
  - lawatlas_home_except_caring_for_a_person_outside_the_home: 2
  - lawatlas_home_except_caring_for_a_pet_outside_the_home: 2
  - lawatlas_home_statewide: 2

## mask-use-by-county.csv
- Total rows (estimated): 3,142
- Columns: 6
- Rows profiled: 3,142
- Numeric columns (sample): 6
- Key cardinality (sample unique):
  - COUNTYFP: 3,142

## mobility.csv
- Total rows (estimated): 6,321,226
- Columns: 8
- Rows profiled: 20,001
- Numeric columns (sample): 6
- Highest null columns (sample):
  - mobility_grocery_and_pharmacy: 38.93%
  - mobility_transit_stations: 33.03%
  - mobility_residential: 28.03%
  - mobility_retail_and_recreation: 26.21%
  - mobility_parks: 5.39%
- Date coverage (sample):
  - date: 2020-02-15 to 2022-09-12 (invalid: 0)
- Key cardinality (sample unique):
  - mobility_residential: 53

## systems.csv
- Total rows (estimated): 53
- Columns: 8
- Rows profiled: 54
- Numeric columns (sample): 7
- Highest null columns (sample):
  - max_inmate_population_2020: 7.41%
  - latest_inmate_population: 5.56%
  - inmate_tests: 1.85%
  - total_officer_cases: 1.85%
  - total_officer_deaths: 1.85%

## us-counties-2020.csv
- Total rows (estimated): 884,736
- Columns: 6
- Rows profiled: 20,001
- Numeric columns (sample): 3
- Highest null columns (sample):
  - fips: 1.55%
- Date coverage (sample):
  - date: 2020-01-21 to 2020-03-30 (invalid: 0)
- Key cardinality (sample unique):
  - county: 1,283
  - state: 55
  - fips: 1,963

## us-counties-2021.csv
- Total rows (estimated): 1,185,372
- Columns: 6
- Rows profiled: 20,001
- Numeric columns (sample): 3
- Highest null columns (sample):
  - deaths: 2.34%
  - fips: 0.85%
- Date coverage (sample):
  - date: 2021-01-01 to 2021-01-07 (invalid: 0)
- Key cardinality (sample unique):
  - county: 1,930
  - state: 55
  - fips: 3,218

## us-counties-2022.csv
- Total rows (estimated): 1,188,041
- Columns: 6
- Rows profiled: 20,001
- Numeric columns (sample): 3
- Highest null columns (sample):
  - deaths: 2.34%
  - fips: 1.04%
- Date coverage (sample):
  - date: 2022-01-01 to 2022-01-07 (invalid: 0)
- Key cardinality (sample unique):
  - county: 1,930
  - state: 56
  - fips: 3,218

## us-states.csv
- Total rows (estimated): 61,941
- Columns: 5
- Rows profiled: 20,001
- Numeric columns (sample): 3
- Date coverage (sample):
  - date: 2020-01-21 to 2021-03-01 (invalid: 0)
- Key cardinality (sample unique):
  - state: 55
  - fips: 55

## us.csv
- Total rows (estimated): 1,157
- Columns: 3
- Rows profiled: 1,158
- Numeric columns (sample): 2
- Date coverage (sample):
  - date: 2020-01-21 to 2023-03-23 (invalid: 0)
