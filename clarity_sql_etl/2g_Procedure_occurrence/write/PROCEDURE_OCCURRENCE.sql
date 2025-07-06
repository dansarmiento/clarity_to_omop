/*******************************************************************************
* Query: PROCEDURE_OCCURRENCE
* Description: Retrieves procedure occurrence data excluding records with fatal 
*              or invalid data errors
*
* Tables Used:
*   - CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE_RAW
*   - CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_ERR_DBT
*
* Modifications:
* Date        Author        Description
* ----------  ------------  ------------------------------------------------
* 
*******************************************************************************/

SELECT
    -- OMOP Standard Fields
    PROCEDURE_OCCURRENCE_ID,                -- Unique identifier for procedure occurrence
    PERSON_ID,                             -- Foreign key to the PERSON table
    PROCEDURE_CONCEPT_ID,                  -- Concept ID for the procedure
    PROCEDURE_DATE,                        -- Date of procedure
    PROCEDURE_DATETIME,                    -- Date and time of procedure
    PROCEDURE_END_DATE,                    -- End date of procedure
    PROCEDURE_END_DATETIME,                -- End date and time of procedure
    PROCEDURE_TYPE_CONCEPT_ID,             -- Type concept ID for procedure
    MODIFIER_CONCEPT_ID,                   -- Concept ID for procedure modifier
    QUANTITY,                              -- Number of procedures performed
    PROVIDER_ID,                           -- Foreign key to the PROVIDER table
    VISIT_OCCURRENCE_ID,                   -- Foreign key to the VISIT_OCCURRENCE table
    VISIT_DETAIL_ID,                       -- Foreign key to the VISIT_DETAIL table
    PROCEDURE_SOURCE_VALUE,                -- Source value for procedure (human readable)
    PROCEDURE_SOURCE_CONCEPT_ID,           -- Source concept ID for procedure
    MODIFIER_SOURCE_VALUE,                 -- Source value for modifier

    -- Non-OMOP Fields
    etl_MODULE,                            -- ETL module identifier
    phi_PAT_ID,                           -- Patient identifier (PHI)
    phi_MRN_CPI,                          -- Medical Record Number (PHI)
    phi_CSN_ID,                           -- Contact Serial Number (PHI)
    
    -- Source Reference Fields
    src_TABLE,                            -- Source table name
    src_FIELD,                            -- Source field name
    src_VALUE_ID                          -- Source value identifier

FROM 
    CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE_RAW AS PROCEDURE_OCCURRENCE

-- Exclude records with fatal or invalid data errors
LEFT JOIN (
    SELECT 
        CDT_ID
    FROM 
        CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_ERR_DBT AS QA_ERR_DBT
    WHERE 
        (STANDARD_DATA_TABLE = 'PROCEDURE_OCCURRENCE')
        AND (ERROR_TYPE IN ('FATAL', 'INVALID DATA'))
) AS EXCLUSION_RECORDS
    ON PROCEDURE_OCCURRENCE.PROCEDURE_OCCURRENCE_ID = EXCLUSION_RECORDS.CDT_ID

WHERE 
    (EXCLUSION_RECORDS.CDT_ID IS NULL);