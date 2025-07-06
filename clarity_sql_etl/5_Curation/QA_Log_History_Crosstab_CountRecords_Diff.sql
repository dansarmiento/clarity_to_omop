

/*******************************************************************************
Script Name: QA_LOG_HISTORY_PIVOT
Author: Roger J Carlson - Corewell Health
Date: June 2025

* Description: Dynamic Snowflake query Pivots QA log history data to show record counts 
* by date for each standard data table
********************************************************************************/

-- Dynamic query to get distinct dates
{% set get_dates_query %}
select distinct to_char(RUN_DATE,'YYYY_MM_DD') as RUN_DATE
from CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_LOG_HISTORY
order by RUN_DATE
{% endset %}

-- Execute query and store results
{% set results = run_query(get_dates_query) %}

-- Process results if executing
{% if execute %}
{% set dates = results.columns[0].values() %}
{% else %}
{% set dates = [] %}
{% endif %}

-- Main query
with LOG_HIST as (
    SELECT STANDARD_DATA_TABLE,
           'Raw:  '|| TOTAL_RECORDS  ||'  Clean:  '||TOTAL_RECORDS_CLEAN ||  '  Diff:  '|| (TOTAL_RECORDS-TOTAL_RECORDS_CLEAN) as records,
           to_char(RUN_DATE,'YYYY_MM_DD') as RUN_DATE
    from CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_LOG_HISTORY
)

SELECT
    STANDARD_DATA_TABLE,
    {% for date in dates %}
    MAX(CASE WHEN RUN_DATE = '{{ date }}' THEN RECORDS END) as _{{ date }}
    {%- if not loop.last %},{% endif %}
    {% endfor %}
FROM LOG_HIST
GROUP BY STANDARD_DATA_TABLE

/*******************************************************************************
COLUMN DESCRIPTIONS:
- STANDARD_DATA_TABLE: Name of the data table being analyzed
- _YYYY_MM_DD: Dynamically created columns for each date, containing:
    * Raw: Total number of records in the raw data
    * Clean: Total number of records after cleaning
    * Diff: Difference between raw and clean records

LOGIC:
1. Retrieves distinct dates from QA_LOG_HISTORY
2. Creates a CTE with formatted record counts
3. Pivots the data to show record counts by date for each table
4. Uses dynamic SQL to accommodate varying dates

LEGAL WARNING:
This code is provided "AS IS" without warranty of any kind, either express or 
implied, including without limitation any implied warranties of condition, 
uninterrupted use, merchantability, fitness for a particular purpose, or 
non-infringement. Use at your own risk.
*******************************************************************************/