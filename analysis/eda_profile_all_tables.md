# EDA Profile - COVID Source Tables

Tables profiled: 21

## colleges.csv
- Shape: 1,948 rows x 9 cols
- Numeric vs non-numeric: 3 / 6
- Date coverage:
  - date: 2021-05-26 to 2021-05-26 (invalid: 0)
- Highest null columns:
  - notes: 98.15%
  - cases_2021: 17.3%
- Key cardinality signals:
  - state: 57 unique
  - county: 737 unique
  - ipeds_id: 1948 unique

## deaths.csv
- Shape: 7,258 rows x 12 cols
- Numeric vs non-numeric: 5 / 7
- Date coverage:
  - start_date: 2010-01-09 to 2020-12-23 (invalid: 0)
  - end_date: 2010-01-15 to 2020-12-29 (invalid: 0)
  - year: 2010-01-01 to 2020-01-01 (invalid: 418)
- Highest null columns:
  - placename: 94.83%
  - expected_deaths: 82.53%
  - excess_deaths: 82.53%
  - baseline: 82.53%
  - start_date: 10.58%

## demographics.csv
- Shape: 21,689 rows x 19 cols
- Numeric vs non-numeric: 18 / 1
- Highest null columns:
  - population_clustered: 99.44%
  - population_largest_city: 99.3%
  - population_rural: 99.02%
  - population_urban: 99.02%
  - population_density: 94.5%

## economy.csv
- Shape: 404 rows x 4 cols
- Numeric vs non-numeric: 3 / 1
- Highest null columns:
  - human_capital_index: 61.39%
  - gdp_per_capita_usd: 9.65%
  - gdp_usd: 7.67%

## epidemiology.csv
- Shape: 12,525,825 rows x 10 cols
- Numeric vs non-numeric: 8 / 2
- Date coverage:
  - date: 2019-12-31 to 2022-12-30 (invalid: 0)
- Highest null columns:
  - cumulative_tested: 75.95%
  - new_tested: 74.5%
  - new_recovered: 68.22%
  - cumulative_recovered: 68.14%
  - cumulative_deceased: 8.39%

## facilities.csv
- Shape: 2,639 rows x 16 cols
- Numeric vs non-numeric: 9 / 7
- Highest null columns:
  - note: 98.48%
  - max_inmate_population_2020: 68.25%
  - latest_inmate_population: 39.64%
  - facility_city: 0.38%
  - facility_state: 0.04%
- Key cardinality signals:
  - nyt_id: 2638 unique
  - facility_county: 956 unique
  - facility_county_fips: 1348 unique
  - facility_state: 53 unique

## facility-boundary-us-all.csv
- Shape: 353,020 rows x 15 cols
- Numeric vs non-numeric: 4 / 11
- Key cardinality signals:
  - facility_place_id: >10000 unique
  - facility_provider_id: >10000 unique
  - facility_region_place_id: 2534 unique

## geography.csv
- Shape: 22,130 rows x 8 cols
- Numeric vs non-numeric: 7 / 1
- Highest null columns:
  - area_rural_sq_km: 99.19%
  - area_urban_sq_km: 99.19%
  - openstreetmap_id: 26.87%
  - elevation_m: 26.64%
  - area_sq_km: 12.28%
- Key cardinality signals:
  - openstreetmap_id: >10000 unique

## google-search-trends.csv
- Shape: 2,713,929 rows x 424 cols
- Numeric vs non-numeric: 421 / 3
- Date coverage:
  - date: 2020-01-01 to 2022-09-12 (invalid: 0)
- Highest null columns:
  - search_trends_generalized_tonic–clonic_seizure: 100.0%
  - search_trends_viral_pneumonia: 97.77%
  - search_trends_photodermatitis: 97.57%
  - search_trends_shallow_breathing: 97.37%
  - search_trends_burning_chest_pain: 97.34%
- Key cardinality signals:
  - search_trends_avoidant_personality_disorder: 143 unique
  - search_trends_candidiasis: 760 unique
  - search_trends_diabetic_ketoacidosis: 128 unique
  - search_trends_epidermoid_cyst: 263 unique
  - search_trends_hemorrhoids: 412 unique
  - search_trends_hyperemesis_gravidarum: 99 unique
  - search_trends_hyperhidrosis: 302 unique
  - search_trends_hyperlipidemia: 100 unique

## health.csv
- Shape: 3,504 rows x 14 cols
- Numeric vs non-numeric: 13 / 1
- Highest null columns:
  - hospital_beds_per_1000: 99.29%
  - smoking_prevalence: 95.83%
  - physicians_per_1000: 95.32%
  - nurses_per_1000: 94.86%
  - pollution_mortality_rate: 94.78%
- Key cardinality signals:
  - comorbidity_mortality_rate: 128 unique

## hospitalizations.csv
- Shape: 1,768,485 rows x 11 cols
- Numeric vs non-numeric: 9 / 2
- Date coverage:
  - date: 0022-01-10 to 2022-09-16 (invalid: 0)
