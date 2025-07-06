/*******************************************************************************
* Script Name: PULL_CARE_SITE_ALL
* Description: Retrieves distinct care site information including location details
* 
* Tables Used:
*    CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.T_POS
*
* Output Fields:
*    - Care site identification and naming
*    - Location information
*    - Address details
*
* Created: [Date]
* Modified: [Date]
*******************************************************************************/

SELECT DISTINCT
    -- Care Site Identification
    T_POS.POS_ID                AS CARE_SITE_ID,
    T_POS.POS_NAME             AS CARE_SITE_NAME,
    
    -- Concatenated Location Information
    COALESCE(T_POS.ADDRESS_LINE_1, '') ||
    COALESCE(T_POS.ADDRESS_LINE_2, '') ||
    COALESCE(T_POS.CITY, '') ||
    COALESCE(LEFT(T_POS.STATE_ABBR, 2), '') ||
    COALESCE(T_POS.ZIP, '') ||
    COALESCE(T_POS.COUNTY_C, '')      AS CARE_SITE_LOCATION_SOURCE_VALUE,

    -- Source Address Components
    T_POS.ADDRESS_LINE_1,
    T_POS.ADDRESS_LINE_2,
    T_POS.CITY,
    T_POS.STATE_C,
    T_POS.STATE_ABBR,
    T_POS.COUNTY_C             AS COUNTY_C,
    T_POS.COUNTY              AS COUNTY_NAME,
    T_POS.ZIP,
    T_POS.POS_TYPE

    -- Future enhancement:
    -- POS_TYPE_NAME AS POS_TYPE  (use when ZC_POS_TYPE is added to snowflake)

FROM 
    CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.T_POS AS T_POS
WHERE 
    T_POS.POS_ID IS NOT NULL;