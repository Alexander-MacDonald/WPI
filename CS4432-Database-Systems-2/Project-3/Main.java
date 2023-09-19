/**
 * @Author Alexander MacDonald
 * @Date 4/30/2023
 * @Class CS4432
 */
import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        //cmd of user input
        String cmd = "";

        //always
        while(true) {
            //starter text
            //command logic
            System.out.println("SYSTEM:\tProgram is ready and waiting for user command.");
            Scanner stdin = new Scanner(System.in);
            cmd = stdin.nextLine();
            CMD userStdin = new CMD(cmd);
        }
    }
}