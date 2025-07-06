
# OMOP Observation Data Flow Documentation

## Overview
This SQL code implements the Extract-Transform-Load (ETL) process for the OMOP Observation domain, transforming data from various source tables into the OMOP CDM format.

## PULL Queries

### PULL_OBSERVATION_ALL_ALLERGY
Sources patient allergy data from `PAT_ALLERGIES`, `ALLERGY`, and `CL_ELG` tables
- Captures allergy records and their associated details
- Links to patient encounters and providers

### PULL_OBSERVATION_AMB_FLOWSHEET
Extracts ambulatory flowsheet measurements
- Sources from `IP_FLWSHT_MEAS` and related tables
- Captures flowsheet values and measurements

### PULL_OBSERVATION_AMB_ICD
Pulls ambulatory ICD diagnosis codes
- Sources from `PAT_ENC_DX` and related diagnosis tables
- Handles both ICD-9 and ICD-10 codes

### PULL_OBSERVATION_HOSP_FLOWSHEET
Extracts hospital flowsheet measurements
- Similar to `AMB_FLOWSHEET` but for inpatient settings
- Includes additional hospital-specific attributes

### PULL_OBSERVATION_HOSP_ICD
Pulls hospital ICD diagnosis codes
- Sources from hospital encounter diagnosis tables
- Handles both ICD-9 and ICD-10 codes

## STAGE Queries

### STAGE_OBSERVATION_ALLERGY_ALL
Standardizes allergy data to OMOP format
- Maps allergy concepts to standard vocabularies
- Includes provider and visit linkages

### STAGE_OBSERVATION_AMB_ICD
Standardizes ambulatory ICD codes
- Maps to OMOP standard concepts
- Includes temporal validity checks

### STAGE_OBSERVATION_AMB_SDOH_FLOWSHEET
Standardizes Social Determinants of Health data
- Maps flowsheet measures to OMOP concepts
- Includes value mappings

### STAGE_OBSERVATION_HSP_ICD
Standardizes hospital ICD codes
- Similar to `AMB_ICD` but for inpatient settings
- Includes hospital-specific attributes

### STAGE_OBSERVATION_HSP_SDOH_FLOWSHEET
Standardizes hospital SDOH data
- Maps to standard concepts
- Includes hospital-specific context

## OBSERVATION Queries

### OBSERVATION_RAW
Combines all staged observation data
- Assigns unique observation IDs
- Includes source-to-concept mappings
- Maintains links to source data
- Includes both OMOP standard fields and custom fields

### OBSERVATION
Final cleaned observation table
- Excludes invalid/error records
- Maintains full OMOP CDM compliance
- Includes both standard and custom fields
- Links to source systems maintained

The code implements a comprehensive ETL process for converting various clinical observations into the OMOP Common Data Model format while maintaining data provenance and quality controls.

