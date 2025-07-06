{{ config(materialized='ephemeral') }}
--BEGIN cte__SOURCE_TO_CONCEPT_MAP_RACE
    SELECT *
    FROM {{ref('SOURCE_TO_CONCEPT_MAP_stg')}}
    WHERE SOURCE_VOCABULARY_ID = 'SH_RACE'
--END cte__SOURCE_TO_CONCEPT_MAP_RACE
--
