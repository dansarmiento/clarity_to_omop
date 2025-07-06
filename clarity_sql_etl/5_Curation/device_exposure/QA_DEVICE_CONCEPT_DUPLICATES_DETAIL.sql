---------------------------------------------------------------------
-- QA_DEVICE_CONCEPT_DUPLICATES_DETAIL
-- Identifies duplicate device exposure records based on key fields
---------------------------------------------------------------------

WITH TMP_DUPES AS (
    SELECT 
        PERSON_ID,
        DEVICE_CONCEPT_ID,
        DEVICE_EXPOSURE_START_DATE,
        DEVICE_EXPOSURE_START_DATETIME, 
        DEVICE_EXPOSURE_END_DATE,
        DEVICE_EXPOSURE_END_DATETIME,
        DEVICE_TYPE_CONCEPT_ID,
        UNIQUE_DEVICE_ID,
        QUANTITY,
        PROVIDER_ID,
        VISIT_OCCURRENCE_ID,
        DEVICE_SOURCE_VALUE,
        DEVICE_SOURCE_CONCEPT_ID,
        COUNT(*) AS CNT

    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEVICE_EXPOSURE_RAW AS T1

    -- Filter out invalid/missing person and concept IDs
    WHERE T1.DEVICE_CONCEPT_ID != 0
        AND T1.DEVICE_CONCEPT_ID IS NOT NULL 
        AND T1.PERSON_ID != 0
        AND T1.PERSON_ID IS NOT NULL

    GROUP BY 
        PERSON_ID,
        DEVICE_CONCEPT_ID,
        DEVICE_EXPOSURE_START_DATE,
        DEVICE_EXPOSURE_START_DATETIME,
        DEVICE_EXPOSURE_END_DATE,
        DEVICE_EXPOSURE_END_DATETIME,
        DEVICE_TYPE_CONCEPT_ID,
        UNIQUE_DEVICE_ID,
        QUANTITY,
        PROVIDER_ID,
        VISIT_OCCURRENCE_ID,
        DEVICE_SOURCE_VALUE,
        DEVICE_SOURCE_CONCEPT_ID
    
    -- Only keep groups with duplicates
    HAVING COUNT(*) > 1
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'DEVICE_EXPOSURE' AS STANDARD_DATA_TABLE,
    'DUPLICATE' AS QA_METRIC,
    'RECORDS' AS METRIC_FIELD,
    'FATAL' AS ERROR_TYPE,
    DE.DEVICE_EXPOSURE_ID

FROM TMP_DUPES AS D
INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.DEVICE_EXPOSURE_RAW AS DE 
    ON D.PERSON_ID = DE.PERSON_ID
    AND D.DEVICE_CONCEPT_ID = DE.DEVICE_CONCEPT_ID
    AND D.DEVICE_EXPOSURE_START_DATE = DE.DEVICE_EXPOSURE_START_DATE
    AND D.DEVICE_EXPOSURE_START_DATETIME = DE.DEVICE_EXPOSURE_START_DATETIME
    AND COALESCE(D.DEVICE_EXPOSURE_END_DATE,'1900-01-01') = COALESCE(DE.DEVICE_EXPOSURE_END_DATE,'1900-01-01')
    AND COALESCE(D.DEVICE_EXPOSURE_END_DATETIME,'1900-01-01') = COALESCE(DE.DEVICE_EXPOSURE_END_DATETIME,'1900-01-01')
    AND COALESCE(D.DEVICE_TYPE_CONCEPT_ID, 0) = COALESCE(DE.DEVICE_TYPE_CONCEPT_ID, 0)
    AND COALESCE(D.UNIQUE_DEVICE_ID, '0') = COALESCE(DE.UNIQUE_DEVICE_ID, '0')
    AND COALESCE(D.QUANTITY, 0) = COALESCE(DE.QUANTITY, 0)
    AND COALESCE(D.PROVIDER_ID, 0) = COALESCE(DE.PROVIDER_ID, 0)
    AND COALESCE(D.VISIT_OCCURRENCE_ID, 0) = COALESCE(DE.VISIT_OCCURRENCE_ID, 0)
    AND COALESCE(D.DEVICE_SOURCE_VALUE, '0') = COALESCE(DE.DEVICE_SOURCE_VALUE, '0')
    AND COALESCE(D.DEVICE_SOURCE_CONCEPT_ID, 0) = COALESCE(DE.DEVICE_SOURCE_CONCEPT_ID, 0);

/*
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Date the QA check was executed
STANDARD_DATA_TABLE: Name of the table being checked (DEVICE_EXPOSURE)
QA_METRIC: Type of QA check (DUPLICATE)
METRIC_FIELD: Field being checked (RECORDS)
ERROR_TYPE: Severity of the error (FATAL)
DEVICE_EXPOSURE_ID: Unique identifier for the device exposure record

LOGIC:
------
1. TMP_DUPES CTE identifies groups of records that share the same values across all relevant fields
2. Only keeps groups with more than 1 record (duplicates)
3. Main query joins back to original table to get DEVICE_EXPOSURE_IDs
4. COALESCE used to handle NULL values in join conditions
5. Results show duplicate device exposure records that need to be addressed

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/