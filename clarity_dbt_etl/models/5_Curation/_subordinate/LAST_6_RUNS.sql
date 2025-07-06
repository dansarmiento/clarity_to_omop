--LAST_6_RUNS
{{ config(materialized='view') }}

SELECT distinct TOP 6 RUN_DATE from {{ ref('QA_LOG_HISTORY') }} ORDER BY RUN_DATE DESC


