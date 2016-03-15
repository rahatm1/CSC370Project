CREATE TABLE Airline (
    air_name VARCHAR(255),
    code CHAR(4) PRIMARY KEY,
    website VARCHAR(255)
);

CREATE TABLE Route (
    r_number INT CHECK(r_number < 10000) PRIMARY KEY
    ON DELETE CASCADE
);

CREATE TABLE flight (
    plane_model CHAR(20),
    code CHAR(4),
    r_number INT,
    FOREIGN KEY(code) REFERENCES Airline(code),
    FOREIGN KEY(r_number) REFERENCES Route(r_number)
);

CREATE TABLE Outgoing (
    destination VARCHAR(255),
    outT DATE,
    r_number INT PRIMARY KEY REFERENCES Route(r_number)
);

CREATE TABLE Incoming (
    origin VARCHAR(255),
    incT DATE,
    r_number INT PRIMARY KEY REFERENCES Route(r_number)
);

CREATE TABLE Departure (
    depID INT PRIMARY KEY,
    gate CHAR(3),
    depDate Date,
    DepT Date
);

CREATE TABLE Arrival (
    arrID INT PRIMARY KEY,
    gate CHAR(3),
    arrDate Date,
    arrT Date
);

CREATE TABLE Passengers (
    passenger_name VARCHAR(255),
    dob DATE,
    birth_place VARCHAR(255),
    passId CHAR(20) PRIMARY KEY
);

CREATE TABLE Baggage (
    baggageID INT PRIMARY KEY,
    passID CHAR(20) REFERENCES Passengers(passID)
);