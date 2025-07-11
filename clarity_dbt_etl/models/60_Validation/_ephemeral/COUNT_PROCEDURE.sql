-- OMOP_CS.COUNT_PROCEDURE
  {{ config(materialized='ephemeral') }}
  
SELECT
    PROCEDURE_OCCURRENCE.VISIT_OCCURRENCE_ID
    , COUNT(PROCEDURE_OCCURRENCE.PERSON_ID) AS COUNTOFPROCEDURE
    , PROCEDURE_OCCURRENCE.PERSON_ID

FROM
    {{ref('PROCEDURE_OCCURRENCE')}} AS PROCEDURE_OCCURRENCE
GROUP BY
    PROCEDURE_OCCURRENCE.VISIT_OCCURRENCE_ID
    , PROCEDURE_OCCURRENCE.PERSON_ID
