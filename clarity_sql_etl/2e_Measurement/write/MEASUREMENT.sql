/*******************************************************************************
* Query: MEASUREMENT Data Retrieval
* Description: Retrieves measurement data excluding records with fatal or invalid errors
* Tables: 
*   - CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT_RAW
*   - CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_ERR_DBT
*******************************************************************************/

SELECT
    -- OMOP Standard Fields
    MEASUREMENT_ID,
    PERSON_ID,
    MEASUREMENT_CONCEPT_ID,
    MEASUREMENT_DATE,
    MEASUREMENT_DATETIME,
    MEASUREMENT_TIME,
    MEASUREMENT_TYPE_CONCEPT_ID,
    OPERATOR_CONCEPT_ID,
    VALUE_AS_NUMBER,
    VALUE_AS_CONCEPT_ID,
    UNIT_CONCEPT_ID,
    RANGE_LOW,
    RANGE_HIGH,
    PROVIDER_ID,
    VISIT_OCCURRENCE_ID,
    VISIT_DETAIL_ID,
    MEASUREMENT_SOURCE_VALUE,     
    MEASUREMENT_SOURCE_CONCEPT_ID,
    UNIT_SOURCE_VALUE,
    UNIT_SOURCE_CONCEPT_ID,
    VALUE_SOURCE_VALUE,
    MEASUREMENT_EVENT_ID,
    MEAS_EVENT_FIELD_CONCEPT_ID,

    -- Non-OMOP Fields
    ETL_MODULE,
    phi_PAT_ID,
    phi_MRN_CPI,
    phi_CSN_ID,

    -- Source Link Fields
    src_TABLE,
    src_FIELD,
    src_VALUE_ID

FROM 
    CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT_RAW AS MEASUREMENT

    -- Exclude records with fatal or invalid errors
    LEFT JOIN (
        SELECT 
            CDT_ID
        FROM 
            CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_ERR_DBT AS QA_ERR_DBT
        WHERE 
            (STANDARD_DATA_TABLE = 'MEASUREMENT')
            AND (ERROR_TYPE IN ('FATAL', 'INVALID DATA'))
    ) AS EXCLUSION_RECORDS
    ON MEASUREMENT.MEASUREMENT_ID = EXCLUSION_RECORDS.CDT_ID

WHERE 
    EXCLUSION_RECORDS.CDT_ID IS NULL;