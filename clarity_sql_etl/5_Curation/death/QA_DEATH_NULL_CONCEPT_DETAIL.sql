/*
QA_DEATH_NULL_CONCEPT_DETAIL

This query identifies records in the DEATH_RAW table where DEATH_TYPE_CONCEPT_ID is null,
which is considered a fatal error.

*/

WITH NULLCONCEPT_DETAIL AS (
    SELECT 
        'DEATH_TYPE_CONCEPT_ID' AS METRIC_FIELD,
        'NULL CONCEPT' AS QA_METRIC,
        'FATAL' AS ERROR_TYPE,
        PERSON_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEATH_RAW AS T1
    WHERE (DEATH_TYPE_CONCEPT_ID IS NULL)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'DEATH' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD, 
    ERROR_TYPE,
    CDT_ID
FROM NULLCONCEPT_DETAIL
WHERE ERROR_TYPE <> 'EXPECTED'

/*
Column Descriptions:
- RUN_DATE: Date the QA check was executed
- STANDARD_DATA_TABLE: Name of the table being checked (DEATH)
- QA_METRIC: Type of quality check being performed (NULL CONCEPT)
- METRIC_FIELD: Field being checked (DEATH_TYPE_CONCEPT_ID)
- ERROR_TYPE: Severity of the error (FATAL)
- CDT_ID: PERSON_ID from the source record

Logic:
1. CTE identifies records where DEATH_TYPE_CONCEPT_ID is null
2. Main query returns details for all fatal errors
3. Records marked as 'EXPECTED' are excluded from results

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/