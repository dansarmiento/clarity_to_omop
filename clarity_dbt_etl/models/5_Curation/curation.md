# OMOP Data Curation Process Documentation

## Overview

The 5_Curation process is designed to validate and clean data in OMOP tables. It involves running quality assurance (QA) checks on each OMOP table to identify and address data quality issues before finalizing the data for use.

## Process Structure

The curation process is organized by OMOP table, with each table having its own set of quality checks. The following OMOP tables are included in the process:

- care_site
- condition_occurrence
- death
- device_exposure
- drug_exposure
- location
- measurement
- note
- observation
- person
- procedure_occurrence
- provider
- specimen
- visit_detail
- visit_occurrence

## Quality Assurance Queries

For each OMOP table, there are pairs of SQL queries that perform specific quality checks:

1. **COUNT queries**: Identify and count the number of records with specific errors
2. **DETAIL queries**: Provide row-level details for records with errors

### Query Naming Convention

Queries follow a consistent naming pattern:
- `QA_[TABLE_NAME]_[ERROR_TYPE]_COUNT.sql`
- `QA_[TABLE_NAME]_[ERROR_TYPE]_DETAIL.sql`

### Common Error Types

The QA process checks for various error types including:

- **DUPLICATES**: Records that are duplicated based on key fields
- **NONSTANDARD**: Records using non-standard concept IDs
- **NULLCONCEPT**: Records with NULL concept IDs
- **ZEROCONCEPT**: Records with concept IDs equal to 0
- **NOVISIT** or **WO_VISIT**: Records without associated visit information
- **DATEVDATETIME**: Inconsistencies between date and datetime fields
- **END_BEFORE_START**: Records where end dates precede start dates
- **VISITDATEDISPARITY**: Records where event dates fall outside visit dates
- **30AFTERDEATH**: Records with events occurring 30+ days after death
- **NULLFK**: Records with NULL foreign keys
- **AGE_ERR**: Records with invalid age values

### Query Structure

#### COUNT Queries

COUNT queries typically:
1. Identify records with specific errors using a CTE (Common Table Expression)
2. Return summary information including:
   - Run date
   - Table name
   - QA metric type
   - Field being checked
   - Error count
   - Error type (FATAL or WARNING)
   - Total record counts (raw and clean)

#### DETAIL Queries

DETAIL queries typically:
1. Identify the same problematic records as the COUNT query
2. Return row-level details including:
   - Run date
   - Table name
   - QA metric type
   - Field being checked
   - Error type
   - Record ID (specific to the table)

## Master QA Queries

Two master queries combine all individual QA checks:

1. **QA_LOG_DBT.sql**: Combines all COUNT queries to provide a comprehensive summary of data quality issues
2. **QA_ERR_DBT.sql**: Combines all DETAIL queries to provide a comprehensive list of problematic records

## Data Extraction Process

After identifying errors, the final step is to extract clean data by excluding records with fatal or invalid data errors:

1. The raw OMOP table is joined with QA_ERR_DBT
2. Records identified as having FATAL or INVALID DATA errors are excluded
3. Clean data is written to the final OMOP tables

### Example Extraction Query Structure

```sql
SELECT
    [All OMOP standard fields],
    [Any custom fields]
FROM 
    [OMOP_TABLE]_RAW AS SOURCE_TABLE
    LEFT JOIN (
        SELECT 
            CDT_ID
        FROM 
            OMOP_QA.QA_ERR_DBT
        WHERE 
            (STANDARD_DATA_TABLE = '[TABLE_NAME]')
            AND (ERROR_TYPE IN ('FATAL', 'INVALID DATA'))
    ) AS EXCLUSION_RECORDS
    ON SOURCE_TABLE.[ID_FIELD] = EXCLUSION_RECORDS.CDT_ID
WHERE 
    (EXCLUSION_RECORDS.CDT_ID IS NULL)

```

## Error Handling
Errors are categorized by severity:

- **FATAL:** Critical errors that require record exclusion
- **WARNING:** Issues that should be reviewed but may not require exclusion
- **EXPECTED:** Known issues that are acceptable in the current context

## Summary
The 5_Curation process provides a systematic approach to data quality assurance for OMOP data. By running standardized checks across all tables and consolidating results, it ensures that only high-quality data is included in the final OMOP tables.    