/***************************************************************
 * Query: STAGE_PROCEDURE_OCCURRENCE_SURG_CPT
 * Description: Retrieves and transforms surgical CPT procedure data
 *              into OMOP CDM format for the PROCEDURE_OCCURRENCE table
 * 
 * Tables Used:
 *   - PULL_PROCEDURE_OCCURRENCE_SURG_CPT
 *   - T_PROCEDURE_SOURCE
 *   - T_PROCEDURE_CONCEPT
 *   - VISIT_OCCURRENCE_RAW
 *   - PROVIDER_RAW
 *
 * Notes:
 *   - Uses CPT codes as source for surgical procedures
 *   - Maps to standard OMOP concepts
 *   - Includes ETL tracking fields
 ***************************************************************/

SELECT DISTINCT
    -- Standard OMOP CDM Fields
    PULL_PROCEDURE_OCCURRENCE_SURG_CPT.PERSON_ID             AS PERSON_ID,
    T_CONCEPT.CONCEPT_ID                                     AS PROCEDURE_CONCEPT_ID,
    PROCEDURE_DATE                                           AS PROCEDURE_DATE,
    PROCEDURE_DATETIME                                       AS PROCEDURE_DATETIME,
    NULL                                                     AS PROCEDURE_END_DATE,
    NULL                                                     AS PROCEDURE_END_DATETIME,
    32817                                                    AS PROCEDURE_TYPE_CONCEPT_ID,  -- EHR order list entry
    NULL                                                     AS MODIFIER_CONCEPT_ID,
    1                                                        AS QUANTITY,                   -- Default quantity
    PROVIDER.PROVIDER_ID                                     AS PROVIDER_ID,
    VISIT_OCCURRENCE.VISIT_OCCURRENCE_ID                     AS VISIT_OCCURRENCE_ID,
    NULL                                                     AS VISIT_DETAIL_ID,
    PROCEDURE_SOURCE_VALUE                                   AS PROCEDURE_SOURCE_VALUE,
    T_SOURCE.CONCEPT_ID                                      AS PROCEDURE_SOURCE_CONCEPT_ID,
    MODIFIER_SOURCE_VALUE                                    AS MODIFIER_SOURCE_VALUE,

    -- Custom Fields for ETL tracking
    'PROCEDURE_OCCURRENCE_SURG_CPT'                          AS ETL_MODULE,
    VISIT_OCCURRENCE.phi_PAT_ID                             AS STAGE_PAT_ID,
    VISIT_OCCURRENCE.phi_MRN_CPI                            AS STAGE_MRN_CPI,
    VISIT_OCCURRENCE.phi_CSN_ID                             AS STAGE_CSN_ID,
    PULL_PROC_ID                                            AS STAGE_PROC_ID

FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.PULL_PROCEDURE_OCCURRENCE_SURG_CPT AS PULL_PROCEDURE_OCCURRENCE_SURG_CPT

-- Join to get standard concepts
INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE.T_PROCEDURE_SOURCE AS T_SOURCE
    ON PULL_PROCEDURE_OCCURRENCE_SURG_CPT.PULL_PROC_CODE = T_SOURCE.CONCEPT_CODE

INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE.T_PROCEDURE_CONCEPT AS T_CONCEPT
    ON T_SOURCE.CONCEPT_ID = T_CONCEPT.CONCEPT_ID

-- Join to get visit and provider information
INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS VISIT_OCCURRENCE
    ON PULL_PROCEDURE_OCCURRENCE_SURG_CPT.PULL_CSN_ID = VISIT_OCCURRENCE.phi_CSN_ID

LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER_RAW AS PROVIDER
    ON PULL_PROCEDURE_OCCURRENCE_SURG_CPT.PROVIDER_SOURCE_VALUE = PROVIDER.PROVIDER_SOURCE_VALUE;