--PULL_DEATH_ALL
{#-- {{ config(materialized = 'view', schema = 'OMOP_PULL') }}#}

SELECT DISTINCT
-- ***STAGE ATTRIBUTES***
-- fields used for the Stage
    PATIENT_DRIVER.PERSON_ID                    AS PERSON_ID
      ,PATIENT.DEATH_DATE::DATE                 AS DEATH_DATE
      ,PATIENT.DEATH_DATE                       AS DEATH_DATETIME
    --   ,T_DEATH_DIAGNOSIS.DX_ID                  AS CAUSE_SOURCE_VALUE

-- ***PULL attributes***
-- field names pulled from the source for verification purposes. May be duplicated above.
-- Death Cause creates duplicates in OMOP 5.4
    --   ,T_DEATH_DIAGNOSIS.DX_ID                  AS CAUSE_DX_ID
    --   ,T_DEATH_DIAGNOSIS.DX_NAME                AS CAUSE_DX_NAME
    --   ,T_DEATH_DIAGNOSIS.SNOMED_CODE            AS CAUSE_SNOMED_CODE
    --   ,T_DEATH_DIAGNOSIS.FULLY_SPECIFIED_NM     AS CAUSE_FULLY_SPECIFIED_NM
    , PATIENT_DRIVER.EHR_PATIENT_ID             AS PULL_PAT_ID
    , PATIENT_DRIVER.MRN_CPI                    AS PULL_MRN_CPI

FROM   {{ref('PATIENT_DRIVER')}} AS PATIENT_DRIVER

    INNER JOIN {{ ref('PATIENT_stg')}} AS PATIENT
        ON PATIENT_DRIVER.EHR_PATIENT_ID = PATIENT.PAT_ID
            AND PATIENT.PAT_STATUS_C = 2

-- Death Cause creates duplicates in OMOP 5.4
    -- LEFT JOIN {{ref('T_DEATH_DIAGNOSIS')}} AS T_DEATH_DIAGNOSIS
    --     ON PATIENT_DRIVER.EHR_PATIENT_ID = T_DEATH_DIAGNOSIS.PAT_ID
