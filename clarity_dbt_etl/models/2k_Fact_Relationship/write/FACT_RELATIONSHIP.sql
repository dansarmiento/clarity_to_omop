 {{ config(materialized = 'table', schema = 'OMOP') }}
--FACT_RELATIONSHIP


SELECT DISTINCT
      DOMAIN_CONCEPT_ID_1::NUMBER(28,0)            AS DOMAIN_CONCEPT_ID_1
    , FACT_ID_1::NUMBER(28,0)                      AS FACT_ID_1
    , DOMAIN_CONCEPT_ID_2::NUMBER(28,0)            AS DOMAIN_CONCEPT_ID_2
    , FACT_ID_2::NUMBER(28,0)                      AS FACT_ID_2
    , RELATIONSHIP_CONCEPT_ID::NUMBER(28,0)        AS RELATIONSHIP_CONCEPT_ID

 ------Non OMOP fields -----------
    , ETL_MODULE::VARCHAR                         AS ETL_MODULE
----- Link to source
    , FACT_1::VARCHAR                             AS fct1_FACT
    , FACT_1_TABLE::VARCHAR                       AS fct1_TABLE
    , FACT_1_FIELD::VARCHAR                       AS fct1_FIELD
    , FACT_1_VALUE_ID::VARCHAR                    AS fct1_VALUE_ID

    , FACT_2::VARCHAR                             AS fct2_FACT
    , FACT_2_TABLE::VARCHAR                       AS fct2_TABLE
    , FACT_2_FIELD::VARCHAR                       AS fct2_FIELD
    , FACT_2_VALUE_ID::VARCHAR                    AS fct2_VALUE_ID
FROM
(SELECT DOMAIN_CONCEPT_ID_1, FACT_ID_1, DOMAIN_CONCEPT_ID_2, FACT_ID_2, RELATIONSHIP_CONCEPT_ID
     , ETL_MODULE AS ETL_MODULE
     , 'BABY_ID' AS FACT_1, 'PATIENT' as FACT_1_TABLE, 'PAT_ID' AS FACT_1_FIELD, STAGE_BABY_ID::VARCHAR AS FACT_1_VALUE_ID
     , 'MOM_ID' AS FACT_2, 'PATIENT' as FACT_2_TABLE, 'PAT_ID' AS FACT_2_FIELD, STAGE_MOM_ID::VARCHAR AS FACT_2_VALUE_ID
FROM
     {{ref('STAGE_FACT_RELATIONSHIP_MOM_AND_BABY')}} AS STAGE_FACT_RELATIONSHIP_MOM_AND_BABY

     ) A

