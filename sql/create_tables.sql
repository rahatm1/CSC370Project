CREATE TABLE Airline (
    air_name VARCHAR(255),
    code CHAR(4) PRIMARY KEY,
    website VARCHAR(255)
);

CREATE TABLE Route (
    r_number INT CHECK(r_number < 10000) PRIMARY KEY
);

CREATE TABLE flight (
    plane_model CHAR(20),
    code CHAR(4),
    r_number INT,
    FOREIGN KEY(code) REFERENCES Airline(code),
    FOREIGN KEY(r_number) REFERENCES Route(r_number) ON DELETE CASCADE
);

CREATE TABLE Outgoing (
    destination VARCHAR(255),
    outT DATE,
    r_number INT PRIMARY KEY REFERENCES Route(r_number) ON DELETE CASCADE
);

CREATE TABLE Incoming (
    origin VARCHAR(255),
    incT DATE,
    r_number INT PRIMARY KEY REFERENCES Route(r_number) ON DELETE CASCADE
);

CREATE TABLE Departure (
    depID INT PRIMARY KEY,
    gate CHAR(3),
    depT Date,
    r_number INT REFERENCES Outgoing(r_number) ON DELETE CASCADE
);

CREATE TABLE Arrival (
    arrID INT PRIMARY KEY,
    gate CHAR(3),
    arrT Date,
    r_number INT REFERENCES Incoming(r_number) ON DELETE CASCADE
);

CREATE TABLE Gates (
    gate CHAR(3) PRIMARY KEY,
    is_free CHAR(1)
);

CREATE TABLE GateDep (
    depID INT REFERENCES Departure(depID),
    gate CHAR(3) REFERENCES Gates(gate)
);

CREATE TABLE GateArr (
    arrID INT REFERENCES Arrival(arrID),
    gate CHAR(3) REFERENCES Gates(gate)
);

CREATE TABLE Passengers (
    passenger_name VARCHAR(255),
    dob VARCHAR(20),
    birth_place VARCHAR(255),
    passID CHAR(20) PRIMARY KEY
);

CREATE TABLE Baggage (
    baggageID CHAR(20) PRIMARY KEY,
    passID CHAR(20) REFERENCES Passengers(passID),
    num_baggage INT
);

CREATE TABLE Travel (
    tID INT PRIMARY KEY,
    freshID INT,
    depID INT REFERENCES Departure(depID),
    arrID INT REFERENCES Arrival(arrID),
    passID CHAR(20) REFERENCES Passengers(passID)
);
