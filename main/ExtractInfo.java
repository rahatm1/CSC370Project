import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class ExtractInfo extends HttpServlet {
    void getRoutesForAirline(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        PrintWriter out = response.getWriter();
        String air_name = request.getParameter("air_name");

        Connection conn = ConnectionManager.getInstance().getConnection();
        try { Statement stmt = conn.createStatement();
            ResultSet rset = stmt.executeQuery("SELECT * FROM OPERATE JOIN AIRLINE USING (ACODE) WHERE AIRLINE.NAME = '" + air_name + "'");

        		out.println("<table>");
                out.print(
                "<tr>\n" +
                    "<th>Name</th>\n" +
                    "<th>Website</th>\n" +
                    "<th>Route Number</th>\n" +
                "</tr>\n");
        	while (rset.next()) {
        		out.println("<tr>");
        		out.print (
        			"<td>"+rset.getString("name")+"</td>" +
                    "<td>"+rset.getString("website")+"</td>" +
                    "<td>"+rset.getString("rnum")+"</td>");
        			out.println("</tr>");
        		}
        		out.println("</table>");
                stmt.close();
            }
            catch(SQLException e) { out.println(e); }
            ConnectionManager.getInstance().returnConnection(conn);
        }

        void getRoutesForPlace(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

            PrintWriter out = response.getWriter();
            String place = request.getParameter("place");

            Connection conn = ConnectionManager.getInstance().getConnection();
            try { Statement stmt = conn.createStatement();
                ResultSet rset = stmt.executeQuery(
                "SELECT DISTINCT rnum FROM (SELECT rnum FROM OutgoingRoutes WHERE destination='"
                    + place  + "' UNION SELECT rnum FROM IncomingRoutes WHERE source= '" + place + "')"
                );

                    out.println("<h5> Routes from and to: " + place + "</h5>");
            		out.println("<table>");
                    out.print(
                    "<tr>\n" +
                        "<th>Route Number</th>\n" +
                    "</tr>\n");
            	while (rset.next()) {
            		out.println("<tr>");
            		out.print (
                        "<td>"+rset.getString("rnum")+"</td>");
            			out.println("</tr>");
            		}
            		out.println("</table>");
                    stmt.close();
                }
                catch(SQLException e) { out.println(e); }
                ConnectionManager.getInstance().returnConnection(conn);
            }

            void getPassengers(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {

                PrintWriter out = response.getWriter();
                String depID;
                String arrID;
                String query = "SELECT pID, name, dob, pob, gov_issued_id FROM Passengers WHERE ";
                if (request.getPathInfo().equals("/DeparturePassenger")) {
                    depID = request.getParameter("depID");
                    query += "DP = " + depID;
                }
                else if (request.getPathInfo().equals("/ArrivalPassenger")) {
                    arrID = request.getParameter("arrID");
                    query += "AP = " + arrID;
                }
                System.out.println(query);

                Connection conn = ConnectionManager.getInstance().getConnection();
                try { Statement stmt = conn.createStatement();
                    ResultSet rset =
                        stmt.executeQuery(query);

                        out.println("<h5> All passengers for: </h5>");
                        out.println("<table>");
                        out.print(
                        "<tr>\n" +
                            "<th>Passenger ID</th>\n" +
                            "<th>Name</th>\n" +
                            "<th>Date of Birth</th>\n" +
                            "<th>Place of Birth</th>\n" +
                            "<th>Government Issued ID</th>\n" +
                        "</tr>\n");
                    while (rset.next()) {
                        out.println("<tr>");
                        out.print (
                            "<td>"+rset.getString("pID")+"</td>" +
                            "<td>"+rset.getString("name")+"</td>" +
                            "<td>"+rset.getString("dob")+"</td>" +
                            "<td>"+rset.getString("pob")+"</td>" +
                            "<td>"+rset.getString("gov_issued_id")+"</td>"
                            );
                            out.println("</tr>");
                        }
                        out.println("</table>");
                        stmt.close();
                    }
                    catch(SQLException e) { out.println(e); }
                    ConnectionManager.getInstance().returnConnection(conn);
                }

                void getBaggage(HttpServletRequest request, HttpServletResponse response)
                    throws ServletException, IOException {

                    PrintWriter out = response.getWriter();
                    String passengerID = request.getParameter("passengerID");

                    Connection conn = ConnectionManager.getInstance().getConnection();
                    try { Statement stmt = conn.createStatement();
                        ResultSet rset = stmt.executeQuery(
                            "SELECT bID, weight FROM Baggage, Passengers WHERE Baggage.passID=Passengers.pID AND pID=" + passengerID);

                            out.println("<h5> Baggage for passenger:  " + passengerID + "</h5>");
                            out.println("<table>");
                            out.print(
                            "<tr>\n" +
                                "<th>Baggage ID</th>\n" +
                                "<th>Weight</th>\n" +
                            "</tr>\n");
                        while (rset.next()) {
                            out.println("<tr>");
                            out.print (
                                "<td>"+rset.getString("bID")+"</td>" +
                                "<td>"+rset.getString("weight")+"</td>");
                                out.println("</tr>");
                            }
                            out.println("</table>");
                            stmt.close();
                        }
                        catch(SQLException e) { out.println(e); }
                        ConnectionManager.getInstance().returnConnection(conn);
                    }

                    void getFreeGate(HttpServletRequest request, HttpServletResponse response)
                        throws ServletException, IOException {

                        PrintWriter out = response.getWriter();

                        Connection conn = ConnectionManager.getInstance().getConnection();
                        try { Statement stmt = conn.createStatement();
                            ResultSet rset = stmt.executeQuery("SELECT gate FROM Gates WHERE is_free='y'");

                                out.println("<h5> Free Gates </h5>");
                                out.println("<table>");
                                out.print(
                                "<tr>\n" +
                                    "<th>Gate Number</th>\n" +
                                "</tr>\n");
                            while (rset.next()) {
                                out.println("<tr>");
                                out.print (
                                    "<td>"+rset.getString("gate")+"</td>");
                                    out.println("</tr>");
                                }
                                out.println("</table>");
                                stmt.close();
                            }
                            catch(SQLException e) { out.println(e); }
                            ConnectionManager.getInstance().returnConnection(conn);
                        }

                        void setDoneGate(HttpServletRequest request, HttpServletResponse response)
                            throws ServletException, IOException {

                            PrintWriter out = response.getWriter();
                            String id;
                            boolean departure = false;
                            String statementString;
                            if (request.getPathInfo().equals("/DoneGateDeparture"))
                            {
                                departure = true;
                                id = request.getParameter("depID");
                                statementString = "SELECT gate FROM Departure WHERE depID = " + id;
                            }
                            else
                            {
                                id = request.getParameter("arrID");
                                statementString = "SELECT gate FROM Arrival WHERE arrID = " + id;
                            }
                            Connection conn = ConnectionManager.getInstance().getConnection();
                            int gateNum = -1;
                            try {
                                Statement stmt = conn.createStatement();
                                System.out.println(statementString);
                                ResultSet rset = stmt.executeQuery(statementString);
                                while (rset.next()) {
                                    gateNum = rset.getInt("gate");
                                }
                                stmt.close();
                            }
                                catch(SQLException e) { out.println(e); }
                            if (gateNum != -1)
                            {
                                try{
                                    Statement stmt = conn.createStatement();
                                    stmt.executeQuery("UPDATE GATES SET IS_FREE = 'y' WHERE GATE = " + gateNum);
                                    out.println("Gate: " + gateNum + " has been freed!");
                                    stmt.close();
                                }
                                catch(SQLException e) { out.println(e); }

                            }
                                ConnectionManager.getInstance().returnConnection(conn);
                            }

                void getFlightTime(HttpServletRequest request, HttpServletResponse response)
                    throws ServletException, IOException {

                    PrintWriter out = response.getWriter();
                    String time = request.getParameter("time");
                    Connection conn = ConnectionManager.getInstance().getConnection();
                    try {
                        Statement stmt = conn.createStatement();
                        String statementString = "SELECT depID, depT, rnum, gate FROM Departure D1 " +
                        "WHERE ABS(D1.depT-TO_DATE('" + time + "','DD-MM-YYYY HH24:MI:SS'))*24<1";
                        System.out.println(statementString);
                        ResultSet rset = stmt.executeQuery(statementString);
                            out.println("<h5> Departures </h5>");
                            out.println("<table>");
                            out.print(
                            "<tr>\n" +
                                "<th>Departure ID</th>\n" +
                                "<th>Departure Time</th>\n" +
                                "<th>Route Number</th>\n" +
                                "<th>Gate Number</th>\n" +
                            "</tr>\n");
                        while (rset.next()) {
                            out.println("<tr>");
                            out.print (
                                "<td>"+rset.getString("depID")+"</td>" +
                                "<td>"+rset.getString("depT")+"</td>" +
                                "<td>"+rset.getString("rnum")+"</td>" +
                                "<td>"+rset.getString("gate")+"</td>"
                                );
                                out.println("</tr>");
                            }
                            out.println("</table>");
                            stmt.close();
                        }
                        catch(SQLException e) { out.println(e); }

                        try {
                            Statement stmt = conn.createStatement();
                            String statementString = "SELECT arrID, arrT, rnum, gate FROM Arrival A1 " +
                            "WHERE ABS(A1.arrT-TO_DATE('" + time + "','DD-MM-YYYY HH24:MI:SS'))*24<1";
                            System.out.println(statementString);
                            ResultSet rset = stmt.executeQuery(statementString);
                                out.println("<h5> Arrivals </h5>");
                                out.println("<table>");
                                out.print(
                                "<tr>\n" +
                                    "<th>Arrival ID</th>\n" +
                                    "<th>Arrival Time</th>\n" +
                                    "<th>Route Number</th>\n" +
                                    "<th>Gate Number</th>\n" +
                                "</tr>\n");
                            while (rset.next()) {
                                out.println("<tr>");
                                out.print (
                                    "<td>"+rset.getString("arrID")+"</td>" +
                                    "<td>"+rset.getString("arrT")+"</td>" +
                                    "<td>"+rset.getString("rnum")+"</td>" +
                                    "<td>"+rset.getString("gate")+"</td>"
                                    );
                                    out.println("</tr>");
                                }
                                out.println("</table>");
                                stmt.close();
                            }
                            catch(SQLException e) { out.println(e); }
                        ConnectionManager.getInstance().returnConnection(conn);
                    }



        public void printHeader(PrintWriter out)
        {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<link rel='stylesheet' href='https://cdnjs.cloudflare.com/ajax/libs/skeleton/2.0.4/skeleton.min.css'>");
            out.println("</head>");
            out.println("<body>");
            out.println("<center>");
        }

        public void printEnd(PrintWriter out)
        {
            out.println("</center>");
            out.println("</body>");
            out.println("</html>");
        }

        protected void doGet(HttpServletRequest request, HttpServletResponse response)
        					throws ServletException, IOException {

            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            printHeader(out);

            if (request.getPathInfo().equals("/AirlineRoute")) getRoutesForAirline(request, response);
            else if (request.getPathInfo().equals("/PlaceRoute")) getRoutesForPlace(request, response);
            else if (request.getPathInfo().equals("/DeparturePassenger") || request.getPathInfo().equals("/ArrivalPassenger")) getPassengers(request, response);
            else if (request.getPathInfo().equals("/Baggage")) getBaggage(request, response);
            else if (request.getPathInfo().equals("/FreeGate")) getFreeGate(request, response);
            else if (request.getPathInfo().equals("/DoneGateDeparture") || request.getPathInfo().equals("/DoneGateArrival")) setDoneGate(request, response);
            else if (request.getPathInfo().equals("/FlightTime")) getFlightTime(request, response);
            else out.println("<p>NOT FOUND</p>");

            printEnd(out);
        }

        public String getServletInfo() {  return "ExtractInfo"; }
    }
