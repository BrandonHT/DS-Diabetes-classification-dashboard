
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

columns = ['pregnancies', 'glucose', 'bloodpressure', 'skinthickness', 'insulin',
            'bmi', 'diabetespedigreefunction', 'age']

@app.route('/health_check')
def health_check():
    return "API is alive! :)"

@app.route('/count')
def count():
    cur = conn.cursor(cursor_factory=psycopg2.extras.NamedTupleCursor)
    cur.execute("select count(*) from diabetes")
    results = cur.fetchall()
    cur.close()
    return json.dumps([x._asdict() for x in results], default=str)

# -- Method goal : Get all information from the diabetes DB 
# --  Dasboard section : Data overview
@app.route('/', methods=['GET'])
def home():
    cur = conn.cursor(cursor_factory=psycopg2.extras.NamedTupleCursor)
    cur.execute(f"select * from diabetes")
    results = cur.fetchall()
    cur.close()
    return json.dumps([x._asdict() for x in results], default=str)

# -- CRUD methods
@app.route('/crud', methods=["POST", "GET", "DELETE", "PATCH"])
def crud():
    # -- Method goal : Get info from an especific ID 
    # --  Dasboard section : Search 
    if request.method == 'GET':
        cur = conn.cursor(cursor_factory=psycopg2.extras.NamedTupleCursor)
        observation_id = request.args.get("id")
        # observation_id = json.loads(request.data)
        cur.execute(f"select * from diabetes where id={observation_id}")
        results = cur.fetchone()
        cur.close()
        if results:
            return json.dumps(results._asdict(), default=str)
        
    # -- Method goal : Add a new observation 
    # --  Dasboard section : Add
    if request.method == "POST":
        new_observation = json.loads(request.data)
        logging.info(new_observation)
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
        cur = conn.cursor()
        observation_id = request.args.get("id")
        cur.execute(f"delete from diabetes where id={observation_id}")
        conn.commit()
        cur.close()
        return json.dumps({"ID": observation_id})
        
    # -- Method goal : Update an observation 
    # --  Dasboard section : Update
    if request.method == "PATCH":
        user = json.loads(request.data)
        cur = conn.cursor()
        observation_id = request.args.get("id")
        cur.execute(
            "update diabetes set (pregnancies,glucose,bloodpressure,skinthickness,insulin,bmi,diabetespedigreefunction,age,outcome)) = (%s, %s, %s, %s, %s, %s, %s, %s, %s) where id=%s",
            (user[0]["pregnancies"], user[0]["glucose"], user[0]["bloodpressure"], user[0]["skinthickness"], user[0]["insulin"], user[0]["bmi"], user[0]["diabetespedigreefunction"], user[0]["age"], user[0]["outcome"], observation_id),
        )
        conn.commit()
        cur.close()
        return json.dumps({"ID": observation_id})

@app.route('/predict', methods=['POST'])
def predict_function():
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