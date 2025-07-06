
# OMOP Provider ETL Documentation

## Data Flow Overview
The ETL process transforms provider data from the CLARITY source system into the OMOP CDM `Provider` table through several stages:

- Source data extraction from CLARITY tables
- Initial transformation and staging (`PULL_PROVIDER_ALL`)
- Mapping to standard concepts (`STAGE_PROVIDER_ALL`)
- Final formatting (`PROVIDER_RAW`)
- Quality checks and loading (`PROVIDER`)

## Source Queries

### Source Tables
- **CLARITY_SER**: Provider basic information
- **CLARITY_SER_2**: Additional provider details including NPI
- **CLARITY_DEP**: Department information
- **D_PROV_PRIMARY_HIERARCHY**: Provider hierarchy and specialty
- **ZC_SPECIALTY**: Specialty lookup
- **CLARITY_EMP**: Employee information
- **ZC_SEX**: Gender lookup

## Main Transformation Queries

### PULL_PROVIDER_ALL
Combines data from source tables
- Extracts key provider attributes:
  - Provider ID and Name
  - NPI and DEA numbers
  - Birth year
  - Gender
  - Specialty
- Filters out resource and laboratory providers
- Removes duplicates through `ROW_NUMBER()`

### STAGE_PROVIDER_ALL
Maps source values to standard concepts
- Links to care sites
- Handles specialty and gender concept mapping
- Groups data by provider attributes

### PROVIDER_RAW Query
Formats data types for OMOP schema
- Includes fields:
  - Provider identifiers (ID, NPI, DEA)
  - Demographics (name, birth year, gender)
  - Specialty information
  - Care site associations
  - Source values and concept mappings

### PROVIDER Query
Final transformation step
- Applies quality checks
- Excludes records with fatal or invalid data errors
- Produces final OMOP-compliant provider records

## Data Quality
- Removes duplicate providers
- Validates provider IDs
- Excludes problematic records based on QA checks
- Ensures proper data type formatting

