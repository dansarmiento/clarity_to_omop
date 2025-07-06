
    
    

with child as (
    select OPERATOR_CONCEPT_ID as from_field
    from CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT
    where OPERATOR_CONCEPT_ID is not null
),

parent as (
    select CONCEPT_ID as to_field
    from CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


