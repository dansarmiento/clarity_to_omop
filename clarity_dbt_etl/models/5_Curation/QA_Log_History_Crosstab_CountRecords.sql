--QA_Log_History_Crosstab_CountRecords
{{ config(materialized='table') }}

{% set
YYYYMMDD = dbt_utils.get_column_values(table=ref('QA_LOG_HISTORY'),
column="to_char(RUN_DATE,'YYYY_MM_DD')") %}

with LOG_HIST
as
(SELECT STANDARD_DATA_TABLE ,TOTAL_RECORDS ,  to_char(RUN_DATE,'YYYY_MM_DD') as RUN_DATE
        from {{ ref('QA_LOG_HISTORY') }}
)

select *

from LOG_HIST
pivot( max(TOTAL_RECORDS)  for RUN_DATE
        in ({{ "'" ~ YYYYMMDD | sort | join("', '") ~ "'" }})
        ) as p ( STANDARD_DATA_TABLE, {{ '_' ~ YYYYMMDD | sort | join(', _') }})

