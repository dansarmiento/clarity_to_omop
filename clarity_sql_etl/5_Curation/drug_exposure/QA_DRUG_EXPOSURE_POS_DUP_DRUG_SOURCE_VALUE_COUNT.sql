---------------------------------------------------------------------
-- QA_DRUG_EXPOSURE_POS_DUP_DRUG_SOURCE_VALUE_COUNT
-- Identifies potential duplicate drug exposure records based on key fields
---------------------------------------------------------------------

WITH TMP_DUPES AS (
    SELECT 
        PERSON_ID,
        DRUG_CONCEPT_ID,
        DRUG_EXPOSURE_START_DATETIME,
        DRUG_EXPOSURE_END_DATETIME, 
        VERBATIM_END_DATE,
        STOP_REASON,
        REFILLS,
        QUANTITY,
        DAYS_SUPPLY,
        SIG,
        LOT_NUMBER,
        PROVIDER_ID,
        VISIT_OCCURRENCE_ID,
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
        STOP_REASON,
        REFILLS,
        QUANTITY,
        DAYS_SUPPLY,
        SIG,
        ROUTE_CONCEPT_ID,
        LOT_NUMBER,
        PROVIDER_ID,
        VISIT_OCCURRENCE_ID,
        ROUTE_SOURCE_VALUE
    HAVING COUNT(*) > 1
)

SELECT
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'DRUG_EXPOSURE' AS STANDARD_DATA_TABLE,
    'POSSIBLE_DUPLICATE' AS QA_METRIC,
    'DRUG_SOURCE_VALUE' AS METRIC_FIELD,
    COALESCE(SUM(CNT),0) AS QA_ERRORS,
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
Column Descriptions:
------------------
RUN_DATE: Date QA check was executed
STANDARD_DATA_TABLE: Name of table being checked (DRUG_EXPOSURE)
QA_METRIC: Type of QA check being performed (POSSIBLE_DUPLICATE)
METRIC_FIELD: Field being checked for duplicates (DRUG_SOURCE_VALUE)
QA_ERRORS: Count of potential duplicate records found
ERROR_TYPE: Indicates if follow up investigation needed
TOTAL_RECORDS: Total count of records in raw table
TOTAL_RECORDS_CLEAN: Total count of records in clean table

Logic:
------
1. CTE identifies groups of records that share the same values across key fields
2. Only includes records with valid DRUG_CONCEPT_ID and PERSON_ID
3. Groups must have more than 1 record to be considered potential duplicates
4. Main query returns summary metrics of duplicate counts
5. Compares raw vs clean table record counts

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/