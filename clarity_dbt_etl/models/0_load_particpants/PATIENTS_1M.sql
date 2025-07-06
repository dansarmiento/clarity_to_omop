/* Find 1M Patients for testing */
/* Require that they have a hospital visit and/or a face to face visit */
-- limit to last year, three years?
-- Think about: when we have a specific patient list (AoU, Covid Patients, etc.)
	-- would we make a new database?

{{ config(materialized = 'view', schema = 'OMOP') }}

with f2f_encounters as (
	SELECT DISTINCT
		PAT_ENC.PAT_ID
		,count(distinct PAT_ENC.PAT_ENC_CSN_ID) AS f2f_count
	--	,PAT_ENC.CONTACT_DATE
	FROM {{ source('CLARITY','PAT_ENC')}} PAT_ENC
	WHERE PAT_ENC.ENC_TYPE_C IN ('1000', '1001', '1003', '101', '1021004', '106', '108', '11', '111113', '120', '1200', '1201', '122', '1300', '2', '200', '201', '202', '203', '204', '205', '206', '207', '208', '209', '2100', '2101', '210100', '210200', '2133', '2425', '2500', '2501', '2502', '2506', '2522', '2523', '3', '300', '3015', '3018', '304210', '304214', '3042508', '3042509', '3042716', '50', '5852101', '76', '91')
	AND DATEDIFF(DAY, PAT_ENC.CONTACT_DATE, getDate()) between 0 and 365*3
	GROUP BY PAT_ENC.PAT_ID
)
, hsp_encounters as (
	SELECT DISTINCT
		PAT_ENC_HSP.PAT_ID
		,count(distinct PAT_ENC_HSP.PAT_ENC_CSN_ID) AS hsp_count
	--	,PAT_ENC_HSP.HOSP_ADMSN_TIME
	FROM {{ source('CLARITY','PAT_ENC_HSP')}} PAT_ENC_HSP
	WHERE DATEDIFF(DAY, PAT_ENC_HSP.HOSP_ADMSN_TIME, getDate()) between 0 and 365*5
	GROUP BY PAT_ENC_HSP.PAT_ID
)
select top 1000000
	COALESCE(f2f_encounters.PAT_ID, hsp_encounters.PAT_ID) as EPIC_PAT_ID
	,II.IDENTITY_ID AS mrn
	,f2f_count
	,hsp_count
	,(f2f_count + hsp_count) as visit_count
from f2f_encounters
inner join hsp_encounters on f2f_encounters.PAT_ID = hsp_encounters.PAT_ID
inner join {{ source('CLARITY','IDENTITY_ID')}}  II	on f2f_encounters.PAT_ID = II.PAT_ID AND II.IDENTITY_TYPE_ID = 49
order by visit_count desc



