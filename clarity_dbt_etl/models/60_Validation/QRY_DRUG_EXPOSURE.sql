--QRY_DRUG_EXPOSURE

WITH drug_exposure_detail AS (
    SELECT
        DRUG_EXPOSURE.DRUG_EXPOSURE_ID,
        DRUG_EXPOSURE.PERSON_ID,
        LEFT(DRUG_EXPOSURE.DRUG_CONCEPT_ID || '::' || c1.CONCEPT_NAME, 100) AS DRUG_CONCEPT,
        DRUG_EXPOSURE.DRUG_EXPOSURE_START_DATETIME,
        DRUG_EXPOSURE.DRUG_EXPOSURE_END_DATETIME,
        DRUG_EXPOSURE.VERBATIM_END_DATE,
        DRUG_EXPOSURE.DRUG_TYPE_CONCEPT_ID || '::' || c2.CONCEPT_NAME AS DRUG_TYPE,
        DRUG_EXPOSURE.STOP_REASON,
        DRUG_EXPOSURE.REFILLS,
        DRUG_EXPOSURE.QUANTITY,
        DRUG_EXPOSURE.DAYS_SUPPLY,
        DRUG_EXPOSURE.SIG,
        DRUG_EXPOSURE.ROUTE_CONCEPT_ID || '::' || c3.CONCEPT_NAME AS ROUTE,
        DRUG_EXPOSURE.LOT_NUMBER,
        PROVIDER.PROVIDER_NAME,
        DRUG_EXPOSURE.VISIT_OCCURRENCE_ID,
        DRUG_EXPOSURE.DRUG_SOURCE_VALUE,
        DRUG_EXPOSURE.DRUG_SOURCE_CONCEPT_ID || '::' || c4.CONCEPT_NAME AS DRUG_SOURCE_CONCEPT,
        DRUG_EXPOSURE.ROUTE_SOURCE_VALUE,
        DRUG_EXPOSURE.DOSE_UNIT_SOURCE_VALUE,
        'DRUG' AS SDT_TAB,
        VISIT_OCCURRENCE.PERSON_ID || DRUG_SOURCE_VALUE || DRUG_EXPOSURE_START_DATETIME AS NK,
        DRUG_EXPOSURE.ETL_MODULE,
        DRUG_EXPOSURE.PHI_PAT_ID,
        DRUG_EXPOSURE.PHI_MRN_CPI,
        DRUG_EXPOSURE.PHI_CSN_ID,
        DRUG_EXPOSURE.SRC_TABLE,
        DRUG_EXPOSURE.SRC_FIELD,
        DRUG_EXPOSURE.SRC_VALUE_ID
    FROM {{ ref('DRUG_EXPOSURE') }}
    INNER JOIN {{ source('OMOP', 'CONCEPT') }} c1
        ON DRUG_EXPOSURE.DRUG_CONCEPT_ID = c1.CONCEPT_ID
    INNER JOIN {{ source('OMOP', 'CONCEPT') }} c2
        ON DRUG_EXPOSURE.DRUG_TYPE_CONCEPT_ID = c2.CONCEPT_ID
    INNER JOIN {{ source('OMOP', 'CONCEPT') }} c3
        ON DRUG_EXPOSURE.ROUTE_CONCEPT_ID = c3.CONCEPT_ID
    INNER JOIN {{ source('OMOP', 'CONCEPT') }} c4
        ON DRUG_EXPOSURE.DRUG_SOURCE_CONCEPT_ID = c4.CONCEPT_ID
    LEFT JOIN {{ ref('PROVIDER') }}
        ON DRUG_EXPOSURE.PROVIDER_ID = PROVIDER.PROVIDER_ID
    INNER JOIN {{ ref('VISIT_OCCURRENCE') }}
        ON DRUG_EXPOSURE.VISIT_OCCURRENCE_ID = VISIT_OCCURRENCE.VISIT_OCCURRENCE_ID
)

SELECT * FROM drug_exposure_detail
