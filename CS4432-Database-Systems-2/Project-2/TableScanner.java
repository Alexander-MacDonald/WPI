/**
 * @Author Alexander MacDonald
 * @Date 4/18/2023
 * @Class CS4432
 */
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class TableScanner {

    public TableScanner() {
        //dead constructor
        //could be useful for future expanded implementation
    }

    //the only difference between equality, inequality, and range for table scan in just the value check logic
    public void EQTableScan(int value) {
        //track starting time
        long preTime = System.currentTimeMillis();

        //for all files
        for(int i = 1; i < 100; i++) {
            try {
                //init vars
                //single line string of all records in a file
                String allRecordsInFile;
                //string array of all records in a file
                String[] records;
                //string array of all data in a file
                String[] recordData;

                //read each file
                BufferedReader data = new BufferedReader(new FileReader("Project2Dataset/F" + i + ".txt"));
                //only one line per file
                allRecordsInFile = data.readLine();
                //records are delimited by "..."
                records = allRecordsInFile.split("\\.\\.\\.");
                //for all records in a file
                for (String record : records) {
                    //record data is delimited by ", "
                    recordData = record.split(", ");
                    //get the integer value of each record and if is what you're looking for print it
                    if (Integer.parseInt(recordData[3]) == value) {
                        System.out.println(record);
                    }
                }
            }
            catch (IOException e){
                System.out.println("SYSTEM:\tError Reading File");
            }
        }
        //print time taken
        System.out.println("SYSTEM:\tEquality Table Scan took " + (System.currentTimeMillis()-preTime) + " milliseconds\nSYSTEM:\t99 Files accessed");
    }

    public void INEQTableScan(int value) {
        //track starting time
        long preTime = System.currentTimeMillis();

        //for all files
        for(int i = 1; i < 100; i++) {
            try {
                //init vars
                //same as above
                String allRecordsInFile;
                String[] records;
                String[] recordData;

                //read each file
                BufferedReader data = new BufferedReader(new FileReader("Project2Dataset/F" + i + ".txt"));
                //only one line per file
                allRecordsInFile = data.readLine();
                //records are delimited by "..."
                records = allRecordsInFile.split("\\.\\.\\.");
                //for all records in a file
                for (String record : records) {
                    //record data is delimited by ", "
                    recordData = record.split(", ");
                    //get the integer value of each record and if is what you're looking for print it
                    if (Integer.parseInt(recordData[3]) != value) {
                        System.out.println(record);
                    }
                }
            }
            catch (IOException e) {
                System.out.println("SYSTEM:\tError Reading File");
            }
        }
        //print time taken
        System.out.println("SYSTEM:\tInequality Table Scan took " + (System.currentTimeMillis()-preTime) + " milliseconds\nSYSTEM:\t99 Files Accessed");
    }

    public void RangeTableScan(int low, int high) {
        //track starting time
        long preTime = System.currentTimeMillis();

        //for all files
        for(int i = 1; i < 100; i++) {
            try {
                //init vars
                //same as above
                String allRecordsInFile;
                String[] records;
                String[] recordData;

                //read each file
                BufferedReader data = new BufferedReader(new FileReader("Project2Dataset/F" + i + ".txt"));
                //only one line per file
                allRecordsInFile = data.readLine();
                //records are delimited by "..."
                records = allRecordsInFile.split("\\.\\.\\.");
                //for all records in a file
                for (String record : records) {
                    //record data is delimited by ", "
                    recordData = record.split(", ");
                    //get the integer value of each record and if is what you're looking for print it
                    if (Integer.parseInt(recordData[3]) > low && Integer.parseInt(recordData[3]) < high) {
                        System.out.println(record);
                    }
                }
            }
            catch (IOException e) {
                System.out.println("SYSTEM:\tError Reading File");
            }
        }
        //print time taken
        System.out.println("SYSTEM:\tRange Table Scan took " + (System.currentTimeMillis()-preTime) + " milliseconds\nSYSTEM:\t99 Files Accessed");
    }
}
