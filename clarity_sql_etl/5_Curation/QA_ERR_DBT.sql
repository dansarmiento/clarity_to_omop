/*********************************************************
Script Name: QA_ERR_DBT
Author: Roger J Carlson - Corewell Health
Date: June 2025

Description: This script combines multiple QA check results from various OMOP tables
to create a comprehensive quality assessment report.

**********************************************************/

--CARE_SITE
SELECT  RUN_DATE, STANDARD_DATA_TABLE, QA_METRIC, METRIC_FIELD, ERROR_TYPE, CARE_SITE_ID AS CDT_ID
 FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_CARE_SITE_DUPLICATES_DETAIL AS QA_CARE_SITE_DUPLICATES_DETAIL

UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_CARE_SITE_NON_STANDARD_DETAIL AS QA_CARE_SITE_NON_STANDARD_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_CARE_SITE_ZERO_CONCEPT_DETAIL AS QA_CARE_SITE_ZERO_CONCEPT_DETAIL

--CONDITION
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_CONDITION_30AFTERDEATH_DETAIL AS QA_CONDITION_30AFTERDEATH_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_CONDITION_OCCURRENCE_DATEVDATETIME_DETAIL AS QA_CONDITION_OCCURRENCE_DATEVDATETIME_DETAIL
UNION ALL SELECT  * FROM
 CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_CONDITION_OCCURRENCE_DUPLICATES_DETAIL AS QA_CONDITION_OCCURRENCE_DUPLICATES_DETAIL
UNION ALL SELECT  * FROM
 CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_CONDITION_OCCURRENCE_END_BEFORE_START_DETAIL AS QA_CONDITION_OCCURRENCE_END_BEFORE_START_DETAIL

UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_CONDITION_OCCURRENCE_NONSTANDARD_DETAIL AS QA_CONDITION_OCCURRENCE_NONSTANDARD_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_CONDITION_OCCURRENCE_NOVISIT_DETAIL AS QA_CONDITION_OCCURRENCE_NOVISIT_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_CONDITION_OCCURRENCE_NULLCONCEPT_DETAIL AS QA_CONDITION_OCCURRENCE_NULLCONCEPT_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_CONDITION_OCCURRENCE_NULLFK_DETAIL AS QA_CONDITION_OCCURRENCE_NULLFK_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_CONDITION_OCCURRENCE_VISITDATEDISPARITY_DETAIL AS QA_CONDITION_OCCURRENCE_VISITDATEDISPARITY_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_CONDITION_OCCURRENCE_ZEROCONCEPT_DETAIL AS QA_CONDITION_OCCURRENCE_ZEROCONCEPT_DETAIL

--DEATH
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_DEATH_DUPLICATES_DETAIL AS QA_DEATH_DUPLICATES_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_DEATH_NULL_CONCEPT_DETAIL AS QA_DEATH_NULL_CONCEPT_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_DEATH_ZERO_CONCEPT_DETAIL AS QA_DEATH_ZERO_CONCEPT_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_DEATH_NULL_DEATHDATE_DETAIL AS QA_DEATH_NULL_DEATHDATE_DETAIL

--DEVICE_EXPOSURE
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_DEVICE_CONCEPT_DUPLICATES_DETAIL AS QA_DEVICE_CONCEPT_DUPLICATES_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_DEVICE_EXPOSURE_DATEVDATETIME_DETAIL AS QA_DEVICE_EXPOSURE_DATEVDATETIME_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_DEVICE_EXPOSURE_END_BEFORE_START_DETAIL AS QA_DEVICE_EXPOSURE_END_BEFORE_START_DETAIL

UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_DEVICE_EXPOSURE_NONSTANDARD_DETAIL AS QA_DEVICE_EXPOSURE_NONSTANDARD_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_DEVICE_EXPOSURE_NOVISIT_DETAIL AS QA_DEVICE_EXPOSURE_NOVISIT_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_DEVICE_EXPOSURE_NULLFK_DETAIL AS QA_DEVICE_EXPOSURE_NULLFK_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_DEVICE_EXPOSURE_NULL_CONCEPT_DETAIL AS QA_DEVICE_EXPOSURE_NULL_CONCEPT_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_DEVICE_EXPOSURE_ZERO_CONCEPT_DETAIL AS QA_DEVICE_EXPOSURE_ZERO_CONCEPT_DETAIL

