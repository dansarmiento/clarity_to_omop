/*******************************************************************************
* Script Name: PULL_CARE_SITE_LOCATIONS
* Description: Retrieves distinct care site location details including address,
*              city, state, zip, and county information from various CLARITY
*              tables.
* 
* Tables Used:
*   - OMOP.PATIENT_DRIVER
*   - CLARITY_PROD.DBO.PAT_ENC
*   - CLARITY_PROD.DBO.CLARITY_DEP
*   - CLARITY_PROD.DBO.CLARITY_POS
*   - CLARITY_PROD.DBO.ZC_STATE
*   - CLARITY_PROD.DBO.ZC_COUNTY
*
* Created: [Date]
* Modified: [Date]
*******************************************************************************/

SELECT DISTINCT 
    CLARITY_POS.ADDRESS_LINE_1 AS ADDRESS_1,
    CLARITY_POS.ADDRESS_LINE_2 AS ADDRESS_2,
    CLARITY_POS.CITY AS CITY,
    LEFT(ZC_STATE.ABBR, 2) AS STATE,
    LEFT(CLARITY_POS.ZIP, 5) AS ZIP,
    ZC_COUNTY.NAME AS COUNTY,
    -- Concatenate address components for location source value
    COALESCE(CLARITY_POS.ADDRESS_LINE_1, '') ||
    COALESCE(CLARITY_POS.ADDRESS_LINE_2, '') ||
    COALESCE(CLARITY_POS.CITY, '') ||
    COALESCE(LEFT(ZC_STATE.ABBR, 2), '') ||
    COALESCE(CLARITY_POS.ZIP, '') ||
    COALESCE(ZC_COUNTY.COUNTY_C, '') AS LOCATION_SOURCE_VALUE

FROM 
    CARE_RES_OMOP_DEV2_WKSP.OMOP.PATIENT_DRIVER AS PATIENT_DRIVER
    -- Join to get patient encounter information
    INNER JOIN CARE_BRONZE_CLARITY_PROD.DBO.PAT_ENC AS PAT_ENC
        ON PAT_ENC.PAT_ID = PATIENT_DRIVER.EHR_PATIENT_ID
    -- Join to get department information
    INNER JOIN CARE_BRONZE_CLARITY_PROD.DBO.CLARITY_DEP AS CLARITY_DEP
        ON PAT_ENC.DEPARTMENT_ID = CLARITY_DEP.DEPARTMENT_ID
    -- Join to get location information
    INNER JOIN CARE_BRONZE_CLARITY_PROD.DBO.CLARITY_POS AS CLARITY_POS
        ON CLARITY_DEP.REV_LOC_ID = CLARITY_POS.POS_ID
    -- Join to get state information
    INNER JOIN CARE_BRONZE_CLARITY_PROD.DBO.ZC_STATE AS ZC_STATE
        ON CLARITY_POS.STATE_C = ZC_STATE.STATE_C
    -- Left join to get county information (optional)
    LEFT OUTER JOIN CARE_BRONZE_CLARITY_PROD.DBO.ZC_COUNTY AS ZC_COUNTY
        ON CLARITY_POS.COUNTY_C = ZC_COUNTY.COUNTY_C;