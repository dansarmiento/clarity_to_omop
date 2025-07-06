
/******************************************************************************
* Query: T_DIAGNOSIS
* Description: Retrieves unique diagnosis records with corresponding ICD-9 and 
*             ICD-10 codes from CLARITY_EDG and related tables.
* 
* Tables Referenced:
*   - CARE_BRONZE_CLARITY_PROD.DBO.CLARITY_EDG
*   - CARE_BRONZE_CLARITY_PROD.DBO.EDG_CURRENT_ICD10
*   - CARE_BRONZE_CLARITY_PROD.DBO.EDG_CURRENT_ICD9
*
* Columns Retrieved:
*   - DX_ID: Diagnosis ID
*   - DX_NAME: Diagnosis Name
*   - ICD10_CODE: ICD-10 Diagnosis Code
*   - ICD9_CODE: ICD-9 Diagnosis Code
******************************************************************************/

SELECT DISTINCT
    CLARITY_EDG.DX_ID,
    CLARITY_EDG.DX_NAME,
    EDG_CURRENT_ICD10.CODE AS ICD10_CODE,
    EDG_CURRENT_ICD9.CODE AS ICD9_CODE
FROM 
    CARE_BRONZE_CLARITY_PROD.DBO.CLARITY_EDG AS CLARITY_EDG
    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.EDG_CURRENT_ICD10 AS EDG_CURRENT_ICD10
        ON CLARITY_EDG.DX_ID = EDG_CURRENT_ICD10.DX_ID
    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.EDG_CURRENT_ICD9 AS EDG_CURRENT_ICD9
        ON CLARITY_EDG.DX_ID = EDG_CURRENT_ICD9.DX_ID
