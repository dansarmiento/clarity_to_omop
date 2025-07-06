/*******************************************************************************
* Query: CARE_SITE Selection
* Description: Retrieves distinct care site information excluding records with 
*              fatal or invalid data errors
* Tables: 
*   - CARE_RES_OMOP_DEV2_WKSP.OMOP.CARE_SITE_RAW
*   - CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_ERR_DBT
*******************************************************************************/

SELECT DISTINCT
    CARE_SITE_ID,                      -- Unique identifier for care site
    CARE_SITE_NAME,                    -- Name of the care site
    PLACE_OF_SERVICE_CONCEPT_ID,       -- Standardized concept ID for place of service
    LOCATION_ID,                       -- Foreign key to the location table
    CARE_SITE_SOURCE_VALUE,            -- Source value for care site
    PLACE_OF_SERVICE_SOURCE_VALUE      -- Source value for place of service
FROM 
    CARE_RES_OMOP_DEV2_WKSP.OMOP.CARE_SITE_RAW AS CARE_SITE
    LEFT JOIN (
        SELECT 
            CDT_ID
        FROM 
            CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_ERR_DBT AS QA_ERR_DBT
        WHERE 
            (STANDARD_DATA_TABLE = 'CARE_SITE')
            AND (ERROR_TYPE IN ('FATAL', 'INVALID DATA'))
    ) AS EXCLUSION_RECORDS
    ON CARE_SITE.CARE_SITE_ID = EXCLUSION_RECORDS.CDT_ID
WHERE 
    (EXCLUSION_RECORDS.CDT_ID IS NULL);