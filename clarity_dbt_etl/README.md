# Corewell Health OMOP Code - Version 5
## The Final Frontier

## Contents
- 1a_location
- 1b_care_site
- 1c_provider
- 1d_person
- 1e_death
- 1f_specimen
- 2c_Visit_occurrence
- 2c_Visit_detail
- 2d_Condition_occurrence
- 2e_Measurement
- 2f_Drug_Exposure
- 2g_Procedure_occurrence
- 2h_Observation
- 2i_Note
- 2j_Device_exposure
- 3_derived_tables
- 5_Curation: various Data Quality queries
- 60_Validation: Summary queries

## Database Information
### Clarity Instance
- Database: `CARE_BRONZE_CLARITY_PROD`
- Schema: `dbo`

### OMOP Instance
- Database: `CARE_RES_OMOP_DEV2_WKSP`
- Schemas:
  - `OMOP`
  - `OMOP_CLARITY`
  - `OMOP_PULL`
  - `OMOP_STAGE`

## Patient Data
All code is limited to a de-identified list of patients using `CARE_RES_OMOP_DEV2_WKSP.OMOP.PATIENT_DRIVER`. This table contains:
- `EPIC_PAT_ID`
- `DEIDENT_ID`

## Code Module Steps
1. "Pull" query: queries the Clarity data
2. "Stage" query: maps the pull query data to OMOP vocabularies
3. "Write" query: UNIONs stage queries and writes to OMOP clinical data table
4. "yml_tests": tests for data integrity

## Implementation Notes
- Code is provided as SELECT statements
- Implementation method (tables, temp tables, or views) is flexible
- Entity Relationship Diagrams included for Clarity data
