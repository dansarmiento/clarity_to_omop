
    
    

select
    VISIT_DETAIL_ID as unique_field,
    count(*) as n_records

from CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_DETAIL
where VISIT_DETAIL_ID is not null
group by VISIT_DETAIL_ID
having count(*) > 1


