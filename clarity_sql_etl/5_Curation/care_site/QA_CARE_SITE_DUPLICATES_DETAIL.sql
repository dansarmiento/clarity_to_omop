/*******************************************************************************
* Script Name: QA_CARE_SITE_DUPLICATES_DETAIL
* Description: Identifies duplicate records in the CARE_SITE_RAW table based on 
*              specific column combinations
* 
* Tables Used: CARE_RES_OMOP_DEV2_WKSP.OMOP.CARE_SITE_RAW
*
* Output: Returns duplicate care site records with their IDs and metadata
*******************************************************************************/

-- Temporary CTE to identify duplicate records based on key columns
WITH TMP_DUPES AS (
    SELECT  
        PLACE_OF_SERVICE_CONCEPT_ID,
        LOCATION_ID,
        PLACE_OF_SERVICE_SOURCE_VALUE,
        CARE_SITE_NAME,
        CARE_SITE_SOURCE_VALUE,
        COUNT(*) AS CNT
    FROM 
        CARE_RES_OMOP_DEV2_WKSP.OMOP.CARE_SITE_RAW AS T1
    GROUP BY  
        PLACE_OF_SERVICE_CONCEPT_ID,
        LOCATION_ID,
        PLACE_OF_SERVICE_SOURCE_VALUE,
        CARE_SITE_NAME,
        CARE_SITE_SOURCE_VALUE
    HAVING 
        COUNT(*) > 1  -- Only return groups with multiple records
)

-- Main query to return duplicate records with metadata
SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'CARE_SITE' AS STANDARD_DATA_TABLE,
    'DUPLICATE' AS QA_METRIC,
    'RECORDS' AS METRIC_FIELD,
    'FATAL' AS ERROR_TYPE,
    CS.CARE_SITE_ID
FROM 
    TMP_DUPES AS D
    INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.CARE_SITE_RAW AS CS ON
        COALESCE(D.CARE_SITE_NAME, '0') = COALESCE(CS.CARE_SITE_NAME, '0')
        AND COALESCE(D.PLACE_OF_SERVICE_CONCEPT_ID, 0) = COALESCE(CS.PLACE_OF_SERVICE_CONCEPT_ID, 0)
        AND COALESCE(D.LOCATION_ID, 0) = COALESCE(CS.LOCATION_ID, 0)
        AND COALESCE(D.CARE_SITE_SOURCE_VALUE, '0') = COALESCE(CS.CARE_SITE_SOURCE_VALUE, '0')
        AND COALESCE(D.PLACE_OF_SERVICE_SOURCE_VALUE, '0') = COALESCE(CS.PLACE_OF_SERVICE_SOURCE_VALUE, '0');

/*******************************************************************************
* Column Descriptions:
* - RUN_DATE: Current date when the query is executed
* - STANDARD_DATA_TABLE: Constant value indicating the table being checked
* - QA_METRIC: Type of quality check being performed
* - METRIC_FIELD: Specific field or aspect being checked
* - ERROR_TYPE: Severity of the identified issue
* - CARE_SITE_ID: Unique identifier for the care site
*
* Logic:
* 1. TMP_DUPES CTE:
*    - Groups records by key identifying columns
*    - Counts occurrences of each unique combination
*    - Filters for combinations with more than one record
*
* 2. Main Query:
*    - Joins temporary results back to original table
*    - Uses COALESCE to handle NULL values in comparison
*    - Returns metadata and IDs for duplicate records
*
* Note: COALESCE is used in the JOIN conditions to ensure consistent handling
*       of NULL values when identifying duplicates

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*******************************************************************************/