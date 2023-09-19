/**
 * @Author Alexander MacDonald
 * @Date 4/30/2023
 * @Class CS4432
 */
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.Arrays;
import java.util.Hashtable;

public class CMD {

    private String[] selectArgs = {};
    private String[] fromArgs = {};
    private String[] whereArgs = {};
    private String[] groupByArgs = {};
    private String aggregate = "";

    public CMD (String cmd) {
        cmd = cmd.replace(",", "");
        String[] cmdArgs = cmd.split(" ");

        if(cmdArgs[0].equalsIgnoreCase("exit")) {
            System.out.println("SYSTEM:\tProgram Exiting");
            System.exit(0);
        }

        int idxSelect = -1;
        int idxFrom = -1;
        int idxWhere = -1;
        int idxGroupBy = -1;

        for(int argIdx = 0; argIdx < cmdArgs.length; argIdx++) {
            if(cmdArgs[argIdx].equalsIgnoreCase("select")) {
                idxSelect = argIdx;
            }
            else if(cmdArgs[argIdx].equalsIgnoreCase("from")) {
                idxFrom = argIdx;
            }
            else if(cmdArgs[argIdx].equalsIgnoreCase("where")) {
                idxWhere = argIdx;
            }
            else if(cmdArgs[argIdx].equalsIgnoreCase("group")) {
                idxGroupBy = argIdx;
            }
        }
        if(idxSelect != -1) {
            selectArgs = Arrays.copyOfRange(cmdArgs, idxSelect + 1, (idxFrom - idxSelect));
        }
        if(idxFrom != -1 && idxWhere != -1) {
            fromArgs = Arrays.copyOfRange(cmdArgs, idxFrom + 1, idxWhere);
        } else {
            fromArgs = Arrays.copyOfRange(cmdArgs, idxFrom + 1, idxGroupBy);
        }
        if(idxWhere != -1) {
            whereArgs = Arrays.copyOfRange(cmdArgs, idxWhere + 1, cmdArgs.length);
        }
        if(idxGroupBy != -1) {
            groupByArgs = Arrays.copyOfRange(cmdArgs, idxGroupBy + 2, cmdArgs.length);
        }
        cmdParse();
    }

    public void cmdParse() {
        if (selectArgs.length == 4) {
            //time tracking
            long preTime = System.currentTimeMillis();
            hashBasedJoin(createHashBucket());
            System.out.println("SYSTEM:\tOperation Took " + (System.currentTimeMillis() - preTime) + "ms");
            return;
        }
        if (selectArgs.length == 1 && selectArgs[0].contains("count")){
            long preTime = System.currentTimeMillis();
            blockLevelNestedLoopJoin();
            System.out.println("SYSTEM:\tOperation Took " + (System.currentTimeMillis() -preTime) + "ms");
            return;
        }

        int printCols = 0;
        for(int argIdx = 0; argIdx < selectArgs.length; argIdx++) {
            if(selectArgs[argIdx].toLowerCase().contains("sum") || selectArgs[argIdx].toLowerCase().contains("avg")) {
                printCols = argIdx;
            }
        }
        aggregate = selectArgs[printCols];
        long preTime = System.currentTimeMillis();
        aggregateFunction(createHashAggregate());
        System.out.println("SYSTEM:\tOperation Took " + (System.currentTimeMillis() - preTime) + "ms");
        return;
    }

    //future impl will have aggregate object with hashtable & string list of groups,
    //groups are static in this project so they were hardcoded
    private void aggregateFunction(Hashtable<String, int[]> aggregateData) {
        for(int i = 1; i < 101; i++) {
            String builtStr = "Name" + String.format("%03d", i);
            int[] recordAggregate = aggregateData.get(builtStr);
            if(aggregate.toLowerCase().contains("sum")) {
                System.out.println("SYSTEM:\t" + builtStr + " SUM: " + recordAggregate[0]);
                continue;
            }
            if(aggregate.toLowerCase().contains("avg")) {
                System.out.println("SYSTEM:\t" + builtStr + " AVG: " + (recordAggregate[0]/recordAggregate[1]));
                continue;
            }
            System.out.println("SYSTEM:\t" + builtStr + " COUNT: " + (recordAggregate[1]));
        }
    }
    private Hashtable<String, int[]> createHashAggregate() {
        Hashtable<String, int[]> aggregateData = new Hashtable<String, int[]>();
        //future impl would have metadata in dir for # of files
        for(int fileIdx = 1; fileIdx < 100; fileIdx++) {
            try {
                //init vars
                //single line string that stores all records in a file
                String allRecordsInFile;
                //string array of all each record in a file
                String[] records;
                //string array of all the data in each record
                String[] recordData;

                //read each file
                BufferedReader data = new BufferedReader(new FileReader("Project3Dataset-" + fromArgs[0] + "/" + fromArgs[0] + fileIdx + ".txt"));
                //only one line per file
                allRecordsInFile = data.readLine();
                //records are delimited by "..."
                records = allRecordsInFile.split("\\.\\.\\.");
                //for all records in a file
                for (String record : records) {
                    recordData = record.split(", ");
                    //will be refactored into a hashtable.merge in the future
                    if(aggregateData.get(recordData[1]) == null) {
                        aggregateData.put(recordData[1], new int[]{Integer.parseInt(recordData[3]), 1});
                    }
                    else {
                        int[] currentData = aggregateData.get(recordData[1]);
                        aggregateData.put(recordData[1], new int[]{(currentData[0] + Integer.parseInt(recordData[3])), (currentData[1] + 1)});
                    }
                }
            }
            catch (IOException e) {
                System.out.println("SYSTEM:\tError Reading File # " + fileIdx + " in " + fromArgs[0] + " DB Read");
            }
        }
        return aggregateData;
    }
    private void blockLevelNestedLoopJoin() {
        int count = 0;
        for(int aI = 1; aI < 100; aI++) {
            try {
                //init vars
                //single line string that stores all records in a file
                String allRecordsInFile;
                //string array of all each record in a file
                String[] records;
                //string array of all the data in each record
                String[] recordData;

                //read each file
                BufferedReader data = new BufferedReader(new FileReader("Project3Dataset-A/A" + aI + ".txt"));
                //only one line per file
                allRecordsInFile = data.readLine();
                //records are delimited by "..."
                records = allRecordsInFile.split("\\.\\.\\.");
                //for all records in a file
                for (String record : records) {
                    recordData = record.split(", ");
                    count += compareB(recordData);
                }
            } catch (IOException e) {
                System.out.println("SYSTEM:\tError Reading File # " + aI + " in A DB Read");
            }
        }
        System.out.println("SYSTEM:\t" + count + " matching records");
    }

