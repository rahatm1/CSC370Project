/* Flight Project SQL Queries */

/* Given an airline (airline_code) find all the routes it operates.*/
SELECT rnum
FROM Operate
WHERE acode="airline_code";

/* Given a place (place) (e.g. Toronto) find all the routes from and to that
place.*/
SELECT DISTINCT rnum
FROM
  (SELECT rnum
  FROM OutgoingRoutes
  WHERE destination="place"
   UNION
  SELECT rnum
  FROM IncomingRoutes
  WHERE source="place");

/* Given a time of the day find all the arrivals and departures around that time
and print their status.*/
-- determine status in java ...
-- gets depID for departures within +/- 1 hour
SELECT depID
FROM Departure D1
WHERE ABS(D1.depT-TO_DATE('date_string','Month dd, YYYY, HH:MI A.M.','NLS_DATE_LANGUAGE = American'))*24<1;
-- gets arrID for arrivals within +/- 1 hour
SELECT arrID
FROM Arrival A1
WHERE ABS(A1.depT-TO_DATE('date_string','Month dd, YYYY, HH:MI A.M.','NLS_DATE_LANGUAGE = American'))*24<1;


/* Given a departure (dep_ID) or arrival (arr_ID) find all the passengers recorded
for it. Print all the information about these passengers.*/
SELECT pID, name, dob, pob, gov_issued_id, DP, AP
FROM Passengers
WHERE AP="arr_ID";
SELECT pID, name, dob, pob, gov_issued_id, DP, AP
FROM Passengers
WHERE DP="dep_ID";

/* For a given passenger (person) in a flight find his/her baggage.*/
SELECT bID
FROM Baggage, Passengers
WHERE Baggage.passID=Passengers.pID AND pID="person";

/* Find a free gate for a flight (arrival or departure).*/
SELECT gate
FROM Gates
WHERE is_free='y';

/* Assign a flight as done and return the gate*/
-- returns gates of flights that are done
SELECT DISTINCT gate
FROM
  (SELECT gate
  FROM GateDep JOIN Departure USING(depID)
  WHERE depT < SYSDATE
   UNION
  SELECT gate
  FROM ArrDep JOIN Arrival USING(arrID)
  WHERE arrT < SYSDATE)
;

/* ---------------- */

/* List all the possible connecting routes, i.e. pairs (r1, r2) of
IncomingRoutes-OutgoingRoutes routes, such that the scheduled arrival time of r1 is not more
than 12 hours earlier but not less than 1 hour earlier of the scheduled
departure time of r2.*/
SELECT r1.rnum, r2.rnum
FROM IncomingRoutes r1, OutgoingRoutes r2
WHERE r1.incT < r2.outT
  AND (r2.outT-r1.incT)*24<12
  AND (r2.outT-r1.incT)*24>1;

/* Find all the passengers in transit.*/
SELECT Passenger.pID
FROM (Passenger JOIN Departure USING(DepID)) JOIN Arrival USING(ArrID)
WHERE SYSDATE>Departure.depT AND SYSDATE<Arrival.arrT;

/* Find the top three persons with respect to the number of flights they have
taken. */
SELECT *
FROM
  (SELECT pID, COUNT(pID) as num_flights
  FROM Passenger
  GROUP BY pID
  ORDER BY COUNT(pID) DESC)
WHERE ROWNUM<=3;

/* For each (from, to) route, find the airline with the most delays.*/
-- delay: outT>depT OR incT>arrT
SELECT name, COUNT(name)
FROM
  (SELECT name
  FROM Operate JOIN Airline USING(acode)
  WHERE rnum IN
    (SELECT rnum
    FROM OutgoingRoutes JOIN Departure USING(rnum)
    WHERE OutgoingRoutes.outT>Departure.depT
      UNION
    SELECT rnum
    FROM IncomingRoutes JOIN Arrival USING(rnum)
    WHERE IncomingRoutes.incT>Arrival.arrT))
GROUP BY name
ORDER BY COUNT(name) DESC;


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
CREATE OR REPLACE VIEW ConflictingDep AS
  SELECT depID, depT, rnum
  FROM Departure D1
  WHERE NOT EXISTS (
    SELECT *
    FROM ((Departure JOIN GateDep USING(depID)) JOIN
         (Arrival JOIN GateArr USING (arrID))
          USING(gate) ) D2
    WHERE D1.gate=D2.gate AND
      (ABS(D1.depT-D2.depT)*24<1 OR
       ABS(D1.depT-D2.arrT)*24<1)
  )
WITH CHECK OPTION;

CREATE OR REPLACE VIEW ConflictingArr AS
  SELECT arrID, arrT, rnum
  FROM Arrival A1
  WHERE NOT EXISTS (
    SELECT *
    FROM ((Arrival JOIN GateArr USING(arrID)) JOIN
         (Departure JOIN GateDep USING(depID))
          USING(gate) ) A2
    WHERE A1.gate=A2.gate AND
      (ABS(A1.arrT-A2.arrT)*24<1 OR
       ABS(A1.depT-A2.depT)*24<1)
  )
WITH CHECK OPTION;
