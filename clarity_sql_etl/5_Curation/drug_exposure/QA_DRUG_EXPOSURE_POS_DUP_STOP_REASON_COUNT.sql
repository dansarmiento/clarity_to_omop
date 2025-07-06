---------------------------------------------------------------------
-- QA_DRUG_EXPOSURE_POS_DUP_STOP_REASON_COUNT
--  This query identifies potential duplicate records in DRUG_EXPOSURE_RAW table
--  and provides QA metrics for the STOP_REASON field
---------------------------------------------------------------------

WITH TMP_DUPES AS (
    SELECT 
        PERSON_ID,
        DRUG_CONCEPT_ID,
        DRUG_EXPOSURE_START_DATETIME,
        DRUG_EXPOSURE_END_DATETIME,
        VERBATIM_END_DATE,
        REFILLS,
        QUANTITY,
        DAYS_SUPPLY,
        SIG,
        LOT_NUMBER,
        PROVIDER_ID,
        VISIT_OCCURRENCE_ID,
        DRUG_SOURCE_VALUE,
        ROUTE_SOURCE_VALUE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE_RAW AS T1
    WHERE T1.DRUG_CONCEPT_ID != 0
        AND T1.DRUG_CONCEPT_ID IS NOT NULL
        AND T1.PERSON_ID != 0
        AND T1.PERSON_ID IS NOT NULL
    GROUP BY 
        PERSON_ID,
        DRUG_CONCEPT_ID,
        DRUG_EXPOSURE_START_DATETIME,
        DRUG_EXPOSURE_END_DATETIME,
        VERBATIM_END_DATE,
        REFILLS,
        QUANTITY,
        DAYS_SUPPLY,
        SIG,
        ROUTE_CONCEPT_ID,
        LOT_NUMBER,
        PROVIDER_ID,
        VISIT_OCCURRENCE_ID,
        DRUG_SOURCE_VALUE,
        ROUTE_SOURCE_VALUE
    HAVING COUNT(*) > 1
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'DRUG_EXPOSURE' AS STANDARD_DATA_TABLE,
    'POSSIBLE_DUPLICATE' AS QA_METRIC,
    'STOP_REASON' AS METRIC_FIELD,
    COALESCE(SUM(CNT), 0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) IS NOT NULL THEN 'FOLLOW_UP' 
        ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE) AS TOTAL_RECORDS_CLEAN
FROM TMP_DUPES;

/*
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Name of the table being analyzed
QA_METRIC: Type of quality check being performed
METRIC_FIELD: Specific field being analyzed
QA_ERRORS: Count of identified potential duplicate records
ERROR_TYPE: Indicates if follow-up is needed
TOTAL_RECORDS: Total number of records in the raw table
TOTAL_RECORDS_CLEAN: Total number of records in the clean table

LOGIC:
------
1. TMP_DUPES CTE identifies duplicate records by grouping on multiple fields
2. Only considers valid DRUG_CONCEPT_ID and PERSON_ID (non-zero and non-null)
3. Records are considered duplicates if they share the same values across all grouped fields
4. Main query summarizes the findings and provides QA metrics
5. Includes comparison between raw and clean table record counts

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/