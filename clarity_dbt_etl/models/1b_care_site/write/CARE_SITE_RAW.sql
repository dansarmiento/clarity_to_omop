--CARE_SITE
{{ config(materialized = 'table', schema = 'OMOP') }}
SELECT DISTINCT
      CARE_SITE_ID::NUMBER(28,0)                    AS CARE_SITE_ID
    , CARE_SITE_NAME::VARCHAR                       AS CARE_SITE_NAME
    , PLACE_OF_SERVICE_CONCEPT_ID::NUMBER(28,0)     AS PLACE_OF_SERVICE_CONCEPT_ID
    , LOCATION_ID::NUMBER(28,0)                     AS LOCATION_ID
    , CARE_SITE_SOURCE_VALUE::VARCHAR               AS CARE_SITE_SOURCE_VALUE
    , PLACE_OF_SERVICE_SOURCE_VALUE::VARCHAR        AS PLACE_OF_SERVICE_SOURCE_VALUE
    ------------------------------------------

FROM
 {{ref('STAGE_CARE_SITE_ALL')}} AS T
 	    QUALIFY
        ROW_NUMBER() OVER (
        PARTITION BY CARE_SITE_ID
        ORDER BY CARE_SITE_ID
        )=1
