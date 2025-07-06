# README.md

# Implementing `clarity_to_omop` with dbt-core and SQL Server

This guide provides a comprehensive implementation plan to build an OMOP Common Data Model (CDM) database on SQL Server and to manage the data import and transformation from an Epic Clarity source using the `clarity_to_omop` dbt project.

## Project Overview & Evaluation

The GitHub repository [`dansarmiento/clarity_to_omop`](https://github.com/dansarmiento/clarity_to_omop) is a **dbt (data build tool) project** designed to transform data from an Epic Clarity database into the OMOP CDM.

* **Purpose:** To provide a standardized, maintainable, and transparent process for the ETL (Extract, Transform, Load) of Clarity data to OMOP.
* **Technology:** It leverages `dbt-core` to manage SQL-based data transformations, bringing software engineering best practices to data analytics.
* **Methodology:** This guide outlines the steps to set up the destination database (OMOP CDM on SQL Server), load the required standard vocabularies, and then use the `clarity_to_omop` dbt project to populate it.

## Table of Contents
* [Part 1: Building the OMOP Database on SQL Server](#part-1-building-the-omop-database-on-sql-server-)
  * [Step 1: Obtain OMOP CDM DDL Scripts](#step-1-obtain-omop-cdm-ddl-scripts)
  * [Step 2: Create the OMOP CDM Schema and Tables](#step-2-create-the-omop-cdm-schema-and-tables)
  * [Step 3: Download and Load the Standard Vocabularies](#step-3-download-and-load-the-standard-vocabularies)
* [Part 2: Managing Data Import with dbt-core](#part-2-managing-data-import-with-dbt-core-)
  * [Step 1: Set Up Your dbt-core Environment](#step-1-set-up-your-dbt-core-environment)
  * [Step 2: Configure Your dbt Profile](#step-2-configure-your-dbt-profile)
  * [Step 3: Clone and Configure the clarity_to_omop Project](#step-3-clone-and-configure-the-clarity_to_omop-project)
  * [Step 4: Run and Test the dbt Project](#step-4-run-and-test-the-dbt-project)

---

## Part 1: Building the OMOP Database on SQL Server 🏗️

This section covers the initial setup of the destination data warehouse.

### Step 1: Obtain OMOP CDM DDL Scripts

The Observational Health Data Sciences and Informatics (OHDSI) organization provides the Data Definition Language (DDL) scripts required to create the OMOP CDM tables.

1.  **Download the DDL:** Get the latest DDL scripts from the [OHDSI CommonDataModel GitHub repository](https://github.com/OHDSI/CommonDataModel). Download the zip file from the "releases" tab.
2.  **Locate SQL Server Scripts:** After unzipping, navigate to the `Sql Server` folder. You will find scripts to create tables, constraints, and indexes.

### Step 2: Create the OMOP CDM Schema and Tables

1.  **Create a New Database:** In your SQL Server instance, create a new, empty database that will host the OMOP CDM.
2.  **Execute DDL Scripts:** Using a tool like SQL Server Management Studio (SSMS), execute the following scripts in the specified order:
    1.  `OMOP CDM ddl - SQL Server.sql` - **Run this first.**
    2.  `OMOP CDM constraints - SQL Server.sql` - **Run this after data is loaded.**
    3.  `OMOP CDM indexes required - SQL Server.sql` - **Run this after data is loaded.**

### Step 3: Download and Load the Standard Vocabularies

This is a critical step for data normalization within the OMOP CDM.

1.  **Download from ATHENA:** Register for a free account at [OHDSI ATHENA](https://athena.ohdsi.org/). Select the vocabularies you need (e.g., SNOMED, LOINC, RxNorm) and download the package.
2.  **Load Vocabulary Tables:** The downloaded zip file from ATHENA contains multiple CSV files (`CONCEPT.csv`, `VOCABULARY.csv`, etc.). You must load these files into their corresponding tables in the OMOP CDM. The **SQL Server Bulk Insert feature** is a highly efficient method for this task.

---

## Part 2: Managing Data Import with dbt-core ⚙️

With the destination database ready, you can now configure `dbt` to perform the data transformation.

### Step 1: Set Up Your dbt-core Environment

1.  **Install Python:** Ensure Python 3.8 or newer is installed.
2.  **Create a Virtual Environment:**
    ```bash
    python -m venv dbt-env
    source dbt-env/bin/activate  # On Windows, use `dbt-env\Scripts\activate`
    ```
3.  **Install dbt-core and the SQL Server Adapter:**
    ```bash
    pip install dbt-core dbt-sqlserver
    ```
4.  **Install ODBC Driver:** Download and install the [Microsoft ODBC Driver for SQL Server](https://docs.microsoft.com/en-us/sql/connect/odbc/download-odbc-driver-for-sql-server).

### Step 2: Configure Your dbt Profile

The `profiles.yml` file stores your database connection details. This file should be placed in your `~/.dbt/` folder.

Create `profiles.yml` with the following content, updating the placeholders with your credentials:

```yaml
# profiles.yml

clarity_to_omop:
  target: dev
  outputs:
    dev:
      type: sqlserver
      driver: 'ODBC Driver 18 for SQL Server' # Or your installed version
      server: your_sql_server_name
      port: 1433
      database: your_omop_database_name
      schema: dbo
      user: your_username
      password: your_password

### Step 3: Clone and Configure the clarity_to_omop Project

1.  **Clone the Repository:**
    ```bash
    git clone [https://github.com/dansarmiento/clarity_to_omop.git](https://github.com/dansarmiento/clarity_to_omop.git)
    cd clarity_to_omop
    ```
2.  **Review `dbt_project.yml`:** Open the `dbt_project.yml` file in the cloned directory. Ensure the `profile` name listed in this file matches the one you created in `profiles.yml` (e.g., `clarity_to_omop`).

### Step 4: Run and Test the dbt Project

From within the `clarity_to_omop` project directory, execute the following commands.

1.  **Test the Connection:**
    ```bash
    dbt debug
    ```
    If successful, dbt can connect to your SQL Server database.

2.  **Run the dbt Models:**
    ```bash
    dbt run
    ```
    This command will execute all transformation models in the project, populating your OMOP CDM tables with data from your Clarity source.

3.  **Test the Data:**
    ```bash
    dbt test
    ```
    This command runs any data quality tests defined in the project to help validate the output.
