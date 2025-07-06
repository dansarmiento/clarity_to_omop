
--PULL_CONDITION_OCCURRENCE_AMB_TDL_SNO
{#-- {{ config(materialized = 'view', schema = 'OMOP_PULL') }}#}

SELECT DISTINCT
-- ***STAGE ATTRIBUTES***
-- fields used for the Stage
    PULL_VISIT_OCCURRENCE_AMB.PERSON_ID                             AS PERSON_ID
    ,T_TDL_DX.START_DATE :: DATE                                    AS CONDITION_START_DATE
    ,T_TDL_DX.START_DATE                                            AS CONDITION_START_DATETIME
    ,T_TDL_DX.END_DATE :: DATE 	                                    AS CONDITION_END_DATE
	,T_TDL_DX.END_DATE 					                            AS CONDITION_END_DATETIME
    ,CASE WHEN T_TDL_DX.P_DX = 'Y' THEN 'PRIMARY_DX'
		ELSE 'SECONDARY_DX'
		END 											            AS CONDITION_STATUS_SOURCE_VALUE
    ,PULL_VISIT_OCCURRENCE_AMB.PULL_PROVIDER_SOURCE_VALUE           AS PROVIDER_SOURCE_VALUE

-- ***ADDITIONAL ATTRIBUTES***
-- Non-OMOP fields used for the Stage
    ,PULL_VISIT_OCCURRENCE_AMB.PULL_CSN_ID                          AS PULL_CSN_ID
    ,PULL_VISIT_OCCURRENCE_AMB.VISIT_START_DATE                     AS PULL_VISIT_DATE
    ,T_SNO_CODE.DX_ID                                               AS PULL_DX_ID
    ,T_SNO_CODE.DX_NAME                                             AS PULL_DX_NAME
    ,T_SNO_CODE.CURRENT_ICD9_LIST                                   AS PULL_CURRENT_ICD9_LIST
    ,T_SNO_CODE.CURRENT_ICD10_LIST                                  AS PULL_CURRENT_ICD10_LIST
    ,T_SNO_CODE.SNOMED_CODE                                         AS PULL_SNOMED_CODE


FROM  {{ ref('T_TDL_DX')}} AS T_TDL_DX

INNER JOIN  {{ref('PULL_VISIT_OCCURRENCE_AMB')}} AS PULL_VISIT_OCCURRENCE_AMB
    ON T_TDL_DX.PAT_ENC_CSN_ID = PULL_VISIT_OCCURRENCE_AMB.PULL_CSN_ID

INNER JOIN  {{ref('T_SNO_CODE')}} AS T_SNO_CODE
    ON T_TDL_DX.DX_ID = T_SNO_CODE.DX_ID

WHERE PULL_VISIT_OCCURRENCE_AMB.PULL_ENC_TYPE_C <> 3 --Hospital Encounter
