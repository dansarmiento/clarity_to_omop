/*******************************************************************************
* Script: STAGE_CARE_SITE_ALL
* Description: This query creates a staged version of care site data by combining
* information from multiple sources and mapping place of service concepts.
* 
* Tables Referenced:
* - OMOP_CLARITY.SOURCE_TO_CONCEPT_MAP_stg
* - OMOP_PULL.PULL_CARE_SITE_ALL
* - OMOP.LOCATION_RAW
*
* Created: [Date]
* Modified: [Date]
*******************************************************************************/

-- Common Table Expression (CTE) for Place of Service mapping
WITH cte__SOURCE_TO_CONCEPT_MAP_POS AS (
    SELECT *
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_CLARITY.SOURCE_TO_CONCEPT_MAP_stg
    WHERE SOURCE_VOCABULARY_ID = 'SH_POS'
)

-- Main query to combine care site information
SELECT DISTINCT
    PULL_CARE_SITE_ALL.CARE_SITE_ID                                    AS CARE_SITE_ID,
    PULL_CARE_SITE_ALL.CARE_SITE_NAME                                 AS CARE_SITE_NAME,
    COALESCE(SOURCE_TO_CONCEPT_MAP_POS.TARGET_CONCEPT_ID, 0)          AS PLACE_OF_SERVICE_CONCEPT_ID,
    LOCATION.LOCATION_ID                                              AS LOCATION_ID,
    LEFT(CAST(CARE_SITE_ID AS VARCHAR) || ':' || CARE_SITE_NAME, 50) AS CARE_SITE_SOURCE_VALUE,
    LEFT(CARE_SITE_ID, 50)                                           AS PLACE_OF_SERVICE_SOURCE_VALUE

FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.PULL_CARE_SITE_ALL AS PULL_CARE_SITE_ALL
    -- Join with location information
    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.LOCATION_RAW AS LOCATION
        ON LOCATION.LOCATION_SOURCE_VALUE = PULL_CARE_SITE_ALL.CARE_SITE_LOCATION_SOURCE_VALUE
    -- Join with place of service mapping
    LEFT JOIN cte__SOURCE_TO_CONCEPT_MAP_POS AS SOURCE_TO_CONCEPT_MAP_POS
        ON SOURCE_TO_CONCEPT_MAP_POS.SOURCE_CODE = PULL_CARE_SITE_ALL.POS_TYPE;