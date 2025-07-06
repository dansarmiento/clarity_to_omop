{{ config(materialized='ephemeral') }}
--BEGIN cte__SOURCE_TO_CONCEPT_MAP_VISIT
    SELECT *
    FROM {{ref('SOURCE_TO_CONCEPT_MAP_stg')}}
    WHERE SOURCE_VOCABULARY_ID IN ('SH_visit','SH_VISIT')
--BEGIN cte__SOURCE_TO_CONCEPT_MAP_VISIT
--
