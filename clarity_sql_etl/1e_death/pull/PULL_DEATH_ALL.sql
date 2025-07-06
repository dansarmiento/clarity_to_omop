/*******************************************************************************
* Query: PULL_DEATH_ALL
* Description: Retrieves death-related information for patients
* 
* Tables Used:
* - CARE_RES_OMOP_DEV2_WKSP.OMOP.PATIENT_DRIVER
* - CARE_BRONZE_CLARITY_PROD.DBO.PATIENT
*
* Note: Death Cause related joins are commented out as they create duplicates 
* in OMOP 5.4
*******************************************************************************/

SELECT DISTINCT
    -- Stage Attributes
    PATIENT_DRIVER.PERSON_ID        AS PERSON_ID,
    PATIENT.DEATH_DATE::DATE        AS DEATH_DATE,
    PATIENT.DEATH_DATE              AS DEATH_DATETIME,
    -- T_DEATH_DIAGNOSIS.DX_ID      AS CAUSE_SOURCE_VALUE  -- Commented out

    -- Pull Attributes (for verification)
    -- Death Cause fields (currently disabled)
    -- T_DEATH_DIAGNOSIS.DX_ID           AS CAUSE_DX_ID,
    -- T_DEATH_DIAGNOSIS.DX_NAME         AS CAUSE_DX_NAME,
    -- T_DEATH_DIAGNOSIS.SNOMED_CODE     AS CAUSE_SNOMED_CODE,
    -- T_DEATH_DIAGNOSIS.FULLY_SPECIFIED_NM  AS CAUSE_FULLY_SPECIFIED_NM,
    
    -- Patient Identification Fields
    PATIENT_DRIVER.EHR_PATIENT_ID   AS PULL_PAT_ID,
    PATIENT_DRIVER.MRN_CPI          AS PULL_MRN_CPI

FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PATIENT_DRIVER AS PATIENT_DRIVER

    -- Join to get patient death information
    INNER JOIN CARE_BRONZE_CLARITY_PROD.DBO.PATIENT AS PATIENT
        ON PATIENT_DRIVER.EHR_PATIENT_ID = PATIENT.PAT_ID
        AND PATIENT.PAT_STATUS_C = 2

    -- Death Cause join (currently disabled)
    /*
    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.T_DEATH_DIAGNOSIS AS T_DEATH_DIAGNOSIS
        ON PATIENT_DRIVER.EHR_PATIENT_ID = T_DEATH_DIAGNOSIS.PAT_ID
    */