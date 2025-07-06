
    
    

with child as (
    select VISIT_OCCURRENCE_ID as from_field
    from CARE_RES_OMOP_DEV2_WKSP.OMOP.CONDITION_OCCURRENCE
    where VISIT_OCCURRENCE_ID is not null
),

parent as (
    select VISIT_OCCURRENCE_ID as to_field
    from CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


