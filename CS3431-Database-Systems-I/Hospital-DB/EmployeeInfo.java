import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Scanner;

public class EmployeeInfo {
    private static String employeeIDIO;
    public static void retrieveInfo(Connection connection) {
        getEmployeeID();
        executeQuery(connection);
    }

    private static void getEmployeeID() {
        Scanner in = new Scanner(System.in);
        System.out.println("Enter Employee ID: ");
        employeeIDIO = in.nextLine();
        System.out.println("\n");
    }
    private static void executeQuery(Connection connection) {
        try {
            Statement stmt = connection.createStatement();
            String str = "SELECT * FROM Employee WHERE employeeID = '" + employeeIDIO + "'";
            ResultSet rset = stmt.executeQuery(str);

            String employeeID = "";
            String npi = "";
            String title = "";
            String firstName = "";
            String lastName = "";
            String username = "";
            String password = "";
            String salaryGrade = "";
            String securityClearance = "";

            while (rset.next()) {
                employeeID = rset.getString("employeeID");
                npi = rset.getString("NPI");
                if (rset.wasNull()) {
                    npi = "";
                }
                else {
                    title = "Dr.";
                }
                firstName = rset.getString("firstName");
                lastName = rset.getString("lastName");
                username = rset.getString("username");
                password = rset.getString("password");
                salaryGrade = rset.getString("salaryGrade");
                if(rset.wasNull()) {
                    salaryGrade = "";
                }
                securityClearance = rset.getString("securityClearance");
                if(rset.wasNull()) {
                    securityClearance = "";
                }


                System.out.println("Employee Information");
                System.out.println("Employee ID: " + employeeID);
                if(npi.length() != 0) {
                    System.out.println("NPI: " + npi);
                }
                System.out.print("Employee Name: ");
                if(title.length() != 0) {
                    System.out.print(title + " ");
                }
                System.out.println(firstName + " " + lastName);
                System.out.println("Username: " + username);
                System.out.println("Password: " + password);
                if(salaryGrade.length() != 0) {
                    System.out.println("Salary Grade: " + salaryGrade);
                }
                if(securityClearance.length() != 0) {
                    System.out.println("Security Clearance: " + securityClearance);
                }
            }

            rset.close();
            stmt.close();
            connection.close();
        }
        catch (SQLException e) {
            System.out.println("Get Data Failed! Check output console");
            e.printStackTrace();
            return;
        }
    }
}
