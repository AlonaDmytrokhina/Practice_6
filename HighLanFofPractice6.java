import java.util.ArrayList;
import java.util.Arrays;
import java.util.Scanner;

class HighLanForPractice6 {

public static void main(String[] args) {
    Scanner scanner = new Scanner(System.in);
    String[] text = new String[100];

    System.out.print("Enter the substring: ");
    String sub = scanner.nextLine();

    System.out.println("Enter the lines (to finish this input enter 'exit'): ");
    String line = scanner.nextLine();
    int n = 0;
    while (!line.equalsIgnoreCase("exit")) {
        text[n] = line;
        n++;
        line = scanner.nextLine();
    }

    for(int i=0; i<text.length; i++){
        if(text[i]==null){
            text = editedText(text, i);
            break;
        }
    }

    printArray(nSubInLine(text, sub));

}

private static String[] editedText(String[] text, int end){
    String[] edited = new String[end];
    for(int i=0; i<edited.length; i++){
        edited[i] = text[i];
    }
    return edited;
}

// Method for finding a number of substrings in lines of the text
private static int[][] nSubInLine(String[] text, String sub){
    int[][] res = new int[text.length][2];
    int n = 0;
    // int index = 0;
    boolean check = true;
    for(int a=0; a<text.length; a++){
        n = 0;
        for(int i=0; i<text[a].length(); i++){
            check = true;
            for(int j=0; j<sub.length(); j++){
                if(sub.charAt(j)!=text[a].charAt(i+j)){
                    check = false;
                    break;
                }
            }
            if(check){
                n++;
                if(text[a].length() > i+sub.length()){
                    i+=sub.length();
                }
                else{
                    break;
                }
            }
        }

        /*while ((index = text[a].indexOf(sub, index)) != -1) {
            n++;
            index += sub.length();
        }*/

        res[a][0] = n;
        res[a][1] = a;
        n = 0;
    }
    return res;
}

public static void printArray(int[][] arr) {
    for (int i = 0; i < arr.length; i++) {
        
        for (int j = 0; j < arr[i].length; j++) {
            System.out.print(arr[i][j] + " ");
        }
        System.out.println();
    }
}

}