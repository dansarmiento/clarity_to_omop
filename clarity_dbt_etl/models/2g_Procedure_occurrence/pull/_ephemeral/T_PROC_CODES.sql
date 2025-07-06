
{{ config(materialized='ephemeral') }}
--BEGIN T_PROC_CODES
AS (
    SELECT DISTINCT EAP.PROC_ID
        ,EAP.PROC_CODE
        ,EAP.PROC_NAME
    FROM {{ ref('CLARITY_EAP_stg')}} AS EAP
--END T_PROC_CODE
--