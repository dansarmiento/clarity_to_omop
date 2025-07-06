{{ config(materialized='ephemeral') }}
--BEGIN cte__T_PROCEDURE_SOURCE
    SELECT CONCEPT_ID
        ,CONCEPT_CODE
        ,DOMAIN_ID
        ,VOCABULARY_ID

    FROM {{ref('CONCEPT_stg')}} AS  C
    WHERE UPPER(C.VOCABULARY_ID) IN ('CPT4')
        AND UPPER(C.DOMAIN_ID) = 'PROCEDURE'
--END cte__T_PROCEDURE_SOURCE
--
