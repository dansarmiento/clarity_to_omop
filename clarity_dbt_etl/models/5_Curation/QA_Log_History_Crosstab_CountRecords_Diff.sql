{% set get_dates_query %}
select distinct to_char(RUN_DATE,'YYYY_MM_DD') as RUN_DATE
from {{ ref('QA_LOG_HISTORY') }}
order by RUN_DATE
{% endset %}

{% set results = run_query(get_dates_query) %}

{% if execute %}
{% set dates = results.columns[0].values() %}
{% else %}
{% set dates = [] %}
{% endif %}

with LOG_HIST as (
    SELECT STANDARD_DATA_TABLE,
           'Raw:  '|| TOTAL_RECORDS  ||'  Clean:  '||TOTAL_RECORDS_CLEAN ||  '  Diff:  '|| (TOTAL_RECORDS-TOTAL_RECORDS_CLEAN) as records,
           to_char(RUN_DATE,'YYYY_MM_DD') as RUN_DATE
    from {{ ref('QA_LOG_HISTORY') }}
)

SELECT
    STANDARD_DATA_TABLE,
    {% for date in dates %}
    MAX(CASE WHEN RUN_DATE = '{{ date }}' THEN RECORDS END) as _{{ date }}
    {%- if not loop.last %},{% endif %}
    {% endfor %}
FROM LOG_HIST
GROUP BY STANDARD_DATA_TABLE
