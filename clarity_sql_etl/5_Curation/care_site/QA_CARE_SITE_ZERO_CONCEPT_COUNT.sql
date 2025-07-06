/***************************************************************
 * Script: QA_CARE_SITE_ZERO_CONCEPT_DETAIL
 * Description: Identifies and counts records in CARE_SITE table 
 *              where PLACE_OF_SERVICE_CONCEPT_ID is zero
 ***************************************************************/

-- Common Table Expression to count zero concepts
WITH CTE_ZERO_CONCEPT_COUNT AS (
    SELECT 
        'CARE_SITE' AS STANDARD_DATA_TABLE,
        'PLACE_OF_SERVICE_CONCEPT_ID' AS METRIC_FIELD,
        'ZERO CONCEPT' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.CARE_SITE_RAW AS CARE_SITE
    WHERE PLACE_OF_SERVICE_CONCEPT_ID = 0
)

-- Main query to generate QA report
SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    COALESCE(SUM(CNT), 0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) <> 0 THEN ERROR_TYPE 
        ELSE NULL 
    END AS ERROR_TYPE,
    (
        SELECT COUNT(*) AS NUM_ROWS 
        FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.CARE_SITE_RAW
    ) AS TOTAL_RECORDS,
    (
        SELECT COUNT(*) AS NUM_ROWS 
        FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.CARE_SITE
    ) AS TOTAL_RECORDS_CLEAN
FROM CTE_ZERO_CONCEPT_COUNT
GROUP BY 
    STANDARD_DATA_TABLE, 
    METRIC_FIELD, 
    QA_METRIC, 
    ERROR_TYPE;

/***************************************************************
 * Column Descriptions:
 * ------------------
 * RUN_DATE: Date when the QA check was performed
 * STANDARD_DATA_TABLE: Name of the table being checked (CARE_SITE)
 * QA_METRIC: Type of quality check being performed (ZERO CONCEPT)
 * METRIC_FIELD: Field being evaluated (PLACE_OF_SERVICE_CONCEPT_ID)
 * QA_ERRORS: Count of records with zero concepts
 * ERROR_TYPE: Indicates severity of the error (WARNING if errors exist, NULL if none)
 * TOTAL_RECORDS: Total number of records in the raw table
 * TOTAL_RECORDS_CLEAN: Total number of records in the clean table
 *
 * Logic Description:
 * ----------------
 * 1. CTE counts records where PLACE_OF_SERVICE_CONCEPT_ID = 0
 * 2. Main query:
 *    - Adds current date
 *    - Calculates total error count
 *    - Determines if WARNING should be displayed
 *    - Includes record counts from both raw and clean tables
 * 3. Results are grouped by table, field, metric, and error type
 
LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
 ***************************************************************/