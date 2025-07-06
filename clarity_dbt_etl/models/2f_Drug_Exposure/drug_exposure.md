
# Drug Exposure ETL Documentation

## Data Flow Summary
The code transforms drug exposure data from multiple source tables into the OMOP CDM `drug_exposure` format through several stages:

- **Pull queries** extract raw data from source systems
- **Stage queries** transform and map the data to OMOP concepts
- **Final `drug_exposure` tables** combine all sources into standardized format

## PULL Queries

### PULL_DRUG_EXPOSURE_ALL_IMM
Extracts immunization records
- Sources: `IMMUNE`, `CLARITY_IMMUNZATN`, `PAT_ENC` tables
- Includes vaccination details like dates, routes, lots

### PULL_DRUG_EXPOSURE_AMB_RXNORM
Extracts ambulatory medication orders
- Sources: `ORDER_MED`, `MAR_ADMIN_INFO` tables
- Includes prescription details for outpatient visits

### PULL_DRUG_EXPOSURE_ANES_RXNORM
Extracts anesthesia medications
- Sources: `ORDER_MED`, `MAR_ADMIN_INFO` for anesthesia cases
- Includes medications administered during procedures

### PULL_DRUG_EXPOSURE_HOSP_RXNORM
Extracts inpatient medications
- Sources: `ORDER_MED`, `MAR_ADMIN_INFO` for hospitalizations
- Includes medications administered during hospital stays

## STAGE Queries

### STAGE_DRUG_EXPOSURE_ALL_IMM
Maps immunization data to standard concepts
- Adds required OMOP fields
- Links to visit and provider data

### STAGE_DRUG_EXPOSURE_AMB_RXNORM
Maps outpatient medications to RxNorm concepts
- Standardizes dosing and route information
- Links to encounters

### STAGE_DRUG_EXPOSURE_ANES_RXNORM
Maps anesthesia medications to standards
- Includes procedure context
- Links to surgical cases

### STAGE_DRUG_EXPOSURE_HSP_RXNORM
Maps inpatient medications to standards
- Includes administration details
- Links to hospital stays

## DRUG_EXPOSURE_RAW Query
Combines all staged drug exposure records
- Assigns `drug_exposure_id` sequence
- Includes source-to-standard mappings
- Adds metadata fields for tracking

## DRUG_EXPOSURE Query
Filters final drug exposure table
- Excludes invalid/error records
- Creates production version of table
- Maintains full OMOP CDM structure

The ETL process ensures complete capture of medication data while standardizing to OMOP concepts and maintaining links to source systems.

