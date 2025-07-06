--QA_Log_History_Crosstab_CountRecords_Last_3
{{ config(materialized='table') }}

{% set
YYYYMMDD = dbt_utils.get_column_values(table=ref('LAST_3_RUNS'),
column="to_char(RUN_DATE,'YYYY_MM_DD')") %}

with LOG_HIST
as
(SELECT STANDARD_DATA_TABLE	,
           'Raw:  '|| TOTAL_RECORDS  ||'  Clean:  '||TOTAL_RECORDS_CLEAN ||  '  Diff:  '|| (TOTAL_RECORDS-TOTAL_RECORDS_CLEAN) as records,
           to_char(RUN_DATE,'YYYY_MM_DD') as RUN_DATE
        from {{ ref('QA_LOG_HISTORY') }}
)

select *

from LOG_HIST
pivot( max(RECORDS)  for RUN_DATE
        in ({{ "'" ~ YYYYMMDD | sort | join("', '") ~ "'" }})
        ) as p ( STANDARD_DATA_TABLE, {{ '_' ~ YYYYMMDD | sort | join(', _') }})

