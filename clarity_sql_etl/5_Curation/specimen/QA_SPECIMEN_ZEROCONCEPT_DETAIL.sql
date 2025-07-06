/*********************************************************
* Script Name: QA_SPECIMEN_ZEROCONCEPT_DETAIL.sql
* Author: Roger J Carlson - Corewell Health
* Date: June 2025
* 
* Description: Identifies zero concepts in the SPECIMEN_RAW table
*********************************************************/

WITH ZEROCONCEPT_DETAIL
AS (
    SELECT 
        'SPECIMEN_CONCEPT_ID' AS METRIC_FIELD, 
        'ZERO CONCEPT' AS QA_METRIC, 
        'WARNING' AS ERROR_TYPE,
        SPECIMEN_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.SPECIMEN_RAW AS SPECIMEN
    WHERE (SPECIMEN_CONCEPT_ID = 0)

    UNION ALL

    SELECT 
        'ANATOMIC_SITE_CONCEPT_ID' AS METRIC_FIELD, 
        'ZERO CONCEPT' AS QA_METRIC, 
        'WARNING' AS ERROR_TYPE,
        SPECIMEN_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.SPECIMEN_RAW AS SPECIMEN
    WHERE (ANATOMIC_SITE_CONCEPT_ID = 0)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'SPECIMEN' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM ZEROCONCEPT_DETAIL
WHERE ERROR_TYPE <> 'EXPECTED';

/*********************************************************
* Column Descriptions:
* - RUN_DATE: Date when the query was executed
* - STANDARD_DATA_TABLE: Name of the table being analyzed
* - QA_METRIC: Type of quality check being performed
* - METRIC_FIELD: Field being evaluated
* - ERROR_TYPE: Classification of the issue found
* - CDT_ID: Specimen ID from the source table
*
* Logic:
* 1. Creates a CTE to identify zero concepts in specific fields
* 2. Checks SPECIMEN_CONCEPT_ID and ANATOMIC_SITE_CONCEPT_ID
* 3. Returns only non-'EXPECTED' errors
* 4. Additional concept checks are commented out for future use
*
* Legal Warning:
* This code is provided as-is without any implied warranty.
* Use at your own risk. The author and organization assume no
* liability for the use of this code.
*********************************************************/