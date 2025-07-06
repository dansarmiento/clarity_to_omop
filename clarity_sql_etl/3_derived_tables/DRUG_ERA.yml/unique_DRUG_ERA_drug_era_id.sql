
    
    

select
    drug_era_id as unique_field,
    count(*) as n_records

from CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_ERA
where drug_era_id is not null
group by drug_era_id
having count(*) > 1


