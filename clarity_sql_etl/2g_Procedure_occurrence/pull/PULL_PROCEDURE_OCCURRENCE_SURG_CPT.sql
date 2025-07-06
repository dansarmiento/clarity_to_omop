/*******************************************************************************
* Procedure Name: PULL_PROCEDURE_OCCURRENCE_SURG_CPT
* Description: Retrieves surgical procedure occurrences with CPT codes
* 
* Tables Used:
*   - PULL_VISIT_OCCURRENCE_HSP
*   - PAT_OR_ADM_LINK
*   - OR_LOG
*   - OR_LOG_VIRTUAL
*   - OR_LOG_ALL_PROC
*   - OR_LOG_ALL_SURG
*   - T_CPT_CODES
*   - OR_OPE_PROC_CODE
*   - ZC_OR_STATUS
*******************************************************************************/

SELECT DISTINCT
    -- OMOP Standard Fields
    PULL_VISIT_OCCURRENCE_HSP.PERSON_ID                              AS PERSON_ID,
    COALESCE(
        OR_LOG_VIRTUAL.ACT_START_OTS_DTTM,
        OR_LOG.SCHED_START_TIME)::DATE                              AS PROCEDURE_DATE,
    COALESCE(
        OR_LOG_VIRTUAL.ACT_START_OTS_DTTM,
        OR_LOG.SCHED_START_TIME)                                    AS PROCEDURE_DATETIME,
    NULL                                                            AS PROCEDURE_END_DATE,
    NULL                                                            AS PROCEDURE_END_DATETIME,
    1                                                               AS QUANTITY,
    COALESCE(OR_LOG_ALL_SURG.SURG_ID, OR_LOG.PRIMARY_PHYS_ID)     AS PROVIDER_SOURCE_VALUE,
    OR_LOG_ALL_PROC.ALL_PROC_CODE_ID || ':' || 
        T_CPT_CODES.PROC_CODE                                       AS PROCEDURE_SOURCE_VALUE,
    NULL                                                            AS MODIFIER_SOURCE_VALUE,

    -- Additional Fields for Stage
    PULL_VISIT_OCCURRENCE_HSP.PULL_CSN_ID                          AS PULL_CSN_ID,
    UPPER(OR_LOG_ALL_PROC.ALL_PROC_CODE_ID)                        AS PULL_PROC_ID,
    COALESCE(T_CPT_CODES.PROC_CODE, T_CPT_CODES_2.PROC_CODE)      AS PULL_PROC_CODE,
    COALESCE(T_CPT_CODES.PROC_NAME, T_CPT_CODES_2.PROC_NAME)      AS PULL_PROC_NAME

FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.PULL_VISIT_OCCURRENCE_HSP AS PULL_VISIT_OCCURRENCE_HSP

    -- Join to get OR admission link
    INNER JOIN CARE_BRONZE_CLARITY_PROD.DBO.PAT_OR_ADM_LINK AS PAT_OR_ADM_LINK
        ON PULL_VISIT_OCCURRENCE_HSP.PULL_CSN_ID = PAT_OR_ADM_LINK.OR_LINK_CSN

    -- Join to get OR log details
    INNER JOIN CARE_BRONZE_CLARITY_PROD.DBO.OR_LOG AS OR_LOG
        ON PAT_OR_ADM_LINK.LOG_ID = OR_LOG.LOG_ID

    -- Join to get virtual OR log information
    INNER JOIN CARE_BRONZE_CLARITY_PROD.DBO.OR_LOG_VIRTUAL AS OR_LOG_VIRTUAL
        ON OR_LOG.LOG_ID = OR_LOG_VIRTUAL.LOG_ID

    -- Join to get all procedures
    INNER JOIN CARE_BRONZE_CLARITY_PROD.DBO.OR_LOG_ALL_PROC AS OR_LOG_ALL_PROC
        ON OR_LOG.LOG_ID = OR_LOG_ALL_PROC.LOG_ID

    -- Join to get surgeon information
    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.OR_LOG_ALL_SURG AS OR_LOG_ALL_SURG
        ON OR_LOG.LOG_ID = OR_LOG_ALL_SURG.LOG_ID
        AND OR_LOG_ALL_PROC.LINE = OR_LOG_ALL_SURG.LINE

    -- Join to get CPT codes for older surgical logs
    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.T_CPT_CODES AS T_CPT_CODES
        ON OR_LOG_ALL_PROC.ALL_PROC_CODE_ID = T_CPT_CODES.PROC_ID

    -- Joins for newer surgical logs (Epic 2018 version and later)
    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.OR_OPE_PROC_CODE AS OR_OPE_PROC_CODE
        ON OR_LOG_ALL_PROC.ALL_PANEL_ADDL_ID = OR_OPE_PROC_CODE.OPE_ID

    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.T_CPT_CODES AS T_CPT_CODES_2
        ON OR_OPE_PROC_CODE.PROC_CODE_ID = T_CPT_CODES_2.PROC_ID

    -- Join to get OR status information
    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.ZC_OR_STATUS AS ZC_OR_STATUS
        ON OR_LOG.STATUS_C = ZC_OR_STATUS.STATUS_C

WHERE (OR_LOG.STATUS_C = 2)
    AND (COALESCE(OR_LOG_ALL_PROC.ALL_PROC_CODE_ID, 
         OR_OPE_PROC_CODE.PROC_CODE_ID)) IS NOT NULL;