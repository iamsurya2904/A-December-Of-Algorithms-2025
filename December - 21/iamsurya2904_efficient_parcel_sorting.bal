import ballerina/io;
import ballerina/regex;

public function main() {
    string|error line1 = io:readln();
    string|error line2 = io:readln();
    
    if (line2 is string) {
        string[] parts = regex:split(line2, " ");
        int[] weights = [];
        foreach string s in parts {
            if (s != "") {
                weights.push(checkpanic int:fromString(s));
            }
        }
        
        // Problem asks to display the sorted list.
        // Simulation produces a sorted list.
        // We can just sort the array.
        // Bubble sort for simplicity in Ballerina
        int n = weights.length();
        int i = 0;
        while (i < n - 1) {
            int j = 0;
            while (j < n - i - 1) {
                if (weights[j] > weights[j+1]) {
                    int temp = weights[j];
                    weights[j] = weights[j+1];
                    weights[j+1] = temp;
                }
                j = j + 1;
            }
            i = i + 1;
        }
        
        string res = "";
        foreach int w in weights {
            res = res + w.toString() + " ";
        }
        io:println(res.trim());
    }
}
