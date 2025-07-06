/***************************************************************
 * QA Check: NOTE_DATE vs NOTE_DATETIME Validation
 * Identifies records where NOTE_DATE does not match the date portion
 * of NOTE_DATETIME
 ***************************************************************/

WITH DATEVDATETIME_DETAIL AS (
    SELECT 
        'NOTE_DATE' AS METRIC_FIELD,
        'DATEVDATETIME' AS QA_METRIC, 
        'WARNING' AS ERROR_TYPE,
        NOTE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.NOTE_RAW AS T1
    WHERE NOTE_DATE <> CAST(NOTE_DATETIME AS DATE)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'NOTE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD, 
    ERROR_TYPE,
    CDT_ID
FROM DATEVDATETIME_DETAIL;

/***************************************************************
 * Column Descriptions:
 * RUN_DATE - Date the QA check was executed
 * STANDARD_DATA_TABLE - Source table being validated (NOTE)
 * QA_METRIC - Type of validation check (DATEVDATETIME)
 * METRIC_FIELD - Field being validated (NOTE_DATE)
 * ERROR_TYPE - Severity of validation issue (WARNING)
 * CDT_ID - NOTE_ID of the record with the validation issue
 *
 * Logic:
 * 1. CTE identifies records where NOTE_DATE does not match 
 *    the date portion of NOTE_DATETIME
 * 2. Main query returns validation details with metadata
 * 3. WARNING level indicates data inconsistency but not critical error

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
 ***************************************************************/