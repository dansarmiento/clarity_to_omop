
    
    

select
    CARE_SITE_ID as unique_field,
    count(*) as n_records

from CARE_RES_OMOP_DEV2_WKSP.OMOP.CARE_SITE
where CARE_SITE_ID is not null
group by CARE_SITE_ID
having count(*) > 1


