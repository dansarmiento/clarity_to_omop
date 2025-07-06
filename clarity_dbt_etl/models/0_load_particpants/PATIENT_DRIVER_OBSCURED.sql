--This code:
--
--Creates a CTE (RandomizedData) that includes all the original columns plus 12 random row numbers
--For each field, uses a different random row number to select values
--Creates the new table PATIENT_DRIVER_OBSCURED with the randomly shuffled values
--Maintains the same data types and structure as the original table
--Ensures each column's values are randomly redistributed independently of other columns
--The result will be a table with the same number of rows as the original, but with values randomly shuffled within each column. Each column is shuffled independently, breaking any correlations between fields in the original data.

--PATIENT_DRIVER_OBSCURED
{{ config(materialized = 'table') }}
WITH RandomizedData AS (
  SELECT
  	PERSON_ID,
    EHR_PATIENT_ID,
    MRN_CPI,
    FIRST_NAME,
    LAST_NAME,
    DATE_OF_BIRTH,
    SEX,
    PHONE,
    STREET_ADDRESS,
    CITY,
    ZIP,
    STATE,
    EMAIL,
    ROW_NUMBER() OVER (ORDER BY RANDOM()) as rnd1,
    ROW_NUMBER() OVER (ORDER BY RANDOM()) as rnd2,
    ROW_NUMBER() OVER (ORDER BY RANDOM()) as rnd3,
    ROW_NUMBER() OVER (ORDER BY RANDOM()) as rnd4,
    ROW_NUMBER() OVER (ORDER BY RANDOM()) as rnd5,
    ROW_NUMBER() OVER (ORDER BY RANDOM()) as rnd6,
    ROW_NUMBER() OVER (ORDER BY RANDOM()) as rnd7,
    ROW_NUMBER() OVER (ORDER BY RANDOM()) as rnd8,
    ROW_NUMBER() OVER (ORDER BY RANDOM()) as rnd9,
    ROW_NUMBER() OVER (ORDER BY RANDOM()) as rnd10,
    ROW_NUMBER() OVER (ORDER BY RANDOM()) as rnd11,
    ROW_NUMBER() OVER (ORDER BY RANDOM()) as rnd12
  FROM {{ ref('PATIENT_DRIVER')}} PATIENT_DRIVER
)
SELECT
  r1.PERSON_ID,
  r2.EHR_PATIENT_ID,
  r3.MRN_CPI,
  r4.FIRST_NAME,
  r5.LAST_NAME,
  r6.DATE_OF_BIRTH,
  r7.SEX,
  r8.PHONE,
  r9.STREET_ADDRESS,
  r10.CITY,
  r11.ZIP,
  r12.STATE,
--   r1.EMAIL
FROM RandomizedData r1
JOIN RandomizedData r2 ON r2.rnd1 = r1.rnd2
JOIN RandomizedData r3 ON r3.rnd2 = r1.rnd3
JOIN RandomizedData r4 ON r4.rnd3 = r1.rnd4
JOIN RandomizedData r5 ON r5.rnd4 = r1.rnd5
JOIN RandomizedData r6 ON r6.rnd5 = r1.rnd6
JOIN RandomizedData r7 ON r7.rnd6 = r1.rnd7
JOIN RandomizedData r8 ON r8.rnd7 = r1.rnd8
JOIN RandomizedData r9 ON r9.rnd8 = r1.rnd9
JOIN RandomizedData r10 ON r10.rnd9 = r1.rnd10
JOIN RandomizedData r11 ON r11.rnd10 = r1.rnd11
JOIN RandomizedData r12 ON r12.rnd11 = r1.rnd12
