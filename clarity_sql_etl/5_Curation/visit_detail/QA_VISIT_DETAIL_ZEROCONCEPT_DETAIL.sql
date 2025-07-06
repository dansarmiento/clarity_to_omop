/*******************************************************************************
Script Name: QA_VISIT_DETAIL_ZEROCONCEPT_DETAIL
Author: Roger J Carlson - Corewell Health
Date: June 2025
********************************************************************************/

/*******************************************************************************
Purpose: Identifies zero concepts in the VISIT_DETAIL table that require attention
*******************************************************************************/

WITH ZEROCONCEPT_DETAIL AS (
    SELECT 
        'VISIT_DETAIL_CONCEPT_ID' AS METRIC_FIELD,
        'ZERO CONCEPT' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        VISIT_DETAIL_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_DETAIL_RAW AS T1
    WHERE (VISIT_DETAIL_CONCEPT_ID = 0)

    UNION ALL

    SELECT 
        'VISIT_DETAIL_TYPE_CONCEPT_ID' AS METRIC_FIELD,
        'ZERO CONCEPT' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        VISIT_DETAIL_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_DETAIL_RAW AS T1
    WHERE (VISIT_DETAIL_TYPE_CONCEPT_ID = 0)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'VISIT_DETAIL' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM ZEROCONCEPT_DETAIL
WHERE ERROR_TYPE <> 'EXPECTED'

/*******************************************************************************
Column Descriptions:
- RUN_DATE: Date when the QA check was performed
- STANDARD_DATA_TABLE: Name of the table being analyzed
- QA_METRIC: Type of quality check being performed
- METRIC_FIELD: Specific field being checked
- ERROR_TYPE: Severity of the issue found (WARNING/ERROR)
- CDT_ID: Visit Detail ID associated with the zero concept

Logic:
1. CTE identifies zero concepts in visit detail and type concept fields
2. Main query returns only WARNING level issues
3. Commented sections contain additional checks that may be implemented

Legal Warning:
This code is provided "AS IS" without warranty of any kind.
Use of this code is at your own risk and responsibility.
*******************************************************************************/