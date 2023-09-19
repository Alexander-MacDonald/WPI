/**
 * @Author Alexander MacDonald
 * @Date 4/18/2023
 * @Class CS4432
 */
import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        //cmd of user input
        String cmd = "";
        //whether an index has been created or not
        boolean index = false;

        //scanners
        HashScanner HS = null;
        ArrayScanner AS = null;
        TableScanner TS = new TableScanner();

        //always
        while(true) {
            //starter text
            //command logic
            System.out.println("SYSTEM:\tProgram is ready and waiting for user command.");
            Scanner stdin = new Scanner(System.in);
            cmd = stdin.nextLine();
            String[] cmdArgs = cmd.split(" ");

            //project name and attribute are fixed according to specs
            if(cmdArgs[0].equalsIgnoreCase("exit")) {
                System.out.println("SYSTEM:\tEXIT Called");
                System.exit(1);
            }
            //helper function to see if indices are working
            else if(cmdArgs[0].equalsIgnoreCase("print")) {
                if(!index) {
                    System.out.println("No Indices Instantiated");
                }
                else {
                    AS.printArray();
                    HS.printArray();
                }
            }
            //Create Index
            //logic that if we used multiple directories & column names would NOT work and would need to be ammended but not too difficult
            else if((cmdArgs[0] + cmdArgs[1] + cmdArgs[2]).equalsIgnoreCase("createindexon")) {
                HS = new HashScanner();
                AS = new ArrayScanner();
                index = true;
            }
            //Select
            //same logic issue as previous cmd check
            else if((cmdArgs[0] + cmdArgs[1] + cmdArgs[2] + cmdArgs[4]).equalsIgnoreCase("select*fromwhere")) {
                //check for which Select statement
                //if not equal
                if(cmdArgs[6].equalsIgnoreCase("!=")) {
                    TS.INEQTableScan(Integer.parseInt(cmdArgs[7]));
                }
                //if it is shorter than a range search
                else if(cmdArgs.length == 8) {
                    if(!index) {
                        TS.EQTableScan(Integer.parseInt(cmdArgs[7]));
                    }
                    else {
                        HS.EQHashScan(Integer.parseInt(cmdArgs[7]));
                    }
                }
                //otherwise its a long command and is a range search (exclusive)
                //fixed command, always < and >, never equals
                else {
                    if(!index) {
                        TS.RangeTableScan(Integer.parseInt(cmdArgs[7]), Integer.parseInt(cmdArgs[11]));
                    }
                    else {
                        AS.RangeArrayScan(Integer.parseInt(cmdArgs[7]), Integer.parseInt(cmdArgs[11]));
                    }
                }
            }
            //uh oh
            else {
                System.out.println("SYSTEM:\tError reading input command, please double check syntax");
            }
        }
    }
}