/*******************************************************************************
* Query: Select Specimen Information
* Description: Retrieves specimen data with standardized OMOP CDM formatting
* Source Table: CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE.STAGE_SPECIMEN_ALL
*******************************************************************************/

SELECT DISTINCT
    -- OMOP Standard Fields
    CARE_RES_OMOP_DEV2_WKSP.OMOP.SPECIMEN_RAW_SEQ.nextval::NUMBER(28,0) AS SPECIMEN_ID,
    PERSON_ID::NUMBER(28,0)                    AS PERSON_ID,
    SPECIMEN_CONCEPT_ID::NUMBER(28,0)          AS SPECIMEN_CONCEPT_ID,
    SPECIMEN_TYPE_CONCEPT_ID::NUMBER(28,0)     AS SPECIMEN_TYPE_CONCEPT_ID,
    SPECIMEN_DATE::DATE                        AS SPECIMEN_DATE,
    SPECIMEN_DATETIME::DATETIME                AS SPECIMEN_DATETIME,
    QUANTITY::FLOAT                            AS QUANTITY,
    UNIT_CONCEPT_ID::NUMBER(28,0)              AS UNIT_CONCEPT_ID,
    ANATOMIC_SITE_CONCEPT_ID::NUMBER(28,0)     AS ANATOMIC_SITE_CONCEPT_ID,
    DISEASE_STATUS_CONCEPT_ID::NUMBER(28,0)    AS DISEASE_STATUS_CONCEPT_ID,
    
    -- Source Values
    SPECIMEN_SOURCE_ID::VARCHAR                AS SPECIMEN_SOURCE_ID,
    SPECIMEN_SOURCE_VALUE::VARCHAR             AS SPECIMEN_SOURCE_VALUE,
    UNIT_SOURCE_VALUE::VARCHAR                 AS UNIT_SOURCE_VALUE,
    ANATOMIC_SITE_SOURCE_VALUE::VARCHAR        AS ANATOMIC_SITE_SOURCE_VALUE,
    DISEASE_STATUS_SOURCE_VALUE::VARCHAR       AS DISEASE_STATUS_SOURCE_VALUE,
    
    -- Custom ETL Fields
    STAGE_ETL_MODULE::VARCHAR                  AS etl_MODULE,
    STAGE_PAT_ID::VARCHAR                      AS phi_PAT_ID,
    STAGE_MRN_CPI::NUMBER(28,0)               AS phi_MRN_CPI,
    
    -- Source Tracking Fields
    'HSC_SPEC_INFO'::VARCHAR                   AS src_TABLE,
    'SPECIMEN_TYPE_C'::VARCHAR                 AS src_FIELD,
    STAGE_SPECIMEN_TYPE_SOURCE_CODE::VARCHAR   AS src_VALUE_ID

FROM 
    CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE.STAGE_SPECIMEN_ALL AS STAGE_SPECIMEN_ALL;