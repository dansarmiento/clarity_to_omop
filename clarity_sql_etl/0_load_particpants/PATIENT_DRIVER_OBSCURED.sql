/*
Purpose: Create a table with randomly shuffled patient data while maintaining data structure
Author: [Your Name]
Date: [Current Date]

Description:
This query creates a new table PATIENT_DRIVER_OBSCURED by:
1. Creating a CTE with original data plus 12 random row numbers
2. Independently shuffling each column's values using different random numbers
3. Maintaining original data types and structure
4. Breaking correlations between fields while preserving individual value distributions

Source Table: CARE_RES_OMOP_DEV2_WKSP.OMOP.PATIENT_DRIVER
Target Table: PATIENT_DRIVER_OBSCURED
*/

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
        -- Generate 12 different random row numbers for independent column shuffling
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
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PATIENT_DRIVER PATIENT_DRIVER
)
SELECT
    r1.PERSON_ID,          -- Randomly shuffled person ID
    r2.EHR_PATIENT_ID,     -- Randomly shuffled EHR patient ID
    r3.MRN_CPI,           -- Randomly shuffled MRN CPI
    r4.FIRST_NAME,        -- Randomly shuffled first name
    r5.LAST_NAME,         -- Randomly shuffled last name
    r6.DATE_OF_BIRTH,     -- Randomly shuffled date of birth
    r7.SEX,              -- Randomly shuffled sex
    r8.PHONE,            -- Randomly shuffled phone number
    r9.STREET_ADDRESS,    -- Randomly shuffled street address
    r10.CITY,            -- Randomly shuffled city
    r11.ZIP,             -- Randomly shuffled ZIP code
    r12.STATE            -- Randomly shuffled state
    -- r1.EMAIL          -- Commented out email field
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
    JOIN RandomizedData r12 ON r12.rnd11 = r1.rnd12;