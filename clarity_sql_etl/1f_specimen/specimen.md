
# OMOP Specimen ETL Documentation

## Data Flow Summary
The ETL process transforms specimen data from the source system (Clarity) into the OMOP CDM `Specimen` table through several stages:

- Source data extraction from multiple Clarity tables
- Initial transformation in PULL layer
- Mapping concepts in STAGE layer
- Loading final data into `SPECIMEN_RAW` and `SPECIMEN` tables

## Query Descriptions

### Source Tables CTEs
- `PATIENT_stg`: Extracts patient demographic data, filtering for valid non-test patients
- `SPEC_DB_MAIN_stg`: Retrieves basic specimen information including collection dates
- `ZC_SPEC_SOURCE_stg`: Contains specimen source category reference data
- `HSC_SPEC_INFO_stg`: Contains detailed specimen information
- `ZC_SPECIMEN_TYPE_stg`: Reference data for specimen types
- `ZC_SPECIMEN_UNIT_stg`: Reference data for specimen measurement units

## Main Transformation Queries

### SPECIMEN_CLARITY_ALL (PULL Layer)
Joins source tables to create initial specimen records
- Maps patient identifiers
- Combines specimen type and source information
- Includes dates, quantities, and source values

### STAGE_SPECIMEN_ALL (STAGE Layer)
Maps source codes to standard concepts using `SOURCE_TO_CONCEPT_MAP`
- Applies concept mappings for specimen types and anatomic sites
- Prepares data structure matching OMOP CDM specifications

### SPECIMEN_RAW Query
Assigns unique `SPECIMEN_ID`s
- Converts data types to match OMOP specifications
- Adds ETL tracking fields
- Maintains source system reference information

### SPECIMEN Query
Final quality-checked specimen records
- Excludes records with fatal or invalid data errors
- Contains complete OMOP CDM specimen information

## Field Mappings
The ETL process maps the following key fields:

- Person identifiers
- Specimen concepts
- Dates and times
- Anatomical sites
- Quantities and units
- Source values and references

## Data Quality
- Excludes test patients
- Requires valid birth dates
- Implements concept mapping validation
- Applies QA error checking before final load

