/*******************************************************************************
* Query: CONDITION_OCCURRENCE Selection
* Description: Retrieves distinct condition occurrence records excluding invalid entries
* Tables: CONDITION_OCCURRENCE_RAW, QA_ERR_DBT
*******************************************************************************/

SELECT DISTINCT
    -- OMOP Standard Fields
    CONDITION_OCCURRENCE_ID,                    -- Primary identifier for condition occurrence
    PERSON_ID,                                 -- Foreign key to the PERSON table
    CONDITION_CONCEPT_ID,                      -- Foreign key to the standardized concept identifier
    CONDITION_START_DATE,                      -- Start date of the condition
    CONDITION_START_DATETIME,                  -- Start date and time of the condition
    CONDITION_END_DATE,                        -- End date of the condition
    CONDITION_END_DATETIME,                    -- End date and time of the condition
    CONDITION_TYPE_CONCEPT_ID,                 -- Type of condition record
    CONDITION_STATUS_CONCEPT_ID,               -- Status of the condition
    STOP_REASON,                              -- Reason for stopping the condition
    PROVIDER_ID,                              -- Foreign key to the provider table
    VISIT_OCCURRENCE_ID,                      -- Foreign key to the visit occurrence table
    VISIT_DETAIL_ID,                          -- Foreign key to the visit detail table
    CONDITION_SOURCE_VALUE,                    -- Human readable source value
    CONDITION_SOURCE_CONCEPT_ID,               -- Source concept identifier
    CONDITION_STATUS_SOURCE_VALUE,             -- Original status value

    -- Non-OMOP Custom Fields
    etl_MODULE,                               -- ETL module identifier
    phi_PAT_ID,                               -- Patient identifier (PHI)
    phi_MRN_CPI,                              -- Medical Record Number (PHI)
    phi_CSN_ID,                               -- Contact Serial Number (PHI)

    -- Source Reference Fields
    src_TABLE,                                -- Source table name
    src_FIELD,                                -- Source field name
    src_VALUE_ID                              -- Source value identifier

FROM
    CARE_RES_OMOP_DEV2_WKSP.OMOP.CONDITION_OCCURRENCE_RAW AS CONDITION_OCCURRENCE

-- Exclude invalid records based on QA errors
LEFT JOIN (
    SELECT CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_ERR_DBT AS QA_ERR_DBT
    WHERE (STANDARD_DATA_TABLE = 'CONDITION_OCCURRENCE')
    AND (ERROR_TYPE IN ('FATAL', 'INVALID DATA'))
) AS EXCLUSION_RECORDS
    ON CONDITION_OCCURRENCE.CONDITION_OCCURRENCE_ID = EXCLUSION_RECORDS.CDT_ID

-- Only include records that don't have fatal or invalid data errors
WHERE (EXCLUSION_RECORDS.CDT_ID IS NULL);