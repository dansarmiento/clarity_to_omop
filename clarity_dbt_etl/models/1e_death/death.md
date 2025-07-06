
# OMOP Death ETL Documentation

## Data Flow Summary
The ETL process transforms patient death data from the source system into the OMOP CDM `Death` table through several stages:

- Source data extraction from CLARITY tables
- Intermediate staging (`PULL_DEATH_ALL`)
- Further staging with concept mapping (`STAGE_DEATH_ALL`)
- Raw OMOP format (`DEATH_RAW`)
- Final OMOP Death table

## Key Queries

### PULL_DEATH_ALL
Extracts death information from source CLARITY tables
- Joins multiple staging CTEs:
  - `PATIENT_stg`: Core patient demographics
  - `PATIENT_3_stg`: Supplemental patient information
  - `CLARITY_EDG_stg`: Diagnosis information
  - Various concept mapping tables
- Focuses on deceased patients (`PAT_STATUS_C = 2`)
- Selects key fields:
  - `PERSON_ID`
  - `DEATH_DATE`
  - `DEATH_DATETIME`

### STAGE_DEATH_ALL
Processes data from `PULL_DEATH_ALL`
- Maps concepts using SNOMED vocabulary
- Adds standard concept mappings
- Includes ETL tracking fields
- Currently excludes cause of death mapping (commented out) to prevent duplicates

### DEATH_RAW
Converts staged data to OMOP format
- Applies data type casting
- Adds standard death type concept (32817 - "EHR")
- Includes both OMOP standard fields and custom tracking fields

### DEATH (Final)
Creates final OMOP Death table
- Excludes records with fatal or invalid data errors
- Maintains both required OMOP fields and custom tracking fields
- Performs quality assurance filtering through `QA_ERR_DBT` table

## Key Fields
- `PERSON_ID`: Primary identifier
- `DEATH_DATE`: Date of death
- `DEATH_DATETIME`: Timestamp of death
- `DEATH_TYPE_CONCEPT_ID`: Fixed as 32817 (EHR source)
- `CAUSE_CONCEPT_ID`: Currently nulled to prevent duplicates
- `ETL_MODULE`: Tracking field for ETL process
- `phi_PAT_ID`: Original patient ID (non-OMOP)
- `phi_MRN_CPI`: Medical record number (non-OMOP)

