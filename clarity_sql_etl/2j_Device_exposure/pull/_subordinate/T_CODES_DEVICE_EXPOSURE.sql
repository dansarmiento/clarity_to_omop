/***************************************************************
* Query Purpose: Retrieves blood administration information joined
* with order procedures and procedure names.
*
* Tables Used:
* - BLOOD_ADMIN_INFO: Contains blood administration details
* - ORDER_PROC: Contains order procedure information
* - CLARITY_EAP: Contains procedure names and details
*
* Date: [Current Date]
* Author: [Author Name]
***************************************************************/

SELECT 
    BLOOD_ADMIN_INFO.ORDER_ID,
    BLOOD_ADMIN_INFO.BLOOD_ADMIN_UNIT,
    BLOOD_ADMIN_INFO.BLOOD_ADMIN_PROD,
    BLOOD_ADMIN_INFO.BLOOD_ADMIN_TYPE,
    ORDER_PROC.PROC_ID,
    -- ORDER_PROC.PROC_CODE,    -- Commented out, retain if needed
    ORDER_PROC.ORDERING_DATE,
    CLARITY_EAP.PROC_NAME
FROM 
    CARE_BRONZE_CLARITY_PROD.DBO.BLOOD_ADMIN_INFO AS BLOOD_ADMIN_INFO
    INNER JOIN CARE_BRONZE_CLARITY_PROD.DBO.ORDER_PROC AS ORDER_PROC
        ON BLOOD_ADMIN_INFO.ORDER_ID = ORDER_PROC.ORDER_PROC_ID
    INNER JOIN CARE_BRONZE_CLARITY_PROD.DBO.CLARITY_EAP AS CLARITY_EAP
        ON ORDER_PROC.PROC_ID = CLARITY_EAP.PROC_ID
WHERE 
    (BLOOD_ADMIN_INFO.LINE = 1);