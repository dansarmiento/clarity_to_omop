/***************************************************************
* Query Purpose: Retrieves distinct procedure IDs, codes, and names
* from CLARITY_EAP table, combining data from linked performable 
* and chargeable procedures
*
* Tables Used:
*   - CARE_BRONZE_CLARITY_PROD.DBO.CLARITY_EAP
*   - CARE_BRONZE_CLARITY_PROD.DBO.LINKED_PERFORMABLE
*   - CARE_BRONZE_CLARITY_PROD.DBO.LINKED_CHARGEABLES
*
* Returns:
*   - PROC_ID: Unique identifier for the procedure
*   - PROC_CODE: Code of the procedure (from linked procedure if available)
*   - PROC_NAME: Name of the procedure (from linked procedure if available)
****************************************************************/

-- First query: Get procedures and their linked performable procedures
SELECT DISTINCT 
    EAP.PROC_ID,
    CASE
        WHEN EAP2.PROC_CODE IS NULL THEN EAP.PROC_CODE
        ELSE EAP2.PROC_CODE
    END AS PROC_CODE,
    CASE
        WHEN EAP2.PROC_NAME IS NULL THEN EAP.PROC_NAME
        ELSE EAP2.PROC_NAME
    END AS PROC_NAME
FROM 
    CARE_BRONZE_CLARITY_PROD.DBO.CLARITY_EAP AS EAP
    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.LINKED_PERFORMABLE AS LINKED_PERFORMABLE
        ON EAP.PROC_ID = LINKED_PERFORMABLE.PROC_ID
    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.CLARITY_EAP AS EAP2
        ON LINKED_PERFORMABLE.LINKED_PERFORM_ID = EAP2.PROC_ID

UNION

-- Second query: Get procedures and their linked chargeable procedures
SELECT DISTINCT 
    EAP.PROC_ID AS PROC_ID,
    CASE
        WHEN EAP2.PROC_CODE IS NULL THEN EAP.PROC_CODE
        ELSE EAP2.PROC_CODE
    END AS PROC_CODE,
    CASE
        WHEN EAP2.PROC_NAME IS NULL THEN EAP.PROC_NAME
        ELSE EAP2.PROC_NAME
    END AS PROC_NAME
FROM 
    CARE_BRONZE_CLARITY_PROD.DBO.CLARITY_EAP AS EAP
    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.LINKED_CHARGEABLES AS LINKED_CHARGEABLES
        ON EAP.PROC_ID = LINKED_CHARGEABLES.PROC_ID
    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.CLARITY_EAP AS EAP2
        ON LINKED_CHARGEABLES.LINKED_CHRG_ID = EAP2.PROC_ID;