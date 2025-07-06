
# Clinical Notes ETL Documentation

## Data Flow Summary
The code processes clinical notes from multiple sources and transforms them into the OMOP CDM `Note` table format. The flow consists of:

- Pulling raw notes data from source tables
- Staging the data with appropriate transformations
- Loading into final OMOP `Note` tables

## PULL Queries

### 1. PULL_NOTE_AMB_ALL
Pulls ambulatory notes
- Sources from `HNO_INFO`, `NOTE_ENC_INFO`, and related tables
- Filters for ambulatory encounters
- Key fields: `person_id`, `note_date`, `note_text`, provider info

### 2. PULL_NOTE_ANES_ALL
Pulls anesthesia-related notes
- Joins anesthesia records with hospital encounters
- Includes additional anesthesia-specific fields
- Filters for anesthesia encounters (type 52)

### 3. PULL_NOTE_HOSP_ALL
Pulls hospital/inpatient notes
- Links hospital accounts and provider information
- Includes hospital-specific note types and classifications

## STAGE Queries

### 1. STAGE_NOTE_AMB
Stages ambulatory notes for OMOP format
- Adds note classification mappings
- Sets encoding and language concepts
- Links to visits and providers

### 2. STAGE_NOTE_ANES
Stages anesthesia notes
- Similar structure to ambulatory staging
- Includes anesthesia-specific note classes

### 3. STAGE_NOTE_HSP
Stages hospital/inpatient notes
- Handles hospital-specific note types
- Links to hospital visits and providers

## NOTE_RAW Query
Combines all staged notes (AMB, ANES, HSP)
- Assigns unique note IDs
- Adds source reference fields
- Includes PHI-related fields
- Maintains links to source systems

## NOTE Query
Final filtered view of `NOTE_RAW`
- Excludes records with fatal/invalid data errors
- Presents notes in OMOP CDM format
- Includes both standard OMOP fields and custom fields
- Maintains traceability to source data

The ETL process carefully handles note metadata while currently masking actual note text content for PHI protection ("NO_TEXT" placeholder used).

