/*******************************************************************************
* Script Name: PULL_PERSON_ALL
* Description: This query retrieves comprehensive person-related information by
*              joining multiple tables from the healthcare database.
* 
* Tables Used:
*   - CARE_BRONZE_CLARITY_PROD.DBO.PATIENT
*   - CARE_BRONZE_CLARITY_PROD.DBO.PATIENT_RACE
*   - CARE_BRONZE_CLARITY_PROD.DBO.ZC_PATIENT_RACE
*   - CARE_BRONZE_CLARITY_PROD.DBO.ZC_ETHNIC_GROUP
*   - CARE_BRONZE_CLARITY_PROD.DBO.ZC_SEX
*   - CARE_BRONZE_CLARITY_PROD.DBO.ZC_STATE
*   - CARE_BRONZE_CLARITY_PROD.DBO.ZC_COUNTY
*   - CARE_RES_OMOP_DEV2_WKSP.OMOP.PATIENT_DRIVER
*
* Output Columns:
*   - Demographic information (birth date, race, ethnicity, sex)
*   - Location details (address, city, state, zip)
*   - Provider and facility information
*   - Patient identifiers
*******************************************************************************/

SELECT DISTINCT
    -- Patient Demographic Information
    PATIENT_DRIVER.PERSON_ID                AS PERSON_ID,
    YEAR(PATIENT.BIRTH_DATE)               AS YEAR_OF_BIRTH,
    MONTH(PATIENT.BIRTH_DATE)              AS MONTH_OF_BIRTH,
    DAY(PATIENT.BIRTH_DATE)                AS DAY_OF_BIRTH,
    PATIENT.BIRTH_DATE                     AS BIRTH_DATETIME,
    ZC_PATIENT_RACE.PATIENT_RACE_C         AS PATIENT_RACE_C,
    ZC_ETHNIC_GROUP.ETHNIC_GROUP_C         AS ETHNIC_GROUP_C,
    PATIENT.CUR_PCP_PROV_ID               AS CUR_PCP_PROV_ID,
    PATIENT.CUR_PRIM_LOC_ID               AS CUR_PRIM_LOC_ID,
    PATIENT.SEX_C,
    
    -- Concatenated Location Information (limited to 50 characters)
    LEFT(COALESCE(PATIENT.ADD_LINE_1, '') ||
         COALESCE(PATIENT.ADD_LINE_2, '') ||
         COALESCE(PATIENT.CITY, '') ||
         COALESCE(LEFT(ZC_STATE.ABBR, 2), '') ||
         COALESCE(PATIENT.ZIP, '') ||
         COALESCE(ZC_COUNTY.COUNTY_C, ''), 50) AS LOCATION_SOURCE_VALUE,

    -- Source System Identifiers
    PATIENT_DRIVER.EHR_PATIENT_ID          AS PULL_PAT_ID,
    PATIENT_DRIVER.MRN_CPI                 AS PULL_MRN_CPI,
    
    -- Reference Data Names
    ZC_SEX.NAME                           AS ZC_SEX_NAME,
    ZC_PATIENT_RACE.NAME                  AS ZC_PATIENT_RACE_NAME,
    ZC_ETHNIC_GROUP.NAME                  AS ZC_ETHNIC_GROUP_NAME,
    
    -- Detailed Location Fields
    PATIENT.ADD_LINE_1,
    PATIENT.ADD_LINE_2,
    PATIENT.CITY,
    ZC_STATE.ABBR,
    PATIENT.ZIP,
    ZC_COUNTY.COUNTY_C

FROM CARE_BRONZE_CLARITY_PROD.DBO.PATIENT AS PATIENT

    -- Join for Primary Race Information
    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.PATIENT_RACE AS FIRST_PATIENT_RACE
        ON PATIENT.PAT_ID = FIRST_PATIENT_RACE.PAT_ID 
        AND FIRST_PATIENT_RACE.LINE = 1

    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.ZC_PATIENT_RACE AS ZC_PATIENT_RACE
        ON FIRST_PATIENT_RACE.PATIENT_RACE_C = ZC_PATIENT_RACE.PATIENT_RACE_C

    -- Join for Ethnic Group Information
    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.ZC_ETHNIC_GROUP AS ZC_ETHNIC_GROUP
        ON ZC_ETHNIC_GROUP.ETHNIC_GROUP_C = PATIENT.ETHNIC_GROUP_C

    -- Join for Sex Information
    INNER JOIN CARE_BRONZE_CLARITY_PROD.DBO.ZC_SEX AS ZC_SEX
        ON ZC_SEX.RCPT_MEM_SEX_C = PATIENT.SEX_C

    -- Join for State Information
    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.ZC_STATE AS ZC_STATE
        ON PATIENT.STATE_C = ZC_STATE.STATE_C

    -- Join for County Information
    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.ZC_COUNTY AS ZC_COUNTY
        ON PATIENT.COUNTY_C = ZC_COUNTY.COUNTY_C

    -- Join for Patient Driver Information
    INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.PATIENT_DRIVER AS PATIENT_DRIVER
        ON PATIENT.PAT_ID = PATIENT_DRIVER.EHR_PATIENT_ID;