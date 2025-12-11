import ballerina/io;
import ballerina/regex;

public function main() {
    // Problem asks to reorder linked list zig-zag. L0 Ln L1 Ln-1...
    // Input format: N then values.
    string|error line1 = io:readln(); // Enter N: 4
    string|error line2 = io:readln(); // Enter node values: 1 2 3 4
    
    if (line2 is string) {
        string cleanLine2 = line2;
        int idx = cleanLine2.indexOf(":");
        if (idx is int) {
            cleanLine2 = cleanLine2.substring(idx + 1);
        }
        
        string[] parts = regex:split(cleanLine2, " ");
        int[] values = [];
        foreach string s in parts {
            string trimmed = s.trim();
            if (trimmed != "") {
                values.push(checkpanic int:fromString(trimmed));
            }
        }
        
        int n = values.length();
        int left = 0;
        int right = n - 1;
        string result = "";
        
        while (left <= right) {
            if (left == right) {
                result = result + values[left].toString() + " ";
            } else {
                result = result + values[left].toString() + " " + values[right].toString() + " ";
            }
            left = left + 1;
            right = right - 1;
        }
        
        io:println(result.trim());
    }
}
