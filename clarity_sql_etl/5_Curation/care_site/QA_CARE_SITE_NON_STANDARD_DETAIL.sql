/*******************************************************************************
* Script: QA_CARE_SITE_NON_STANDARD_DETAIL
* Description: Identifies non-standard place of service concepts in CARE_SITE table
* 
* Tables Used:
*   - CARE_RES_OMOP_DEV2_WKSP.OMOP.CARE_SITE_RAW
*   - CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT
*******************************************************************************/

WITH CTE_NON_STANDARD_DETAIL AS (
    SELECT 
        CAST(GETDATE() AS DATE) AS RUN_DATE,
        'CARE_SITE' AS STANDARD_DATA_TABLE,
        'NON-STANDARD' AS QA_METRIC,
        'PLACE_OF_SERVICE_CONCEPT_ID' AS METRIC_FIELD,
        'INVALID DATA' AS ERROR_TYPE,
        CARE_SITE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.CARE_SITE_RAW AS P
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
        ON P.PLACE_OF_SERVICE_CONCEPT_ID = C.CONCEPT_ID 
        AND UPPER(C.DOMAIN_ID) = 'PLACE OF SERVICE'
    WHERE PLACE_OF_SERVICE_CONCEPT_ID <> 0 
        AND STANDARD_CONCEPT <> 'S'
)

SELECT 
    RUN_DATE,
    STANDARD_DATA_TABLE,
    QA_METRIC,
    METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM CTE_NON_STANDARD_DETAIL
WHERE ERROR_TYPE <> 'EXPECTED';

/*******************************************************************************
* Column Descriptions:
* - RUN_DATE: Date when the QA check was performed
* - STANDARD_DATA_TABLE: Name of the table being checked (CARE_SITE)
* - QA_METRIC: Type of quality check being performed (NON-STANDARD)
* - METRIC_FIELD: Field being evaluated (PLACE_OF_SERVICE_CONCEPT_ID)
* - ERROR_TYPE: Classification of the error found (INVALID DATA)
* - CDT_ID: Care site identifier from the source table
*
* Logic:
* 1. Creates a CTE to identify care sites with non-standard place of service concepts
* 2. Joins CARE_SITE_RAW with CONCEPT table to validate place of service concepts
* 3. Filters for:
*    - Non-zero place of service concept IDs
*    - Concepts that are not marked as standard ('S')
* 4. Final query excludes any 'EXPECTED' errors from the results


LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*******************************************************************************/