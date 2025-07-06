
--LOCATION
{{ config(materialized = 'table', schema = 'OMOP') }}

SELECT DISTINCT
     {{ sequence_get_nextval() }}::NUMBER(28,0) AS LOCATION_ID
    , ADDRESS_1::VARCHAR                    AS ADDRESS_1
    , ADDRESS_2::VARCHAR                    AS ADDRESS_2
    , CITY::VARCHAR                         AS CITY
    , STATE::VARCHAR                        AS STATE
    , ZIP::VARCHAR                          AS ZIP
    , COUNTY::VARCHAR                       AS COUNTY
    , LOCATION_SOURCE_VALUE::VARCHAR        AS LOCATION_SOURCE_VALUE

FROM
 {{ref('STAGE_LOCATION_ALL')}} AS T

