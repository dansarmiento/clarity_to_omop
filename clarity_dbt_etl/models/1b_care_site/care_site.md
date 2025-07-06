
# OMOP Care_Site ETL Documentation

## Data Flow Summary
This code processes healthcare facility and location data through several stages:

- Extracts raw patient, location, and encounter data from source systems
- Stages and transforms the data
- Combines PCP (Primary Care Provider) and encounter-based location data
- Maps to standardized concepts
- Creates final `CARE_SITE` records

## PULL Queries

### PULL_CARE_SITE_ALL
Combines PCP and encounter point of service data
- Extracts distinct facility locations with IDs, names, and addresses
- Includes location source values for mapping

## STAGE Queries

### STAGE_CARE_SITE_ALL
Maps source location data to OMOP concepts
- Links to location IDs
- Creates standardized care site identifiers and names
- Maps place of service concepts

## Key Query Details

### CARE_SITE_RAW Query
**Purpose:** Creates intermediate care site records

**Key fields:**
- `CARE_SITE_ID`
- `CARE_SITE_NAME`
- `PLACE_OF_SERVICE_CONCEPT_ID`
- `LOCATION_ID`
- Source values for care site and place of service
- Includes data type casting and deduplication

### CARE_SITE Query
**Purpose:** Creates final care site records
- Excludes records with fatal or invalid data errors
- Performs final validation and filtering
- Maintains core care site attributes from RAW table
- Links to quality assurance exclusions

## Supporting CTEs
- `PATIENT_stg`: Patient demographics and registration
- `CLARITY_POS_stg`: Place of service details
- `ZC_STATE_stg`: State/province reference data
- `ZC_COUNTY_stg`: County reference data
- `PAT_ENC_stg`: Patient encounter data
- `CLARITY_DEP_stg`: Department information
- Various location and provider mapping CTEs

