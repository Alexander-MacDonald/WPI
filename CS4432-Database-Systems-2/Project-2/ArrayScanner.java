/**
 * @Author Alexander MacDonald
 * @Date 4/18/2023
 * @Class CS4432
 */
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class ArrayScanner {
    private final String[] arrayIndex;
    public ArrayScanner() {
        //create array index of 5001 because indices are 0 based in the files for an awesome reason and i am not translating them every time
        arrayIndex = new String[5001];
        //for all the files
        for (int i = 1; i < 100; i++) {
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
                    //weird appending null issue but this fixes it
                    if(arrayIndex[Integer.parseInt(recordData[3])] == null) {
                        arrayIndex[Integer.parseInt(recordData[3])] = (recordData[0].substring(0, 3) + "," + recordData[0].substring(7) + ";");
                    }
                    else {
                        arrayIndex[Integer.parseInt(recordData[3])] += (recordData[0].substring(0, 3) + "," + recordData[0].substring(7) + ";");
                    }
                }
            }
            catch (IOException e) {
                System.out.println("SYSTEM:\tError Reading File");
            }
        }
    }

    public void RangeArrayScan(int low, int high) {
        //# of times buffered reader is successful
        int filesAccessed = 0;
        //keep track of time
        long preTime = System.currentTimeMillis();
        //string array of offsets in array index
        String[] offsets;
        //string array of data in offset
        String[] offsetData;
        //string array of records
        String[] records;
        //single line string of all records in a file
        String allRecordsInFile;

        //logic to not bog down in nested for loops and just get EVERY reference
        //same as hash scanner just different for arrays
        String allReferences = "";
        for(int i = low+1; i < high; i++) {
            if(arrayIndex[i] != null) {
                allReferences += arrayIndex[i];
            }
        }
        offsets = allReferences.split(";");
        //for all the offsets
        for (String offset : offsets) {
            offsetData = offset.split(",");
            //I LOVE WHEN FORMATS DONT LINE UP! F7.txt -> F07 IN THE ABSTRACTION!!!!!
            if (offsetData[0].charAt(1) == '0') {
                offsetData[0] = offsetData[0].charAt(0) + offsetData[0].substring(2);
            }
            try {
                //open file in index
                BufferedReader data = new BufferedReader(new FileReader("Project2Dataset/" + offsetData[0] + ".txt"));
                allRecordsInFile = data.readLine();
                filesAccessed++;
                records = allRecordsInFile.split("\\.\\.\\.");

                //jump to offset do not search whole file
                System.out.println(records[Integer.parseInt(offsetData[1]) - 1]);
            } catch (IOException e) {
                System.out.println("SYSTEM:\tError Reading File");
            }
        }
        System.out.println("SYSTEM:\tRange Array Scan took " + (System.currentTimeMillis()-preTime) + " milliseconds\nSYSTEM:\t" + filesAccessed + " Files Accessed");
    }
    //helper function
    public void printArray() {
        for(int i = 0; i < arrayIndex.length; i++) {
            System.out.println(i + ": " + arrayIndex[i]);
        }
    }
}
