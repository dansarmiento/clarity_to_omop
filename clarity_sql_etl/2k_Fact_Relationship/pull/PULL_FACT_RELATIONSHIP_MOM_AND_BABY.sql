/*******************************************************************************
* Script Name: PULL_FACT_RELATIONSHIP_MOM_AND_BABY
* Description: This query retrieves the relationship between mothers and their
*              babies by linking their respective Person IDs and EHR Patient IDs
* 
* Tables Used: 
*    - CARE_BRONZE_CLARITY_PROD.DBO.V_OB_DEL_RECORDS
*    - CARE_RES_OMOP_DEV2_WKSP.OMOP.PATIENT_DRIVER
*
* Output Columns:
*    - PULL_BABY_PERSON_ID    - Person ID of the baby
*    - PULL_BABY_ID           - EHR Patient ID of the baby
*    - PULL_MOM_PERSON_ID     - Person ID of the mother
*    - PULL_MOM_ID            - EHR Patient ID of the mother
*******************************************************************************/

SELECT DISTINCT
    BABY.PERSON_ID          AS PULL_BABY_PERSON_ID,
    BABY.EHR_PATIENT_ID     AS PULL_BABY_ID,
    MOM.PERSON_ID           AS PULL_MOM_PERSON_ID,
    MOM.EHR_PATIENT_ID      AS PULL_MOM_ID
FROM 
    CARE_BRONZE_CLARITY_PROD.DBO.V_OB_DEL_RECORDS V_OB_DEL_RECORDS
    JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.PATIENT_DRIVER AS BABY 
        ON BABY.EHR_PATIENT_ID = V_OB_DEL_RECORDS.BABYID
    JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.PATIENT_DRIVER AS MOM 
        ON MOM.EHR_PATIENT_ID = V_OB_DEL_RECORDS.MOMID;