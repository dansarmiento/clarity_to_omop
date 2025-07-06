
{%- set source_relation = source('CLARITY', 'IP_FLO_GP_DATA') -%}

{{ config(materialized = 'table') }}
--BEGIN IP_FLO_GP_DATA_stg
-- This table contains generic information about flowsheet groups/rows.
SELECT
	UPPER(FLO_MEAS_ID) AS FLO_MEAS_ID
	,MINVALUE
	,MAX_VAL
	,UPPER(FLO_MEAS_NAME) AS FLO_MEAS_NAME
	,VAL_TYPE_C
	,UPPER(UNITS::VARCHAR) AS UNITS
	,UPPER(DISP_NAME) AS DISP_NAME
	,UPPER(CAT_INI) AS CAT_INI
	,UPPER(CAT_ITEM) AS CAT_ITEM
FROM
	{{source('CLARITY','IP_FLO_GP_DATA')}} AS  IP_FLO_GP_DATA
--END IP_FLO_GP_DATA_stg
--   