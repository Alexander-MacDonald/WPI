import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Scanner;

public class EmployeePassword {

    private static final Scanner input = new Scanner(System.in);

    private static String getEmployeeID() {
        System.out.println("Enter the employee ID:");
        return input.nextLine();
    }

    private static String newPassword() {
        System.out.println("Enter the updated password:");
        return input.nextLine();
    }

    public static int updatePassword(Connection connection) {
        Statement stmt;
        try {
            stmt = connection.createStatement();
        } catch (SQLException e) {
            System.out.println("Error connecting to the database.");
            return -1;
        }
        String empID = getEmployeeID();
        String queryEmployee = "SELECT * FROM Employee WHERE employeeID = '"+empID+"'";
        ResultSet result;
        try {
            result = stmt.executeQuery(queryEmployee);
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("Error fetching employeeID from database.");
            return -1;
        }
        try {
            if (!result.next()) {
                System.out.println("Your Employee ID does not exist in our database. Consider contacting an administrator.");
                return 0;
            }
            else {
                String newPw = newPassword();
                String updateQuery = "UPDATE Employee SET password = '"+newPw+"' WHERE employeeID = '"+empID+"'";
                stmt.executeQuery(updateQuery);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("An unknown error occurred while fetching the result.");
            return -1;
        }

        System.out.println("Your password was updated.");
        return 1;
    }
}
