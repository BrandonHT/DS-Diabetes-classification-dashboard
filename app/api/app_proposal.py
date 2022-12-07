
from flask import Flask, request
import json
import psycopg2
import psycopg2.extras
import os
# Estructura del uri:
# "motor://user:password@host:port/database"
database_uri = f'postgresql://{os.environ["PGUSR"]}:{os.environ["PGPASS"]}@{os.environ["PGHOST"]}:5432/{os.environ["PGDB"]}'

app = Flask(__name__)
conn = psycopg2.connect(database_uri)


# -- Method goal : Get all information from the diabetes DB 
# --  Dasboard section : Data overview
@app.route('/diabetes', methods=['GET'])
def flights():
    cur = conn.cursor(cursor_factory=psycopg2.extras.NamedTupleCursor)
    cur.execute(f"select * from diabetes ")
    results = cur.fetchall()
    cur.close()
    return json.dumps([x._asdict() for x in results], default=str)

# -- CRUD methods
@app.route('/users', methods=["POST", "GET", "DELETE", "PATCH"])
def user():
    # -- Method goal : Get info from an especific ID 
    # --  Dasboard section : Search 
    if request.method == 'GET':
        cur = conn.cursor(cursor_factory=psycopg2.extras.NamedTupleCursor)
        observation_id = request.args.get("ID")
        cur.execute(f"select * from diabetes where ID={observation_id}")
        results = cur.fetchone()
        cur.close()
        return json.dumps(results._asdict(), default=str)
        
    # -- Method goal : Add a new observation 
    # --  Dasboard section : Add
    if request.method == "POST":
        user = json.loads(request.data)
        cur = conn.cursor()
        cur.execute(
            "insert into diabetes (Pregnancies,Glucose, BloodPressure,SkinThickness,Insulin,BMI,DiabetesPedigreeFunction,Age,Outcome) values (%s, %s, %s, %s, %s, %s, %s, %s, %s)",
            (user[0]["Pregnancies"], user[0]["Glucose"], user[0]["BloodPressure"], user[0]["SkinThickness"], user[0]["Insulin"], user[0]["BMI"], user[0]["DiabetesPedigreeFunction"], user[0]["Age"], user[0]["Outcome"]),
        )
        conn.commit()
        cur.execute("SELECT LASTVAL()")
        observation_id = cur.fetchone()[0]
        cur.close()
        return json.dumps({"ID": observation_id})
        
    # -- Method goal : Delete an observation 
    # --  Dasboard section : Delete     
    if request.method == "DELETE":
        cur = conn.cursor()
        observation_id = request.args.get("id")
        cur.execute(f"delete from users where id={observation_id}")
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
            "update diabetes set (Pregnancies,Glucose, BloodPressure,SkinThickness,Insulin,BMI,DiabetesPedigreeFunction,Age,Outcome)) = (%s, %s, %s, %s, %s, %s, %s, %s, %s) where id=%s ",
            (user[0]["Pregnancies"], user[0]["Glucose"], user[0]["BloodPressure"], user[0]["SkinThickness"], user[0]["Insulin"], user[0]["BMI"], user[0]["DiabetesPedigreeFunction"], user[0]["Age"], user[0]["Outcome"], observation_id_id),
        )
        conn.commit()
        cur.close()
        return json.dumps({"ID": observation_id})




if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True, port=8080)