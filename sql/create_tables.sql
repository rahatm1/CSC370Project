CREATE TABLE Airline (
    name VARCHAR(255),
    acode CHAR(4) PRIMARY KEY,
    website VARCHAR(255)
);

CREATE TABLE Route (
    rnum INT CHECK(rnum < 10000) PRIMARY KEY,
    planemodel CHAR(30)
);

CREATE TABLE Operate (
    acode CHAR(4),
    rnum INT,
    FOREIGN KEY(acode) REFERENCES Airline(acode),
    FOREIGN KEY(rnum) REFERENCES Route(rnum) ON DELETE CASCADE
);

CREATE TABLE OutgoingRoutes (
    destination VARCHAR(255),
    outT DATE,
    rnum INT PRIMARY KEY REFERENCES Route(rnum) ON DELETE CASCADE
);

CREATE TABLE IncomingRoutes (
    source VARCHAR(255),
    incT DATE,
    rnum INT PRIMARY KEY REFERENCES Route(rnum) ON DELETE CASCADE
);

CREATE TABLE Departure (
    depID INT PRIMARY KEY,
    DepT Date,
    rnum INT REFERENCES Outgoing(rnum) ON DELETE CASCADE
);

CREATE TABLE Arrival (
    arrID INT PRIMARY KEY,
    arrT Date,
    rnum INT REFERENCES Incoming(rnum) ON DELETE CASCADE
);

CREATE TABLE Gates (
    gate CHAR(3) PRIMARY KEY,
    is_free CHAR(1) check (is_free in ('y', 'n'))
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
    pID INT,
    name VARCHAR(255),
    dob DATE,
    pob VARCHAR(255),
    gov_issued_id CHAR(20) PRIMARY KEY,
    DP INT REFERENCES Departure(depID),
    AP INT REFERENCES Arrival(arrID)
);

CREATE TABLE Baggage (
    bID INT PRIMARY KEY,
    weight NUMBER,
    pID CHAR(20) REFERENCES Passengers(passID)
);
