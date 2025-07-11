-- PULL_PROCEDURE_OCCURRENCE_HSP_CPT
{#-- {{ config(materialized = 'view', schema = 'OMOP_PULL') }}#}

SELECT
-- ***STAGE ATTRIBUTES***
-- OMOP Standard fields used for the Stage
	PULL_VISIT_OCCURRENCE_HSP.PERSON_ID 					AS PERSON_ID
	,ORDER_PROC.PROC_START_TIME::DATE 							AS PROCEDURE_DATE
	,ORDER_PROC.PROC_START_TIME 								AS PROCEDURE_DATETIME

    ,NULL 														AS PROCEDURE_END_DATE
    ,NULL 														AS PROCEDURE_END_DATETIME
	,ORDER_PROC.QUANTITY 										AS QUANTITY
	,ORDER_PROC.AUTHRZING_PROV_ID 								AS PROVIDER_SOURCE_VALUE
	,ORDER_PROC.PROC_ID||':'||T_CPT_CODES.PROC_NAME 			AS PROCEDURE_SOURCE_VALUE
	,ORDER_PROC.MODIFIER1_ID||':'||CLARITY_MOD.MODIFIER_NAME 	AS MODIFIER_SOURCE_VALUE

-- ***ADDITIONAL ATTRIBUTES***
-- Non_OMOP fields used for the Stage
	,PULL_VISIT_OCCURRENCE_HSP.PULL_CSN_ID 						AS PULL_CSN_ID
	,ORDER_PROC.MODIFIER1_ID::VARCHAR							AS PULL_MODIFIER1_ID
	,ORDER_PROC.PROC_ID::VARCHAR								AS PULL_PROC_ID
	,T_CPT_CODES.PROC_CODE										AS PULL_PROC_CODE

-- ***SOURCE ATTRIBUTES***
-- field names pulled from the source for verification purposes.
	-- PULL_VISIT_OCCURRENCE_HSP.PERSON_ID
	-- ,PULL_VISIT_OCCURRENCE_HSP.PAT_ENC_CSN_ID
	-- ,PULL_VISIT_OCCURRENCE_HSP.HSP_ACCOUNT_ID
	-- ,PULL_VISIT_OCCURRENCE_HSP.PAT_ID
	-- ,ORDER_PROC.INSTANTIATED_TIME AS OP_INSTANTIATED_TIME
	-- ,ORDER_PROC.ORDER_TIME AS OP_ORDER_TIME
	-- ,ORDER_PROC.PROC_START_TIME AS OP_PROC_START_TIME
	-- ,ORDER_PROC.PROC_BGN_TIME AS OP_PROC_BGN_TIME
	-- ,ORDER_PROC.PROC_END_TIME AS OP_PROC_END_TIME
	-- ,ORDER_PROC.MODIFIER1_ID
	-- ,MODIFIER_NAME
	-- ,ORDER_PROC.QUANTITY
	-- ,ORDER_PROC.AUTHRZING_PROV_ID
	-- ,ORDER_PROC.FUTURE_OR_STAND
	-- ,ORDER_PROC.PROC_ID
	-- ,ORDER_DX_PROC.LINE AS ORDER_DX_LINE
	-- ,ORDER_DX_PROC.DX_ID AS ORDER_DX_ID
	-- ,T_CPT_CODES.PROC_CODE
	-- ,T_CPT_CODES.PROC_NAME
	-- ,ORDER_PROC.ORDER_STATUS_C
	-- ,ZC_ORDER_STATUS_NAME AS ZC_ORDER_STATUS_NAME
	-- , ORDER_PROC.ORDER_PROC_ID
	-- , ORDER_PROC.ORDER_TYPE_C
	-- , ZC_ORDER_TYPE_NAME AS ZC_ORDER_TYPE_NAME
	-- ,ORDER_PROC.ORDER_CLASS_C
	-- ,ZC_ORDER_CLASS_NAME AS ZC_ORDER_CLASS_NAME
	-- ,ORDER_PROC.LAB_STATUS_C
	-- ,ZC_LAB_STATUS_NAME AS ZC_LAB_STATUS_NAME

FROM {{ref('PULL_VISIT_OCCURRENCE_HSP')}} AS PULL_VISIT_OCCURRENCE_HSP

    INNER JOIN {{ ref('ORDER_PROC_stg')}} AS ORDER_PROC
        ON  PULL_VISIT_OCCURRENCE_HSP.PULL_CSN_ID = ORDER_PROC.PAT_ENC_CSN_ID

    LEFT JOIN {{ ref('ORDER_DX_PROC_stg')}} AS ORDER_DX_PROC
        ON ORDER_PROC.ORDER_PROC_ID = ORDER_DX_PROC.ORDER_PROC_ID

    INNER JOIN {{ref('T_CPT_CODES')}} AS T_CPT_CODES
        ON ORDER_PROC.PROC_ID = T_CPT_CODES.PROC_ID

    LEFT JOIN {{ ref('ZC_ORDER_STATUS_stg')}} AS ZC_ORDER_STATUS
        ON ORDER_PROC.ORDER_STATUS_C = ZC_ORDER_STATUS.ORDER_STATUS_C

    LEFT JOIN {{ ref('ZC_LAB_STATUS_stg')}} AS ZC_LAB_STATUS
        ON ORDER_PROC.LAB_STATUS_C = ZC_LAB_STATUS.LAB_STATUS_C

    LEFT JOIN {{ ref('ZC_ORDER_CLASS_stg')}} AS 	ZC_ORDER_CLASS
        ON ORDER_PROC.ORDER_CLASS_C = ZC_ORDER_CLASS.ORDER_CLASS_C

    LEFT JOIN {{ ref('ZC_ORDER_TYPE_stg')}} AS 	ZC_ORDER_TYPE
        ON ORDER_PROC.ORDER_TYPE_C = ZC_ORDER_TYPE.ORDER_TYPE_C

    LEFT JOIN {{ ref('CLARITY_MOD_stg')}} AS CLARITY_MOD
        ON ORDER_PROC.MODIFIER1_ID = CLARITY_MOD.MODIFIER_ID

WHERE (	ORDER_PROC.ORDER_STATUS_C = 5) --COMPLETED
	AND ORDER_PROC.LAB_STATUS_C = 3 --FINAL
	AND ORDER_PROC.PROC_START_TIME IS NOT NULL
