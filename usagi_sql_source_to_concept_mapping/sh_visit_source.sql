--EpicClarity PO2

--SELECT
--    ZC_PAT_CLASS.ADT_PAT_CLASS_C AS [code],
--    ZC_PAT_CLASS.NAME AS [English],
--    COUNT(PAT_ENC_HSP.PAT_ID) AS [count]
--FROM
--    PAT_ENC_HSP
--INNER JOIN ZC_PAT_CLASS ON
--    PAT_ENC_HSP.ADT_PAT_CLASS_C = ZC_PAT_CLASS.ADT_PAT_CLASS_C
--GROUP BY
--    ZC_PAT_CLASS.ADT_PAT_CLASS_C,
--    ZC_PAT_CLASS.NAME
--ORDER BY
--    COUNT(PAT_ENC_HSP.PAT_ID) DESC
    
    
-- Snowflake   

WITH TEMP AS (
SELECT    
PAT_ENC_HSP.PAT_ENC_CSN_ID ,
CASE 
            WHEN CLARITY_ADT_A.PAT_LVL_OF_CARE_C = 6
                  THEN 9999 -- ICU
            ELSE
                  TO_NUMERIC(PAT_ENC_HSP.ADT_PAT_CLASS_C) 
            END AS SOURCE_CODE,
      CASE 
            WHEN CLARITY_ADT_A.PAT_LVL_OF_CARE_C = 6
                  THEN 'ICU' -- ICU
                  ELSE     ZC_PAT_CLASS.NAME 
            END AS SOURCE_NAME
 
FROM
    SH_LAND_EPIC_CLARITY_PROD.DBO.PAT_ENC_HSP
    
INNER JOIN SH_LAND_EPIC_CLARITY_PROD.DBO.ZC_PAT_CLASS ON
    PAT_ENC_HSP.ADT_PAT_CLASS_C = ZC_PAT_CLASS.ADT_PAT_CLASS_C
    
left JOIN  SH_LAND_EPIC_CLARITY_PROD.DBO.CLARITY_ADT AS CLARITY_ADT_A
      ON PAT_ENC_HSP.PAT_ENC_CSN_ID = CLARITY_ADT_A.PAT_ENC_CSN_ID
      AND CLARITY_ADT_A.PAT_LVL_OF_CARE_C = 6
      AND CLARITY_ADT_A.EVENT_TYPE_C NOT IN (4, 5, 6)
      AND CLARITY_ADT_A.SEQ_NUM_IN_ENC IS NOT NULL
)
    
SELECT distinct
SOURCE_CODE,
SOURCE_NAME,
COUNT(PAT_ENC_CSN_ID) AS SOURCE_FREQUENCY

FROM
    TEMP
GROUP BY

SOURCE_CODE,
SOURCE_NAME
    
ORDER BY
    COUNT(PAT_ENC_CSN_ID) DESC