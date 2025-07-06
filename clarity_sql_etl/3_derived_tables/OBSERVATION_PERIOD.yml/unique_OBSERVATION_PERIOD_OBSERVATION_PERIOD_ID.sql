
    
    

select
    OBSERVATION_PERIOD_ID as unique_field,
    count(*) as n_records

from CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION_PERIOD
where OBSERVATION_PERIOD_ID is not null
group by OBSERVATION_PERIOD_ID
having count(*) > 1


