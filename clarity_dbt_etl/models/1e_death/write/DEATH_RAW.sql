
-- DEATH_RAW
{{ config(materialized = 'table', schema = 'OMOP') }}

SELECT
     PERSON_ID::NUMBER(28,0)                AS PERSON_ID
    ,DEATH_DATE::DATE                       AS DEATH_DATE
    ,DEATH_DATETIME::DATETIME               AS DEATH_DATETIME
    ,32817::NUMBER(28,0)                    AS DEATH_TYPE_CONCEPT_ID -- FROM EHR
    ,CAUSE_CONCEPT_ID::NUMBER(28,0)         AS CAUSE_CONCEPT_ID
    ,CAUSE_SOURCE_VALUE::VARCHAR(50)        AS CAUSE_SOURCE_VALUE
    ,CAUSE_SOURCE_CONCEPT_ID::NUMBER(28,0)  AS CAUSE_SOURCE_CONCEPT_ID
	-------- Non-OMOP Fields ------------
    ,ETL_MODULE::VARCHAR(100)               AS ETL_MODULE
	,STAGE_PAT_ID                           AS phi_PAT_ID
    ,STAGE_MRN_CPI                          AS phi_MRN_CPI
FROM  {{ref('STAGE_DEATH_ALL')}} AS T
