---------------------------------------------------------------------
-- QA_DRUG_EXPOSURE_END_BEFORE_START_DETAIL
---------------------------------------------------------------------

/**
 * This query identifies drug exposure records where the end date/datetime
 * occurs before the start date/datetime, which is logically invalid.
 */

WITH END_BEFORE_START_DETAIL AS (
    SELECT 
        'DRUG_EXPOSURE_END_DATE' AS METRIC_FIELD,
        'END_BEFORE_START' AS QA_METRIC,
        'INVALID DATA' AS ERROR_TYPE,
        DRUG_EXPOSURE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE_RAW AS DRUG_EXPOSURE
    WHERE DRUG_EXPOSURE_END_DATE < DRUG_EXPOSURE_START_DATE
        OR
        DRUG_EXPOSURE_END_DATETIME < DRUG_EXPOSURE_START_DATETIME
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'DRUG_EXPOSURE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM END_BEFORE_START_DETAIL;

/**
 * Column Descriptions:
 * ------------------
 * RUN_DATE: Current date when the QA check is executed
 * STANDARD_DATA_TABLE: Name of the table being checked (DRUG_EXPOSURE)
 * QA_METRIC: Type of quality check being performed (END_BEFORE_START)
 * METRIC_FIELD: Field being evaluated (DRUG_EXPOSURE_END_DATE)
 * ERROR_TYPE: Category of error found (INVALID DATA)
 * CDT_ID: Drug exposure record identifier (DRUG_EXPOSURE_ID)
 *
 * Logic:
 * ------
 * 1. The CTE identifies drug exposure records where either:
 *    - The end date is before the start date
 *    - The end datetime is before the start datetime
 * 2. These cases represent logical errors in the data
 * 3. The main query adds metadata about the QA check and returns the results

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
 */