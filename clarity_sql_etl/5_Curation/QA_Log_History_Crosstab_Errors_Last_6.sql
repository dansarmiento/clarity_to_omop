/*******************************************************************************
Script Name: QA_Log_History_Crosstab_Errors_Last_6
Author: Roger J Carlson - Corewell Health
Date: June 2025

* Description: Dynamic Snowflake query Pivots QA log history data to show record counts 
* by date for each standard data table
********************************************************************************/

{% set
YYYYMMDD = dbt_utils.get_column_values(table=ref('LAST_6_RUNS'),
column="to_char(RUN_DATE,'YYYY_MM_DD')") %}

with LOG_HIST
as
(SELECT STANDARD_DATA_TABLE, 
        QA_METRIC, 
        Metric_field,
        QA_Errors,
        Error_Type,
        to_char(RUN_DATE,'YYYY_MM_DD') as RUN_DATE
 from {{ref('QA_LOG_HISTORY') }}
)
select *
from LOG_HIST
pivot( sum(QA_Errors) 
       for RUN_DATE
       in ({{ "'" ~ YYYYMMDD | sort | join("', '") ~ "'" }})
     ) as p ( STANDARD_DATA_TABLE, 
              QA_METRIC, 
              Metric_field,
              Error_Type, 
              {{ '_' ~ YYYYMMDD | sort | join(', _') }}
            )

/*******************************************************************************
COLUMN DESCRIPTIONS:
------------------
STANDARD_DATA_TABLE: Name of the table being quality checked
QA_METRIC: Type of quality check being performed
Metric_field: Specific field being evaluated
QA_Errors: Count of errors found
Error_Type: Classification of the error
RUN_DATE: Date the quality check was performed (YYYY_MM_DD format)

LOGIC:
------
1. Gets the last 6 run dates from LAST_6_RUNS table
2. Creates a crosstab view of QA errors by date
3. Pivots the data to show error counts for each run date in separate columns

LEGAL DISCLAIMER:
---------------
This code is provided "AS IS" without warranty of any kind.
The entire risk arising out of the use or performance of the code 
remains with you. In no event shall the author be liable for any damages 
whatsoever arising out of the use of or inability to use this code.

*******************************************************************************/