{{ config(materialized='ephemeral') }}
--BEGIN cte__SOURCE_TO_CONCEPT_MAP_ADMIT
    SELECT *
    FROM {{ref('SOURCE_TO_CONCEPT_MAP_stg')}}
    WHERE SOURCE_VOCABULARY_ID IN ('SH_admit','SH_ADMIT')
--END cte__SOURCE_TO_CONCEPT_MAP_ADMIT
--
