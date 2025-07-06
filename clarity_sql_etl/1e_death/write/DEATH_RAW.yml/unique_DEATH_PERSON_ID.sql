
    
    

select
    PERSON_ID as unique_field,
    count(*) as n_records

from CARE_RES_OMOP_DEV2_WKSP.OMOP.DEATH
where PERSON_ID is not null
group by PERSON_ID
having count(*) > 1


