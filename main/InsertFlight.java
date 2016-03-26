import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class InsertFlight extends HttpServlet {
    void processRequest(HttpServletRequest request, HttpServletResponse response)
    						throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();


        String plane_model = request.getParameter("plane_model");
        String code = request.getParameter("code");
        String r_number = request.getParameter("r_number");

        String statementString =
		"INSERT INTO flight(plane_model, code, r_number) " +
        "VALUES( '" + plane_model + "','" + code + "','"+ r_number + "')";
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
    public String getServletInfo() {  return "InsertFlight"; }
}
