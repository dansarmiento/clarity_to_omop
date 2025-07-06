---------------------------------------------------------------------
-- QA_MEASUREMENT_DUPLICATES_DETAIL_UNIT_CONCEPT_ID
-- Identifies duplicate measurement records that differ only by unit_concept_id
---------------------------------------------------------------------

WITH TMP_DUPES AS (
    SELECT 
        PERSON_ID,
        MEASUREMENT_CONCEPT_ID,
        MEASUREMENT_DATETIME,
        VALUE_AS_NUMBER,
        VALUE_AS_CONCEPT_ID, 
        RANGE_LOW,
        RANGE_HIGH,
        PROVIDER_ID,
        VISIT_OCCURRENCE_ID,
        MEASUREMENT_SOURCE_VALUE,
        VALUE_SOURCE_VALUE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT_RAW AS T1
    WHERE T1.MEASUREMENT_CONCEPT_ID <> 0
        AND T1.MEASUREMENT_CONCEPT_ID IS NOT NULL
        AND T1.PERSON_ID <> 0 
        AND T1.PERSON_ID IS NOT NULL
    GROUP BY 
        PERSON_ID,
        MEASUREMENT_CONCEPT_ID,
        MEASUREMENT_DATETIME,
        VALUE_AS_NUMBER,
        VALUE_AS_CONCEPT_ID,
        RANGE_LOW,
        RANGE_HIGH,
        PROVIDER_ID,
        VISIT_OCCURRENCE_ID,
        MEASUREMENT_SOURCE_VALUE,
        VALUE_SOURCE_VALUE
    HAVING COUNT(*) > 1
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'MEASUREMENT' AS STANDARD_DATA_TABLE,
    'POSSIBLE_DUPLICATE' AS QA_METRIC,
    'UNIT_CONCEPT_ID' AS METRIC_FIELD,
    'FOLLOW_UP' AS ERROR_TYPE,
    ME.MEASUREMENT_ID
FROM TMP_DUPES AS D
INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT_RAW AS ME 
    ON D.PERSON_ID = ME.PERSON_ID
    AND D.MEASUREMENT_CONCEPT_ID = ME.MEASUREMENT_CONCEPT_ID
    AND COALESCE(D.MEASUREMENT_DATETIME,'1900-01-01') = COALESCE(ME.MEASUREMENT_DATETIME,'1900-01-01')
    AND COALESCE(D.VALUE_AS_NUMBER, 0) = COALESCE(ME.VALUE_AS_NUMBER, 0)
    AND COALESCE(D.VALUE_AS_CONCEPT_ID, 0) = COALESCE(ME.VALUE_AS_CONCEPT_ID, 0)
    AND COALESCE(D.RANGE_LOW, 0) = COALESCE(ME.RANGE_LOW, 0)
    AND COALESCE(D.RANGE_HIGH, 0) = COALESCE(ME.RANGE_HIGH, 0)
    AND COALESCE(D.PROVIDER_ID, 0) = COALESCE(ME.PROVIDER_ID, 0)
    AND COALESCE(D.VISIT_OCCURRENCE_ID, 0) = COALESCE(ME.VISIT_OCCURRENCE_ID, 0)
    AND COALESCE(D.MEASUREMENT_SOURCE_VALUE, '0') = COALESCE(ME.MEASUREMENT_SOURCE_VALUE, '0')
    AND COALESCE(D.VALUE_SOURCE_VALUE, '0') = COALESCE(ME.VALUE_SOURCE_VALUE, '0');

/*
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Date the QA check was executed
STANDARD_DATA_TABLE: Name of the table being checked (MEASUREMENT)
QA_METRIC: Type of QA check being performed (POSSIBLE_DUPLICATE)
METRIC_FIELD: Specific field being checked for duplicates (UNIT_CONCEPT_ID)
ERROR_TYPE: Classification of the error (FOLLOW_UP)
MEASUREMENT_ID: Unique identifier for the measurement record

LOGIC:
------
1. TMP_DUPES CTE identifies groups of records that share the same values for:
   - PERSON_ID
   - MEASUREMENT_CONCEPT_ID  
   - MEASUREMENT_DATETIME
   - VALUE_AS_NUMBER
   - VALUE_AS_CONCEPT_ID
   - RANGE_LOW
   - RANGE_HIGH
   - PROVIDER_ID
   - VISIT_OCCURRENCE_ID
   - MEASUREMENT_SOURCE_VALUE
   - VALUE_SOURCE_VALUE
   
2. Only groups with more than 1 record are included (COUNT(*) > 1)

3. Main query joins back to MEASUREMENT_RAW to get the MEASUREMENT_IDs
   of the duplicate records


LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/