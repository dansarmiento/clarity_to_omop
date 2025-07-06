/*******************************************************************************
* Query: DEATH_RAW
* Description: Retrieves death-related information from staging table and 
*              transforms it into OMOP CDM format
* 
* Fields:
*   - Standard OMOP Fields:
*     - PERSON_ID: Unique identifier for the person
*     - DEATH_DATE: Date of death
*     - DEATH_DATETIME: Date and time of death
*     - DEATH_TYPE_CONCEPT_ID: Concept ID indicating death record type (EHR)
*     - CAUSE_CONCEPT_ID: Concept ID for cause of death
*     - CAUSE_SOURCE_VALUE: Original value for cause of death
*     - CAUSE_SOURCE_CONCEPT_ID: Source concept ID for cause of death
*
*   - Custom Fields:
*     - ETL_MODULE: Identifier for ETL process
*     - phi_PAT_ID: Patient ID from source system
*     - phi_MRN_CPI: Medical Record Number
*******************************************************************************/

SELECT
    -- Standard OMOP Fields
    PERSON_ID::NUMBER(28,0)                AS PERSON_ID,
    DEATH_DATE::DATE                       AS DEATH_DATE,
    DEATH_DATETIME::DATETIME               AS DEATH_DATETIME,
    32817::NUMBER(28,0)                    AS DEATH_TYPE_CONCEPT_ID,  -- FROM EHR
    CAUSE_CONCEPT_ID::NUMBER(28,0)         AS CAUSE_CONCEPT_ID,
    CAUSE_SOURCE_VALUE::VARCHAR(50)        AS CAUSE_SOURCE_VALUE,
    CAUSE_SOURCE_CONCEPT_ID::NUMBER(28,0)  AS CAUSE_SOURCE_CONCEPT_ID,

    -- Custom Non-OMOP Fields
    ETL_MODULE::VARCHAR(100)               AS ETL_MODULE,
    STAGE_PAT_ID                           AS phi_PAT_ID,
    STAGE_MRN_CPI                          AS phi_MRN_CPI

FROM 
    CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE.STAGE_DEATH_ALL AS T;