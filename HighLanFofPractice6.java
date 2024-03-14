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

    int[][] result = nSubInLine(text, sub);
    System.out.println("Sorted array with data(<number of occurrences><index of line in text>):");
    mergeSort(result, 0, result.length - 1);
    printArray(result);
}

// A method for reducing an array with strings
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
    int index = 0;
    for(int a=0; a<text.length; a++){
        n = 0;
        while ((index = text[a].indexOf(sub, index)) != -1) {
            n++;
            index += sub.length();
        }

        res[a][0] = n;
        res[a][1] = a;
        n = 0;
    }
    return res;
}

// A method for printing an array
public static void printArray(int[][] arr) {
    for (int i = 0; i < arr.length; i++) {
        
        for (int j = 0; j < arr[i].length; j++) {
            System.out.print(arr[i][j] + " ");
        }
        System.out.println();
    }
}

// A method for separation the array
public static void mergeSort(int[][] arr, int left, int right) {
    if (left < right) {
        int mid = left + (right - left) / 2;
        mergeSort(arr, left, mid);
        mergeSort(arr, mid + 1, right);
        merge(arr, left, mid, right);
    }
}

// This method implements the merge
public static void merge(int[][] arr, int left, int mid, int right) {
    int[][] temp = new int[right - left + 1][2];
    int i = left, j = mid + 1, k = 0;

    while (i <= mid && j <= right) {
        if (arr[i][0] < arr[j][0] || (arr[i][0] == arr[j][0] && arr[i][1] <= arr[j][1])) {
            temp[k++] = arr[i++];
        } else {
            temp[k++] = arr[j++];
        }
    }

    while (i <= mid) {
        temp[k++] = arr[i++];
    }

    while (j <= right) {
        temp[k++] = arr[j++];
    }

    for (i = left, k = 0; i <= right; i++, k++) {
        arr[i] = temp[k];
    }
}

}
