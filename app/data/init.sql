create table diabetes(
    ID serial,
    Pregnancies int,
    Glucose int,
    BloodPressure int,
    SkinThickness int,
    Insulin int,
    BMI float,
    DiabetesPedigreeFunction float,
    Age int,
    Outcome int
);
COPY diabetes(Pregnancies, Glucose, BloodPressure, SkinThickness, Insulin, BMI, DiabetesPedigreeFunction, Age, Outcome)
FROM '/data/diabetes.csv' 
DELIMITER ',' 
CSV HEADER
NULL as 'NA';
