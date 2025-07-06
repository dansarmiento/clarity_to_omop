
{%- set source_relation = source('CLARITY', 'SPEC_DB_MAIN') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN SPEC_DB_MAIN_stg
--The SPEC_DB_MAIN table contains basic information about your specimen records. 
----These include clinical pathology, anatomic pathology, and quality control specimens. One row in this table represents one specimen.
SELECT
	SPECIMEN_ID
	, SPEC_EPT_PAT_ID
    , SPEC_DTM_COLLECTED
    , SPEC_DTM_RECEIVED
    , SPEC_SOURCE_C
	, SPECIMEN_COL_ID
FROM
	{{source('CLARITY','SPEC_DB_MAIN')}} AS  SPEC_DB_MAIN
--END SPEC_DB_MAIN_stg
--