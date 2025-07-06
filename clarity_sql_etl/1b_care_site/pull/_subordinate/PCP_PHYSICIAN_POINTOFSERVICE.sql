/*
Purpose: Retrieves distinct location information for patients
Tables Used:
- PATIENT: Contains patient information
- CLARITY_POS: Contains location/facility information
- ZC_STATE: Contains state reference data
- ZC_COUNTY: Contains county reference data
- PATIENT_DRIVER: Contains patient mapping information
*/

SELECT DISTINCT
    CLARITY_POS.POS_ID,           -- Unique identifier for location
    CLARITY_POS.POS_NAME,         -- Name of the location/facility
    CLARITY_POS.ADDRESS_LINE_1,   -- Primary address
    CLARITY_POS.ADDRESS_LINE_2,   -- Secondary address
    CLARITY_POS.CITY,            -- City name
    CLARITY_POS.STATE_C,         -- State code
    ZC_STATE.ABBR as STATE_ABBR, -- State abbreviation
    CLARITY_POS.COUNTY_C,        -- County code
    ZC_COUNTY.NAME as COUNTY,    -- County name
    CLARITY_POS.ZIP,             -- ZIP code
    CLARITY_POS.POS_TYPE         -- Type of location/facility
    -- Commented out fields
    --CLARITY_POS.POS_TYPE_C
    --ZC_POS_TYPE.NAME AS POS_TYPE_NAME

FROM CARE_BRONZE_CLARITY_PROD.DBO.PATIENT as PATIENT

-- Join to get location information
INNER JOIN CARE_BRONZE_CLARITY_PROD.DBO.CLARITY_POS as CLARITY_POS
    ON PATIENT.CUR_PRIM_LOC_ID = CLARITY_POS.POS_ID

-- Join to get state information
LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.ZC_STATE AS ZC_STATE
    ON CLARITY_POS.STATE_C = ZC_STATE.STATE_C

-- Join to get county information
LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.ZC_COUNTY as ZC_COUNTY
    ON CLARITY_POS.COUNTY_C = ZC_COUNTY.COUNTY_C

-- Join to get patient mapping
INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.PATIENT_DRIVER AS PATIENT_DRIVER
    ON PATIENT.PAT_ID = PATIENT_DRIVER.EHR_PATIENT_ID

/* Commented out join for future reference
LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.ZC_POS_TYPE as ZC_POS_TYPE
    ON CLARITY_POS.POS_TYPE_C = ZC_POS_TYPE.POS_TYPE_C
*/