    private int compareB(String[] aRecordData) throws IOException {
        int count = 0;
        for(int bI = 1; bI < 100; bI++) {
            try {
                //init vars
                //single line string that stores all records in a file
                String allRecordsInFile;
                //string array of all each record in a file
                String[] records;
                //string array of all the data in each record
                String[] recordData;

                //read each file
                BufferedReader data = new BufferedReader(new FileReader("Project3Dataset-B/B" + bI + ".txt"));
                //only one line per file
                allRecordsInFile = data.readLine();
                //records are delimited by "..."
                records = allRecordsInFile.split("\\.\\.\\.");
                //for all records in a file
                for (String record : records) {
                    recordData = record.split(", ");
                    if(Integer.parseInt(aRecordData[3]) > Integer.parseInt(recordData[3])) {
                        count++;
                    }
                }
            }
            catch (IOException e) {
                System.out.println("SYSTEM:\tError Reading File # " + bI + " in B DB Read");
            }
        }
        return count;
    }

    private void hashBasedJoin(Hashtable<Integer, String> buckets) {
        int count = 0;
        for (int i = 1; i < 100; i++) {
            try {
                //init vars
                //single line string that stores all records in a file
                String allRecordsInFile;
                //string array of all each record in a file
                String[] records;
                //string array of all the data in each record
                String[] recordData;
                //hashtable locations from get(value) in B table
                String locations;
                //split into arr
                String[] locationSplit;

                //read each file
                BufferedReader data = new BufferedReader(new FileReader("Project3Dataset-B/B" + i + ".txt"));
                //only one line per file
                allRecordsInFile = data.readLine();
                //records are delimited by "..."
                records = allRecordsInFile.split("\\.\\.\\.");
                //for all records in a file
                for (String record : records) {
                    //record data is delimited by ", "
                    recordData = record.split(", ");
                    locations = buckets.get(Integer.parseInt(recordData[3]));
                    locationSplit = locations.split(";");
                    for (String location : locationSplit) {
                        if(!location.equals("null")) {
                            System.out.println(location + ", " + recordData[0] + ", " + recordData[1]);
                            count++;
                        }
                    }
                }
            }
            catch (IOException e) {
                System.out.println("SYSTEM:\tError Reading File");
            }
        }
        System.out.println("SYSTEM:\t" + count + " matching records");
    }
    private Hashtable<Integer, String> createHashBucket() {
        //hash storage
        Hashtable<Integer, String> buckets = new Hashtable<Integer, String>();

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
                BufferedReader data = new BufferedReader(new FileReader("Project3Dataset-A/A" + i + ".txt"));
                //only one line per file
                allRecordsInFile = data.readLine();
                //records are delimited by "..."
                records = allRecordsInFile.split("\\.\\.\\.");
                //for all records in a file
                for (String record : records) {
                    //record data is delimited by ", "
                    recordData = record.split(", ");
                    //had an if null else append but intellij said this is better...
                    buckets.merge(Integer.parseInt(recordData[3]), (recordData[0] + ", " + recordData[1] + ";"), (a, b) -> (a + b));
                }
            }
            catch (IOException e) {
                System.out.println("SYSTEM:\tError Reading File");
            }
        }
        return buckets;
    }

    public void printArgs() {
        System.out.println("SELECT " + Arrays.toString(selectArgs));
        System.out.println("FROM " + Arrays.toString(fromArgs));
        System.out.println("WHERE " + Arrays.toString(whereArgs));
    }
}
