/*******************************************************************************
* Script Name: QA_CARE_SITE_ZERO_CONCEPT_DETAIL
* Description: Identifies care sites with zero concept IDs in place of service
* 
* Tables Used:
*    CARE_RES_OMOP_DEV2_WKSP.OMOP.CARE_SITE_RAW
*
* Output Columns:
*    - RUN_DATE: Date when the QA check was performed
*    - STANDARD_DATA_TABLE: Name of the table being checked
*    - QA_METRIC: Type of quality check performed
*    - METRIC_FIELD: Field being evaluated
*    - ERROR_TYPE: Severity of the issue found
*    - CDT_ID: Care site ID with the issue
*******************************************************************************/

WITH CTE_ZERO_CONCEPT_DETAIL AS (
    SELECT 
        'CARE_SITE' AS STANDARD_DATA_TABLE,
        'PLACE_OF_SERVICE_CONCEPT_ID' AS METRIC_FIELD,
        'ZERO CONCEPT' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        CARE_SITE_ID AS CDT_ID
    FROM 
        CARE_RES_OMOP_DEV2_WKSP.OMOP.CARE_SITE_RAW AS CARE_SITE
    WHERE 
        PLACE_OF_SERVICE_CONCEPT_ID = 0
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    STANDARD_DATA_TABLE,
    QA_METRIC,
    METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM 
    CTE_ZERO_CONCEPT_DETAIL
WHERE 
    ERROR_TYPE <> 'EXPECTED';

/*******************************************************************************
* Column Descriptions:
* - RUN_DATE: Current date when the query is executed
* - STANDARD_DATA_TABLE: Always 'CARE_SITE' for this query
* - QA_METRIC: Always 'ZERO CONCEPT' indicating the type of quality check
* - METRIC_FIELD: Always 'PLACE_OF_SERVICE_CONCEPT_ID' indicating the field being checked
* - ERROR_TYPE: Always 'WARNING' for this check
* - CDT_ID: The CARE_SITE_ID where PLACE_OF_SERVICE_CONCEPT_ID = 0
*
* Logic:
* 1. CTE identifies care sites where PLACE_OF_SERVICE_CONCEPT_ID is 0
* 2. Main query adds the current date and filters out any 'EXPECTED' error types
* 3. This helps identify potentially problematic care site records where the
*    place of service concept hasn't been properly mapped (indicated by 0)

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*******************************************************************************/