import ballerina/io;
import ballerina/lang.value;

public function main() {
    string|error input = io:readln();
    if (input is string) {
        // Remove quotes if present? Sample input "324" or "[123...]"
        // value:fromJsonString handles standard JSON.
        // If input contains quotes around the string, we might need to remove them.
        string clean = input;
        if (clean.startsWith("\"") && clean.endsWith("\"")) {
            clean = clean.substring(1, clean.length() - 1);
        }
        // Unescape internal quotes if needed? Likely raw input.
        
        json|error j = value:fromJsonString(clean);
        if (j is json) {
             io:println(j.toString());
        } else {
            // Fallback: just print the input as it likely requests the structure string back
            io:println(clean);
        }
    }
}
