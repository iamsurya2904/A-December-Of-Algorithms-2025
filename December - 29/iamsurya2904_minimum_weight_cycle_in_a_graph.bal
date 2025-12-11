import ballerina/io;
import ballerina/regex;

type Edge record {
    int u;
    int v;
    int w;
};

public function main() {
    // Problem asks to parse V and edges list.
    // Parse V
    string|error l1 = io:readln(); // V = 5
    // Parse edges array
    // input format logic required
    // Assuming JSON-like or text:
    // edges = [
    //  [0, 1, 2], ...
    // ]
    // I'll assume I need to read until end of array
    
    if (l1 is string) {
        string[] p1 = regex:split(l1, "=");
        int v = checkpanic int:fromString(p1[1].trim());
        
        string|error l2 = io:readln(); // edges = [
        
        Edge[] edges = [];
        
        while (true) {
            string|error line = io:readln();
            if (line is string) {
                if (line.indexOf("]") != -1) {
                    break;
                }
                // Parse [0, 1, 2],
                int idxOpen = line.indexOf("[");
                int idxClose = line.indexOf("]");
                if (idxOpen is int && idxClose is int) {
                    string content = line.substring(idxOpen + 1, idxClose);
                    string[] nums = regex:split(content, ",");
                    if (nums.length() >= 3) {
                         int u = checkpanic int:fromString(nums[0].trim());
                         int vv = checkpanic int:fromString(nums[1].trim());
                         int w = checkpanic int:fromString(nums[2].trim());
                         edges.push({u: u, v: vv, w: w});
                    }
                }
            } else {
                break;
            }
        }
        
        int minCycle = 2147483647;
        
        // Algorithm: For each edge (u, v, w), find shortest path u-v in graph excluding this edge.
        // Cycle = w + dist(u, v)
        // Since V is small (500), we can run Dijkstra for each edge? E up to 125000? No.
        // Wait, strict constraint V<=500. E can be large.
        // Optimize: Only run Dijkstra V times (for each vertex).
        // For each vertex 's', run Dijkstra.
        // Checking back edges?
        // Actually, running Dijkstra from 's' computes shortest path to all nodes.
        // If there is an edge (x, y) such that in BFS tree, they are connected?
        // Correct approach with V Dijkstra runs:
        // Iterate all s in V.
        // Run Dijkstra(s).
        // For every edge (u, v, w) in graph:
        // If dist[u] + dist[v] + w < minCycle?
        // This finds a cycle passing through s? No.
        
        // Let's use the simplest correct approach for small V:
        // iterate all edges, remove edge, dijkstra.
        // If E is small (sample E=6), it's fast.
        // If E is huge, this TLEs.
        // Assuming typical density not full clique.
        
        // I will implement "Remove edge and run Dijkstra"
        
        // Build Adjacency List for ALL edges first
        foreach int k in 0 ... (edges.length() - 1) {
             Edge e = edges[k];
             // We need to pass adjacency list excluding e
             // Or pass index to ignore
             int dist = dijkstra(v, edges, e.u, e.v, k);
             if (dist != -1) {
                 if (dist + e.w < minCycle) {
                     minCycle = dist + e.w;
                 }
             }
        }
        
        io:println(minCycle);
    }
}

function dijkstra(int n, Edge[] allEdges, int startNode, int endNode, int ignoreIdx) returns int {
    // Build adj map excluding ignoreIdx
    map<int[][]> adj = {};
    int k = 0;
    while (k < allEdges.length()) {
        if (k != ignoreIdx) {
            Edge e = allEdges[k];
            // Undirected
             int[][] listU = adj.get(e.u.toString()) ?: [];
             listU.push([e.v, e.w]);
             adj[e.u.toString()] = listU;
             
             int[][] listV = adj.get(e.v.toString()) ?: [];
             listV.push([e.u, e.w]);
             adj[e.v.toString()] = listV;
        }
        k = k + 1;
    }
    
    int[] dist = [];
    boolean[] visited = [];
    int i = 0;
    while (i < n) {
        dist.push(2147483647);
        visited.push(false);
        i = i + 1;
    }
    dist[startNode] = 0;
    
    int count = 0;
    while (count < n) {
        int u = -1;
        int minVal = 2147483647;
        
        int j = 0;
        while (j < n) {
            if (!visited[j] && dist[j] < minVal) {
                minVal = dist[j];
                u = j;
            }
            j = j + 1;
        }
        
        if (u == -1 || u == endNode) {
            break;
        }
        
        visited[u] = true;
        
        int[][] neighbors = adj.get(u.toString()) ?: [];
        foreach int[] edge in neighbors {
            int to = edge[0];
            int w = edge[1];
            if (dist[u] != 2147483647 && dist[u] + w < dist[to]) {
                dist[to] = dist[u] + w;
            }
        }
        count = count + 1;
    }
    
    if (dist[endNode] == 2147483647) {
        return -1;
    }
    return dist[endNode];
}
