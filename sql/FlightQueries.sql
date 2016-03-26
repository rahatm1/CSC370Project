/* Flight Project SQL Queries */

/* Given an airline (airline_code) find all the routes it operates.*/
SELECT r_number
FROM flight
WHERE code="airline_code";

/* Given a place (place) (e.g. Toronto) find all the routes from and to that
place.*/
SELECT DISTINCT r_number
FROM
  (SELECT r_number
  FROM Outgoing
  WHERE destination="place"
   UNION
  SELECT r_number
  FROM Incoming
  WHERE origin="place");

/* Given a time of the day find all the arrivals and departures around that time
and print their status.*/
-- determine status in java ...
-- gets depID for departures within +/- 1 hour
SELECT depID
FROM Departure D1
WHERE ABS(D1.depT-TO_DATE('date_string','Month dd, YYYY, HH:MI A.M.','NLS_DATE_LANGUAGE = American'))*24<1;
-- gets arrID for arrivals within +/- 1 hour
SELECT arrID
FROM Arrival D1
WHERE ABS(A1.depT-TO_DATE('date_string','Month dd, YYYY, HH:MI A.M.','NLS_DATE_LANGUAGE = American'))*24<1;


/* Given a departure or arrival (dep_arr_ID) find all the passengers recorded
for it. Print all the information about these passengers.*/
SELECT passenger_name, dob, birth_place, passID
FROM Passengers
WHERE passID IN
  (SELECT passID
  FROM Travel
  WHERE depID="dep_arr_ID" OR arrID="dep_arr_ID");

/* For a given passenger (person) in a flight find his/her baggage.*/
SELECT baggageID
FROM Baggage, Passengers
WHERE Baggage.passID=Passengers.passID AND passID="person";

/* Find a free gate for a flight (arrival or departure).*/
SELECT gate
FROM Gates
WHERE is_free='y';

/* Assign a flight as “done” and return the gate*/
-- returns travel ID, pass ID, depID, arrID for a "finished" flight
SELECT tID, passID, depID, arrID 
FROM Travel JOIN Arrival USING(arrID)
WHERE arrT < SYSDATE;

/* ---------------- */

/* List all the possible connecting routes, i.e. pairs (r1, r2) of
incoming-outgoing routes, such that the scheduled arrival time of r1 is not more
than 12 hours earlier but not less than 1 hour earlier of the scheduled
departure time of r2.*/
SELECT r1.r_number, r2.r_number
FROM Incoming r1, Outgoing r2
WHERE r1.incT < r2.outT
  AND (r2.outT-r1.incT)*24<12
  AND (r2.outT-r1.incT)*24>1;

/* Find all the passengers in transit.*/
SELECT Travel.passID
FROM (Travel JOIN Departure USING(DepID)) JOIN Arrival USING(ArrID)
WHERE SYSDATE>Departure.depT AND SYSDATE<Arrival.arrT;

/* Find the top three persons with respect to the number of flights they have
taken. */
-- freshID acts like a Travel ID
SELECT *
FROM
  (SELECT passID, COUNT(freshID) as num_flights
  FROM Travel
  GROUP BY (passID)
  ORDER BY COUNT(freshID) DESC)
WHERE ROWNUM<=3;

/* For each (from, to) route, find the airline with the most delays.*/
-- delay: outT>depT OR incT>arrT
SELECT air_name, COUNT(air_name)
FROM
  (SELECT air_name
  FROM Flight JOIN Airline USING(code)
  WHERE r_number IN
    (SELECT r_number
    FROM Outgoing JOIN Departure USING(r_number)
    WHERE Outgoing.outT>Departure.depT
      UNION
    SELECT r_number
    FROM Incoming JOIN Arrival USING(r_number)
    WHERE Incoming.incT>Arrival.arrT))
GROUP BY air_name
ORDER BY COUNT(air_name) DESC;


-- Advanced Constraints

-- i) No passenger can be associated with more than two flights, which have to be connecting flights.
CREATE OR REPLACE VIEW ConflictingFlights AS
 SELECT freshID, depID, arrID, passID
 FROM Travel T
 WHERE NOT EXISTS(
  SELECT *
  FROM ((Travel T1 JOIN Departure D1 USING(depID)) JOIN Arrival A1 USING(arrID)) Flights1,
    ((Travel T2 JOIN Departure D2 USING(depID)) JOIN Arrival A2 USING(arrID)) Flights2
  WHERE Flights1.passID=Flights2.passID AND
    Flights1.freshID<>Flights2.freshID AND
    Flights1.depT<Flights2.depT AND
    Flights1.arrT<Flights2.arrT AND
    Flights1.arrT>Flights2.depT
 )
WITH CHECK OPTION;

-- ii) No two flights can have the same gate (during a time interval of -1, +1 hour around their planned time)
CREATE OR REPLACE VIEW ConflictingDep AS
  SELECT depID, gate, depT
  FROM Departure D1
  WHERE NOT EXISTS (
    SELECT *
    FROM Departure D2 JOIN Arrival A2 USING(gate)
    WHERE D1.gate=D2.gate AND
      (ABS(D1.depT-D2.depT)*24<1 OR
       ABS(D1.depT-A2.arrT)*24<1)
  )
WITH CHECK OPTION;

CREATE OR REPLACE VIEW ConflictingArr AS
  SELECT arrID, gate, arrT
  FROM Arrival A1
  WHERE NOT EXISTS (
    SELECT *
    FROM Arrival A2 JOIN Departure D2 USING(gate)
    WHERE A1.gate=A2.gate AND
      (ABS(A1.arrT-A2.arrT)*24<1 OR
       ABS(A1.depT-D2.depT)*24<1)
  )
WITH CHECK OPTION;














