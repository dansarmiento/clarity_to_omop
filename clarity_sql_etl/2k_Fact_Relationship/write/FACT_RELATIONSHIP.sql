/***************************************************************
* Table: FACT_RELATIONSHIP
* Description: Retrieves relationship data between facts, specifically
* focusing on mother and baby relationships
****************************************************************/

SELECT DISTINCT
    -- OMOP Standard Fields
    DOMAIN_CONCEPT_ID_1::NUMBER(28,0)     AS DOMAIN_CONCEPT_ID_1,    -- Domain concept ID for the first fact
    FACT_ID_1::NUMBER(28,0)               AS FACT_ID_1,              -- Identifier for the first fact
    DOMAIN_CONCEPT_ID_2::NUMBER(28,0)     AS DOMAIN_CONCEPT_ID_2,    -- Domain concept ID for the second fact
    FACT_ID_2::NUMBER(28,0)               AS FACT_ID_2,              -- Identifier for the second fact
    RELATIONSHIP_CONCEPT_ID::NUMBER(28,0)  AS RELATIONSHIP_CONCEPT_ID,-- Concept ID defining the relationship type

    -- Non-OMOP Fields
    ETL_MODULE::VARCHAR                    AS ETL_MODULE,             -- ETL module identifier

    -- Source Link Information for Fact 1 (Baby)
    FACT_1::VARCHAR                        AS fct1_FACT,              -- Fact 1 identifier (BABY_ID)
    FACT_1_TABLE::VARCHAR                  AS fct1_TABLE,             -- Source table for Fact 1
    FACT_1_FIELD::VARCHAR                  AS fct1_FIELD,             -- Source field for Fact 1
    FACT_1_VALUE_ID::VARCHAR               AS fct1_VALUE_ID,          -- Source value ID for Fact 1

    -- Source Link Information for Fact 2 (Mother)
    FACT_2::VARCHAR                        AS fct2_FACT,              -- Fact 2 identifier (MOM_ID)
    FACT_2_TABLE::VARCHAR                  AS fct2_TABLE,             -- Source table for Fact 2
    FACT_2_FIELD::VARCHAR                  AS fct2_FIELD,             -- Source field for Fact 2
    FACT_2_VALUE_ID::VARCHAR               AS fct2_VALUE_ID           -- Source value ID for Fact 2

FROM (
    SELECT 
        DOMAIN_CONCEPT_ID_1, 
        FACT_ID_1, 
        DOMAIN_CONCEPT_ID_2, 
        FACT_ID_2, 
        RELATIONSHIP_CONCEPT_ID,
        ETL_MODULE AS ETL_MODULE,
        'BABY_ID' AS FACT_1,
        'PATIENT' AS FACT_1_TABLE,
        'PAT_ID' AS FACT_1_FIELD,
        STAGE_BABY_ID::VARCHAR AS FACT_1_VALUE_ID,
        'MOM_ID' AS FACT_2,
        'PATIENT' AS FACT_2_TABLE,
        'PAT_ID' AS FACT_2_FIELD,
        STAGE_MOM_ID::VARCHAR AS FACT_2_VALUE_ID
    FROM 
        CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE.STAGE_FACT_RELATIONSHIP_MOM_AND_BABY 
        AS STAGE_FACT_RELATIONSHIP_MOM_AND_BABY
) A;