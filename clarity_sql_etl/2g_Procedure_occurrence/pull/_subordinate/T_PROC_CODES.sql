/*******************************************************************************
* Query Description: Retrieves distinct procedure information from CLARITY_EAP
* 
* Tables Used:
*   CARE_BRONZE_CLARITY_PROD.DBO.CLARITY_EAP - Contains procedure information
*
* Columns Retrieved:
*   PROC_ID   - Unique identifier for the procedure
*   PROC_CODE - Procedure code
*   PROC_NAME - Name/description of the procedure
*
* Date: [Current Date]
* Author: [Author Name]
*******************************************************************************/

SELECT DISTINCT 
    EAP.PROC_ID,
    EAP.PROC_CODE,
    EAP.PROC_NAME
FROM 
    CARE_BRONZE_CLARITY_PROD.DBO.CLARITY_EAP AS EAP;