/**
 * @Author Alexander MacDonald
 * @Date 3/29/2023
 * @Class CS4432
 */
import java.util.Scanner;

public class Main {

    public static void main(String[] args) {
        String cmd = "";

        if(!(args[0].chars().allMatch(Character::isDigit))) {
            System.out.println("Input should be an integer");
            System.exit(1);
        }
        BufferPool bp = new BufferPool(Integer.parseInt(args[0]));
        while(true) {
            System.out.println("The program is ready for the next command:");
            Scanner stdin = new Scanner(System.in);
            cmd = stdin.nextLine();
            String[] cmdArgs = cmd.split(" ");
            if(cmdArgs[0].equalsIgnoreCase("HELP")) {
                System.out.println("The Commands available in this program include:\nHELP\nEXIT\nPRINT\nGET n\nSET n\nPIN n\nUNPIN n");
            }
            else if(cmdArgs[0].equalsIgnoreCase("EXIT")) {
                System.out.println("Exiting Program");
                System.exit(0);
            }
            else if(cmdArgs[0].equalsIgnoreCase("PRINT")) {
                bp.printFrames();
            }
            else if(cmdArgs[0].equalsIgnoreCase("GET")) {
                bp.get(Integer.parseInt(cmdArgs[1]));

            }
            else if(cmdArgs[0].equalsIgnoreCase("SET")) {
                //i love set i love set i love set i love set
                //dont include SET argument and BID argument
                String[] newCmd = new String[cmdArgs.length-2];
                //copy over contents of cmdArgs
                System.arraycopy(cmdArgs, 2, newCmd, 0, cmdArgs.length - 2);
                //join the strings back together
                String spaceDelimeter = String.join(" ", newCmd);
                //remove the quotes
                spaceDelimeter = spaceDelimeter.replace("\"", "");
                bp.set(Integer.parseInt(cmdArgs[1]), spaceDelimeter);
            }
            else if (cmdArgs[0].equalsIgnoreCase("UNPIN")) {
                bp.unpin(Integer.parseInt(cmdArgs[1]));
            }
            else if (cmdArgs[0].equalsIgnoreCase("PIN")) {
                bp.pin(Integer.parseInt(cmdArgs[1]));
            }
        }
    }
}