/*******************************************************************************
* Query: Extract Temperature Measurements from Hospital Flowsheet
* Description: Retrieves distinct temperature measurements from hospital flowsheet
* data where the measurement ID is '7'
* Database: CARE_RES_OMOP_DEV2_WKSP
* Schema: OMOP_PULL
*******************************************************************************/

SELECT DISTINCT
    PERSON_ID,              -- Unique identifier for the patient
    PULL_CSN_ID,           -- Contact Serial Number ID for the visit
    MEASUREMENT_DATETIME,   -- Date and time when temperature was measured
    VALUE_SOURCE_VALUE     -- Actual temperature measurement value

FROM 
    CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.PULL_MEASUREMENT_HOSP_FLOWSHEET AS PULL_MEASUREMENT_HOSP_FLOWSHEET

WHERE 
    PULL_FLO_MEAS_ID IN ('7')  -- Filter for temperature measurements (ID: 7)