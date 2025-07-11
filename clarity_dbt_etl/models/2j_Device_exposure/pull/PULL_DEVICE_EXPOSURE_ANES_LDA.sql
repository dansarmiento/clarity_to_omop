--PULL_DEVICE_EXPOSURE_ANES_LDA
--   {{ config(materialized = 'view', schema = 'OMOP_PULL') }}


SELECT
-- ***STAGE ATTRIBUTES***
-- OMOP Standard fields used for the Stage
	PATIENT_DRIVER.PERSON_ID							AS PERSON_ID
	,IP_LDA_NOADDSINGLE.PLACEMENT_INSTANT :: DATE		AS DEVICE_EXPOSURE_START_DATE
	,IP_LDA_NOADDSINGLE.PLACEMENT_INSTANT 				AS DEVICE_EXPOSURE_START_DATETIME
	,IP_LDA_NOADDSINGLE.REMOVAL_INSTANT::DATE 			AS DEVICE_EXPOSURE_END_DATE
	,IP_LDA_NOADDSINGLE.REMOVAL_INSTANT					AS DEVICE_EXPOSURE_END_DATETIME
	,NULL												AS UNIQUE_DEVICE_ID
	,NULL 												AS PRODUCTION_ID --NEW 5.4
	,NULL 												AS QUANTITY
	,BILL_ATTEND_PROV_ID 								AS PROVIDER_SOURCE_VALUE
--    ,VISIT_DETAIL.VISIT_DETAIL_ID AS VISIT_DETAIL_ID
    ,0 													AS VISIT_DETAIL_ID
	,IP_LDA_NOADDSINGLE.FLO_MEAS_ID :: VARCHAR
		||':'|| IP_FLO_GP_DATA.FLO_MEAS_NAME			AS DEVICE_SOURCE_VALUE
  	,NULL 												AS UNIT_SOURCE_VALUE --NEW 5.4

-- ***ADDITIONAL ATTRIBUTES***
-- Non_OMOP fields used for the Stage
	,PAT_ENC.PAT_ENC_CSN_ID								AS PULL_CSN_ID
	,IP_LDA_NOADDSINGLE.FLO_MEAS_ID	::VARCHAR			AS PULL_FLO_MEAS_ID
	,IP_FLO_GP_DATA.FLO_MEAS_NAME						AS PULL_FLO_MEAS_NAME

-- ***SOURCE ATTRIBUTES***	
	-- PATIENT_DRIVER.PERSON_ID
	-- ,PATIENT_DRIVER.EHR_PATIENT_ID
	-- ,IP_LDA_NOADDSINGLE.IP_LDA_ID
	-- ,IP_LDA_NOADDSINGLE.PAT_ENC_CSN_ID AS LDS_ENC
	-- ,F_AN_RECORD_SUMMARY.AN_52_ENC_CSN_ID ANES_ENC
	-- ,PAT_ENC_HSP.PAT_ENC_CSN_ID
	-- ,IP_LDA_NOADDSINGLE.FLO_MEAS_ID
	-- ,IP_FLO_GP_DATA.FLO_MEAS_NAME
	-- ,IP_FLO_GP_DATA.DISP_NAME AS FLO_MEAS_DISP_NAME
	-- ,IP_LDA_NOADDSINGLE.PLACEMENT_INSTANT
	-- ,IP_LDA_NOADDSINGLE.REMOVAL_INSTANT
	-- ,IP_LDA_NOADDSINGLE.DESCRIPTION
	-- ,IP_LDA_NOADDSINGLE.PROPERTIES_DISPLAY
	-- ,IP_LDA_NOADDSINGLE.SITE
	-- ,PAT_ENC_HSP.BILL_ATTEND_PROV_ID

FROM {{ ref('PAT_ENC_stg')}} AS PAT_ENC

-- ASSOCIATES ANETHESIA EVENT TO HOSPITAL ENCOUNTER
    INNER JOIN {{ ref('F_AN_RECORD_SUMMARY_stg')}} AS F_AN_RECORD_SUMMARY
        ON PAT_ENC.PAT_ENC_CSN_ID = F_AN_RECORD_SUMMARY.AN_52_ENC_CSN_ID

    INNER JOIN {{ ref('AN_HSB_LINK_INFO_stg')}} AS AN_HSB_LINK_INFO
        ON F_AN_RECORD_SUMMARY.AN_EPISODE_ID=AN_HSB_LINK_INFO.SUMMARY_BLOCK_ID

    INNER JOIN {{ ref('PAT_ENC_HSP_stg')}} AS PAT_ENC_HSP
        ON AN_HSB_LINK_INFO.AN_BILLING_CSN_ID=PAT_ENC_HSP.PAT_ENC_CSN_ID

    -- LDA data
    INNER JOIN {{ ref('IP_LDA_NOADDSINGLE_stg')}} AS IP_LDA_NOADDSINGLE
        ON PAT_ENC.PAT_ENC_CSN_ID = IP_LDA_NOADDSINGLE.PAT_ENC_CSN_ID

    INNER JOIN {{ ref('IP_FLO_GP_DATA_stg')}} AS IP_FLO_GP_DATA
        ON IP_LDA_NOADDSINGLE.FLO_MEAS_ID = IP_FLO_GP_DATA.FLO_MEAS_ID

    INNER JOIN {{ref('PATIENT_DRIVER')}} AS PATIENT_DRIVER
        ON PATIENT_DRIVER.EHR_PATIENT_ID = PAT_ENC.PAT_ID
		
WHERE PLACEMENT_INSTANT IS NOT NULL