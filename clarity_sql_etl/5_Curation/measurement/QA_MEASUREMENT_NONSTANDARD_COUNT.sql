/*
QA_MEASUREMENT_NONSTANDARD_COUNT
This query checks for non-standard concept IDs and invalid data in the MEASUREMENT table
by comparing against the CONCEPT table.
*/

WITH NONSTANDARD_COUNT AS (
    -- Check MEASUREMENT_CONCEPT_ID
    SELECT 
        'MEASUREMENT_CONCEPT_ID' AS METRIC_FIELD,
        'NON-STANDARD' AS QA_METRIC, 
        'INVALID DATA' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT_RAW AS M
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
        ON M.MEASUREMENT_CONCEPT_ID = C.CONCEPT_ID 
        AND upper(C.DOMAIN_ID) = 'MEASUREMENT'
        AND upper(C.VOCABULARY_ID) IN ('LOINC', 'SNOMED', 'CPT4')
    WHERE MEASUREMENT_CONCEPT_ID <> 0 
    AND MEASUREMENT_CONCEPT_ID IS NOT NULL 
    AND (STANDARD_CONCEPT <> 'S' OR STANDARD_CONCEPT IS NULL)

    UNION ALL

    -- Check MEASUREMENT_TYPE_CONCEPT_ID  
    SELECT 
        'MEASUREMENT_TYPE_CONCEPT_ID' AS METRIC_FIELD,
        'NON-STANDARD' AS QA_METRIC,
        'INVALID DATA' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT_RAW AS M
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
        ON M.MEASUREMENT_TYPE_CONCEPT_ID = C.CONCEPT_ID
        AND upper(C.DOMAIN_ID) = 'TYPE CONCEPT'
        AND upper(C.VOCABULARY_ID) IN ('TYPE CONCEPT')
    WHERE MEASUREMENT_TYPE_CONCEPT_ID <> 0
    AND MEASUREMENT_TYPE_CONCEPT_ID IS NOT NULL
    AND (STANDARD_CONCEPT <> 'S' OR STANDARD_CONCEPT IS NULL)

    UNION ALL

    -- Check OPERATOR_CONCEPT_ID
    SELECT 
        'OPERATOR_CONCEPT_ID' AS METRIC_FIELD,
        'NON-STANDARD' AS QA_METRIC,
        'INVALID DATA' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT_RAW AS M
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
        ON M.OPERATOR_CONCEPT_ID = C.CONCEPT_ID
        AND upper(C.DOMAIN_ID) = 'MEAS VALUE OPERATOR'
    WHERE OPERATOR_CONCEPT_ID <> 0
    AND OPERATOR_CONCEPT_ID IS NOT NULL
    AND (STANDARD_CONCEPT <> 'S' OR STANDARD_CONCEPT IS NULL)

    UNION ALL

    -- Check VALUE_AS_CONCEPT_ID
    SELECT 
        'VALUE_AS_CONCEPT_ID' AS METRIC_FIELD,
        'NON-STANDARD' AS QA_METRIC,
        'INVALID DATA' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT_RAW AS M
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
        ON M.VALUE_AS_CONCEPT_ID = C.CONCEPT_ID
        AND upper(C.DOMAIN_ID) IN ('MEAS VALUE', 'OBSERVATION')
        AND upper(C.VOCABULARY_ID) IN ('LOINC', 'SNOMED')
    WHERE VALUE_AS_CONCEPT_ID <> 0
    AND VALUE_AS_CONCEPT_ID IS NOT NULL
    AND (STANDARD_CONCEPT <> 'S' OR STANDARD_CONCEPT IS NULL)

    UNION ALL

    -- Check COVID Mapping
    SELECT 
        'VALUE_AS_CONCEPT_ID' AS METRIC_FIELD,
        'COVID_MAPPING' AS QA_METRIC,
        'INVALID DATA' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT_RAW AS M
    JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT_ANCESTOR AS CA 
        ON M.MEASUREMENT_CONCEPT_ID = CA.DESCENDANT_CONCEPT_ID
    WHERE CA.ANCESTOR_CONCEPT_ID = 756055
    AND (M.VALUE_AS_CONCEPT_ID IS NULL OR M.VALUE_AS_CONCEPT_ID = 0)

    UNION ALL

    -- Check UNIT_CONCEPT_ID
    SELECT 
        'UNIT_CONCEPT_ID' AS METRIC_FIELD,
        'NON-STANDARD' AS QA_METRIC,
        'INVALID DATA' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT_RAW AS M
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
        ON M.UNIT_CONCEPT_ID = C.CONCEPT_ID
        AND upper(C.DOMAIN_ID) = 'UNIT'
    WHERE UNIT_CONCEPT_ID <> 0
    AND UNIT_CONCEPT_ID IS NOT NULL
    AND (STANDARD_CONCEPT <> 'S' OR STANDARD_CONCEPT IS NULL)

    UNION ALL

    -- Check MEASUREMENT_SOURCE_CONCEPT_ID
    SELECT 
        'MEASUREMENT_SOURCE_CONCEPT_ID' AS METRIC_FIELD,
        'NON-STANDARD' AS QA_METRIC,
        'INVALID DATA' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT_RAW AS M
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
        ON M.MEASUREMENT_SOURCE_CONCEPT_ID = C.CONCEPT_ID
        AND upper(C.DOMAIN_ID) = 'MEASUREMENT'
        AND upper(C.VOCABULARY_ID) IN ('LOINC', 'SNOMED')
    WHERE MEASUREMENT_SOURCE_CONCEPT_ID <> 0
    AND C.CONCEPT_ID IS NULL
)

-- Final Results
SELECT
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'MEASUREMENT' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    COALESCE(SUM(CNT), 0) AS QA_ERRORS,
    CASE WHEN SUM(CNT) <> 0 THEN ERROR_TYPE ELSE NULL END AS ERROR_TYPE,
    (SELECT COUNT(*) FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT) AS TOTAL_RECORDS_CLEAN
FROM NONSTANDARD_COUNT
GROUP BY METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/*Tables Used:
- MEASUREMENT_RAW: Raw measurement data before standardization
- CONCEPT: Reference table containing standard concepts
- CONCEPT_ANCESTOR: Table showing relationships between concepts

Fields Checked:
- MEASUREMENT_CONCEPT_ID: Concept ID for the measurement
- MEASUREMENT_TYPE_CONCEPT_ID: Type of measurement record
- OPERATOR_CONCEPT_ID: Mathematical operator for the measurement value
- VALUE_AS_CONCEPT_ID: Standardized measurement result value
- UNIT_CONCEPT_ID: Units for the measurement
- MEASUREMENT_SOURCE_CONCEPT_ID: Source concept ID

Logic:
1. Creates CTE NONSTANDARD_COUNT that checks each field against CONCEPT table
2. For each field, validates:
   - Concept exists in CONCEPT table
   - Concept is from correct domain
   - Concept is marked as standard ('S')
3. Special COVID mapping check for VALUE_AS_CONCEPT_ID
4. Returns summary metrics including:
   - Run date
   - Table name
   - QA metric type
   - Field being checked  
   - Count of errors
   - Error type
   - Total raw records
   - Total clean records

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
   */