

/*******************************************************************************
* Description: This query retrieves unique diagnosis codes and their descriptions,
*              including both ICD-10 and ICD-9 codes when available.
*
* Tables:
*   - CLARITY_EDG: Contains diagnosis information
*   - EDG_CURRENT_ICD10: Contains ICD-10 codes
*   - EDG_CURRENT_ICD9: Contains ICD-9 codes
*
* Columns Retrieved:
*   - DX_ID: Diagnosis identifier
*   - DX_NAME: Diagnosis description
*   - ICD10_CODE: ICD-10 diagnosis code
*   - ICD9_CODE: ICD-9 diagnosis code
*******************************************************************************/

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
        ON CLARITY_EDG.DX_ID = EDG_CURRENT_ICD9.DX_ID;
