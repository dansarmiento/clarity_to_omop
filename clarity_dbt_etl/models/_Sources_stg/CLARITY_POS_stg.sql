{%- set source_relation = source('CLARITY', 'CLARITY_POS') -%}

{{ config(materialized = 'ephemeral') }}
--BEGIN CLARITY_POS_stg
--The CLARITY_POS table contains information about your places of service. 
-- All EAF records are included in this table regardless of their type. 
-- That is, facilities, locations, service areas, and places of service are all included in this table.

SELECT
	POS_ID
    ,UPPER(POS_NAME)        AS POS_NAME
    ,UPPER(POS_TYPE)        AS POS_TYPE
	,UPPER(ADDRESS_LINE_1)  AS ADDRESS_LINE_1
    ,UPPER(ADDRESS_LINE_2)  AS ADDRESS_LINE_2
    ,UPPER(CITY)            AS CITY
    ,UPPER(STATE_C)         AS STATE_C
    ,UPPER(ZIP)             AS ZIP
    ,UPPER(COUNTY_C)        AS COUNTY_C

FROM
	{{source('CLARITY','CLARITY_POS')}} AS  CLARITY_POS
--END CLARITY_POS_stg
--

