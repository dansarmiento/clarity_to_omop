
# OMOP Person ETL Documentation

## Data Flow Summary
The ETL process transforms patient demographic data from a source system (CLARITY) into the OMOP `Person` table format through several stages:

- Source data extraction from CLARITY tables
- Initial transformation in `PULL_PERSON_ALL`
- Further transformation in `STAGE_PERSON_ALL`
- Final loading into `PERSON_RAW` and `PERSON` tables

## Query Descriptions

### PULL_PERSON_ALL Query
This query combines data from multiple source tables to create the initial patient dataset:

**Main source tables:**
- `PATIENT`
- `PATIENT_3`
- `VALID_PATIENT`
- `PATIENT_RACE`
- Various `ZC_` lookup tables for demographics

**Key transformations:**
- Filters out test patients
- Validates patient records
- Extracts demographic information
- Creates location source value from address components
- Joins with `PATIENT_DRIVER` for ID mapping

### STAGE_PERSON_ALL Query
This query standardizes the data according to OMOP CDM requirements:

- Maps source codes to standard concepts using `SOURCE_TO_CONCEPT_MAP` tables for:
  - Gender
  - Race
  - Ethnicity
- Links to other OMOP tables:
  - `LOCATION`
  - `PROVIDER`
  - `CARE_SITE`
- Creates source value concatenations for demographics

### PERSON_RAW Query
Performs final data typing and formatting:

- Applies proper data types to all fields
- Removes duplicates using `ROW_NUMBER()`
- Maintains both OMOP standard fields and custom fields

### PERSON Query
Final production table that:

- Excludes records with fatal or invalid data errors
- Maintains referential integrity
- Provides the final validated person dataset for the OMOP CDM

## Key Fields
- `PERSON_ID`: Unique identifier
- Demographic concepts (gender, race, ethnicity)
- Birth information
- Location and provider references
- Source value fields for traceability
- Custom fields for local use (`ETL_MODULE`, phi fields)

