
# Device Exposure ETL Documentation

## Data Flow Summary
The ETL process transforms device exposure data from multiple source tables into the OMOP CDM format through these main steps:

- Pull raw data from source tables
- Stage the data with standardized fields
- Create final `DEVICE_EXPOSURE` tables (RAW and clean)

## PULL Queries

### PULL_DEVICE_EXPOSURE_HOSP_BLOOD
Pulls blood product administration data
- Sources from `ORDER_PROC`, `CLARITY_EAP`, and `BLOOD_ADMIN_INFO` tables
- Captures blood product units, types, and administration details

### PULL_DEVICE_EXPOSURE_ANES_LDA
Pulls anesthesia-related line/drain/airway (LDA) device data
- Sources from `PAT_ENC`, `F_AN_RECORD_SUMMARY`, and `IP_LDA_NOADDSINGLE` tables
- Captures device placement and removal details during anesthesia

### PULL_DEVICE_EXPOSURE_HOSP_LDA
Pulls hospital line/drain/airway device data
- Similar to `ANES_LDA` but for general hospital stays
- Sources from `IP_LDA_NOADDSINGLE` table

## STAGE Queries

### STAGE_DEVICE_EXPOSURE_HSP_BLOOD
Standardizes blood product administration data
- Maps to OMOP concepts using `SOURCE_TO_CONCEPT_MAP_DEVICE_BLOOD`
- Includes visit and provider linkage

### STAGE_DEVICE_EXPOSURE_ANES_LDA
Standardizes anesthesia device data
- Maps to OMOP concepts using `SOURCE_TO_CONCEPT_MAP_DEVICE_LDA`
- Includes visit and provider linkage

### STAGE_DEVICE_EXPOSURE_HSP_LDA
Standardizes hospital device data
- Similar to `ANES_LDA` staging
- Maps using same concept mappings

## DEVICE_EXPOSURE_RAW Query
Combines all staged device data into single raw table
- Assigns unique `DEVICE_EXPOSURE_ID`s
- Includes source system reference fields
- Maintains PHI fields for validation
- Adds metadata like `ETL_MODULE`

## DEVICE_EXPOSURE Query
Creates final clean `DEVICE_EXPOSURE` table
- Excludes records with fatal/invalid data errors
- Removes records flagged in QA process
- Maintains core OMOP fields plus custom extensions
- Final production-ready device exposure data

The ETL process ensures complete capture of blood products and medical devices while standardizing to OMOP concepts and maintaining data quality through QA checks.

