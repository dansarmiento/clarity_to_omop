
    
    

select
    DRUG_EXPOSURE_ID as unique_field,
    count(*) as n_records

from CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE
where DRUG_EXPOSURE_ID is not null
group by DRUG_EXPOSURE_ID
having count(*) > 1


