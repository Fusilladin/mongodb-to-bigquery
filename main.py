from flask import abort
from flask import request
import functions_framework
# from pymongo import MongoClient
import pandas as pd
import pandas_gbq
import json
from google.cloud import storage
from google.cloud import bigquery
from datetime import datetime, timedelta
import os
import time

start_time = datetime.now()

def get_server():
    with open('secret.txt') as file:
        server = file.read()
        return server

project = <project_id>
dataset = <dataset_id>
# client = MongoClient(get_server())

bigquery_client = bigquery.Client(project=project)
dataset_id = f'{project}.{dataset}'
db = client['production']

collection_name_list = {
    'company': [],
    'store': [],
    'user': [],
    'product': [],
    'product_category': [],
    'brand': [],
    'order': [],
    'checkout': [] 
}

def run_time():
    end_time = datetime.now()
    run_time = end_time - start_time
    return run_time

def post_or_get(request):
    if request.method == "GET":
    # if request == "GET":
        return write_to_bigquery_table()
    return abort(405)

def schema_validation():
    
    # production validation
    table_columns = set()
    for coll in collection_name_list:

        # query to get unique keys
        cursor = db[coll].aggregate([
            { "$project": { "arrayOfKeys": { "$objectToArray": "$$ROOT" } } },
            { "$unwind": "$arrayOfKeys" },
            { "$group": { "_id": None, "allKeys": { "$addToSet": "$arrayOfKeys.k" } } }
            ])
        for key_columns in cursor:
            for key in key_columns["allKeys"]:
                column = str(coll) + "." + str(key)
                table_columns.add(column)
    table_columns = sorted(table_columns)

    # split the table and columns names
    for column_reference in table_columns:
        table,column = column_reference.split(".")
        collection_name_list[table].append(column)
    
    # remove unwanted columns
    json_str = json.dumps(collection_name_list,default=str)
    normalized_data = json.loads(json_str)
    pretty_json = json.dumps(normalized_data,indent=4)
    
    return pretty_json

def update_schema_validation():

    # # To update schema validation
    # # /////
    # with open("current_schema.txt","w") as file:
    #     file.write(schema_validation())
    # print("SCHEMA WRITE TO FILE")
    # exit()
    # # /////

    # To read schema as normal
    
    with open("current_schema.txt","r") as file:
        current_schema = file.read()
    return current_schema

def query_mongo():
    for key in list(collection_name_list):
        collection_name_list[key] = {value: [] for value in collection_name_list[key]}
        fields_to_select = []
            
    for table in ["company", "store", "user", "product_category", "brand"]:
        fields_to_select = [column for column in collection_name_list[table]]

        pipeline = [{"$addFields": {field: {"$ifNull": [f"${field}", ""]} for field in fields_to_select}}]
        results = db[table].aggregate(pipeline)

        for doc in results:
            for key in fields_to_select:
                collection_name_list[table][key].append(doc.get(key, ""))    

    for table in ["checkout","order","product"]:
        fields_to_select = [column for column in collection_name_list[table]]
        print(f"{table} : {run_time()}")
        day_increment = 30
        overlap = 1
        pipelines = []
        interval_var_name = "created_at"
        start_date = datetime.strptime("2022-01-01T20:02:59.902+00:00", "%Y-%m-%dT%H:%M:%S.%f%z").replace(tzinfo=None)
        end_date = start_date + timedelta(days=day_increment)
        counter = 0
        while counter < 60:
            
            match_stage = {"$match": {interval_var_name: {"$gte": start_date, "$lt": end_date}}}
            pipeline = [
                match_stage,
                {"$addFields": {field: {"$ifNull": [f"${field}", ""]} for field in fields_to_select}}]

            pipelines.append(pipeline)
            counter += 1
            start_date = end_date - timedelta(days=overlap)
            end_date = start_date + timedelta(days=day_increment)

        unique_documents = {}
        for pipeline in pipelines:
            results = db[table].aggregate(pipeline)
            for doc in results:
                unique_documents[doc["_id"]] = doc

        for doc in unique_documents.values():
            for key in fields_to_select:
                collection_name_list[table][key].append(doc.get(key, ""))  
    return collection_name_list

def remove_private_data(collections): 
    print(f"remove_private_data() : {run_time()}")
    for table in list(collections):
        for column in list(collections[table]):
            try:
                if column.lower() == "api_key":
                    del collections[table][column]
            except:
                pass
    return collections

def mongo_request():
    current_schema = update_schema_validation()
    schema = str(schema_validation())
    current_schema = update_schema_validation()
    
    if str(schema) == str(current_schema):
        print("schema is validated")        
        dict = query_mongo() 
        new_dict = remove_private_data(dict)
        return new_dict,schema
    else:
        raise ValueError("schema validation failed")
        
        # # # unit test
        # # # /////
        # dict = query_mongo() 
        # new_dict = remove_private_data(dict)
        # return new_dict,schema
        # # # /////
    
def write_to_bigquery_table():
    
    # extract data as dict obj
    database = mongo_request()
    db_schema = database[1] 
    database = database[0]
    
    # recreate staging tables
    procedure_name = f"{dataset_id}.procDropRecreateStagingTables"
    call_statement = f"CALL `{procedure_name}`()"
    query_job = bigquery_client.query(call_statement)
    query_job.result()

    for table in database:
        df  = pd.DataFrame(database[table])
        df = df.astype(str)
        pandas_gbq.to_gbq(df, f'{dataset}.{table}', project_id=project, if_exists='replace')
    
    print(f"Successfully Loaded data to BigQuery : {run_time()}")    
    
