{%- set source_relation = source('CLARITY', 'LINKED_PERFORMABLE') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN LINKED_PERFORMABLE_stg
--  This table contains information about performable procedure records linked to orderable procedure records. An orderable record may be linked to one or more performable records.
SELECT
	PROC_ID
	,CONTACT_DATE_REAL
    ,LINE
    ,LINKED_PERFORM_ID
FROM
	{{source('CLARITY','LINKED_PERFORMABLE')}} AS  LINKED_PERFORMABLE
--END LINKED_PERFORMABLE_stg
--   