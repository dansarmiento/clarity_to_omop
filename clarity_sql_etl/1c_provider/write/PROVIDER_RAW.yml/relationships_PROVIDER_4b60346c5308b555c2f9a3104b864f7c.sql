
    
    

with child as (
    select CARE_SITE_ID as from_field
    from CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER
    where CARE_SITE_ID is not null
),

parent as (
    select CARE_SITE_ID as to_field
    from CARE_RES_OMOP_DEV2_WKSP.OMOP.CARE_SITE
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


