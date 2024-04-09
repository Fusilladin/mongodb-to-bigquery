# Project Setup Guide

## Prerequisites

Ensure you have the following software installed on your system:

- **Python 3.11.2**: Download and install from the [official Python website](https://www.python.org/downloads/release/python-3112/).
- **MongoDB**: Download and install from the [official MongoDB website](https://www.mongodb.com/try/download/community).
- **Google Cloud SDK**: Download and install from the [Google Cloud SDK documentation](https://cloud.google.com/sdk/docs/install).

## Configuration

1. **Database and Project IDs**: You must specify your `dataset_id` and `project_id` within the program.
2. **Schema Validation**:
   - Initially, you need to uncomment the function `update_schema_validation()` to write to `current_schema.txt`. This step is crucial for capturing the current schema structure.
   - After the initial schema has been written, comment out the write part of the function. This allows the program to perform read operations on subsequent runs, ensuring the schema is validated with each execution.
3. **Secret Management**:
   - Create a file named `secret.txt` in the root directory of the project. This file should contain your MongoDB URI string, including login credentials, to enable database connections.
4. **Stored Procedures**:
   - You must create and maintain the stored procedure included within this program in your Google Cloud BigQuery console. This procedure is essential for the program's operation and must be updated whenever changes to the schema are made.

## Running the Program

- **Linux Requirements**: I Reccomend a machine with atleast 8GB RAM as my 4GB RAM machine VS Code was crashing, although it was desktop version, so a terminal only linux may be fine on 4GB for now.
- **Execution Time**: The program's runtime is approximately 22 minutes, which exceeds the Google Cloud Function limit of 9 minutes. We recommend hosting this application on an alternative platform, such as an AWS EC2 instance with Airflow, for full automation.
- **Testing**: To facilitate schema updates and validation, remember to manage the `update_schema_validation()` function as described in the Configuration section.


