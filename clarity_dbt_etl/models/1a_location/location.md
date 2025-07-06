
# OMOP Location ETL Documentation

## Data Flow Summary
The code processes location data from multiple sources (patient and care site locations) to create standardized location records in the OMOP format. The flow consists of staging tables, pulling data from multiple sources, and finally creating location records.

## "PULL_" Queries

### PULL_CARE_SITE_LOCATIONS
Extracts location information from care sites
- Joins multiple staging tables (`PAT_ENC`, `CLARITY_DEP`, `CLARITY_POS`)
- Creates a concatenated `LOCATION_SOURCE_VALUE`

### PULL_PERSON_LOCATIONS
Extracts location information from patient records
- Aggregates patient address information
- Creates a concatenated `LOCATION_SOURCE_VALUE`

## "STAGE_" Queries

### STAGE_LOCATION_ALL
Combines results from `PULL_PERSON_LOCATIONS` and `PULL_CARE_SITE_LOCATIONS`
- Uses `UNION ALL` to merge both location sets
- Contains standardized address fields (`ADDRESS_1`, `ADDRESS_2`, `CITY`, `STATE`, `ZIP`, `COUNTY`)

## LOCATION_RAW Query
Generates unique `LOCATION_ID` using sequence
Creates initial location records from `STAGE_LOCATION_ALL`

**Fields include:**
- `LOCATION_ID`
- `ADDRESS_1`, `ADDRESS_2`
- `CITY`, `STATE`, `ZIP`
- `COUNTY`
- `LOCATION_SOURCE_VALUE`

## LOCATION Query
Final location table
- Filters out invalid records using `QA_ERR_DBT` table
- Excludes records with 'FATAL' or 'INVALID DATA' error types
- Contains validated location records ready for use in the OMOP model

## Supporting Staging Tables
- `PAT_ENC_stg`: Patient encounter data
- `CLARITY_DEP_stg`: Department information
- `CLARITY_POS_stg`: Place of service details
- `ZC_STATE_stg`: State reference data
- `ZC_COUNTY_stg`: County reference data
- `PATIENT_stg`: Patient demographic data

