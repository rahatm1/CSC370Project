import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class InsertOutgoing extends HttpServlet {
    void processRequest(HttpServletRequest request, HttpServletResponse response)
    						throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String destination = request.getParameter("destination");
        String outT = request.getParameter("outT");
        String rnum = request.getParameter("rnum");

        String statementString =
		"INSERT INTO OutgoingRoutes(destination, outT, rnum) " +
        "VALUES( '" + destination + "',TO_DATE('" + outT + "', 'DD-MM-YYYY HH24:MI:SS ')," + rnum + ")";
        System.out.println(statementString);
        Connection conn = ConnectionManager.getInstance().getConnection();
        try {
            Statement stmt = conn.createStatement();
            stmt.executeUpdate(statementString);
            stmt.close();
            out.println("Insertion Successful!");
        }
        catch(SQLException e) { out.println(e); }
        ConnectionManager.getInstance().returnConnection(conn);
    }
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    			throws ServletException, IOException {
        processRequest(request, response);
    }
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }
    public String getServletInfo() {  return "InsertOutgoing"; }
}
