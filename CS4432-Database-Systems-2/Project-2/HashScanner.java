/**
 * @Author Alexander MacDonald
 * @Date 4/18/2023
 * @Class CS4432
 */
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.Hashtable;

public class HashScanner {
    private Hashtable<Integer, String> hashIndex = new Hashtable<>();
    public HashScanner() {
        //for all files in directory
        for (int i = 1; i < 100; i++) {
            try {
                //init vars
                //single line string that stores all records in a file
                String allRecordsInFile;
                //string array of all each record in a file
                String[] records;
                //string array of all the data in each record
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
                    //had an if null else append but intellij said this is better...
                    hashIndex.merge(Integer.parseInt(recordData[3]), (recordData[0].substring(0, 3) + "," + recordData[0].substring(7) + ";"), (a, b) -> (a + b));
                }
            }
            catch (IOException e) {
                System.out.println("SYSTEM:\tError Reading File");
            }
        }
    }

    public void EQHashScan(int value) {
        //# of times buffered reader is successful
        int filesAccessed = 0;
        //track time
        long preTime = System.currentTimeMillis();
        //get all offsets stored in the hash index
        String offsets = hashIndex.get(value);
        //single line string with all records in file
        String allRecordsInFile;
        //string array of all offsets in hash index
        String[] offsetArr;
        //string array of all data in offset (File #, and in-file offset)
        String[] offsetData;
        //array of all records (offset is used to determine which record)
        String[] records;


        //if there are no offsets in index
        if(offsets == null) {
            System.out.println("SYSTEM:\tNo Entries for " + value);
            System.out.println("SYSTEM:\tEquality Hash Scan took " + (System.currentTimeMillis()-preTime) + " milliseconds\n0 Files Accessed");
            return;
        }
        //otherwise get all the offsets
        offsetArr = offsets.split(";");
        for (String s : offsetArr) {
            offsetData = s.split(",");

            //I LOVE WHEN FORMATS DONT LINE UP! F7.txt -> F07 IN THE ABSTRACTION!!!!!
            if (offsetData[0].charAt(1) == '0') {
                offsetData[0] = offsetData[0].charAt(0) + offsetData[0].substring(2);
            }
            //for each offset, try to read associated file
            try {
                BufferedReader data = new BufferedReader(new FileReader("Project2Dataset/" + offsetData[0] + ".txt"));
                allRecordsInFile = data.readLine();
                filesAccessed++;
                records = allRecordsInFile.split("\\.\\.\\.");

                //go directly to offset, do not search file
                System.out.println(records[Integer.parseInt(offsetData[1]) - 1]);
            }
            catch (IOException e) {
                System.out.println("SYSTEM:\tError Reading File");
            }
        }
        System.out.println("SYSTEM:\tEquality Hash Scan took " + (System.currentTimeMillis()-preTime) + " milliseconds\nSYSTEM:\t" + filesAccessed + " Files Accessed");
    }
    //helper debug function
    public void printArray() {
        for(int i = 0; i < 5001; i++) {
            System.out.println(i + ": " + hashIndex.get(i));
        }
    }
}
