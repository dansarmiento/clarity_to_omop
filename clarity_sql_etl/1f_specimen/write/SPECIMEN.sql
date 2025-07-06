/*******************************************************************************
* Query: SPECIMEN Data Retrieval
* Description: Retrieves specimen data excluding records with fatal or invalid errors
* Tables: 
*   - SPECIMEN_RAW
*   - QA_ERR_DBT (for exclusions)
*******************************************************************************/

SELECT DISTINCT
    -- OMOP Standard Fields
    SPECIMEN_ID,                     -- Unique identifier for the specimen
    PERSON_ID,                       -- Reference to the person
    SPECIMEN_CONCEPT_ID,            -- Standardized concept for specimen type
    SPECIMEN_TYPE_CONCEPT_ID,       -- Concept indicating the type of specimen
    SPECIMEN_DATE,                  -- Date the specimen was collected
    SPECIMEN_DATETIME,              -- Date and time the specimen was collected
    QUANTITY,                       -- Quantity of specimen collected
    UNIT_CONCEPT_ID,               -- Standardized concept for unit of measurement
    ANATOMIC_SITE_CONCEPT_ID,      -- Standardized concept for anatomic site
    DISEASE_STATUS_CONCEPT_ID,      -- Standardized concept for disease status
    SPECIMEN_SOURCE_ID,            -- Source identifier for the specimen
    SPECIMEN_SOURCE_VALUE,         -- Source value for specimen type
    UNIT_SOURCE_VALUE,             -- Source value for unit of measurement
    ANATOMIC_SITE_SOURCE_VALUE,    -- Source value for anatomic site
    DISEASE_STATUS_SOURCE_VALUE,   -- Source value for disease status

    -- Non-OMOP Custom Fields
    etl_MODULE,                    -- ETL module identifier
    phi_PAT_ID,                    -- Patient identifier (PHI)
    phi_MRN_CPI,                  -- Medical Record Number (PHI)

    -- Source Reference Fields
    src_TABLE,                     -- Source table name
    src_FIELD,                     -- Source field name
    src_VALUE_ID                   -- Source value identifier

FROM 
    CARE_RES_OMOP_DEV2_WKSP.OMOP.SPECIMEN_RAW AS SPECIMEN

    -- Join to exclude records with fatal or invalid errors
    LEFT JOIN (
        SELECT CDT_ID
        FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_ERR_DBT AS QA_ERR_DBT
        WHERE (STANDARD_DATA_TABLE = 'SPECIMEN')
          AND (ERROR_TYPE IN ('FATAL', 'INVALID DATA'))
    ) AS EXCLUSION_RECORDS
    ON SPECIMEN.SPECIMEN_ID = EXCLUSION_RECORDS.CDT_ID

-- Only include records that don't have fatal or invalid errors
WHERE (EXCLUSION_RECORDS.CDT_ID IS NULL);