--CARE_SITE
{{ config(materialized = 'view', schema = 'OMOP') }}
SELECT DISTINCT
      CARE_SITE_ID
    , CARE_SITE_NAME
    , PLACE_OF_SERVICE_CONCEPT_ID
    , LOCATION_ID
    , CARE_SITE_SOURCE_VALUE
    , PLACE_OF_SERVICE_SOURCE_VALUE
    ------------------------------------------

FROM
 {{ref('CARE_SITE_RAW')}} AS CARE_SITE
LEFT JOIN (
    SELECT CDT_ID
    FROM {{ref('QA_ERR_DBT')}} AS QA_ERR_DBT
        WHERE (STANDARD_DATA_TABLE = 'CARE_SITE')
            AND (ERROR_TYPE IN ('FATAL', 'INVALID DATA'))
        ) AS EXCLUSION_RECORDS
        ON CARE_SITE.CARE_SITE_ID = EXCLUSION_RECORDS.CDT_ID
WHERE (EXCLUSION_RECORDS.CDT_ID IS NULL)
