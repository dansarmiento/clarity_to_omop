
    
    

with child as (
    select PROVIDER_ID as from_field
    from CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT
    where PROVIDER_ID is not null
),

parent as (
    select PROVIDER_ID as to_field
    from CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER_RAW
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


