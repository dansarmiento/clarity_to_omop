
--QA_LOG_HISTORY

/*{{ config(materialized = 'incremental', schema='OMOP_QA') }}*/

--++---added for incremental-----++ */
{%- set scd_surrogate_key = "QA_HX_ID" -%}
{%- set scd_integration_key = "INTEGRATION_ID" -%}
{%- set scd_cdc_hash_key = "cdc_hash_key" -%}
{%- set scd_dbt_updated_at = "LAST_UPDATED_TS" -%}
{%- set scd_dbt_inserted_at = "LAST_INSERTED_TS" -%}

     -----replaces materialization above-----
{{ config(
    materialized = "incremental",
    unique_key=scd_surrogate_key,
    merge_exclude_columns = [scd_surrogate_key, scd_dbt_inserted_at],
    transient=false,
    schema='OMOP_QA'
    )
}}
     -----sql variable-----
{%- set scd_source_sql -%}
--++-----------------------------++

SELECT
    RUN_DATE,
    STANDARD_DATA_TABLE,
    QA_METRIC,
    METRIC_FIELD,
    QA_ERRORS,
    ERROR_TYPE,
    TOTAL_RECORDS,
    TOTAL_RECORDS_CLEAN
--++-------added for incremental------++
    ,{{ surrogate_key(["RUN_DATE"
          , "STANDARD_DATA_TABLE"
          , "QA_METRIC"
          , "METRIC_FIELD"
          , "ERROR_TYPE"]) }} AS {{scd_integration_key}}
    ,HASH( QA_ERRORS,
        TOTAL_RECORDS,
        TOTAL_RECORDS_CLEAN)    AS {{scd_cdc_hash_key}}
     --++-------------------------------++
FROM
{{ref('QA_LOG_DBT')}} AS QA_LOG_DBT

--++---added for incremental-----++
{% endset -%}
     -----DEVICE_EXPOSURE_ID inserted here-----
{{ get_scd_sql(scd_source_sql, scd_surrogate_key, scd_integration_key, scd_cdc_hash_key, scd_dbt_updated_at, scd_dbt_inserted_at) -}}
--++------------------------------++