--DRUG_EXPOSURE
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_DRUG_30AFTERDEATH_DETAIL AS QA_DRUG_30AFTERDEATH_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_DRUG_EXPOSURE_DATEVDATETIME_DETAIL AS QA_DRUG_EXPOSURE_DATEVDATETIME_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_DRUG_EXPOSURE_DUPLICATES_DETAIL AS QA_DRUG_EXPOSURE_DUPLICATES_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_DRUG_EXPOSURE_END_BEFORE_START_DETAIL AS QA_DRUG_EXPOSURE_END_BEFORE_START_DETAIL

UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_DRUG_EXPOSURE_NONSTANDARD_DETAIL AS QA_DRUG_EXPOSURE_NONSTANDARD_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_DRUG_EXPOSURE_NOVISIT_DETAIL AS QA_DRUG_EXPOSURE_NOVISIT_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_DRUG_EXPOSURE_NULLCONCEPT_DETAIL AS QA_DRUG_EXPOSURE_NULLCONCEPT_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_DRUG_EXPOSURE_NULLFK_DETAIL AS QA_DRUG_EXPOSURE_NULLFK_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_DRUG_EXPOSURE_VISITDATEDISPARITY_DETAIL AS QA_DRUG_EXPOSURE_VISITDATEDISPARITY_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_DRUG_EXPOSURE_ZEROCONCEPT_DETAIL AS QA_DRUG_EXPOSURE_ZEROCONCEPT_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_DRUG_EXPOSURE_INGREDIENTCLASS_DETAIL AS QA_DRUG_EXPOSURE_INGREDIENTCLASS_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_DRUG_EXPOSURE_POS_DUP_DRUG_SOURCE_VALUE_DETAIL AS QA_DRUG_EXPOSURE_POS_DUP_DRUG_SOURCE_VALUE_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_DRUG_EXPOSURE_POS_DUP_PROVIDER_ID_DETAIL AS QA_DRUG_EXPOSURE_POS_DUP_PROVIDER_ID_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_DRUG_EXPOSURE_POS_DUP_REFILLS_DETAIL AS QA_DRUG_EXPOSURE_POS_DUP_REFILLS_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_DRUG_EXPOSURE_POS_DUP_STOP_REASON_DETAIL AS QA_DRUG_EXPOSURE_POS_DUP_STOP_REASON_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_DRUG_EXPOSURE_POS_DUP_VERBATIM_END_DATE_DETAIL AS QA_DRUG_EXPOSURE_POS_DUP_VERBATIM_END_DATE_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_DRUG_EXPOSURE_POS_DUP_VISIT_OCCURRENCE_ID_DETAIL AS QA_DRUG_EXPOSURE_POS_DUP_VISIT_OCCURRENCE_ID_DETAIL


--LOCATION
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_LOCATION_DUPLICATES_DETAIL AS QA_LOCATION_DUPLICATES_DETAIL

--MEASUREMENT
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_MEASUREMENT_30AFTERDEATH_DETAIL AS QA_MEASUREMENT_30AFTERDEATH_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_MEASUREMENT_DATEVDATETIME_DETAIL AS QA_MEASUREMENT_DATEVDATETIME_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_MEASUREMENT_DUPLICATES_DETAIL AS QA_MEASUREMENT_DUPLICATES_DETAIL

UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_MEASUREMENT_NONSTANDARD_DETAIL AS QA_MEASUREMENT_NONSTANDARD_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_MEASUREMENT_NOVISIT_DETAIL AS QA_MEASUREMENT_NOVISIT_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_MEASUREMENT_NULLCONCEPT_DETAIL AS QA_MEASUREMENT_NULLCONCEPT_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_MEASUREMENT_NULLFK_DETAIL AS QA_MEASUREMENT_NULLFK_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_MEASUREMENT_VISITDATEDISPARITY_DETAIL AS QA_MEASUREMENT_VISITDATEDISPARITY_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_MEASUREMENT_ZEROCONCEPT_DETAIL AS QA_MEASUREMENT_ZEROCONCEPT_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_MEASUREMENT_POS_DUP_LOW_HIGH_DETAIL AS QA_MEASUREMENT_POS_DUP_LOW_HIGH_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_MEASUREMENT_POS_DUP_MEASUREMENT_SOURCE_VALUE_DETAIL AS QA_MEASUREMENT_POS_DUP_MEASUREMENT_SOURCE_VALUE_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_MEASUREMENT_POS_DUP_PROVIDER_DETAIL AS QA_MEASUREMENT_POS_DUP_PROVIDER_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_MEASUREMENT_POS_DUP_UNIT_CONCEPT_ID_DETAIL AS QA_MEASUREMENT_POS_DUP_UNIT_CONCEPT_ID_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_MEASUREMENT_POS_DUP_VALUE_SOURCE_VALUE_DETAIL AS QA_MEASUREMENT_POS_DUP_VALUE_SOURCE_VALUE_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_MEASUREMENT_POS_DUP_VISIT_OCCURRENCE_DETAIL AS QA_MEASUREMENT_POS_DUP_VISIT_OCCURRENCE_DETAIL

