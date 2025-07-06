/*******************************************************************************
* QA_DEATH_ZERO_CONCEPT_COUNT
* This query identifies records in DEATH_RAW table where DEATH_TYPE_CONCEPT_ID = 0
* and provides QA metrics for the DEATH tables
*******************************************************************************/

WITH ZEROCONCEPT_COUNT AS (
    SELECT 
        'DEATH_TYPE_CONCEPT_ID' AS METRIC_FIELD,
        'ZERO CONCEPT' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEATH_RAW AS T1
    WHERE (DEATH_TYPE_CONCEPT_ID = 0)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'DEATH' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    COALESCE(SUM(CNT), 0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) <> 0 THEN ERROR_TYPE 
        ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEATH_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEATH) AS TOTAL_RECORDS_CLEAN
FROM ZEROCONCEPT_COUNT
GROUP BY 
    METRIC_FIELD, 
    QA_METRIC, 
    ERROR_TYPE;

/*******************************************************************************
* Column Descriptions:
* ------------------
* RUN_DATE: Current date when the query is executed
* STANDARD_DATA_TABLE: Name of the table being analyzed (DEATH)
* QA_METRIC: Type of quality check being performed (ZERO CONCEPT)
* METRIC_FIELD: Field being analyzed (DEATH_TYPE_CONCEPT_ID)
* QA_ERRORS: Count of records that failed the quality check
* ERROR_TYPE: Severity of the error (WARNING if errors exist, NULL if no errors)
* TOTAL_RECORDS: Total number of records in the DEATH_RAW table
* TOTAL_RECORDS_CLEAN: Total number of records in the cleaned DEATH table
*
* Logic:
* ------
* 1. CTE ZEROCONCEPT_COUNT identifies records where DEATH_TYPE_CONCEPT_ID = 0
* 2. Main query aggregates results and adds metadata columns
* 3. Compares raw vs. cleaned table record counts
* 4. Returns WARNING if any records have DEATH_TYPE_CONCEPT_ID = 0

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*******************************************************************************/