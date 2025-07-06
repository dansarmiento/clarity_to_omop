/*******************************************************************************
Script Name: QA_Log_History_Crosstab_CountRecords
Author: Roger J Carlson - Corewell Health
Date: June 2025

* Description: Dynamic Snowflake query Pivots QA log history data to show record counts 
* by date for each standard data table
********************************************************************************/

{% set
YYYYMMDD = dbt_utils.get_column_values(table=CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_LOG_HISTORY,
column="to_char(RUN_DATE,'YYYY_MM_DD')") %}

-- Create CTE for log history data
with LOG_HIST
as
(
    SELECT 
        STANDARD_DATA_TABLE,
        TOTAL_RECORDS,
        to_char(RUN_DATE,'YYYY_MM_DD') as RUN_DATE
    from CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_LOG_HISTORY
)

-- Generate pivot table with dynamic columns based on dates
select *
from LOG_HIST
pivot
( 
    max(TOTAL_RECORDS) 
    for RUN_DATE in ({{ "'" ~ YYYYMMDD | sort | join("', '") ~ "'" }})
) as p 
( 
    STANDARD_DATA_TABLE, 
    {{ '_' ~ YYYYMMDD | sort | join(', _') }}
)

/*******************************************************************************
COLUMN DESCRIPTIONS:
------------------
STANDARD_DATA_TABLE: Name of the data table being tracked
TOTAL_RECORDS: Count of records in the table
RUN_DATE: Date when the record count was captured (YYYY_MM_DD format)

LOGIC:
------
1. Creates a CTE (LOG_HIST) that retrieves table names, record counts, and 
   formatted run dates from QA_LOG_HISTORY
2. Generates a pivot table that shows record counts for each table (rows) 
   across different dates (columns)
3. Dates are dynamically generated based on available data in QA_LOG_HISTORY

LEGAL WARNING:
-------------
This code is provided "AS IS" without warranty of any kind, either express 
or implied, including without limitation any implied warranties of condition, 
uninterrupted use, merchantability, fitness for a particular purpose, or 
non-infringement. Use at your own risk.
*******************************************************************************/