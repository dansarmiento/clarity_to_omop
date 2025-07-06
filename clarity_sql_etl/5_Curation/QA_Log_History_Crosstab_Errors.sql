/*******************************************************************
* Script Name: QA_Log_History_Crosstab_Errors
* Author: Roger J Carlson - Corewell Health
* Date: June 2025
* Description: Dynamic Snowflake query Pivots QA log history data to show record counts 
* by date for each standard data table
*******************************************************************/

-- Get unique dates from QA_LOG_HISTORY
{% set
YYYYMMDD = dbt_utils.get_column_values(table=CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_LOG_HISTORY,
column="to_char(RUN_DATE,'YYYY_MM_DD')") %}

-- Create CTE for log history data
with LOG_HIST
as
(
    SELECT 
        STANDARD_DATA_TABLE,
        QA_METRIC,
        METRIC_FIELD,
        QA_Errors,
        ERROR_TYPE,
        to_char(RUN_DATE,'YYYY_MM_DD') as RUN_DATE
    from CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_LOG_HISTORY
)

-- Create pivot table with dates as columns
select *
from LOG_HIST
pivot
( 
    sum(QA_Errors) 
    for RUN_DATE in ({{ "'" ~ YYYYMMDD | sort | join("', '") ~ "'" }})
) as p 
( 
    STANDARD_DATA_TABLE,
    QA_METRIC,
    METRIC_FIELD,
    ERROR_TYPE,
    {{ '_' ~ YYYYMMDD | sort | join(', _') }}
)

/*******************************************************************
* Column Descriptions:
* STANDARD_DATA_TABLE - Name of the table being validated
* QA_METRIC - Type of quality check being performed
* METRIC_FIELD - Specific field being checked
* ERROR_TYPE - Classification of the error found
* _YYYY_MM_DD - Count of errors for each date
*
* Logic:
* 1. Extracts unique dates from QA_LOG_HISTORY
* 2. Creates base query with required columns
* 3. Pivots data to create columns for each date
* 4. Sums error counts for each date
*
* Legal Warning:
* This code is provided "AS IS" without warranty of any kind.
* The entire risk as to the quality and performance of the code
* is with you. In no event shall the author be liable for any
* damages whatsoever arising out of the use or inability to use
* this code.
*******************************************************************/