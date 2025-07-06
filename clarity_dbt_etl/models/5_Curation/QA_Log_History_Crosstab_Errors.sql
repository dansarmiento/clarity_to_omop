--QA_Log_History_Crosstab_Errors
{{ config(materialized='table') }}

{% set
YYYYMMDD = dbt_utils.get_column_values(table=ref('QA_LOG_HISTORY'),
column="to_char(RUN_DATE,'YYYY_MM_DD')") %}

with LOG_HIST
as
(SELECT STANDARD_DATA_TABLE, QA_METRIC, METRIC_FIELD ,QA_Errors	,ERROR_TYPE ,  to_char(RUN_DATE,'YYYY_MM_DD') as RUN_DATE
        from {{ ref('QA_LOG_HISTORY') }}
)

select *

from LOG_HIST
pivot( sum(QA_Errors)  for RUN_DATE
        in ({{ "'" ~ YYYYMMDD | sort | join("', '") ~ "'" }})
        ) as p ( STANDARD_DATA_TABLE, QA_METRIC, METRIC_FIELD ,ERROR_TYPE , {{ '_' ~ YYYYMMDD | sort | join(', _')  }})

