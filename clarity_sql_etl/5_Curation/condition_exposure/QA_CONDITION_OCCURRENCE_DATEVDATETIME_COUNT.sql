/*
QA_CONDITION_OCCURRENCE_DATEVDATETIME_COUNT
This query performs quality assurance checks on date/datetime consistency 
in the CONDITION_OCCURRENCE_RAW table
*/

WITH DATEVDATETIME_COUNT AS (
    -- Check CONDITION_START_DATE consistency
    SELECT 
        'CONDITION_START_DATE' AS METRIC_FIELD,
        'DATEVDATETIME' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        SUM(CASE 
            WHEN (CONDITION_START_DATE <> CAST(CONDITION_START_DATETIME AS DATE)) 
            THEN 1 
            ELSE 0 
        END) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.CONDITION_OCCURRENCE_RAW AS T1

    UNION ALL

    -- Check CONDITION_END_DATE consistency
    SELECT 
        'CONDITION_END_DATE' AS METRIC_FIELD,
        'DATEVDATETIME' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        SUM(CASE 
            WHEN (CONDITION_END_DATE <> CAST(CONDITION_END_DATETIME AS DATE)) 
            THEN 1 
            ELSE 0 
        END) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.CONDITION_OCCURRENCE_RAW AS T1
)

-- Final result set
SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'CONDITION_OCCURRENCE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    COALESCE(SUM(CNT), 0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) IS NOT NULL AND SUM(CNT) <> 0 
        THEN ERROR_TYPE 
        ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.CONDITION_OCCURRENCE_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.CONDITION_OCCURRENCE) AS TOTAL_RECORDS_CLEAN
FROM DATEVDATETIME_COUNT
GROUP BY 
    METRIC_FIELD,
    QA_METRIC,
    ERROR_TYPE;

/*
COLUMN DESCRIPTIONS:
- RUN_DATE: Date when the QA check was performed
- STANDARD_DATA_TABLE: Name of the table being checked
- QA_METRIC: Type of quality check being performed (DATEVDATETIME)
- METRIC_FIELD: Specific field being checked
- QA_ERRORS: Number of inconsistencies found
- ERROR_TYPE: Type of error (WARNING in this case)
- TOTAL_RECORDS: Total number of records in the raw table
- TOTAL_RECORDS_CLEAN: Total number of records in the clean table

LOGIC:
1. The CTE (DATEVDATETIME_COUNT) checks for inconsistencies between:
   - CONDITION_START_DATE and CONDITION_START_DATETIME
   - CONDITION_END_DATE and CONDITION_END_DATETIME
2. Inconsistency is defined as when the DATE value doesn't match the DATE portion of DATETIME
3. Results are aggregated to show total number of inconsistencies for each date field
4. ERROR_TYPE is only populated when inconsistencies are found

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/