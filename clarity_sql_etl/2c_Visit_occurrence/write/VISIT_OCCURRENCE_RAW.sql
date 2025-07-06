/***************************************************************
 * Script: VISIT_OCCURRENCE Query
 * Description: Combines ambulatory and hospital visit occurrences
 * and formats them according to OMOP CDM specifications
 * Target Table: VISIT_OCCURRENCE
 ***************************************************************/

SELECT DISTINCT
    -- Primary and Foreign Keys
    CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW_SEQ.nextval::NUMBER(28,0) AS VISIT_OCCURRENCE_ID,
    PERSON_ID::NUMBER(28,0)                     AS PERSON_ID,
    
    -- Visit Details
    VISIT_CONCEPT_ID::NUMBER(28,0)              AS VISIT_CONCEPT_ID,
    VISIT_START_DATE::DATE                      AS VISIT_START_DATE,
    VISIT_START_DATETIME::DATETIME              AS VISIT_START_DATETIME,
    VISIT_END_DATE::DATE                        AS VISIT_END_DATE,
    VISIT_END_DATETIME::DATETIME                AS VISIT_END_DATETIME,
    VISIT_TYPE_CONCEPT_ID::NUMBER(28,0)         AS VISIT_TYPE_CONCEPT_ID,
    
    -- Provider and Care Site Information
    PROVIDER_ID::NUMBER(28,0)                   AS PROVIDER_ID,
    CARE_SITE_ID::NUMBER(28,0)                  AS CARE_SITE_ID,
    
    -- Source Values and Concepts
    VISIT_SOURCE_VALUE::VARCHAR                 AS VISIT_SOURCE_VALUE,
    VISIT_SOURCE_CONCEPT_ID::NUMBER(28,0)       AS VISIT_SOURCE_CONCEPT_ID,
    
    -- Admission and Discharge Information
    ADMITTED_FROM_CONCEPT_ID::NUMBER(28,0)      AS ADMITTED_FROM_CONCEPT_ID,
    ADMITTED_FROM_SOURCE_VALUE::VARCHAR         AS ADMITTED_FROM_SOURCE_VALUE,
    DISCHARGED_TO_CONCEPT_ID::NUMBER(28,0)      AS DISCHARGED_TO_CONCEPT_ID,
    DISCHARGED_TO_SOURCE_VALUE::VARCHAR         AS DISCHARGED_TO_SOURCE_VALUE,
    PRECEDING_VISIT_OCCURRENCE_ID::NUMBER(28,0) AS PRECEDING_VISIT_OCCURRENCE_ID,
    
    -- Non-OMOP Fields
    ETL_MODULE::VARCHAR                         AS ETL_MODULE,
    STAGE_PAT_ID::VARCHAR                       AS phi_PAT_ID,
    STAGE_MRN_CPI::NUMBER(28,0)                 AS phi_MRN_CPI,
    STAGE_CSN_ID::NUMBER(28,0)                  AS phi_CSN_ID

FROM (
    -- Combine Ambulatory and Hospital Visits
    SELECT *
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE.STAGE_VISIT_OCCURRENCE_AMB AS STAGE_VISIT_OCCURRENCE_AMB
    
    UNION ALL
    
    SELECT *
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE.STAGE_VISIT_OCCURRENCE_HSP AS VISIT_OCCURRENCE_HSP
) A;