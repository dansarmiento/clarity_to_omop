
    
    

with child as (
    select LOCATION_ID as from_field
    from CARE_RES_OMOP_DEV2_WKSP.OMOP.PERSON
    where LOCATION_ID is not null
),

parent as (
    select LOCATION_ID as to_field
    from CARE_RES_OMOP_DEV2_WKSP.OMOP.LOCATION_RAW
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


