/*******************************************************
* Query to retrieve anesthesia flowsheet measurements
* from PULL_MEASUREMENT_ANES_FLOWSHEET table
* for specific measurement ID
*
* Returns: Patient measurements for FLO_MEAS_ID = '7'
*******************************************************/

SELECT 
    PERSON_ID,              -- Unique identifier for the patient
    PULL_CSN_ID,           -- Contact Serial Number ID
    MEASUREMENT_DATETIME,   -- Date and time of measurement
    VALUE_SOURCE_VALUE     -- Recorded measurement value

FROM 
    CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.PULL_MEASUREMENT_ANES_FLOWSHEET AS PULL_MEASUREMENT_ANES_FLOWSHEET

WHERE 
    PULL_FLO_MEAS_ID IN ('7')  -- Filter for specific flowsheet measurement ID