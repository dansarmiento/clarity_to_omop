--STAGE_OBSERVATION_AMB_SDOH_FLOWSHEET
{#-- {{ config(materialized = 'view', schema = 'OMOP_STAGE') }}#}
--
SELECT DISTINCT
      PULL_OBSERVATION_AMB_FLOWSHEET.PERSON_ID
      ,COALESCE(
            SOURCE_TO_CONCEPT_MAP_FLOWSHEET_MEAS.TARGET_CONCEPT_ID, 0)  AS OBSERVATION_CONCEPT_ID
      ,OBSERVATION_DATE                                                 AS OBSERVATION_DATE
      ,OBSERVATION_DATETIME                                             AS OBSERVATION_DATETIME
      ,32817                                                            AS OBSERVATION_TYPE_CONCEPT_ID --EHR
      ,VALUE_AS_NUMBER                                                  AS VALUE_AS_NUMBER
      ,LEFT(SOURCE_TO_CONCEPT_MAP_VALUE.SOURCE_CODE_DESCRIPTION,60)     AS VALUE_AS_STRING
      ,COALESCE(SOURCE_TO_CONCEPT_MAP_VALUE.TARGET_CONCEPT_ID, 0)       AS VALUE_AS_CONCEPT_ID
      ,0                                                                AS QUALIFIER_CONCEPT_ID
      ,0                                                                AS UNIT_CONCEPT_ID
	,PROVIDER.PROVIDER_ID 							                    AS PROVIDER_ID
      ,VISIT_OCCURRENCE.VISIT_OCCURRENCE_ID                             AS VISIT_OCCURRENCE_ID

      ,0                                                                AS VISIT_DETAIL_ID

      ,PULL_OBSERVATION_AMB_FLOWSHEET.PULL_FLO_MEAS_ID::VARCHAR
            ||':'|| PULL_OBSERVATION_AMB_FLOWSHEET.PULL_FLO_MEAS_NAME        AS OBSERVATION_SOURCE_VALUE
      ,0                                                                AS OBSERVATION_SOURCE_CONCEPT_ID
      ,NULL                                                             AS UNIT_SOURCE_VALUE
      ,NULL                                                             AS QUALIFIER_SOURCE_VALUE
      -----------------------
      , NULL::NUMBER(28,0)                                              AS OBSERVATION_EVENT_ID
      , 0::NUMBER(28,0)                                                 AS OBS_EVENT_FIELD_CONCEPT_ID
      , NULL::VARCHAR(50)                                               AS VALUE_SOURCE_VALUE
      -------- Non-OMOP Fields ------------
      ,'OBSERVATION_AMB_SDOH_FLOWSHEET'                                 AS ETL_MODULE
      , VISIT_OCCURRENCE.phi_PAT_ID                      				AS STAGE_PAT_ID
      , VISIT_OCCURRENCE.phi_MRN_CPI                           			AS STAGE_MRN_CPI
      , VISIT_OCCURRENCE.phi_CSN_ID							            AS STAGE_CSN_ID
      , PULL_FLO_MEAS_ID							                    AS STAGE_FLO_MEAS_ID

FROM {{ref('PULL_OBSERVATION_AMB_FLOWSHEET')}} AS PULL_OBSERVATION_AMB_FLOWSHEET

	INNER JOIN {{ ref('SOURCE_TO_CONCEPT_MAP_SDOH')}} AS SOURCE_TO_CONCEPT_MAP_FLOWSHEET_MEAS
		ON PULL_OBSERVATION_AMB_FLOWSHEET.PULL_FLO_MEAS_ID = SOURCE_TO_CONCEPT_MAP_FLOWSHEET_MEAS.SOURCE_CODE

      LEFT JOIN {{ ref('SOURCE_TO_CONCEPT_MAP_SDOH_ANSWERS')}} AS SOURCE_TO_CONCEPT_MAP_VALUE
            ON PULL_OBSERVATION_AMB_FLOWSHEET.PULL_MEAS_VALUE ||'_'|| PULL_CAT_INI || '_' || PULL_CAT_ITEM = SOURCE_TO_CONCEPT_MAP_VALUE.SOURCE_CODE

      INNER JOIN {{ref('VISIT_OCCURRENCE_RAW')}} AS VISIT_OCCURRENCE
            ON PULL_OBSERVATION_AMB_FLOWSHEET.PULL_CSN_ID = VISIT_OCCURRENCE.phi_CSN_ID

	LEFT JOIN {{ref('PROVIDER_RAW')}} AS PROVIDER
		ON PULL_OBSERVATION_AMB_FLOWSHEET.PROVIDER_SOURCE_VALUE = PROVIDER.PROVIDER_SOURCE_VALUE

WHERE PULL_MEAS_VALUE is not null
