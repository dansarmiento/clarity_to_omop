/*********************************************************
* Script Name: QA_NOTE_ZEROCONCEPT_DETAIL.sql
* Author: Roger J Carlson - Corewell Health
* Date: June 2025
* Description: Identifies zero concept IDs in NOTE_RAW table
*********************************************************/

WITH ZEROCONCEPT_DETAIL
AS (
    SELECT 
        'NOTE_TYPE_CONCEPT_ID' AS METRIC_FIELD,
        'ZERO CONCEPT' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        NOTE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.NOTE_RAW AS NOTE
    WHERE (NOTE_TYPE_CONCEPT_ID = 0)

    UNION ALL

    SELECT 
        'NOTE_CLASS_CONCEPT_ID' AS METRIC_FIELD,
        'ZERO CONCEPT' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        NOTE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.NOTE_RAW AS NOTE
    WHERE (NOTE_CLASS_CONCEPT_ID = 0)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'NOTE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM ZEROCONCEPT_DETAIL
WHERE ERROR_TYPE <> 'EXPECTED'

/*********************************************************
* Column Descriptions:
* RUN_DATE - Date when the query was executed
* STANDARD_DATA_TABLE - Name of the source table being analyzed
* QA_METRIC - Type of quality check being performed
* METRIC_FIELD - Field being evaluated for zero concepts
* ERROR_TYPE - Severity level of the finding
* CDT_ID - NOTE_ID from the source record
*
* Logic:
* 1. Creates CTE to identify records with zero concepts
* 2. Checks both NOTE_TYPE_CONCEPT_ID and NOTE_CLASS_CONCEPT_ID
* 3. Returns only WARNING level findings
*
* Legal Warning:
* This code is provided as-is without any implied warranty.
* Use at your own risk. No guarantee of accuracy or fitness
* for any particular purpose is provided.
*********************************************************/