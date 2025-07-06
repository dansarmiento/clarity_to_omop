{{ config(materialized='ephemeral') }}
--BEGIN cte__SOURCE_TO_CONCEPT_MAP_ROUTE
    SELECT *
    FROM {{ref('SOURCE_TO_CONCEPT_MAP_stg')}}
    WHERE SOURCE_VOCABULARY_ID = 'SH_ROUTE'
--END cte__SOURCE_TO_CONCEPT_MAP_ROUTE
--
