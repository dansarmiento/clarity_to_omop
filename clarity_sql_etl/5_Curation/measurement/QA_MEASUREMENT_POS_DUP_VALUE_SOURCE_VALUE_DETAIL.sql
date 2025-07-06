---------------------------------------------------------------------
-- QA_MEASUREMENT_DUPLICATES_DETAIL_VALUE_SOURCE_VALUE
-- Purpose: 
-- This query identifies duplicate measurements in the MEASUREMENT_RAW table based on multiple matching criteria.
---------------------------------------------------------------------

WITH TMP_DUPES AS (
    SELECT 
        PERSON_ID,
        MEASUREMENT_CONCEPT_ID,
        MEASUREMENT_DATETIME,
        VALUE_AS_NUMBER,
        VALUE_AS_CONCEPT_ID,
        UNIT_CONCEPT_ID,
        RANGE_LOW,
        RANGE_HIGH,
        PROVIDER_ID,
        VISIT_OCCURRENCE_ID,
        MEASUREMENT_SOURCE_VALUE,
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
        UNIT_CONCEPT_ID,
        RANGE_LOW,
        RANGE_HIGH,
        PROVIDER_ID,
        VISIT_OCCURRENCE_ID,
        MEASUREMENT_SOURCE_VALUE
    HAVING COUNT(*) > 1
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'MEASUREMENT' AS STANDARD_DATA_TABLE,
    'POSSIBLE_DUPLICATE' AS QA_METRIC,
    'VALUE_SOURCE_VALUE' AS METRIC_FIELD,
    'FOLLOW_UP' AS ERROR_TYPE,
    ME.MEASUREMENT_ID
FROM TMP_DUPES AS D
INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT_RAW AS ME 
    ON D.PERSON_ID = ME.PERSON_ID
    AND D.MEASUREMENT_CONCEPT_ID = ME.MEASUREMENT_CONCEPT_ID
    AND COALESCE(D.MEASUREMENT_DATETIME,'1900-01-01') = COALESCE(ME.MEASUREMENT_DATETIME,'1900-01-01')
    AND COALESCE(D.VALUE_AS_NUMBER, 0) = COALESCE(ME.VALUE_AS_NUMBER, 0)
    AND COALESCE(D.VALUE_AS_CONCEPT_ID, 0) = COALESCE(ME.VALUE_AS_CONCEPT_ID, 0)
    AND COALESCE(D.UNIT_CONCEPT_ID, 0) = COALESCE(ME.UNIT_CONCEPT_ID, 0)
    AND COALESCE(D.RANGE_LOW, 0) = COALESCE(ME.RANGE_LOW, 0)
    AND COALESCE(D.RANGE_HIGH, 0) = COALESCE(ME.RANGE_HIGH, 0)
    AND COALESCE(D.PROVIDER_ID, 0) = COALESCE(ME.PROVIDER_ID, 0)
    AND COALESCE(D.VISIT_OCCURRENCE_ID, 0) = COALESCE(ME.VISIT_OCCURRENCE_ID, 0)
    AND COALESCE(D.MEASUREMENT_SOURCE_VALUE, '0') = COALESCE(ME.MEASUREMENT_SOURCE_VALUE, '0');

/*
Column Descriptions:
- RUN_DATE: Current date when the query is executed
- STANDARD_DATA_TABLE: Indicates the source table being analyzed ('MEASUREMENT')
- QA_METRIC: Type of quality check being performed ('POSSIBLE_DUPLICATE')
- METRIC_FIELD: Specific field being analyzed ('VALUE_SOURCE_VALUE')
- ERROR_TYPE: Classification of the identified issue ('FOLLOW_UP')
- MEASUREMENT_ID: Unique identifier for the measurement record

Logic:
1. TMP_DUPES CTE:
   - Groups measurements by multiple fields
   - Identifies records where exact matches exist (COUNT > 1)
   - Excludes records with invalid MEASUREMENT_CONCEPT_ID or PERSON_ID

2. Main Query:
   - Joins temporary duplicates back to original table
   - Uses COALESCE to handle NULL values in comparison
   - Returns specific duplicate measurement IDs for investigation

Note: All NULL values are converted to default values (0, '1900-01-01', or '0') for comparison purposes.

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/