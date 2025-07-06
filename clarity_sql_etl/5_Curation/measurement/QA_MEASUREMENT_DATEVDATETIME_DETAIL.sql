---------------------------------------------------------------------
-- QA_MEASUREMENT_DATEVDATETIME_DETAIL
-- This query identifies records where the measurement date does not match the date portion 
-- of the measurement datetime in the MEASUREMENT_RAW table.
---------------------------------------------------------------------

WITH DATEVDATETIME_DETAIL AS (
    SELECT 
        'MEASUREMENT_DATE' AS METRIC_FIELD,
        'DATEVDATETIME' AS QA_METRIC, 
        'WARNING' AS ERROR_TYPE,
        MEASUREMENT_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT_RAW AS T1
    WHERE MEASUREMENT_DATE <> CAST(MEASUREMENT_DATETIME AS DATE)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'MEASUREMENT' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD, 
    ERROR_TYPE,
    CDT_ID
FROM DATEVDATETIME_DETAIL;

/*
Column Descriptions:
- RUN_DATE: Current date when query is executed
- STANDARD_DATA_TABLE: Name of the source table being validated ('MEASUREMENT')
- QA_METRIC: Type of quality check being performed ('DATEVDATETIME')
- METRIC_FIELD: Field being validated ('MEASUREMENT_DATE')
- ERROR_TYPE: Severity of the data quality issue ('WARNING')
- CDT_ID: MEASUREMENT_ID of the record with the discrepancy

Logic:
1. CTE identifies records where MEASUREMENT_DATE does not equal the date portion of MEASUREMENT_DATETIME
2. Main query formats results with metadata about the QA check
3. WARNING level indicates this may need investigation but is not necessarily an error

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/