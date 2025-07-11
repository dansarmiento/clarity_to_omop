--Query_Visit_Occurrence_Errors

SELECT
    QA_ERR_DBT.RUN_DATE
    , QA_ERR_DBT.STANDARD_DATA_TABLE
    , QA_ERR_DBT.QA_METRIC
    , QA_ERR_DBT.METRIC_FIELD
    , QA_ERR_DBT.ERROR_TYPE
    , VISIT_OCCURRENCE.*
FROM
    {{ref('QA_ERR_DBT')}} AS QA_ERR_DBT
INNER JOIN {{ref('VISIT_OCCURRENCE')}} AS VISIT_OCCURRENCE ON
    QA_ERR_DBT.CDT_ID = VISIT_OCCURRENCE.VISIT_OCCURRENCE_ID
    AND QA_ERR_DBT.CDT_ID = VISIT_OCCURRENCE.VISIT_OCCURRENCE_ID
WHERE
    QA_ERR_DBT.STANDARD_DATA_TABLE = 'VISIT_OCCURRENCE'
