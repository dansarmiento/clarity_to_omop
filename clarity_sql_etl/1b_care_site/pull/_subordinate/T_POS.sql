
/*******************************************************************************
* Query Name: Combined Point of Service Data
* Description: This query combines Point of Service (POS) data from both PCP 
*              physicians and encounter physicians into a single result set
* Tables Used: 
*   - CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.PCP_PHYSICIAN_POINTOFSERVICE
*   - CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.ENC_PHYSICIAN_POINTOFSERVICE
*******************************************************************************/

-- Create a Common Table Expression (CTE) for combined POS data
--BEGIN cte__T_POS
SELECT *
FROM (
    -- Get PCP physician point of service data
    SELECT *
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.PCP_PHYSICIAN_POINTOFSERVICE
    
    UNION
    
    -- Get encounter physician point of service data
    SELECT *
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.ENC_PHYSICIAN_POINTOFSERVICE
) AS T_POS
--END cte__T_POS