--NOTE
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_NOTE_DATEVDATETIME_DETAIL AS QA_NOTE_DATEVDATETIME_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_NOTE_DUPLICATES_DETAIL AS QA_NOTE_DUPLICATES_DETAIL
-- 
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_NOTE_NONSTANDARD_DETAIL AS QA_NOTE_NONSTANDARD_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_NOTE_NOVISIT_DETAIL AS QA_NOTE_NOVISIT_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_NOTE_NULLCONCEPT_DETAIL AS QA_NOTE_NULLCONCEPT_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_NOTE_NULLFK_DETAIL AS QA_NOTE_NULLFK_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_NOTE_ZEROCONCEPT_DETAIL AS QA_NOTE_ZEROCONCEPT_DETAIL

--OBSERVATION
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_OBSERVATION_30AFTERDEATH_DETAIL AS QA_OBSERVATION_30AFTERDEATH_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_OBSERVATION_DATEVDATETIME_DETAIL AS QA_OBSERVATION_DATEVDATETIME_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_OBSERVATION_DUPLICATES_DETAIL AS QA_OBSERVATION_DUPLICATES_DETAIL

UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_OBSERVATION_NONSTANDARD_DETAIL AS QA_OBSERVATION_NONSTANDARD_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_OBSERVATION_NOVISIT_DETAIL AS QA_OBSERVATION_NOVISIT_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_OBSERVATION_NULLCONCEPT_DETAIL AS QA_OBSERVATION_NULLCONCEPT_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_OBSERVATION_NULLFK_DETAIL AS QA_OBSERVATION_NULLFK_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_OBSERVATION_VISITDATEDISPARITY_DETAIL AS QA_OBSERVATION_VISITDATEDISPARITY_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_OBSERVATION_ZEROCONCEPT_DETAIL AS QA_OBSERVATION_ZEROCONCEPT_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_OBSERVATION_POS_DUP_PROVIDER_ID_DETAIL AS QA_OBSERVATION_POS_DUP_PROVIDER_ID_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_OBSERVATION_POS_DUP_VISIT_OCCURRENCE_ID_DETAIL AS QA_OBSERVATION_POS_DUP_VISIT_OCCURRENCE_ID_DETAIL

--PERSON
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_PERSON_WO_VISIT_DETAIL AS QA_PERSON_WO_VISIT_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_PERSON_AGE_ERR_DETAIL AS QA_PERSON_AGE_ERR_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_PERSON_DUPLICATES_DETAIL AS QA_PERSON_DUPLICATES_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_PERSON_NONSTANDARD_DETAIL AS QA_PERSON_NONSTANDARD_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_PERSON_NULLCONCEPT_DETAIL AS QA_PERSON_NULLCONCEPT_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_PERSON_ZEROCONCEPT_DETAIL AS QA_PERSON_ZEROCONCEPT_DETAIL

--PROCEDURE_OCCURRENCE
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_PROCEDURE_30AFTERDEATH_DETAIL AS QA_PROCEDURE_30AFTERDEATH_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_PROCEDURE_OCCURRENCE_DATEVDATETIME_DETAIL AS QA_PROCEDURE_OCCURRENCE_DATEVDATETIME_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_PROCEDURE_OCCURRENCE_DUPLICATES_DETAIL AS QA_PROCEDURE_OCCURRENCE_DUPLICATES_DETAIL

UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_PROCEDURE_OCCURRENCE_NONSTANDARD_DETAIL AS QA_PROCEDURE_OCCURRENCE_NONSTANDARD_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_PROCEDURE_OCCURRENCE_NOVISIT_DETAIL AS QA_PROCEDURE_OCCURRENCE_NOVISIT_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_PROCEDURE_OCCURRENCE_NULLCONCEPT_DETAIL AS QA_PROCEDURE_OCCURRENCE_NULLCONCEPT_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_PROCEDURE_OCCURRENCE_NULLFK_DETAIL AS QA_PROCEDURE_OCCURRENCE_NULLFK_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_PROCEDURE_OCCURRENCE_VISITDATEDISPARITY_DETAIL AS QA_PROCEDURE_OCCURRENCE_VISITDATEDISPARITY_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_PROCEDURE_OCCURRENCE_ZEROCONCEPT_DETAIL AS QA_PROCEDURE_OCCURRENCE_ZEROCONCEPT_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_PROCEDURE_OCCURRENCE_POS_DUP_PROVIDER_ID_DETAIL AS QA_PROCEDURE_OCCURRENCE_POS_DUP_PROVIDER_ID_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_PROCEDURE_OCCURRENCE_POS_DUP_VISIT_OCCURRENCE_ID_DETAIL AS QA_PROCEDURE_OCCURRENCE_POS_DUP_VISIT_OCCURRENCE_ID_DETAIL

