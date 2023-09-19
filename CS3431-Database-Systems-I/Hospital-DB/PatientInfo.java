import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Scanner;

public class PatientInfo {

    private static String patientFirstName;
    private static String patientLastName;

    public static void retrieveInfo(Connection connection) {
        getPatientName();
        executeQuery(connection);
    }

    private static void getPatientName() {
        Scanner in = new Scanner(System.in);
        System.out.println("Please enter the first name of the patient: ");
        patientFirstName = in.nextLine();
        System.out.println("Please enter the last name of the patient: ");
        patientLastName = in.nextLine();
        System.out.println("\n");

    }

    private static void executeQuery(Connection connection) {
        try {
            Statement stmt = connection.createStatement();
            String str = "SELECT * FROM Patient WHERE firstName = '" +
                    patientFirstName + "' AND lastName = '" + patientLastName + "'";
            ResultSet rset = stmt.executeQuery(str);

            String patientID = "";
            String firstName = "";
            String lastName = "";
            String city = "";
            String state = "";

            while (rset.next()) {
                patientID = rset.getString("patientID");
                firstName = rset.getString("firstName");
                lastName = rset.getString("lastName");
                city = rset.getString("city");
                state = rset.getString("state");

                System.out.println("Patient Information");
                System.out.println("Patient ID: " + patientID);
                System.out.println("Patient Name: " + firstName + " " + lastName);
                System.out.println("Address: " + city + ", " + state);
                System.out.println("");
            }

            rset.close();
            stmt.close();
            connection.close();
        } catch (SQLException e) {
            System.out.println("Get Data Failed! Check output console");
            e.printStackTrace();
            return;
        }
    }
}
