// Team Members: Harmoni Larrabee, Alexander MacDonald, and Shafath Zaman

import java.sql.*;
public class p3 {

    private static String USERID;
    private static String PASSWORD;
    private static String MENUCHOICE;

    public static void main(String[] args) {

        // Username and password are not provided
        if (args.length < 2) {
            System.out.println("You need to include your UserID and Password parameters on the command line.");
        }
        // username and password are provided, but no menu choice is provided
        else if (args.length == 2) {
            System.out.println("Include the number of one of the following menu items " +
                                    "as the third parameter on the command line:\n");
            System.out.println("1 – Report Patient Information");
            System.out.println("2 – Report Employee Information");
            System.out.println("3 – Update Employee’s Password");
        }
        // username, password, and menu choice are provided
        else {
            USERID = args[0];
            PASSWORD = args[1];
            MENUCHOICE = args[2];

            System.out.println("-------Oracle JDBC Connection Testing ---------");
            try {
                // Register the Oracle driver
                Class.forName("oracle.jdbc.driver.OracleDriver");

            } catch (ClassNotFoundException e) {
                System.out.println("Where is your Oracle JDBC Driver?");
                e.printStackTrace();
                return;
            }

            System.out.println("Oracle JDBC Driver Registered!");
            Connection connection = null;

            try {
                // create the connection string
                connection = DriverManager.getConnection(
                        "jdbc:oracle:thin:@oracle.wpi.edu:1521:orcl", USERID, PASSWORD);
            } catch (SQLException e) {
                System.out.println("Connection Failed! Check output console");
                e.printStackTrace();
                return;
            }
            System.out.println("Oracle JDBC Driver Connected!\n");

            // Call a function to initialize one of the three
            // options based on the MENUCHOICE input
            if (MENUCHOICE.equals("1")) {
                PatientInfo.retrieveInfo(connection);
            } else if (MENUCHOICE.equals("2")) {
                EmployeeInfo.retrieveInfo(connection);
            } else if (MENUCHOICE.equals("3")) {
                EmployeePassword.updatePassword(connection);
            } else {
                System.out.println("You did not enter a valid menu choice." +
                        " Please try again.");
            }
        }
    }

}