- Highest null columns:
  - cumulative_ventilator_patients: 99.53%
  - new_ventilator_patients: 99.38%
  - current_ventilator_patients: 97.29%
  - current_hospitalized_patients: 89.6%
  - current_intensive_care_patients: 89.15%

## index.csv
- Shape: 22,963 rows x 15 cols
- Numeric vs non-numeric: 1 / 14
- Highest null columns:
  - locality_code: 99.86%
  - locality_name: 99.86%
  - datacommons_id: 81.64%
  - subregion2_code: 7.45%
  - subregion2_name: 7.45%
- Key cardinality signals:
  - place_id: >10000 unique
  - wikidata_id: >10000 unique
  - datacommons_id: 4208 unique

## lawatlas-emergency-declarations.csv
- Shape: 8,364 rows x 104 cols
- Numeric vs non-numeric: 92 / 12
- Date coverage:
  - date: 2020-01-20 to 2020-07-01 (invalid: 0)
- Highest null columns:
  - lawatlas_requirement_type_traveler_must_self_quarantine: 100.0%
  - lawatlas_requirement_type_traveler_must_inform_others_of_travel: 100.0%
  - lawatlas_requirement_type_checkpoints_must_be_established: 100.0%
  - lawatlas_requirement_type_travel_requirement_must_be_posted: 100.0%
  - lawatlas_business_type_all_non_essential_businesses: 100.0%
- Key cardinality signals:
  - lawatlas_state_emergency: 2 unique
  - lawatlas_emerg_statewide: 2 unique
  - lawatlas_traveler_type_all_people_entering_the_state: 2 unique
  - lawatlas_traveler_type_travelers_from_specified_states: 2 unique
  - lawatlas_travel_statewide: 1 unique
  - lawatlas_home_except_caring_for_a_person_outside_the_home: 2 unique
  - lawatlas_home_except_caring_for_a_pet_outside_the_home: 2 unique
  - lawatlas_home_statewide: 2 unique

## mask-use-by-county.csv
- Shape: 3,142 rows x 6 cols
- Numeric vs non-numeric: 6 / 0
- Key cardinality signals:
  - COUNTYFP: 3142 unique

## mobility.csv
- Shape: 6,321,226 rows x 8 cols
- Numeric vs non-numeric: 6 / 2
- Date coverage:
  - date: 2020-02-15 to 2022-09-12 (invalid: 0)
- Highest null columns:
  - mobility_parks: 53.49%
  - mobility_transit_stations: 49.58%
  - mobility_grocery_and_pharmacy: 37.74%
  - mobility_residential: 34.68%
  - mobility_retail_and_recreation: 34.08%
- Key cardinality signals:
  - mobility_residential: 102 unique

## systems.csv
- Shape: 54 rows x 8 cols
- Numeric vs non-numeric: 7 / 1
- Highest null columns:
  - max_inmate_population_2020: 7.41%
  - latest_inmate_population: 5.56%
  - inmate_tests: 1.85%
  - total_officer_cases: 1.85%
  - total_officer_deaths: 1.85%

## us-counties-2020.csv
- Shape: 884,737 rows x 6 cols
- Numeric vs non-numeric: 3 / 3
- Date coverage:
  - date: 2020-01-21 to 2020-12-31 (invalid: 0)
- Highest null columns:
  - deaths: 2.12%
  - fips: 0.93%
- Key cardinality signals:
  - county: 1930 unique
  - state: 55 unique
  - fips: 3218 unique

## us-counties-2021.csv
- Shape: 1,185,373 rows x 6 cols
- Numeric vs non-numeric: 3 / 3
- Date coverage:
  - date: 2021-01-01 to 2021-12-31 (invalid: 0)
- Highest null columns:
  - deaths: 2.4%
  - fips: 0.91%
- Key cardinality signals:
  - county: 1930 unique
  - state: 56 unique
  - fips: 3218 unique

## us-counties-2022.csv
- Shape: 1,188,042 rows x 6 cols
- Numeric vs non-numeric: 3 / 3
- Date coverage:
  - date: 2022-01-01 to 2022-12-31 (invalid: 0)
- Highest null columns:
  - deaths: 2.4%
  - fips: 1.1%
- Key cardinality signals:
  - county: 1932 unique
  - state: 56 unique
  - fips: 3220 unique

## us-states.csv
- Shape: 61,942 rows x 5 cols
- Numeric vs non-numeric: 3 / 2
- Date coverage:
  - date: 2020-01-21 to 2023-03-23 (invalid: 0)
- Key cardinality signals:
  - state: 56 unique
  - fips: 56 unique

## us.csv
- Shape: 1,158 rows x 3 cols
- Numeric vs non-numeric: 2 / 1
- Date coverage:
  - date: 2020-01-21 to 2023-03-23 (invalid: 0)
