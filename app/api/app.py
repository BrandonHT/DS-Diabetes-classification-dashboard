
from flask import Flask, request
import json
import psycopg2
import psycopg2.extras
import os
import logging
import pickle
from sklearn.linear_model import LogisticRegression
import pandas as pd

# Estructura del uri:
# "motor://user:password@host:port/database"
database_uri = f'postgresql://{os.environ["PGUSR"]}:{os.environ["PGPASS"]}@{os.environ["PGHOST"]}:5432/{os.environ["PGDB"]}'

app = Flask(__name__)
conn = psycopg2.connect(database_uri)

# Definition of columns from the database to be used in the prediction
columns = ['pregnancies', 'glucose', 'bloodpressure', 'skinthickness', 'insulin',
            'bmi', 'diabetespedigreefunction', 'age']

# -- Method goal: Endpoint to check whether the API is working or not
@app.route('/health_check', methods=['GET'])
def health_check():
    '''
        Description: Return a single message if the API es working
    '''
    return "API is alive! :)"

# -- Method goal : Get all information from the diabetes table
# --  Dasboard section : Data overview
@app.route('/', methods=['GET'])
def home():
    '''
        Description: Create the cursor to connect with postgres, execute the select query
                     and return the result in a json format.
    '''
    cur = conn.cursor(cursor_factory=psycopg2.extras.NamedTupleCursor)
    cur.execute(f"select * from diabetes")
    results = cur.fetchall()
    cur.close()
    return json.dumps([x._asdict() for x in results], default=str)

# -- Method goal : Get the number of registers of the diabetes table
# -- Not used by the Dashboard, just for control 
@app.route('/count')
def count():
    '''
        Description: Create the cursor to connect with postgres, execute the select query
                     including the aggregate *count*, and return the result in a json format.
    '''
    cur = conn.cursor(cursor_factory=psycopg2.extras.NamedTupleCursor)
    cur.execute("select count(*) from diabetes")
    results = cur.fetchall()
    cur.close()
    return json.dumps([x._asdict() for x in results], default=str)

# -- CRUD methods
@app.route('/crud', methods=["POST", "GET", "DELETE", "PATCH"])
def crud():
    # -- Method goal : Get info from an especific ID 
    # --  Dasboard section : Search 
    if request.method == 'GET':
        '''
        Description: Create the cursor to connect with postgres, get the arg *id* from the request, 
                     execute the select query including the condition by the *id*, and finally return 
                     the result in a json format.
        '''
        cur = conn.cursor(cursor_factory=psycopg2.extras.NamedTupleCursor)
        observation_id = request.args.get("id")
        cur.execute(f"select * from diabetes where id={observation_id}")
        results = cur.fetchone()
        cur.close()
        if results:
            return json.dumps(results._asdict(), default=str)
        
    # -- Method goal : Add a new observation 
    # --  Dasboard section : Add
    if request.method == "POST":
        '''
        Description: First load the data from the request, then create the cursor to connect with postgres, 
                     after that execute the insert query using the data collected, and finally get the id 
                     associated to the new observation and return it in json format. 
        '''
        new_observation = json.loads(request.data)
        cur = conn.cursor()
        cur.execute(
            "insert into diabetes (pregnancies,glucose,bloodpressure,skinthickness,insulin,bmi,diabetespedigreefunction,age,outcome) values (%s, %s, %s, %s, %s, %s, %s, %s, %s)",
            (new_observation[0]["pregnancies"], new_observation[0]["glucose"], new_observation[0]["bloodpressure"], new_observation[0]["skinthickness"], new_observation[0]["insulin"], new_observation[0]["bmi"], new_observation[0]["diabetespedigreefunction"], new_observation[0]["age"], new_observation[0]["outcome"]),
        )
        conn.commit()
        cur.execute("SELECT LASTVAL()")
        observation_id = cur.fetchone()[0]
        logging.info(observation_id)
        cur.close()
        return json.dumps({"ID": observation_id})
        
    # -- Method goal : Delete an observation 
    # --  Dasboard section : Delete     
    if request.method == "DELETE":
        '''
        Description: First get the arg *id* from the request, then create the cursor to connect with postgres, 
                     after that execute the delete query by the condition *id*, and finally return the 
                     id deleted in json format. 
        '''
        observation_id = request.args.get("id")
        cur = conn.cursor()
        cur.execute(f"delete from diabetes where id={observation_id}")
        conn.commit()
        cur.close()
        return json.dumps({"ID": observation_id})
        
    # -- Method goal : Update an observation 
    # --  Dasboard section : Update
    if request.method == "PATCH":
        '''
        Description: First get the data and the arg *id* from the request, then create the cursor to connect 
                     with postgres, after that execute the update query by the condition *id*, and finally 
                     return the id updated in json format. 
        '''
        user = json.loads(request.data)
        observation_id = request.args.get("id")
        cur = conn.cursor()
        cur.execute(
            "update diabetes set (pregnancies,glucose,bloodpressure,skinthickness,insulin,bmi,diabetespedigreefunction,age,outcome) = (%s, %s, %s, %s, %s, %s, %s, %s, %s) where id=%s",
            (user[0]["pregnancies"], user[0]["glucose"], user[0]["bloodpressure"], user[0]["skinthickness"], user[0]["insulin"], user[0]["bmi"], user[0]["diabetespedigreefunction"], user[0]["age"], user[0]["outcome"], observation_id),
        )
        conn.commit()
        cur.close()
        return json.dumps({"ID": observation_id})

# -- Method goal : Predict whether a new observation would have diabetes based on the
#                  values of the variables
# --  Dasboard section : Predict
@app.route('/predict', methods=['POST'])
def predict_function():
    '''
        Description: First load a pretrained model (logistic regression), then load the data from the request,
                     create a dataframe using the data collected, and finally predict the diabetes using the 
                     dataframe created and the model loaded. As a result, return the class: 1 diabetes, 0 no diabetes.   
    '''
    file_name = "log_reg.pkl"
    log_reg = pickle.load(open(f"/app/models/{file_name}", "rb"))
    data = json.loads(request.data)[0] 
    observation = pd.DataFrame(
            data=[[
                    data["pregnancies"],
                    data["glucose"],
                    data["bloodpressure"],
                    data["skinthickness"],
                    data["insulin"],
                    data["bmi"],
                    data["diabetespedigreefunction"],
                    data["age"]
                ]], 
            columns=columns
    )
    res = log_reg.predict(observation)
    return json.dumps({"outcome": int(res[0])})

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True, port=8080)