
# Visit Occurrence ETL Documentation

## Overview
This SQL code is responsible for extracting and transforming visit/encounter data from multiple source tables into the OMOP CDM Visit Occurrence table format. The process involves handling both ambulatory (AMB) and hospital (HSP) visits.

## Source Tables

### Primary Tables
- **PAT_ENC** - Contains patient encounter records
- **PAT_ENC_HSP** - Contains hospital encounter information
- **PAT_ENC_2** - Supplemental encounter information
- **PAT_OR_ADM_LINK** - Operating room admission linkage
- **HSP_ACCOUNT** - Hospital account information

### Reference Tables
- **CLARITY_LOC** - Location information
- **CLARITY_SER** - Provider information
- Various **ZC_ tables** - Lookup tables for different codes and classifications

## ETL Process

### 1. Ambulatory Visits (PULL_VISIT_OCCURRENCE_AMB)
Extracts outpatient and ambulatory encounters

**Key transformations:**
- Visit dates derived from `CHECKIN_TIME`, `APPT_TIME`, or `CONTACT_DATE`
- Filters out specific encounter types and statuses
- Links to provider and location information

### 2. Hospital Visits (PULL_VISIT_OCCURRENCE_HSP)
Processes inpatient and hospital encounters

**Key transformations:**
- Visit dates from `HOSP_ADMSN_TIME` and `HOSP_DISCH_TIME`
- Includes admission source and discharge disposition
- Links to hospital account information

### 3. Staging (STAGE_VISIT_OCCURRENCE_*)
Converts source codes to standard concepts
Applies additional business rules
Combines with provider and care site information

### 4. Final Visit Occurrence Table
Combines ambulatory and hospital visits
Assigns unique `VISIT_OCCURRENCE_ID`
Includes both standard OMOP fields and custom fields for tracking

## Key Business Rules
- Visit dates cannot be more than 30 days after death date
- Future visits are removed
- Hospital visits must have both start and end times
- Specific encounter types and statuses are filtered out

## Output Fields

### Standard OMOP Fields
- `VISIT_OCCURRENCE_ID`
- `PERSON_ID`
- `VISIT_CONCEPT_ID`
- `VISIT_START_DATE/DATETIME`
- `VISIT_END_DATE/DATETIME`
- `VISIT_TYPE_CONCEPT_ID`
- `PROVIDER_ID`
- `CARE_SITE_ID`
- Various source values and concept IDs

### Custom Fields
- `ETL_MODULE`
- `phi_PAT_ID`
- `phi_MRN_CPI`
- `phi_CSN_ID`

## Dependencies
- **PATIENT_DRIVER** table for participant list
- **SOURCE_TO_CONCEPT_MAP** for code mapping
- **PROVIDER_RAW** and **CARE_SITE_RAW** for reference data

## Notes
- Uses CTEs for modular code organization
- Implements both `UNION ALL` to combine ambulatory and hospital visits
- Includes PHI fields for tracking and validation

