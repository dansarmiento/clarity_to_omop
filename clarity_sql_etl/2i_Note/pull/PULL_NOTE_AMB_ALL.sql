/*******************************************************************************
* Query: PULL_NOTE_AMB_ALL
* Description: Retrieves ambulatory notes data while excluding specific encounter types
* 
* Tables Used:
* - PULL_VISIT_OCCURRENCE_AMB
* - Z_NOTE_LOOKUP
*******************************************************************************/

SELECT
    -- OMOP Standard Fields
    Z_NOTE_LOOKUP.PERSON_ID                               AS PERSON_ID,
    Z_NOTE_LOOKUP.ENTRY_INSTANT_DTTM::DATE               AS NOTE_DATE,
    Z_NOTE_LOOKUP.ENTRY_INSTANT_DTTM                     AS NOTE_DATETIME,
    Z_NOTE_LOOKUP.ZC_NOTE_TYPE_IP_NAME                   AS NOTE_TITLE,
    
    -- Placeholder for note text (excluded due to PHI concerns)
    'NO_TEXT'                                            AS NOTE_TEXT,
    
    -- Provider and source information
    PULL_VISIT_OCCURRENCE_AMB.PULL_PROVIDER_SOURCE_VALUE AS PROVIDER_SOURCE_VALUE,
    Z_NOTE_LOOKUP.IP_NOTE_TYPE_C 
        || ':' || Z_NOTE_LOOKUP.AMB_NOTE_YN
        || ':' || Z_NOTE_LOOKUP.ZC_NOTE_TYPE_IP_NAME     AS NOTE_SOURCE_VALUE,

    -- Additional Non-OMOP Fields
    Z_NOTE_LOOKUP.PAT_ENC_CSN_ID                        AS PULL_CSN_ID,
    Z_NOTE_LOOKUP.IP_NOTE_TYPE_C                        AS PULL_IP_NOTE_TYPE_C,
    Z_NOTE_LOOKUP.AMB_NOTE_YN                           AS PULL_AMB_NOTE_YN,
    Z_NOTE_LOOKUP.NOTE_ID                               AS PULL_NOTE_ID,
    Z_NOTE_LOOKUP.CONTACT_DATE_REAL                     AS PULL_CONTACT_DATE_REAL,
    PULL_VISIT_OCCURRENCE_AMB.PULL_ENC_TYPE_C          AS PULL_ENC_TYPE_C

FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.PULL_VISIT_OCCURRENCE_AMB AS PULL_VISIT_OCCURRENCE_AMB

INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.Z_NOTE_LOOKUP AS Z_NOTE_LOOKUP
    ON PULL_VISIT_OCCURRENCE_AMB.PULL_CSN_ID = Z_NOTE_LOOKUP.PAT_ENC_CSN_ID

WHERE
    PULL_VISIT_OCCURRENCE_AMB.PULL_ENC_TYPE_C <> 3
    AND PULL_VISIT_OCCURRENCE_AMB.PULL_ENC_TYPE_C <> 52;