--PROVIDER
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_PROVIDER_DUPLICATES_DETAIL AS QA_PROVIDER_DUPLICATES_DETAIL

UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_PROVIDER_NONSTANDARD_DETAIL AS QA_PROVIDER_NONSTANDARD_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_PROVIDER_NULLFK_DETAIL AS QA_PROVIDER_NULLFK_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_PROVIDER_NULL_CONCEPT_DETAIL AS QA_PROVIDER_NULL_CONCEPT_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_PROVIDER_ZEROCONCEPT_DETAIL AS QA_PROVIDER_ZEROCONCEPT_DETAIL

--SPECIMEN
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_SPECIMEN_DATEVDATETIME_DETAIL AS QA_SPECIMEN_DATEVDATETIME_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_SPECIMEN_DUPLICATES_DETAIL AS QA_SPECIMEN_DUPLICATES_DETAIL

UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_SPECIMEN_NONSTANDARD_DETAIL AS QA_SPECIMEN_NONSTANDARD_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_SPECIMEN_NULLCONCEPT_DETAIL AS QA_SPECIMEN_NULLCONCEPT_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_SPECIMEN_ZEROCONCEPT_DETAIL AS QA_SPECIMEN_ZEROCONCEPT_DETAIL

--VISIT_OCCURRENCE
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_VISIT_30AFTERDEATH_DETAIL AS QA_VISIT_30AFTERDEATH_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_VISIT_DATEVDATETIME_DETAIL AS QA_VISIT_DATEVDATETIME_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_VISIT_OCCURRENCE_DUPLICATES_DETAIL AS QA_VISIT_OCCURRENCE_DUPLICATES_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_VISIT_OCCURRENCE_END_BEFORE_START_DETAIL AS QA_VISIT_OCCURRENCE_END_BEFORE_START_DETAIL

UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_VISIT_OCCURRENCE_NONSTANDARD_DETAIL AS QA_VISIT_OCCURRENCE_NONSTANDARD_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_VISIT_OCCURRENCE_NULLCONCEPT_DETAIL AS QA_VISIT_OCCURRENCE_NULLCONCEPT_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_VISIT_OCCURRENCE_NULLFK_DETAIL AS QA_VISIT_OCCURRENCE_NULLFK_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_VISIT_OCCURRENCE_ZEROCONCEPT_DETAIL AS QA_VISIT_OCCURRENCE_ZEROCONCEPT_DETAIL

--VISIT_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_VISIT_DETAIL_30AFTERDEATH_DETAIL AS QA_VISIT_DETAIL_30AFTERDEATH_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_VISIT_DETAIL_DATEVDATETIME_DETAIL AS QA_VISIT_DETAIL_DATEVDATETIME_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_VISIT_DETAIL_DUPLICATES_DETAIL AS QA_VISIT_DETAIL_DUPLICATES_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_VISIT_DETAIL_END_BEFORE_START_DETAIL AS QA_VISIT_DETAIL_END_BEFORE_START_DETAIL

UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_VISIT_DETAIL_NONSTANDARD_DETAIL AS QA_VISIT_DETAIL_NONSTANDARD_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_VISIT_DETAIL_NULLCONCEPT_DETAIL AS QA_VISIT_DETAIL_NULLCONCEPT_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_VISIT_DETAIL_NULLFK_DETAIL AS QA_VISIT_DETAIL_NULLFK_DETAIL
UNION ALL SELECT  * FROM
CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_VISIT_DETAIL_ZEROCONCEPT_DETAIL AS QA_VISIT_DETAIL_ZEROCONCEPT_DETAIL

/*********************************************************
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Date when QA check was performed
STANDARD_DATA_TABLE: OMOP table being checked
QA_METRIC: Type of quality check performed
METRIC_FIELD: Specific field being evaluated
ERROR_TYPE: Category of error found
CDT_ID: Care site identifier

LOGIC:
------
1. Combines results from all QA check tables using UNION ALL
2. Groups checks by OMOP domain (Care_Site, Condition, Death, etc.)
3. Maintains consistent column structure across all unions
4. Returns all error records for analysis

LEGAL DISCLAIMER:
----------------
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code
is with you. Should the code prove defective, you assume the
cost of all necessary servicing, repair or correction.

*********************************************************/