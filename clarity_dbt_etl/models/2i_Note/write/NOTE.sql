

{{ config(materialized = 'view', schema = 'OMOP') }}

--NOTE
SELECT
      NOTE_ID
    , PERSON_ID
    , NOTE_DATE
    , NOTE_DATETIME
    , NOTE_TYPE_CONCEPT_ID
    , NOTE_CLASS_CONCEPT_ID
    , NOTE_TITLE
    , NOTE_TEXT
    , ENCODING_CONCEPT_ID
    , LANGUAGE_CONCEPT_ID
    , PROVIDER_ID
    , VISIT_OCCURRENCE_ID
    , VISIT_DETAIL_ID
    , NOTE_SOURCE_VALUE --Human readable Source Value use src_VALUE_ID below to link
    , NOTE_EVENT_ID
    , NOTE_EVENT_FIELD_CONCEPT_ID
 ------Non OMOP fields -----------
    , ETL_MODULE
    , phi_PAT_ID
    , phi_MRN_CPI
    , phi_CSN_ID
----- Link to source
    , src_TABLE
    , src_FIELD
    , src_VALUE_ID
----- Link to note text
    -- , note_TABLE
    -- , note_FIELD
    -- , note_VALUE_ID
FROM
     {{ref('NOTE_RAW')}}  AS NOTE

LEFT JOIN (
    SELECT CDT_ID
    FROM {{ref('QA_ERR_DBT')}} AS QA_ERR_DBT
        WHERE (STANDARD_DATA_TABLE = 'NOTE')
            AND (ERROR_TYPE IN ('FATAL', 'INVALID DATA'))
        ) AS EXCLUSION_RECORDS
        ON NOTE.NOTE_ID = EXCLUSION_RECORDS.CDT_ID
WHERE (EXCLUSION_RECORDS.CDT_ID IS NULL)
