/*******************************************************************************
* Script Name: QA_VISIT_OCCURRENCE_NULLFK_DETAIL.sql
* Author: Roger J Carlson - Corewell Health
* Date: June 2025
*******************************************************************************/

WITH NULLFK_DETAIL AS (
    SELECT 
        'PERSON_ID' AS METRIC_FIELD,
        'NULL FK' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        VISIT_OCCURRENCE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS T1
    WHERE (PERSON_ID IS NULL)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'VISIT_OCCURRENCE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM NULLFK_DETAIL
WHERE ERROR_TYPE <> 'EXPECTED';

/*******************************************************************************
* Column Descriptions:
* ------------------
* RUN_DATE: Date when the query was executed
* STANDARD_DATA_TABLE: Name of the table being analyzed
* QA_METRIC: Quality assurance metric type
* METRIC_FIELD: Field being evaluated
* ERROR_TYPE: Classification of the error
* CDT_ID: Visit Occurrence ID from the source table
*
* Logic:
* ------
* 1. CTE identifies records where PERSON_ID is NULL in VISIT_OCCURRENCE_RAW
* 2. Main query returns these violations with additional metadata
* 3. Filters out any 'EXPECTED' error types
*
* Legal Warning:
* -------------
* This code is provided "AS IS" without warranty of any kind, either expressed 
* or implied, including but not limited to the implied warranties of 
* merchantability and/or fitness for a particular purpose. The user assumes 
* all risk for any damages whatsoever resulting from the use or misuse of 
* this code.
*******************************************************************************/