import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.sql.*;
import java.util.*;

public class Insertdata{
    public static void main(String[] args)throws SQLException{
        Connection conn = ConnectionManager.getInstance().getConnection();
        passengerdata(conn);
        baggagedata(conn);
    }
    public static void passengerdata(Connection conn){
        FileInputStream fis = null;
        BufferedReader reader = null;
        try {
            fis = new FileInputStream("./passenger.txt"); // need to change this wherever the location of the file
            reader = new BufferedReader(new InputStreamReader(fis));

            String line = reader.readLine();
            while(line != null){
                String m = "INSERT INTO ConnectingPassengers VALUES(";
                String[] tok = line.split(",");
                if (tok[5].length() == 0) tok[5] = "NULL";
                if (tok.length == 6)
                {
                    m+="'"+tok[0]+"','"+tok[1]+"',TO_DATE('"+tok[2]+"', 'DD-MM-YYYY'),'"+tok[3]+"','" + tok[4] + "'," + tok[5] + ", NULL";
                }
                else
                {
                    m+="'"+tok[0]+"','"+tok[1]+"',TO_DATE('"+tok[2]+"', 'DD-MM-YYYY'),'"+tok[3]+"','" + tok[4] + "'," + tok[5] + "," + tok[6] +"";
                } //i added the quotation mark in the code itself..that way much easier than in dataset
                m+=")";
                line = reader.readLine();
                System.out.println(m);
                try {
                    Statement stmt = conn.createStatement();
                    stmt.executeUpdate(m);
                    stmt.close();
                    System.out.println("Insertion Successful!");
                }
                catch(SQLException e) { System.out.println(e); }
                ConnectionManager.getInstance().returnConnection(conn);
            }

        } catch (FileNotFoundException ex) {
            Logger.getLogger(Insertdata.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IOException ex) {
            Logger.getLogger(Insertdata.class.getName()).log(Level.SEVERE, null, ex);

        } finally {
            try {
                reader.close();
                fis.close();
            } catch (IOException ex) {
                Logger.getLogger(Insertdata.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

    }
    public static void baggagedata(Connection conn){
        FileInputStream fis = null;
        BufferedReader reader = null;
        try {
            fis = new FileInputStream("./baggage.txt"); // need to change this wherever the location of the file
            reader = new BufferedReader(new InputStreamReader(fis));

            String line = reader.readLine();
            while(line != null){
                String m = "INSERT INTO BAGGAGE VALUES(";
                String[] tok = line.split(",");
                m+="'"+tok[0]+"','"+tok[1]+"','"+tok[2]+"'"; // i added the quotation mark in the code itself..that way much easier than in dataset
                m+=")";
                line = reader.readLine();
                try {
                    Statement stmt = conn.createStatement();
                    stmt.executeUpdate(m);
                    stmt.close();
                    System.out.println("Insertion Successful!");
                }
                catch(SQLException e) { System.out.println(e); }
                ConnectionManager.getInstance().returnConnection(conn);
            }

        } catch (FileNotFoundException ex) {
            Logger.getLogger(Insertdata.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IOException ex) {
            Logger.getLogger(Insertdata.class.getName()).log(Level.SEVERE, null, ex);

        } finally {
            try {
                reader.close();
                fis.close();
            } catch (IOException ex) {
                Logger.getLogger(Insertdata.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }
}
