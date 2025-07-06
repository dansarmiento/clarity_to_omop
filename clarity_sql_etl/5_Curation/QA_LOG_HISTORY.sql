/*******************************************************************************
* Script Name: QA_LOG_HISTORY.sql
* Author: Roger J Carlson - Corewell Health
* Date: June 2025
* Description: Maintains history of QA log entries with change data capture logic
*******************************************************************************/

with source_data as (
    SELECT
        RUN_DATE,
        STANDARD_DATA_TABLE,
        QA_METRIC,
        METRIC_FIELD,
        QA_ERRORS,
        ERROR_TYPE,
        TOTAL_RECORDS,
        TOTAL_RECORDS_CLEAN,
        COALESCE(RUN_DATE::VARCHAR, '') || '~' || 
        COALESCE(STANDARD_DATA_TABLE::VARCHAR, '') || '~' || 
        COALESCE(QA_METRIC::VARCHAR, '') || '~' || 
        COALESCE(METRIC_FIELD::VARCHAR, '') || '~' || 
        COALESCE(ERROR_TYPE::VARCHAR, '') AS INTEGRATION_ID,
        HASH(
            QA_ERRORS,
            TOTAL_RECORDS,
            TOTAL_RECORDS_CLEAN
        ) AS cdc_hash_key
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_LOG_DBT AS QA_LOG_DBT
),

existing_data as (
    select
        QA_HX_ID,
        INTEGRATION_ID,
        cdc_hash_key,
        LAST_INSERTED_TS
    from CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_LOG_HISTORY
),

inserts as (
    select
        CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_LOG_HISTORY_SEQ.nextval as QA_HX_ID,
        source_data.*,
        sysdate() as LAST_INSERTED_TS,
        sysdate() as LAST_UPDATED_TS
    from source_data
    left outer join existing_data 
        on source_data.INTEGRATION_ID = existing_data.INTEGRATION_ID
    where existing_data.INTEGRATION_ID is null
),

updates as (
    select
        existing_data.QA_HX_ID,
        source_data.*,
        existing_data.LAST_INSERTED_TS,
        sysdate() as LAST_UPDATED_TS
    from source_data
    join existing_data 
        on source_data.INTEGRATION_ID = existing_data.INTEGRATION_ID
    where source_data.cdc_hash_key <> existing_data.cdc_hash_key
)

select * from inserts
union all
select * from updates

/*******************************************************************************
* Column Descriptions:
* - RUN_DATE: Date when QA check was performed
* - STANDARD_DATA_TABLE: Name of the table being checked
* - QA_METRIC: Type of quality check performed
* - METRIC_FIELD: Specific field being evaluated
* - QA_ERRORS: Number of errors found
* - ERROR_TYPE: Classification of the error
* - TOTAL_RECORDS: Total number of records checked
* - TOTAL_RECORDS_CLEAN: Number of records without errors
* - INTEGRATION_ID: Composite key for record identification
* - cdc_hash_key: Hash key for change detection
* - LAST_INSERTED_TS: Timestamp of initial record insertion
* - LAST_UPDATED_TS: Timestamp of last update
*
* Logic:
* 1. Retrieves current QA log entries from QA_LOG_DBT
* 2. Compares against existing history records
* 3. Identifies new records for insertion
* 4. Identifies changed records for updates
* 5. Combines inserts and updates into final result set
*
* Legal Warning:
* This code is provided "AS IS" without warranty of any kind.
* The entire risk as to the quality and performance of the code is with you.
* Use at your own risk.
*******************************************************************************/