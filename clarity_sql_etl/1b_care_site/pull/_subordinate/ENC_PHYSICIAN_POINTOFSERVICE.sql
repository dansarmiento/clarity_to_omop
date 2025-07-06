/*
Purpose: This query retrieves distinct point of service (POS) information for patient encounters
Database: CARE_BRONZE_CLARITY_PROD
Author: [Your Name]
Date: [Current Date]
*/

SELECT DISTINCT
    CLARITY_POS.POS_ID,              -- Unique identifier for point of service
    CLARITY_POS.POS_NAME,            -- Name of the point of service
    CLARITY_POS.ADDRESS_LINE_1,      -- First line of address
    CLARITY_POS.ADDRESS_LINE_2,      -- Second line of address
    CLARITY_POS.CITY,                -- City name
    CLARITY_POS.STATE_C,             -- State code
    ZC_STATE.ABBR as STATE_ABBR,     -- State abbreviation
    CLARITY_POS.COUNTY_C,            -- County code
    ZC_COUNTY.NAME as COUNTY,        -- County name
    CLARITY_POS.ZIP,                 -- ZIP code
    CLARITY_POS.POS_TYPE             -- Point of service type
    -- Commented out fields
    --CLARITY_POS.POS_TYPE_C
    --ZC_POS_TYPE.NAME AS POS_TYPE_NAME

FROM 
    CARE_BRONZE_CLARITY_PROD.DBO.PAT_ENC as PAT_ENC
    -- Join to get department information
    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.CLARITY_DEP as CLARITY_DEP
        ON PAT_ENC.DEPARTMENT_ID = CLARITY_DEP.DEPARTMENT_ID
    -- Join to get point of service information
    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.CLARITY_POS as CLARITY_POS
        ON CLARITY_DEP.REV_LOC_ID = CLARITY_POS.POS_ID
    -- Join to get state information
    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.ZC_STATE AS ZC_STATE
        ON CLARITY_POS.STATE_C = ZC_STATE.STATE_C
    -- Join to get county information
    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.ZC_COUNTY as ZC_COUNTY
        ON CLARITY_POS.COUNTY_C = ZC_COUNTY.COUNTY_C
    -- Commented out join for POS type
    --LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.ZC_POS_TYPE as ZC_POS_TYPE
    --    ON CLARITY_POS.POS_TYPE_C = ZC_POS_TYPE.POS_TYPE_C
    -- Join to limit results to AOU participants
    INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.PATIENT_DRIVER AS PATIENT_DRIVER
        ON PAT_ENC.PAT_ID = PATIENT_DRIVER.EHR_PATIENT_ID;