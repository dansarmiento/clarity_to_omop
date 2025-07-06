
    
    

select
    OBSERVATION_ID as unique_field,
    count(*) as n_records

from CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION
where OBSERVATION_ID is not null
group by OBSERVATION_ID
having count(*) > 1


