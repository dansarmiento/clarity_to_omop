/*******************************************************************************
* Script: QA_DEATH_ZERO_CONCEPT_DETAIL
* Description: Identifies records in DEATH_RAW table where DEATH_TYPE_CONCEPT_ID is zero
* 
* Change History:
* [Add dates and changes here]
*******************************************************************************/

WITH ZEROCONCEPT_DETAIL AS (
    SELECT 
        'DEATH_TYPE_CONCEPT_ID' AS METRIC_FIELD,
        'ZERO CONCEPT' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        PERSON_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEATH_RAW AS T1
    WHERE (DEATH_TYPE_CONCEPT_ID = 0)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'DEATH' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM ZEROCONCEPT_DETAIL
WHERE ERROR_TYPE <> 'EXPECTED';

/*******************************************************************************
* Column Descriptions:
* -------------------------------------------------------------------------
* RUN_DATE              - Date when the QA check was executed
* STANDARD_DATA_TABLE   - Name of the table being checked (DEATH)
* QA_METRIC            - Type of quality check being performed (ZERO CONCEPT)
* METRIC_FIELD         - Field being checked (DEATH_TYPE_CONCEPT_ID)
* ERROR_TYPE           - Severity of the issue (WARNING)
* CDT_ID              - PERSON_ID from the source record
*
* Logic:
* -------------------------------------------------------------------------
* 1. CTE ZEROCONCEPT_DETAIL identifies records where DEATH_TYPE_CONCEPT_ID = 0
* 2. Main query returns all records with non-'EXPECTED' error types
* 3. Results indicate potential data quality issues where concept IDs 
*    were not properly mapped

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*******************************************************************************/