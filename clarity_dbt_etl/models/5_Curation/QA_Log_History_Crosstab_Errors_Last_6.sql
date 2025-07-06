--QA_Log_History_Crosstab_Errors_Last_6
{{ config(materialized='table') }}

{% set
YYYYMMDD = dbt_utils.get_column_values(table=ref('LAST_6_RUNS'),
column="to_char(RUN_DATE,'YYYY_MM_DD')") %}

with LOG_HIST
as
(SELECT STANDARD_DATA_TABLE, QA_METRIC, Metric_field ,QA_Errors	,Error_Type ,  to_char(RUN_DATE,'YYYY_MM_DD') as RUN_DATE
        from {{ref('QA_LOG_HISTORY') }}
)
select *
from LOG_HIST
pivot( sum(QA_Errors)  for RUN_DATE
        in ({{ "'" ~ YYYYMMDD | sort | join("', '") ~ "'" }})
        ) as p ( STANDARD_DATA_TABLE, QA_METRIC, Metric_field ,Error_Type , {{ '_' ~ YYYYMMDD | sort | join(', _') }})
