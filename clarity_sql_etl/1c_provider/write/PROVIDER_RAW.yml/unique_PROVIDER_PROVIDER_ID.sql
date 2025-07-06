
    
    

select
    PROVIDER_ID as unique_field,
    count(*) as n_records

from CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER
where PROVIDER_ID is not null
group by PROVIDER_ID
having count(*) > 1


