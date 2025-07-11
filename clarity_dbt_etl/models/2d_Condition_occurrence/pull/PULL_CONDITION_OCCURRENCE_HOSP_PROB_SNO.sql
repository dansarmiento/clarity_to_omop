--PULL_CONDITION_OCCURRENCE_HOSP_PROB_SNO
{#-- {{ config(materialized = 'view', schema = 'OMOP_PULL') }}#}

WITH T_PROB_START_END AS (
    -- ORIGINAL Columbia code.  We do not have PROBLEM_LIST_HX
	-- the same problem could be linked to multiple PAT_ENC_CSN_ID, therefore one problem could yield multiple condition_occurrence records
	-- sometimes RESOLVED_DATE is not available in PROBLEM_LIST but stored in PROBLEM_LIST_HX
--	SELECT DISTINCT
--		PL.PROBLEM_LIST_ID,
--		COALESCE(PL_HX.HX_PROBLEM_EPT_CSN, PL.PROBLEM_EPT_CSN) AS PAT_ENC_CSN_ID,
--		MIN(COALESCE(PL.NOTED_DATE, PL_HX.HX_DATE_NOTED)) OVER (PARTITION BY PL.PROBLEM_LIST_ID) AS CONDITION_START_DATETIME,
--		MAX(COALESCE(PL.RESOLVED_DATE, PL_HX.HX_DATE_RESOLVED)) OVER (PARTITION BY PL.PROBLEM_LIST_ID) AS CONDITION_END_DATETIME --Sometimes RESOLVED_DATE is not available, we need to use HX_DATE_RESOLVED in PROBLEM_LIST_HX,
--	FROM Clarity..PROBLEM_LIST (NOLOCK) PL
--	LEFT JOIN Clarity..PROBLEM_LIST_HX (NOLOCK) PL_HX
--		ON PL.PROBLEM_LIST_ID = PL_HX.PROBLEM_LIST_ID
--	WHERE PL_HX.HX_STATUS_C <> 3 AND PL.NOTED_DATE > '2015-01-01'

-- Without PROBLEM_LIST_HX, the following may not be accurate
	SELECT DISTINCT
		 PROBLEM_LIST.PROBLEM_LIST_ID
		,PROBLEM_LIST.PROBLEM_EPT_CSN AS PAT_ENC_CSN_ID
		,MIN(COALESCE(PROBLEM_LIST.NOTED_DATE, PROBLEM_LIST_HX.HX_DATE_NOTED))
            OVER (PARTITION BY PROBLEM_LIST.PROBLEM_LIST_ID) AS CONDITION_START_DATETIME
		,MAX(COALESCE(PROBLEM_LIST.RESOLVED_DATE, PROBLEM_LIST_HX.HX_DATE_RESOLVED))
            OVER (PARTITION BY PROBLEM_LIST.PROBLEM_LIST_ID) AS CONDITION_END_DATETIME
	FROM {{ ref('PROBLEM_LIST_stg')}} AS PROBLEM_LIST
    	LEFT JOIN {{ ref('PROBLEM_LIST_HX_stg')}} AS PROBLEM_LIST_HX
    		ON PROBLEM_LIST.PROBLEM_LIST_ID = PROBLEM_LIST_HX.PROBLEM_LIST_ID
    	WHERE PROBLEM_LIST_HX.HX_STATUS_C <> 3
)

SELECT DISTINCT
-- ***STAGE ATTRIBUTES***
-- fields used for the Stage
    PULL_VISIT_OCCURRENCE_HSP.PERSON_ID                         AS PERSON_ID
	,PULL_VISIT_OCCURRENCE_HSP.VISIT_START_DATE 		        AS CONDITION_START_DATE
	,PULL_VISIT_OCCURRENCE_HSP.VISIT_START_DATETIME 			AS CONDITION_START_DATETIME
	,PULL_VISIT_OCCURRENCE_HSP.VISIT_END_DATE  		            AS CONDITION_END_DATE
	,PULL_VISIT_OCCURRENCE_HSP.VISIT_END_DATETIME 				AS CONDITION_END_DATETIME
	,CASE WHEN PULL_DISCHARGE_SOURCE_CODE = 20
		    THEN 'EXPIRED'
		ELSE 'DISCHARGED'
		END 												    AS STOP_REASON
    ,CASE WHEN PROBLEM_LIST.PRINCIPAL_PL_YN = 'Y' OR PROBLEM_LIST.PRINCIPAL_PL_YN IS NULL
            THEN 'PRIMARY_PROB'
        ELSE 'SECONDARY_PROB'
        END						                                AS CONDITION_STATUS_SOURCE_VALUE
    ,PULL_PROVIDER_SOURCE_VALUE                                 AS PROVIDER_SOURCE_VALUE

-- ***ADDITIONAL ATTRIBUTES***
-- Non-OMOP fields used for the Stage
    ,PULL_VISIT_OCCURRENCE_HSP.PULL_CSN_ID                       AS PULL_CSN_ID
    ,PULL_VISIT_OCCURRENCE_HSP.VISIT_START_DATE                  AS PULL_VISIT_DATE
    ,T_SNO_CODE.DX_ID                                            AS PULL_DX_ID
    ,T_SNO_CODE.DX_NAME                                          AS PULL_DX_NAME
    ,T_SNO_CODE.CURRENT_ICD9_LIST                                AS PULL_CURRENT_ICD9_LIST
    ,T_SNO_CODE.CURRENT_ICD10_LIST                               AS PULL_CURRENT_ICD10_LIST
    ,T_SNO_CODE.SNOMED_CODE                                      AS PULL_SNOMED_CODE

FROM  {{ ref('PROBLEM_LIST_stg')}} AS PROBLEM_LIST

    INNER JOIN   {{ ref('PULL_VISIT_OCCURRENCE_HSP')}} AS PULL_VISIT_OCCURRENCE_HSP
        ON PROBLEM_LIST.PROBLEM_EPT_CSN = PULL_VISIT_OCCURRENCE_HSP.PULL_CSN_ID

    INNER JOIN T_PROB_START_END  ON (T_PROB_START_END.PROBLEM_LIST_ID = PROBLEM_LIST.PROBLEM_LIST_ID)

    LEFT JOIN   {{ ref('HSP_ATND_PROV_stg')}} AS HSP_ATND_PROV
        ON PULL_VISIT_OCCURRENCE_HSP.PULL_CSN_ID = HSP_ATND_PROV.PAT_ENC_CSN_ID
            AND VISIT_START_DATETIME BETWEEN ATTEND_FROM_DATE
                AND COALESCE(ATTEND_TO_DATE, GETDATE())

    LEFT JOIN  {{ref('T_SNO_CODE')}} AS T_SNO_CODE
        ON PROBLEM_LIST.DX_ID = T_SNO_CODE.DX_ID

