--QRY_MEASUREMENT

WITH SOURCE_DATA AS (
    SELECT
        MEASUREMENT.MEASUREMENT_ID,
        MEASUREMENT.PERSON_ID,
        LEFT(MEASUREMENT.MEASUREMENT_CONCEPT_ID || '::' || C1.CONCEPT_NAME, 100) AS MEASUREMENT,
        MEASUREMENT.MEASUREMENT_DATETIME,
        MEASUREMENT.MEASUREMENT_TYPE_CONCEPT_ID || '::' || C2.CONCEPT_NAME AS MEASUREMENT_TYPE,
        MEASUREMENT.OPERATOR_CONCEPT_ID || '::' || C3.CONCEPT_NAME AS OPERATOR,
        MEASUREMENT.VALUE_AS_NUMBER,
        MEASUREMENT.VALUE_AS_CONCEPT_ID || '::' || C4.CONCEPT_NAME AS VALUE_AS_CONCEPT,
        MEASUREMENT.UNIT_CONCEPT_ID || '::' || C5.CONCEPT_NAME AS UNIT,
        MEASUREMENT.RANGE_LOW,
        MEASUREMENT.RANGE_HIGH,
        PROVIDER.PROVIDER_NAME,
        MEASUREMENT.VISIT_OCCURRENCE_ID,
        MEASUREMENT.MEASUREMENT_SOURCE_VALUE,
        MEASUREMENT.MEASUREMENT_SOURCE_CONCEPT_ID || '::' || C6.CONCEPT_NAME AS MEASUREMENT_SOURCE,
        MEASUREMENT.UNIT_SOURCE_VALUE,
        MEASUREMENT.VALUE_SOURCE_VALUE,
        'MEASUREMENT' AS SDT_TAB,
        VISIT_OCCURRENCE.PERSON_ID || MEASUREMENT.MEASUREMENT_SOURCE_VALUE || MEASUREMENT.MEASUREMENT_DATETIME AS NK,
        MEASUREMENT.ETL_MODULE,
        MEASUREMENT.PHI_PAT_ID,
        MEASUREMENT.PHI_MRN_CPI,
        MEASUREMENT.PHI_CSN_ID,
        MEASUREMENT.SRC_TABLE,
        MEASUREMENT.SRC_FIELD,
        MEASUREMENT.SRC_VALUE_ID

    FROM {{ ref('MEASUREMENT') }} MEASUREMENT
    LEFT JOIN {{ ref('PROVIDER') }} PROVIDER
        ON MEASUREMENT.PROVIDER_ID = PROVIDER.PROVIDER_ID
    INNER JOIN {{ source('OMOP', 'CONCEPT') }} C1
        ON C1.CONCEPT_ID = MEASUREMENT.MEASUREMENT_CONCEPT_ID
    INNER JOIN {{ source('OMOP', 'CONCEPT') }} C2
        ON C2.CONCEPT_ID = MEASUREMENT.MEASUREMENT_TYPE_CONCEPT_ID
    LEFT JOIN {{ source('OMOP', 'CONCEPT') }} C3
        ON C3.CONCEPT_ID = MEASUREMENT.OPERATOR_CONCEPT_ID
    LEFT JOIN {{ source('OMOP', 'CONCEPT') }} C4
        ON C4.CONCEPT_ID = MEASUREMENT.VALUE_AS_CONCEPT_ID
    INNER JOIN {{ source('OMOP', 'CONCEPT') }} C5
        ON C5.CONCEPT_ID = MEASUREMENT.UNIT_CONCEPT_ID
    LEFT JOIN {{ source('OMOP', 'CONCEPT') }} C6
        ON C6.CONCEPT_ID = MEASUREMENT.MEASUREMENT_SOURCE_CONCEPT_ID
    INNER JOIN {{ ref('VISIT_OCCURRENCE') }} VISIT_OCCURRENCE
        ON MEASUREMENT.VISIT_OCCURRENCE_ID = VISIT_OCCURRENCE.VISIT_OCCURRENCE_ID
)

SELECT * FROM SOURCE_DATA
