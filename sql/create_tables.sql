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

CREATE TABLE Gates (
    gate CHAR(3) PRIMARY KEY,
    is_free CHAR(1) check (is_free in ('y', 'n'))
);

CREATE TABLE Departure (
    depID INT PRIMARY KEY,
    depT Date,
    rnum INT REFERENCES OutgoingRoutes(rnum) ON DELETE CASCADE,
    gate CHAR(3) REFERENCES Gates(gate)
);

CREATE TABLE Arrival (
    arrID INT PRIMARY KEY,
    arrT DATE,
    rnum INT REFERENCES IncomingRoutes(rnum) ON DELETE CASCADE,
    gate CHAR(3) REFERENCES Gates(gate)
);

CREATE TABLE Passengers (
    pID INT PRIMARY KEY,
    name VARCHAR(255),
    dob DATE,
    pob VARCHAR(255),
    gov_issued_id CHAR(20),
    DP INT REFERENCES Departure(depID),
    AP INT REFERENCES Arrival(arrID)
);

CREATE TABLE Baggage (
    bID INT PRIMARY KEY,
    weight NUMBER,
    passID INT REFERENCES Passengers(pID)
);

CREATE OR REPLACE VIEW ConnectingPassengers AS
  SELECT pID, name, dob, pob, gov_issued_id, DP, AP
  FROM Passengers
  WHERE NOT EXISTS(
    SELECT *
    FROM (SELECT arrID, depID
          FROM (Arrival Join INCOMINGROUTES USING (rnum)),
            (Departure Join OutgoingRoutes USING(rnum))
            WHERE (outT-incT)*24>12
            OR (outT-incT)*24<1)
    WHERE AP=arrID AND DP=depID
  )
WITH CHECK OPTION;

-- Advanced Constraints

-- i) No passenger can be associated with more than two flights, which have to be connecting flights.
CREATE OR REPLACE VIEW ConnectingPassengers AS
  SELECT pID, name, dob, pob, gov_issued_id, DP, AP
  FROM Passengers
  WHERE NOT EXISTS(
    SELECT *
    FROM (SELECT arrID, depID
          FROM (Arrival Join INCOMINGROUTES USING (rnum)),
            (Departure Join OutgoingRoutes USING(rnum))
            WHERE (outT-incT)*24>12
            OR (outT-incT)*24<1)
    WHERE AP=arrID AND DP=depID
  )
WITH CHECK OPTION;

-- ii) No two flights can have the same gate (during a time interval of -1, +1 hour around their planned time)

CREATE OR REPLACE VIEW DepartureView AS
SELECT depID, depT, rnum, gate
FROM Departure D1
WHERE NOT EXISTS (
SELECT *
FROM Departure D2
WHERE D1.gate=D2.gate AND ABS(D1.depT-D2.depT)*24<1
UNION
SELECT *
From Arrival A2
WHERE D1.gate=A2.gate AND ABS(D1.depT-A2.arrT)*24<1
)
WITH CHECK OPTION;

CREATE OR REPLACE VIEW ArrivalView AS
SELECT arrID, arrT, rnum, gate
FROM Arrival A1
WHERE NOT EXISTS (
SELECT *
FROM Departure D2
WHERE A1.gate=D2.gate AND ABS(A1.arrT-D2.depT)*24<1
UNION
SELECT *
From Arrival A2
WHERE A1.gate=A2.gate AND ABS(A1.arrT-A2.arrT)*24<1
)
WITH CHECK OPTION;
