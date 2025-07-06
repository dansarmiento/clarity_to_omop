{{ config(materialized='ephemeral') }}
SELECT CONCEPT_ID
    ,CONCEPT_CODE
    ,REPLACE(CONCEPT_NAME, '"', '') AS CONCEPT_NAME

FROM {{ ref('CONCEPT_stg')}} AS C
WHERE C.VOCABULARY_ID IN ('SNOMED')
    AND (
        C.INVALID_REASON IS NULL
        OR C.INVALID_REASON = ''
        )
    AND C.DOMAIN_ID = 'Condition'
