import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class InsertDeparture extends HttpServlet {
    void processRequest(HttpServletRequest request, HttpServletResponse response)
    						throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String depID = request.getParameter("depID");
        String depT = request.getParameter("depT");
        String rnum = request.getParameter("rnum");
        String gate = request.getParameter("gate");

        String statementString =
		"INSERT INTO DepartureView(depID, depT, rnum, gate) " +
        "VALUES( " + depID + ",TO_DATE('" + depT + "', 'DD-MM-YYYY HH24:MI:SS ')," + rnum + "," + gate + ")";
        System.out.println(statementString);
        Connection conn = ConnectionManager.getInstance().getConnection();
        boolean success = false;
        try {
            Statement stmt = conn.createStatement();
            stmt.executeUpdate(statementString);
            stmt.close();
            success = true;
            out.println("Insertion Successful!");
        }
        catch(SQLException e) { out.println(e); }
        if (success) {
            try {
                Statement stmt = conn.createStatement();
                statementString = "UPDATE GATES SET IS_FREE = 'n' WHERE GATE = " + gate;
                stmt.executeUpdate(statementString);
                stmt.close();
                out.println("Insertion Successful!");
            }
            catch(SQLException e) { out.println(e); }
        }
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
    public String getServletInfo() {  return "InsertDeparture"; }
}
