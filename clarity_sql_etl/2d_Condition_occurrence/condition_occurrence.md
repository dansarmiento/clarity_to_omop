# CONDITION_OCCURRENCE Data Flow Documentation

## Overview
This SQL code implements the ETL (Extract, Transform, Load) process for condition occurrence data in an OMOP CDM format. The code processes both ambulatory and hospital condition data, mapping source diagnosis codes to SNOMED concepts.

## Pull Queries

### PULL_CONDITION_OCCURRENCE_AMB_PROB_SNO
Pulls ambulatory problem list conditions with SNOMED mappings
Sources from `PROBLEM_LIST` table

### PULL_CONDITION_OCCURRENCE_AMB_SNO
Pulls ambulatory diagnoses with SNOMED mappings
Sources from `PAT_ENC_DX` table

### PULL_CONDITION_OCCURRENCE_AMB_TDL_SNO
Pulls ambulatory transaction diagnoses with SNOMED mappings
Sources from `CLARITY_TDL_TRAN` table

### PULL_CONDITION_OCCURRENCE_HOSP_ADM_SNO
Pulls hospital admission diagnoses with SNOMED mappings
Sources from `HSP_ACCT_ADMIT_DX` table

### PULL_CONDITION_OCCURRENCE_HOSP_DISCH_SNO
Pulls hospital discharge diagnoses with SNOMED mappings
Sources from `HSP_ACCT_DX_LIST` table

### PULL_CONDITION_OCCURRENCE_HOSP_FIN_SNO
Pulls hospital final diagnoses with SNOMED mappings
Sources from `PAT_ENC_DX` table

### PULL_CONDITION_OCCURRENCE_HOSP_PROB_SNO
Pulls hospital problem list conditions with SNOMED mappings
Sources from `PROBLEM_LIST` table

### PULL_CONDITION_OCCURRENCE_HOSP_TDL_SNO
Pulls hospital transaction diagnoses with SNOMED mappings
Sources from `CLARITY_TDL_TRAN` table

## Stage Queries
Each pull query has a corresponding stage query that:

- Maps source concepts to standard SNOMED concepts
- Adds required OMOP fields
- Validates and transforms data
- Applies business rules for condition status

## CONDITION_OCCURRENCE_RAW Query
This query:

- Combines all staged condition data
- Assigns unique condition occurrence IDs
- Adds metadata fields
- Links to source systems
- Applies exclusion criteria

## CONDITION_OCCURRENCE Query
The final CONDITION_OCCURRENCE table:

- Contains validated condition records
- Includes standard OMOP fields
- Maintains links to source data
- Excludes invalid/error records
- Represents the cleaned condition data ready for analysis
