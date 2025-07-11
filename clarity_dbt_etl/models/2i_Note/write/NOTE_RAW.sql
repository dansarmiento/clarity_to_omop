--NOTE_RAW

{{ config(materialized = 'table', schema = 'OMOP') }}

--NOTE
SELECT
    {{ sequence_get_nextval() }}::NUMBER(28,0)   AS NOTE_ID
    , PERSON_ID::NUMBER(28,0)                    AS PERSON_ID
    , NOTE_DATE::DATE                            AS NOTE_DATE
    , NOTE_DATETIME::DATETIME                    AS NOTE_DATETIME
    , NOTE_TYPE_CONCEPT_ID::NUMBER(28,0)         AS NOTE_TYPE_CONCEPT_ID
    , NOTE_CLASS_CONCEPT_ID::NUMBER(28,0)        AS NOTE_CLASS_CONCEPT_ID
    , NOTE_TITLE::VARCHAR(250)                   AS NOTE_TITLE
    , NOTE_TEXT::VARCHAR                         AS NOTE_TEXT
    , ENCODING_CONCEPT_ID::NUMBER(28,0)          AS ENCODING_CONCEPT_ID
    , LANGUAGE_CONCEPT_ID::NUMBER(28,0)          AS LANGUAGE_CONCEPT_ID
    , PROVIDER_ID::NUMBER(28,0)                  AS PROVIDER_ID
    , VISIT_OCCURRENCE_ID::NUMBER(28,0)          AS VISIT_OCCURRENCE_ID
    , VISIT_DETAIL_ID::NUMBER(28,0)              AS VISIT_DETAIL_ID
    , NOTE_SOURCE_VALUE::VARCHAR(250)            AS NOTE_SOURCE_VALUE --Human readable Source Value use src_VALUE_ID below to link
    , NOTE_EVENT_ID::NUMBER(28,0)                AS NOTE_EVENT_ID
    , NOTE_EVENT_FIELD_CONCEPT_ID::NUMBER(28,0)  AS NOTE_EVENT_FIELD_CONCEPT_ID
 ------Non OMOP fields -----------
    , ETL_MODULE::VARCHAR                         AS ETL_MODULE
    , STAGE_PAT_ID::VARCHAR                  	  AS phi_PAT_ID
    , STAGE_MRN_CPI::NUMBER(28,0)                 AS phi_MRN_CPI
    , STAGE_CSN_ID::NUMBER(28,0)			      AS phi_CSN_ID
----- Link to source
    , SRC_TABLE::VARCHAR                          AS src_TABLE
    , SRC_FIELD::VARCHAR                          AS src_FIELD
    , SRC_VALUE_ID::VARCHAR                       AS src_VALUE_ID
----- Link to note text
    -- , NOTE_TEXT_TABLE::VARCHAR                          AS note_TABLE
    -- , NOTE_TEXT_FIELD::VARCHAR                          AS note_FIELD
    -- , NOTE_TEXT_VALUE_ID::VARCHAR                       AS note_VALUE_ID
FROM
(SELECT PERSON_ID ,NOTE_DATE ,NOTE_DATETIME ,NOTE_TYPE_CONCEPT_ID, NOTE_CLASS_CONCEPT_ID
    ,NOTE_TITLE, NOTE_TEXT, ENCODING_CONCEPT_ID, LANGUAGE_CONCEPT_ID, PROVIDER_ID, VISIT_OCCURRENCE_ID
    ,VISIT_DETAIL_ID, NOTE_SOURCE_VALUE, NOTE_EVENT_ID, NOTE_EVENT_FIELD_CONCEPT_ID
    ,ETL_MODULE, STAGE_PAT_ID, STAGE_MRN_CPI, STAGE_CSN_ID
    ,'HNO_INFO' as SRC_TABLE, 'IP_NOTE_TYPE_C' AS SRC_FIELD, STAGE_IP_NOTE_TYPE_C::INTEGER AS SRC_VALUE_ID
    -- ,'HNO_NOTE_TEXT' as NOTE_TEXT_TABLE, 'NOTE_ID' AS NOTE_TEXT_FIELD, STAGE_NOTE_ID::INTEGER AS NOTE_TEXT_VALUE_ID
FROM
     {{ref('STAGE_NOTE_AMB')}}  AS STAGE_NOTE_AMB

UNION ALL
SELECT PERSON_ID ,NOTE_DATE ,NOTE_DATETIME ,NOTE_TYPE_CONCEPT_ID, NOTE_CLASS_CONCEPT_ID
    ,NOTE_TITLE, NOTE_TEXT, ENCODING_CONCEPT_ID, LANGUAGE_CONCEPT_ID, PROVIDER_ID, VISIT_OCCURRENCE_ID
    ,VISIT_DETAIL_ID, NOTE_SOURCE_VALUE, NOTE_EVENT_ID, NOTE_EVENT_FIELD_CONCEPT_ID
    ,ETL_MODULE, STAGE_PAT_ID, STAGE_MRN_CPI, STAGE_CSN_ID
    ,'HNO_INFO' as SRC_TABLE, 'IP_NOTE_TYPE_C' AS SRC_FIELD, STAGE_IP_NOTE_TYPE_C::INTEGER AS SRC_VALUE_ID
    -- ,'HNO_NOTE_TEXT' as NOTE_TEXT_TABLE, 'NOTE_ID' AS NOTE_TEXT_FIELD, STAGE_NOTE_ID::INTEGER AS NOTE_TEXT_VALUE_ID
FROM
     {{ref('STAGE_NOTE_HSP')}} AS STAGE_NOTE_HSP
UNION ALL
SELECT PERSON_ID ,NOTE_DATE ,NOTE_DATETIME ,NOTE_TYPE_CONCEPT_ID, NOTE_CLASS_CONCEPT_ID
    ,NOTE_TITLE, NOTE_TEXT, ENCODING_CONCEPT_ID, LANGUAGE_CONCEPT_ID, PROVIDER_ID, VISIT_OCCURRENCE_ID
    ,VISIT_DETAIL_ID, NOTE_SOURCE_VALUE, NOTE_EVENT_ID, NOTE_EVENT_FIELD_CONCEPT_ID
    ,ETL_MODULE, STAGE_PAT_ID, STAGE_MRN_CPI, STAGE_CSN_ID
    ,'HNO_INFO' as SRC_TABLE, 'IP_NOTE_TYPE_C' AS SRC_FIELD, STAGE_IP_NOTE_TYPE_C::INTEGER AS SRC_VALUE_ID
    -- ,'HNO_NOTE_TEXT' as NOTE_TEXT_TABLE, 'NOTE_ID' AS NOTE_TEXT_FIELD, STAGE_NOTE_ID::INTEGER AS NOTE_TEXT_VALUE_ID
FROM
     {{ref('STAGE_NOTE_ANES')}} AS STAGE_NOTE_ANES
     ) A

