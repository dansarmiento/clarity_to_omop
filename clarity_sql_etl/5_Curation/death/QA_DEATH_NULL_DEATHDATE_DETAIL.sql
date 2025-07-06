/*
QA check for NULL death dates in DEATH_RAW table
Returns records where death_date is NULL which is considered a fatal error
*/

WITH NULLDEATHDATE_DETAIL AS (
    SELECT 
        'DEATH_DATE' AS METRIC_FIELD,
        'NULL DATE' AS QA_METRIC,
        'FATAL' AS ERROR_TYPE,
        PERSON_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEATH_RAW AS T1
    WHERE (DEATH_DATE IS NULL)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'DEATH' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD, 
    ERROR_TYPE,
    CDT_ID
FROM NULLDEATHDATE_DETAIL
WHERE ERROR_TYPE <> 'EXPECTED';

/*
Column Descriptions:
- RUN_DATE: Date QA check was executed
- STANDARD_DATA_TABLE: Name of table being checked (DEATH)
- QA_METRIC: Type of QA check being performed (NULL DATE)
- METRIC_FIELD: Field being checked (DEATH_DATE)
- ERROR_TYPE: Severity of error (FATAL)
- CDT_ID: Person ID with NULL death date

Logic:
1. CTE identifies records in DEATH_RAW where death_date is NULL
2. Main query returns QA results with metadata
3. Filters out any 'EXPECTED' error types
4. NULL death dates are considered fatal errors since death date is required

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/