/*******************************************************************************
Script Name: QA_Log_History_Crosstab_CountRecords_Last_3
Author: Roger J Carlson - Corewell Health
Date: June 2025
********************************************************************************/

-- Dynamic date column generation for last 3 runs
{% set
YYYYMMDD = dbt_utils.get_column_values(table=ref('LAST_3_RUNS'),
column="to_char(RUN_DATE,'YYYY_MM_DD')") %}

-- CTE to prepare log history data
with LOG_HIST
as
(SELECT STANDARD_DATA_TABLE	,
           'Raw:  '|| TOTAL_RECORDS  ||'  Clean:  '||TOTAL_RECORDS_CLEAN ||  '  Diff:  '|| (TOTAL_RECORDS-TOTAL_RECORDS_CLEAN) as records,
           to_char(RUN_DATE,'YYYY_MM_DD') as RUN_DATE
        from CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_LOG_HISTORY
)

-- Final pivot query to create crosstab view
select *
from LOG_HIST
pivot( max(RECORDS)  for RUN_DATE
        in ({{ "'" ~ YYYYMMDD | sort | join("', '") ~ "'" }})
        ) as p ( STANDARD_DATA_TABLE, {{ '_' ~ YYYYMMDD | sort | join(', _') }})

/*******************************************************************************
COLUMN DESCRIPTIONS:
- STANDARD_DATA_TABLE: Name of the data table being tracked
- RECORDS: Concatenated string showing Raw count, Clean count, and their difference
- RUN_DATE: Date of the QA run in YYYY_MM_DD format

LOGIC:
1. Gets the last 3 run dates from LAST_3_RUNS table
2. Prepares log history data with formatted record counts
3. Pivots the data to show last 3 runs as columns

LEGAL WARNING:
This code is provided "AS IS" without warranty of any kind, either express or 
implied, including without limitation any implied warranties of condition, 
uninterrupted use, merchantability, fitness for a particular purpose, or 
non-infringement. Use at your own risk.
*******************************************************************************/