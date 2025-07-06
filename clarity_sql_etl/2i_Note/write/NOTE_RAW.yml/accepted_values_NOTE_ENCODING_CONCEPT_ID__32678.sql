
    
    

with all_values as (

    select
        ENCODING_CONCEPT_ID as value_field,
        count(*) as n_records

    from CARE_RES_OMOP_DEV2_WKSP.OMOP.NOTE
    group by ENCODING_CONCEPT_ID

)

select *
from all_values
where value_field not in (
    '32678'
)


