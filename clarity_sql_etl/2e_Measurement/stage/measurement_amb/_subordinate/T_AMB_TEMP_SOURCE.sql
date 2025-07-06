/*******************************************************************************
* Query to retrieve specific measurements from ambulatory flowsheet
* 
* Purpose: Extracts patient measurements based on specific flow measurement ID
* Table: PULL_MEASUREMENT_AMB_FLOWSHEET
* Filter: PULL_FLO_MEAS_ID = '7'
*******************************************************************************/

SELECT 
    PERSON_ID,              -- Unique identifier for the person
    PULL_CSN_ID,           -- Contact Serial Number ID
    MEASUREMENT_DATETIME,   -- Date and time of measurement
    VALUE_SOURCE_VALUE      -- Original value of the measurement

FROM 
    CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.PULL_MEASUREMENT_AMB_FLOWSHEET AS PULL_MEASUREMENT_AMB_FLOWSHEET

WHERE 
    PULL_FLO_MEAS_ID IN ('7');