import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class ExtractInfo extends HttpServlet {
    void getRoutes(HttpServletRequest request, HttpServletResponse response)
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

                            System.out.println(request.getPathInfo());

            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            printHeader(out);

            if (request.getPathInfo().equals("/AirlineRoute")) getRoutes(request, response);
            else out.println("<p>NOT FOUND</p>");

            printEnd(out);
        }

        public String getServletInfo() {  return "ExtractInfo"; }
    }
