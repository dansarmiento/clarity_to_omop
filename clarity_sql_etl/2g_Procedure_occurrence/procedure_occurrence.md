
# Procedure Occurrence ETL Documentation

## Data Flow Summary
The ETL process transforms procedure data from Epic Clarity into the OMOP `Procedure_Occurrence` table through the following steps:

- Pull raw procedure data from multiple sources (ambulatory, hospital, surgical)
- Stage the data with standard mappings and transformations
- Load into `PROCEDURE_OCCURRENCE_RAW` with additional metadata
- Final load into `PROCEDURE_OCCURRENCE` after quality checks

## PULL Queries

### PULL_PROCEDURE_OCCURRENCE_AMB_CPT
Pulls ambulatory procedures from `ORDER_PROC` table
- Joins to visit data and procedure codes
- Filters for completed orders with final lab status

### PULL_PROCEDURE_OCCURRENCE_HSP_CPT
Pulls hospital procedures from `ORDER_PROC`
- Similar structure to ambulatory but for inpatient encounters

### PULL_PROCEDURE_OCCURRENCE_SURG_CPT
Pulls surgical procedures from `OR_LOG` tables
- Includes operating room procedures and related data

## STAGE Queries

### STAGE_PROCEDURE_OCCURRENCE_AMB_CPT
Maps ambulatory procedures to standard concepts
- Adds required OMOP fields
- Includes source metadata

### STAGE_PROCEDURE_OCCURRENCE_HSP_CPT
Maps hospital procedures to standard concepts
- Similar structure to ambulatory staging

### STAGE_PROCEDURE_OCCURRENCE_SURG_CPT
Maps surgical procedures to standard concepts
- Includes OR-specific fields

## Key Query Details

### PROCEDURE_OCCURRENCE_RAW
Combines staged data from all three sources
- Adds sequence IDs
- Includes source metadata and PHI fields
- Performs data type standardization
- Structure matches final `PROCEDURE_OCCURRENCE` table

### PROCEDURE_OCCURRENCE
Final production table
- Filters out records that failed QA checks
- Contains standard OMOP fields plus custom extensions
- Maintains traceability to source data
- Includes PHI fields for internal use

The ETL process ensures complete procedure data capture while maintaining data quality and standardization to OMOP concepts.

