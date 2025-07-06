
    
    

select
    CONDITION_ERA_ID as unique_field,
    count(*) as n_records

from CARE_RES_OMOP_DEV2_WKSP.OMOP.CONDITION_ERA
where CONDITION_ERA_ID is not null
group by CONDITION_ERA_ID
having count(*) > 1


