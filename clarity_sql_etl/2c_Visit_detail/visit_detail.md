

```markdown
# Hospital Visit Detail ETL Documentation

## Overview
This SQL code performs ETL (Extract, Transform, Load) operations to populate the VISIT_DETAIL table in an OMOP CDM database. The code processes hospital encounter information from various source tables.

## Source Tables

### Primary Sources
- **PAT_ENC_HSP**
  - Primary table for hospital encounter information
  - Contains ADT workflow data (preadmission, admission, ED Arrival, discharge, etc.)
- **PAT_ENC**
  - Contains patient encounter records
  - Primary key: `PAT_ENC_CSN_ID`
  - Excludes Registration and PCP/Clinic Change contacts
- **CLARITY_ADT**
  - Master table for ADT event history information
  - Contains foreign keys for other ADT tables

### Reference Tables
- **ZC_PAT_CLASS**
- **ZC_PAT_STATUS**
- **ZC_ADM_SOURCE**
- **ZC_DISCH_DISP**
- **ZC_ED_DISPOSITION**
- **HSP_ACCOUNT**
- **CLARITY_DEP**
- **CLARITY_PRC**
- **ZC_PAT_SERVICE**

## Data Flow

### Stage 1: PULL_VISIT_DETAIL_HOSP_ALL
Combines hospital encounter data with reference information
Creates initial visit detail records

**Key fields:**
- `VISIT_DETAIL_START_DATE`
- `VISIT_DETAIL_END_DATE`
- `VISIT_DETAIL_RANK`
- `VISIT_DETAIL_SOURCE_VALUE`

### Stage 2: STAGE_VISIT_DETAIL_ALL
Maps source concepts to standard concepts
Adds required OMOP fields
Links to CARE_SITE and PROVIDER tables

### Final: VISIT_DETAIL
Creates final OMOP-compliant visit detail records
Assigns unique `VISIT_DETAIL_ID`s
Maintains PHI fields separately

## Key Transformations

### Visit Timing Logic
```sql
CAST(COALESCE(CLARITY_ADT_A.EFFECTIVE_TIME,
              PAT_ENC.CHECKIN_TIME,
              PAT_ENC.APPT_TIME,
              PAT_ENC_HSP.CONTACT_DATE) AS DATE) AS VISIT_DETAIL_START_DATE
```

### Visit Detail Ranking
```sql
RANK() OVER (
    PARTITION BY PAT_ENC_HSP.PAT_ENC_CSN_ID
    ORDER BY CLARITY_ADT_A.SEQ_NUM_IN_ENC,
             CLARITY_ADT_A.EFFECTIVE_TIME
) AS VISIT_DETAIL_RANK
```

## Output Fields

### Standard OMOP Fields
- `VISIT_DETAIL_ID`
- `PERSON_ID`
- `VISIT_DETAIL_CONCEPT_ID`
- `VISIT_DETAIL_START_DATE`
- `VISIT_DETAIL_END_DATE`
- `PROVIDER_ID`
- `CARE_SITE_ID`
- `VISIT_OCCURRENCE_ID`

### Custom Fields
- `ETL_MODULE`
- `phi_PAT_ID`
- `phi_MRN_CPI`
- `phi_CSN_ID`

## Dependencies
- OMOP Vocabulary tables
- Source to Concept Map tables
- **CARE_SITE_RAW**
- **PROVIDER_RAW**
- **VISIT_OCCURRENCE_RAW**

## Notes
- Handles both inpatient and outpatient encounters
- Maintains visit hierarchy through `PARENT_VISIT_DETAIL_ID`
- Preserves source values for traceability
- Includes PHI fields for internal reference
```

