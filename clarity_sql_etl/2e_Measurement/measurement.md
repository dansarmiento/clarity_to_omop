
# OMOP Measurement Data Flow Documentation

## Overview
This SQL code implements the Extract-Transform-Load (ETL) process for measurement data in the OMOP Common Data Model. The data flow moves through three main stages:

- **PULL queries** - Extract raw data from source systems
- **STAGE queries** - Transform data into OMOP format
- **Final MEASUREMENT tables** - Load standardized data

## PULL Queries
The code includes the following PULL queries:

### PULL_MEASUREMENT_AMB_FLOWSHEET
Extracts ambulatory flowsheet measurements
Sources from `IP_FLWSHT_MEAS` and related tables
Includes vitals, BMI, blood pressure etc.

### PULL_MEASUREMENT_AMB_LOINC
Extracts ambulatory lab results
Sources from `ORDER_RESULTS` and related tables
Includes LOINC-coded lab tests

### PULL_MEASUREMENT_HOSP_FLOWSHEET
Extracts hospital flowsheet measurements
Similar structure to ambulatory flowsheet
Hospital-specific measurements

### PULL_MEASUREMENT_HOSP_LOINC
Extracts hospital lab results
Similar structure to ambulatory LOINC
Hospital-specific lab tests

### PULL_MEASUREMENT_ANES_FLOWSHEET
Extracts anesthesia-related measurements
Sources from anesthesia-specific tables
Includes vitals during procedures

## STAGE Queries
The code includes STAGE queries for each measurement type:

### Flowsheet measurements:
- `STAGE_MEASUREMENT_AMB_FLOWSHEET_BMI`
- `STAGE_MEASUREMENT_AMB_FLOWSHEET_BPD`
- `STAGE_MEASUREMENT_AMB_FLOWSHEET_BPS`
- `STAGE_MEASUREMENT_AMB_FLOWSHEET_MISC`
- `STAGE_MEASUREMENT_AMB_FLOWSHEET_TEMP`
- `STAGE_MEASUREMENT_AMB_FLOWSHEET_VITALS`

### LOINC measurements:
- `STAGE_MEASUREMENT_AMB_LOINC`
- `STAGE_MEASUREMENT_HOSP_LOINC`

### Hospital measurements:
- `STAGE_MEASUREMENT_HOSP_FLOWSHEET_BMI`
- `STAGE_MEASUREMENT_HOSP_FLOWSHEET_BPD`
- `STAGE_MEASUREMENT_HOSP_FLOWSHEET_BPS`
- `STAGE_MEASUREMENT_HOSP_FLOWSHEET_MISC`
- `STAGE_MEASUREMENT_HOSP_FLOWSHEET_TEMP`
- `STAGE_MEASUREMENT_HOSP_FLOWSHEET_VITALS`

### Anesthesia measurements:
- `STAGE_MEASUREMENT_ANES_FLOWSHEET_BPD`
- `STAGE_MEASUREMENT_ANES_FLOWSHEET_BPM`
- `STAGE_MEASUREMENT_ANES_FLOWSHEET_BPS`
- `STAGE_MEASUREMENT_ANES_FLOWSHEET_MISC`
- `STAGE_MEASUREMENT_ANES_FLOWSHEET_TEMP`
- `STAGE_MEASUREMENT_ANES_FLOWSHEET_VITALS`

## Final Measurement Tables

### MEASUREMENT_RAW
Combines all staged measurements
Adds surrogate keys
Includes source metadata
Applies data quality exclusions

### MEASUREMENT
Final cleaned measurement table
Follows OMOP CDM structure
Excludes invalid records
Links to standard concepts

The code implements comprehensive data quality checks and transformations to ensure the final measurement data conforms to OMOP standards while maintaining traceability to source systems.

