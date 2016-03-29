"INSERT INTO Operate(acode, rnum) " +
"VALUES( '" + acode + "','" + rnum + "')";

"INSERT INTO Route(rnum,planemodel) " +
"VALUES( '" + rnum + "','" + planemodel + "')";

"INSERT INTO OutgoingRoutes(destination, outT, rnum) " +
"VALUES( '" + destination + "',TO_DATE('" + outT + "', 'DD-MM-YYYY HH24:MI:SS ')," + rnum + ")";

"INSERT INTO IncomingRoutes(source, incT, rnum) " +
"VALUES( '" + source + "',TO_DATE('" + incT + "', 'DD-MM-YYYY HH24:MI:SS ')," + rnum + ")";

"INSERT INTO Gates(gate, is_free) " +
"VALUES( '" + gate + "', 'y')";

"INSERT INTO DepartureView(depID, depT, rnum, gate) " +
"VALUES( " + depID + ",TO_DATE('" + depT + "', 'DD-MM-YYYY HH24:MI:SS ')," + rnum + "," + gate + ")";

"INSERT INTO ArrivalView(arrID, arrT, rnum, gate) " +
"VALUES( " + arrID + ",TO_DATE('" + arrT + "', 'DD-MM-YYYY HH24:MI:SS ')," + rnum + "," + gate + ")";

"INSERT INTO Airline(name, acode, website) " +
"VALUES( '" + name + "','" + acode + "','" + website + "')";

"Delete Route where rnum=" +Route;
