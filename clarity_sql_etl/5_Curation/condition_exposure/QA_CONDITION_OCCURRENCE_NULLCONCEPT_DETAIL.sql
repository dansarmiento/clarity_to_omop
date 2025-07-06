/*
QA check for NULL concepts in CONDITION_OCCURRENCE table
Identifies records with missing required concept IDs
*/

WITH NULLCONCEPT_DETAIL AS (
    -- Check for NULL condition_concept_id
    SELECT 
        'CONDITION_CONCEPT_ID' AS METRIC_FIELD,
        'NULL CONCEPT' AS QA_METRIC,
        'FATAL' AS ERROR_TYPE,
        CONDITION_OCCURRENCE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.CONDITION_OCCURRENCE_RAW AS CONDITION_OCCURRENCE 
    WHERE (CONDITION_CONCEPT_ID IS NULL)

    UNION ALL

    -- Check for NULL condition_type_concept_id 
    SELECT
        'CONDITION_TYPE_CONCEPT_ID' AS METRIC_FIELD,
        'NULL CONCEPT' AS QA_METRIC, 
        'FATAL' AS ERROR_TYPE,
        CONDITION_OCCURRENCE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.CONDITION_OCCURRENCE_RAW AS CONDITION_OCCURRENCE
    WHERE (CONDITION_TYPE_CONCEPT_ID IS NULL)
)

-- Return results excluding expected errors
SELECT
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'CONDITION_OCCURRENCE' AS STANDARD_DATA_TABLE,
    QA_METRIC,
    METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM NULLCONCEPT_DETAIL
WHERE ERROR_TYPE <> 'EXPECTED';

/*
Column Descriptions:
- RUN_DATE: Date QA check was executed
- STANDARD_DATA_TABLE: Name of OMOP table being checked
- QA_METRIC: Type of QA check performed
- METRIC_FIELD: Field being validated
- ERROR_TYPE: Severity of error found
- CDT_ID: CONDITION_OCCURRENCE_ID of problematic record

Logic:
1. CTE checks for NULL values in required concept ID fields:
   - condition_concept_id
   - condition_type_concept_id
2. Main query returns all fatal errors found
3. Results can be used to identify records needing correction

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/