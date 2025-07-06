WITH
 T_PROC_CODES
AS (
            SELECT
                  DISTINCT EAP.PROC_ID
                  , CASE
                              WHEN EAP2.PROC_CODE IS NULL THEN
                              EAP.PROC_CODE
                        ELSE
                              EAP2.PROC_CODE
                  END AS PROC_CODE
                  , CASE
                              WHEN EAP2.PROC_NAME IS NULL THEN
                              EAP.PROC_NAME
                        ELSE
                              EAP2.PROC_NAME
                  END AS PROC_NAME
            FROM
                  SH_LAND_EPIC_CLARITY_PROD.DBO.CLARITY_EAP AS EAP
            LEFT JOIN SH_LAND_EPIC_CLARITY_PROD.DBO.LINKED_PERFORMABLE
                        ON
                  EAP.PROC_ID = LINKED_PERFORMABLE.PROC_ID
            LEFT JOIN SH_LAND_EPIC_CLARITY_PROD.DBO.CLARITY_EAP AS EAP2
                        ON
                  LINKED_PERFORMABLE.LINKED_PERFORM_ID = EAP2.PROC_ID
                  --WHERE EAP.PROC_ID = 10233807
            UNION
            SELECT
                  DISTINCT EAP.PROC_ID AS PROC_ID
                  , CASE
                              WHEN EAP2.PROC_CODE IS NULL THEN
                              EAP.PROC_CODE
                        ELSE
                              EAP2.PROC_CODE
                  END AS PROC_CODE
                  , CASE
                              WHEN EAP2.PROC_NAME IS NULL THEN
                              EAP.PROC_NAME
                        ELSE
                              EAP2.PROC_NAME
                  END AS PROC_NAME
            FROM
                  SH_LAND_EPIC_CLARITY_PROD.DBO.CLARITY_EAP AS EAP
            LEFT JOIN SH_LAND_EPIC_CLARITY_PROD.DBO.LINKED_CHARGEABLES
                        ON
                  EAP.PROC_ID = LINKED_CHARGEABLES.PROC_ID
            LEFT JOIN SH_LAND_EPIC_CLARITY_PROD.DBO.CLARITY_EAP AS EAP2
                        ON
                  LINKED_CHARGEABLES.LINKED_CHRG_ID = EAP2.PROC_ID
                  )
SELECT
      DISTINCT COUNT(ORDER_PROC.ORDER_PROC_ID) AS SOURCE_FREQUENCY
      , T_PROC_CODES.PROC_ID AS SOURCE_CODE
      , T_PROC_CODES.PROC_CODE AS SOURCE_CODE_DETAIL
      , T_PROC_CODES.PROC_NAME AS SOURCE_NAME
FROM
      SH_LAND_EPIC_CLARITY_PROD.DBO.PAT_ENC AS PAT_ENC_AMB
LEFT JOIN SH_LAND_EPIC_CLARITY_PROD.DBO.ORDER_PROC
            ON
      PAT_ENC_AMB.PAT_ENC_CSN_ID = ORDER_PROC.PAT_ENC_CSN_ID
LEFT JOIN T_PROC_CODES 
            ON
      ORDER_PROC.PROC_ID = T_PROC_CODES.PROC_ID
WHERE
      T_PROC_CODES.PROC_CODE LIKE '%ANE%'
GROUP BY
      T_PROC_CODES.PROC_ID
      , T_PROC_CODES.PROC_CODE
      , T_PROC_CODES.PROC_NAME 
ORDER BY SOURCE_FREQUENCY DESC
/*WITH
 T_PROC_CODES
AS (
	SELECT DISTINCT eap.proc_id
		,case
			when eap2.PROC_CODE is null then
			eap.PROC_CODE
			else
			eap2.PROC_CODE 
		end AS PROC_CODE
		,case
			when eap2.PROC_NAME is null then
			eap.PROC_NAME
			else
			eap2.PROC_NAME 
		end AS PROC_NAME
	FROM EpicClarity.dbo.CLARITY_EAP AS eap
	LEFT JOIN EpicClarity.dbo.LINKED_PERFORMABLE
		ON eap.PROC_ID = LINKED_PERFORMABLE.PROC_ID
	LEFT JOIN EpicClarity.dbo.CLARITY_EAP AS eap2
		ON LINKED_PERFORMABLE.LINKED_PERFORM_ID = eap2.PROC_ID
	--where eap.proc_id = 10233807
	UNION
	--select * from EpicClarity.dbo.LINKED_PERFORMABLE
	SELECT DISTINCT eap.proc_id as PROC_ID
		,case
			when eap2.PROC_CODE is null then
			eap.PROC_CODE
			else
			eap2.PROC_CODE 
		end AS PROC_CODE
		,case
			when eap2.PROC_NAME is null then
			eap.PROC_NAME
			else
			eap2.PROC_NAME 
		end AS PROC_NAME
	
	FROM EpicClarity.dbo.CLARITY_EAP AS eap
	LEFT JOIN EpicClarity.dbo.LINKED_CHARGEABLES
		ON eap.PROC_ID = LINKED_CHARGEABLES.PROC_ID
	
	LEFT JOIN EpicClarity.dbo.CLARITY_EAP AS eap2
		ON LINKED_CHARGEABLES.LINKED_CHRG_ID = eap2.PROC_ID
	)
	SELECT DISTINCT count(order_proc.ORDER_PROC_ID) AS proc_count
	,T_PROC_CODES.proc_id
	,T_PROC_CODES.PROC_CODE
	,T_PROC_CODES.PROC_NAME
FROM [EpicClarity].[dbo].pat_enc AS PAT_ENC_AMB

	LEFT JOIN [EpicClarity].[dbo].[ORDER_PROC]
		ON PAT_ENC_AMB.[PAT_ENC_CSN_ID] = [ORDER_PROC].[PAT_ENC_CSN_ID]
left join T_PROC_CODES 
		ON ORDER_PROC.PROC_ID = T_PROC_CODES.PROC_ID
WHERE T_PROC_CODES.PROC_CODE LIKE '%ane%'
GROUP BY T_PROC_CODES.proc_id
	,T_PROC_CODES.PROC_CODE
	,T_PROC_CODES.PROC_NAME  */