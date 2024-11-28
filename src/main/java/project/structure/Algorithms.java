package project.structure;

import project.domain.Local;

import java.util.*;
import java.util.function.BinaryOperator;

public class Algorithms {


    private static <V, E> LinkedList<V> breadthFirstSearch(Graph<V, E> graph, V vOrig) { //O(V + E)
        LinkedList<V> qbfs = new LinkedList<>();
        qbfs.add(vOrig);
        LinkedList<V> qaux = new LinkedList<>();
        qaux.add(vOrig);
        Map<V, Boolean> visited = new HashMap<>();
        for (V vertex : graph.vertices()) {
            visited.put(vertex, false);
        }
        visited.put(vOrig, true);
        while (!qaux.isEmpty()) {
            vOrig = qaux.pop();
            for (V adj : graph.adjVertices(vOrig)) {
                if (!visited.get(adj)) {
                    qbfs.add(adj);
                    qaux.add(adj);
                    visited.put(adj, true);
                }
            }
        }
        return qbfs;
    }


    private static <V> boolean isNotVisited(V x, List<V> path) {
        return !path.contains(x);
    }

    /**
     * Returns all paths from vOrig to vDest
     *
     * @param g           Graph instance
     * @param vDest       Vertex that will be the end of the path
     * @param currentPath LinkedList of the vertices from the current path
     * @param allPaths    ArrayList with all the paths (in correct order)
     */
    private static <V, E> void findPaths(Graph<V, E> g, V vDest, ArrayList<LinkedList<V>> allPaths, LinkedList<V> currentPath, int aut, int dist) {
        V last = currentPath.get(currentPath.size() - 1);

        if (last.equals(vDest) && dist <= aut) {
            allPaths.add(new LinkedList<>(currentPath));
        }

        Collection<Edge<V, E>> incomingEdges = g.incomingEdges(last);

        for (Edge<V, E> edge : incomingEdges) {
            V neighbor = edge.getVOrig();
            if (isNotVisited(neighbor, currentPath)) {
                int newDist = dist + (int) edge.getWeight();
                currentPath.add(neighbor);
                findPaths(g, vDest, allPaths, currentPath, aut, newDist);
                currentPath.removeLast();
            }
        }
    }

    /**
     * Returns all paths from vOrig to vDest
     *
     * @param g     Graph instance
     * @param vOrig information of the Vertex origin
     * @param vDest information of the Vertex destination
     * @return paths ArrayList with all paths from vOrig to vDest
     */
    public static <V, E> ArrayList<LinkedList<V>> findPaths(Graph<V, E> g, V vOrig, V vDest, int autonomia) {
        ArrayList<LinkedList<V>> allPaths = new ArrayList<>();
        LinkedList<V> initialPath = new LinkedList<>();
        initialPath.add(vOrig);
        findPaths(g, vDest, allPaths, initialPath, autonomia, 0);

        return allPaths;
    }

    /**
     * Performs depth-first search starting in a vertex
     *
     * @param g       Graph instance
     * @param vOrig   vertex of graph g that will be the source of the search
     * @param visited set of previously visited vertices
     * @param qdfs    return LinkedList with vertices of depth-first search
     */
    private static <V, E> void DepthFirstSearch(Graph<V, E> g, V vOrig, boolean[] visited, LinkedList<V> qdfs) {

        visited[g.key(vOrig)] = true;

        qdfs.add(vOrig);

        for (V vertex : g.adjVertices(vOrig)) {
            if (!visited[g.key(vertex)]) {
                DepthFirstSearch(g, vertex, visited, qdfs);
            }
        }
    }

    /**
     * Performs depth-first search starting in a vertex
     *
     * @param g    Graph instance
     * @param vert vertex of graph g that will be the source of the search
     * @return a LinkedList with the vertices of depth-first search
     */
    public static <V, E> LinkedList<V> DepthFirstSearch(Graph<V, E> g, V vert) {

        if (!g.validVertex(vert)) {
            return null;
        }

        boolean[] visited = new boolean[g.numVertices()];

        LinkedList<V> result = new LinkedList<>();

        DepthFirstSearch(g, vert, visited, result);

        return result;
    }

    /**
     * Returns all paths from vOrig to vDest
     *
     * @param g       Graph instance
     * @param vOrig   Vertex that will be the source of the path
     * @param vDest   Vertex that will be the end of the path
     * @param visited set of discovered vertices
     * @param path    stack with vertices of the current path (the path is in reverse order)
     * @param paths   ArrayList with all the paths (in correct order)
     */
    public static <V, E> void allPaths(Graph<V, E> g, V vOrig, V vDest, boolean[] visited,
                                       LinkedList<V> path, ArrayList<LinkedList<V>> paths) {

        visited[g.key(vOrig)] = true;
        path.push(vOrig);
        for (V vAdj : g.adjVertices(vOrig)) {
            if (vAdj.equals(vDest)) {
                path.push(vDest);
                paths.add(revPath(path));
                path.pop();
            } else {
                if (!visited[g.key(vAdj)]) {
                    allPaths(g, vAdj, vDest, visited, path, paths);
                }
            }
        }
        V vertex = path.pop();
        visited[g.key(vertex)] = false;
    }

    /**
     * Reverses the path
     *
     * @param path stack with path
     */
    public static <V> LinkedList<V> revPath(List<V> path) {
        LinkedList<V> pathcopy = new LinkedList<>(path);
        LinkedList<V> pathrev = new LinkedList<>();

        while (!pathcopy.isEmpty()) {
            pathrev.push(pathcopy.pop());
        }
        return pathrev;
    }

    /**
     * Returns all paths from vOrig to vDest
     *
     * @param g     Graph instance
     * @param vOrig information of the Vertex origin
     * @param vDest information of the Vertex destination
     * @return paths ArrayList with all paths from vOrig to vDest
     */
    public static <V, E> ArrayList<LinkedList<V>> allPaths(Graph<V, E> g, V vOrig, V vDest) {
        ArrayList<LinkedList<V>> paths = new ArrayList<>();
        LinkedList<V> path = new LinkedList<>();
        boolean[] visited = new boolean[g.numVertices()];

        if (g.validVertex(vOrig) && g.validVertex(vDest)) {
            allPaths(g, vOrig, vDest, visited, path, paths);
        }
        return paths;
    }

    /**
     * Computes shortest-path distance from a source vertex to all reachable
     * vertices of a graph g with non-negative edge weights
     * This implementation uses Dijkstra's algorithm
     *
     * @param g        Graph instance
     * @param vOrig    Vertex that will be the source of the path
     * @param visited  set of previously visited vertices
     * @param pathKeys minimum path vertices keys
     * @param dist     minimum distances
     */
    public static <V, E> void shortestPathDijkstra(Graph<V, E> g, V vOrig,
                                                   Comparator<E> ce, BinaryOperator<E> sum, E zero,
                                                   boolean[] visited, V[] pathKeys, E[] dist) {

        int vKey = g.key(vOrig);
        dist[vKey] = zero;
        pathKeys[vKey] = vOrig;

        while (vOrig != null) {
            vKey = g.key(vOrig);
            visited[vKey] = true;
            for (Edge<V, E> edge : g.outgoingEdges(vOrig)) {
                int keyVAdj = g.key(edge.getVDest());
                if (!visited[keyVAdj]) {
                    E s = sum.apply(dist[vKey], edge.getWeight());
                    if (dist[keyVAdj] == null || ce.compare(dist[keyVAdj], s) > 0) {
                        dist[keyVAdj] = s;
                        pathKeys[keyVAdj] = vOrig;
                    }
                }
            }

            E minDist = null;
            vOrig = null;
            for (V vertex : g.vertices()) {
                int vertexKey = g.key(vertex);
                if (!visited[vertexKey] && (dist[vertexKey] != null) && ((minDist == null) || ce.compare(dist[vertexKey], minDist) < 0)) {
                    minDist = dist[vertexKey];
                    vOrig = vertex;
                }
            }
        }
    }

    /**
     * Computes shortest-path distance from a source vertex to all reachable
     * vertices of a graph g with non-negative edge weights
     * This implementation uses Dijkstra's algorithm
     *
     * @param g        Graph instance
     * @param vOrig    Vertex that will be the source of the path
     * @param visited  set of previously visited vertices
     * @param pathKeys minimum path vertices keys
     * @param dist     minimum distances
     */
    public static <V, E> void shortestPathDijkstraWithAutonomy(Graph<V, E> g, E autonomia, V vOrig,
                                                               Comparator<E> ce, BinaryOperator<E> sum, E zero,
                                                               boolean[] visited, V[] pathKeys, E[] dist) {

        int vKey = g.key(vOrig);
        dist[vKey] = zero;
        pathKeys[vKey] = vOrig;

        while (vOrig != null) {
            vKey = g.key(vOrig);
            visited[vKey] = true;
            for (Edge<V, E> edge : g.outgoingEdges(vOrig)) {
                int keyVAdj = g.key(edge.getVDest());
                if (!visited[keyVAdj]) {
                    E s = sum.apply(dist[vKey], edge.getWeight());
                    if ((dist[keyVAdj] == null || ce.compare(dist[keyVAdj], s) > 0) && (ce.compare(autonomia, edge.getWeight()) > 0)) {
                        dist[keyVAdj] = s;
                        pathKeys[keyVAdj] = vOrig;
                    }
                }
            }

            E minDist = null;
            vOrig = null;
            for (V vertex : g.vertices()) {
                int vertexKey = g.key(vertex);
                if (!visited[vertexKey] && (dist[vertexKey] != null) && ((minDist == null) || ce.compare(dist[vertexKey], minDist) < 0)) {
                    minDist = dist[vertexKey];
                    vOrig = vertex;
                }
            }
        }
    }


    /**
     * Shortest-path between two vertices
     *
     * @param g         graph
     * @param vOrig     origin vertex
     * @param vDest     destination vertex
     * @param ce        comparator between elements of type E
     * @param sum       sum two elements of type E
     * @param zero      neutral element of the sum in elements of type E
     * @param shortPath returns the vertices which make the shortest path
     * @return if vertices exist in the graph and are connected, true, false otherwise
     */
    public static <V, E> E shortestPath(Graph<V, E> g, V vOrig, V vDest,
                                        Comparator<E> ce, BinaryOperator<E> sum, E zero,
                                        LinkedList<V> shortPath) {
        if (!g.validVertex(vOrig) || !g.validVertex(vDest)) {
            return null;
        }

        shortPath.clear();
        int numVerts = g.numVertices();
        boolean[] visited = new boolean[numVerts];
        V[] pathKeys = (V[]) new Object[numVerts];
        E[] dist = (E[]) new Object[numVerts];
        initializePathDist(numVerts, pathKeys, dist);

        shortestPathDijkstra(g, vOrig, ce, sum, zero, visited, pathKeys, dist);

        E lengthPath = dist[g.key(vDest)];

        if (lengthPath != null) {
            getPath(g, vOrig, vDest, pathKeys, shortPath);
            return lengthPath;
        }

        return null;
    }

    /**
     * Shortest-path between two vertices
     *
     * @param g         graph
     * @param vOrig     origin vertex
     * @param vDest     destination vertex
     * @param ce        comparator between elements of type E
     * @param sum       sum two elements of type E
     * @param zero      neutral element of the sum in elements of type E
     * @param shortPath returns the vertices which make the shortest path
     * @return if vertices exist in the graph and are connected, true, false otherwise
     */
    public static <V, E> E shortestPathWithAutonomy(Graph<V, E> g, E autonomy, V vOrig, V vDest,
                                                    Comparator<E> ce, BinaryOperator<E> sum, E zero,
                                                    LinkedList<V> shortPath) {
        if (!g.validVertex(vOrig) || !g.validVertex(vDest)) {
            return null;
        }

        shortPath.clear();
        int numVerts = g.numVertices();
        boolean[] visited = new boolean[numVerts];
        V[] pathKeys = (V[]) new Object[numVerts];
        E[] dist = (E[]) new Object[numVerts];
        initializePathDist(numVerts, pathKeys, dist);

        shortestPathDijkstraWithAutonomy(g, autonomy, vOrig, ce, sum, zero, visited, pathKeys, dist);

        E lengthPath = dist[g.key(vDest)];

        if (lengthPath != null) {
            getPath(g, vOrig, vDest, pathKeys, shortPath);
            return lengthPath;
        }

        return null;
    }

    public static <V, E> void initializePathDist(int numVerts, V[] pathKeys, E[] dist) {
        for (int i = 0; i < numVerts; i++) {
            pathKeys[i] = null;
            dist[i] = null;
        }
    }

    /**
     * Shortest-path between a vertex and all other vertices
     *
     * @param g     graph
     * @param vOrig start vertex
     * @param ce    comparator between elements of type E
     * @param sum   sum two elements of type E
     * @param zero  neutral element of the sum in elements of type E
     * @param paths returns all the minimum paths
     * @param dists returns the corresponding minimum distances
     * @return if vOrig exists in the graph true, false otherwise
     */
    public static <V, E> boolean shortestPaths(Graph<V, E> g, V vOrig,
                                               Comparator<E> ce, BinaryOperator<E> sum, E zero,
                                               ArrayList<LinkedList<V>> paths, ArrayList<E> dists) {

        if (!g.validVertex(vOrig)) {
            return false;
        }
        paths.clear();
        dists.clear();
        int numVertices = g.numVertices();
        boolean[] visited = new boolean[numVertices];
        V[] pathKeys = (V[]) new Object[numVertices];
        E[] dist = (E[]) new Object[numVertices];
        initializePathDist(numVertices, pathKeys, dist);

        shortestPathDijkstra(g, vOrig, ce, sum, zero, visited, pathKeys, dist);

        dists.clear();
        paths.clear();
        for (int i = 0; i < numVertices; i++) {
            paths.add(null);
            dists.add(null);
        }
        for (V vDist : g.vertices()) {
            int i = g.key(vDist);
            if (dist[i] != null) {
                LinkedList<V> shortPath = new LinkedList<>();
                getPath(g, vOrig, vDist, pathKeys, shortPath);
                paths.set(i, shortPath);
                dists.set(i, dist[i]);
            }
        }

        return true;
    }

    /**
     * Extracts from pathKeys the minimum path between voInf and vdInf
     * The path is constructed from the end to the beginning
     *
     * @param g        Graph instance
     * @param vOrig    information of the Vertex origin
     * @param vDest    information of the Vertex destination
     * @param pathKeys minimum path vertices keys
     * @param path     stack with the minimum path (correct order)
     */
    private static <V, E> void getPath(Graph<V, E> g, V vOrig, V vDest,
                                       V[] pathKeys, LinkedList<V> path) {

        if (vOrig.equals(vDest))
            path.push(vDest);
        else {
            path.push(vDest);
            int keyVDest = g.key(vDest);
            vDest = pathKeys[keyVDest];
            getPath(g, vOrig, vDest, pathKeys, path);
        }
    }

    /**
     * Calculates the betweenness centrality for each vertex in the graph using Brandes' algorithm.
     * Betweenness centrality measures the extent to which a vertex lies on the shortest paths
     * between other vertices in the graph.
     *
     * @param graph The graph for which to calculate betweenness centrality.
     * @param <V>   The type of vertex in the graph.
     * @param <E>   The type of edge in the graph.
     * @return A map where each vertex is associated with its betweenness centrality value.
     */
    public static <V, E> Map<V, Integer> betweennessCentrality(Graph<V, E> graph) {
        Map<V, Integer> centrality = new HashMap<>();


        for (V vertex : graph.vertices()) {
            centrality.put(vertex, 0);
        }

        for (V source : graph.vertices()) {
            LinkedList<V> queue = new LinkedList<>();
            queue.add(source);

            Map<V, Integer> numShortestPaths = new HashMap<>();
            numShortestPaths.put(source, 1);

            Map<V, Integer> dependency = new HashMap<>();
            for (V vertex : graph.vertices()) {
                dependency.put(vertex, 0);
            }

            Map<V, Integer> distance = new HashMap<>();
            distance.put(source, 0);

            while (!queue.isEmpty()) {
                V currentVertex = queue.poll();

                for (V neighbor : graph.adjVertices(currentVertex)) {
                    if (!distance.containsKey(neighbor)) {
                        distance.put(neighbor, distance.get(currentVertex) + 1);
                        queue.add(neighbor);
                    }

                    if (distance.get(neighbor) == distance.get(currentVertex) + 1) {
                        numShortestPaths.put(neighbor, numShortestPaths.getOrDefault(neighbor, 0) + numShortestPaths.get(currentVertex));
                        dependency.put(neighbor, dependency.get(neighbor) + 1);
                    }
                }
            }

            for (V vertex : graph.vertices()) {
                if (!vertex.equals(source)) {
                    centrality.put(vertex, centrality.get(vertex) + (dependency.get(vertex) / numShortestPaths.get(vertex)));
                }
            }
        }
        return centrality;
    }


    /**
     * Finds a circuit by applying the nearest neighbor heuristic in a graph, considering a hubs list and autonomy.
     *
     * @param <V>            The vertex type in the graph.
     * @param <E>            The edge type in the graph.
     * @param g              The graph where the circuit needs to be found.
     * @param n              The number of iterations for selecting hubs.
     * @param startVertex    The starting vertex for the circuit.
     * @param hubs           The list of hubs to be considered during the circuit formation.
     * @param ce             The comparator for edges in the graph.
     * @param sum            The binary operator to sum edges.
     * @param zero           The zero element for the edge sum.
     * @param autonomia      The autonomy constraint value.
     * @return               A LinkedList representing the circuit found in the graph.
     */
    public static <V,E> LinkedList<V> nearestNeighbor(Graph<V, E> g, int n, V startVertex, List<V> hubs, Comparator<E> ce, BinaryOperator<E> sum, E zero, E autonomia) {
        int hubIndex;
        LinkedList<V> circuit = new LinkedList<>();
        V previousVertex = startVertex;

        circuit.add(startVertex);

        for (int i = 0; i < n; i++) {
            hubIndex = Integer.MIN_VALUE;

            LinkedList<V> shortestPath = new LinkedList<>();

            int shortestValue = Integer.MAX_VALUE;

            for (int j = 0; j < hubs.size(); j++) {
                LinkedList<V> shortPath = new LinkedList<>();
                V selectedHub = hubs.get(j);
                shortestPathWithAutonomy(g, autonomia, previousVertex, selectedHub, ce, sum, zero, shortPath);


                if (pathSize(g, shortPath) < shortestValue) {
                    shortestValue = pathSize(g, shortPath);
                    shortestPath = new LinkedList<>(shortPath);
                    hubIndex = j;
                }
            }

            previousVertex = hubs.get(hubIndex);
            hubs.remove(hubIndex);

            if (shortestPath.size() > 1) {
                shortestPath.removeFirst();
            }

            Collection<V> vertex = g.adjVertices(circuit.getLast());
            boolean auxBoolean = false;
            for (V aux : vertex) {
                if (!circuit.isEmpty() && !shortestPath.isEmpty()) {
                    if (aux.equals(shortestPath.get(0)) && !auxBoolean) {
                        circuit.addAll(shortestPath);
                        auxBoolean = true;
                    }
                }
            }
        }

        if (circuit.size() > n){
            LinkedList<V> shortPathReturn = new LinkedList<>();

            shortestPathWithAutonomy(g, autonomia, previousVertex, startVertex, ce, sum, zero, shortPathReturn);

            if (shortPathReturn.size() > 1){
                shortPathReturn.removeFirst();
            }
            circuit.addAll(shortPathReturn);
        }

        return circuit;
    }

    /**
     * Calculates the total size or weight of a given path in a graph based on edge weights.
     *
     * @param <V>    The vertex type in the graph.
     * @param <E>    The edge type in the graph.
     * @param graph  The graph containing vertices and edges.
     * @param path   The path represented as a list of vertices.
     * @return       The total size or weight of the provided path in the graph.
     */
    private static <V,E> Integer pathSize(Graph<V, E> graph, LinkedList<V> path){
        int total = 0;
        for (int i = 0; i < path.size() - 1; i++) {
            total += Integer.parseInt(String.valueOf(graph.edge(path.get(i), path.get(i + 1)).getWeight()));
        }

        return total;
    }


    /**
     * Obtem N clusters com vertices do grafo, seguindo o algoritmo de Girvan Newman e com o de Brandes.
     * @param graph grafo
     * @param numClusters numero de clusters
     * @param hubList lista de hubs do grafo
     * @return clusters
     * @param <V> vertice
     * @param <E> integer
     */
    public static <V, E> Set<Set<V>> getNClusters(MapGraph<V, E> graph, int numClusters, List<V> hubList) { //O(V^3 * E)
        MapGraph<V, E> copycat = new MapGraph<>(graph); // O1
        Set<Set<V>> clusterSets = new HashSet<>(); //
        boolean thereWasASlipt; //1
        Map<V, Set<V>> clusters = new HashMap<>(); // 1

        for (V hub : graph.getHubsVertexList().subList(0, numClusters)) { //N
            clusters.put(hub, new HashSet<>()); //1
            clusters.get(hub).add(hub); //1
        }

        Map<Edge<V, E>, Double> edgeBetweenness; //1
        Edge<V, E> biggestEdge = null; //1
        double edgeCentrality = -1; //1

        do { //O(V^3 * E)
            double currentBiggestCentrality = edgeCentrality; //1
            thereWasASlipt = false; //1
            edgeBetweenness = edgeBetweennessCentrality(copycat); // //O(V^2 * E)

            for (Edge<V, E> edge : edgeBetweenness.keySet()) { // E
                if (edgeBetweenness.get(edge) > edgeCentrality) { // 1
                    edgeCentrality = edgeBetweenness.get(edge); //1
                    biggestEdge = edge; //1
                }
            }

            if (biggestEdge != null) { // ? ciclo
                copycat.removeEdge(biggestEdge.getVOrig(), biggestEdge.getVDest()); //1
                copycat.removeEdge(biggestEdge.reverse().getVOrig(), biggestEdge.reverse().getVDest()); //1
            }

            for (V hub : clusters.keySet()) { //V
                int formerSize = clusters.get(hub).size(); //1
                clusters.get(hub).clear(); //V
                List<V> bfsHub = breadthFirstSearch(copycat, hub); //O(V + E)
                if ((formerSize != 1) && (formerSize != bfsHub.size())) { //1
                    thereWasASlipt = true; //1
                }
                clusters.get(hub).addAll(bfsHub); //V
            }

            if (thereWasASlipt || currentBiggestCentrality == edgeCentrality) { //V
                edgeCentrality = -1; //V
            }

        } while (!areClustersIsolated(copycat, clusters));  //O(N^2 * (V/N)) m -average n in clusters -> N clusters (V/N)
        //O(V^3 * E)

        for (Map.Entry<V, Set<V>> entry : clusters.entrySet()) { // O(N * (V/N))
            Set<V> clust = new HashSet<>(entry.getValue());
            clust.add(entry.getKey());
            clusterSets.add(clust);
        }

        if (!checkLeftOutVertexes(graph, clusterSets)) { //O(N * (V/N))
            correctClusters(graph, clusterSets, numClusters); //O(N * V * E) -> O(N * V2 * E)
        }
        return clusterSets;
    }

    /**
     * no caso de haverem vertices isolados
     * @param graph grafo
     * @param clusterSets cluters existentes
     * @param numClusters numero de clusters desejados
     * @param <E> integer
     * @param <V> vertices
     */
    private static <E, V> void correctClusters(MapGraph<V, E> graph, Set<Set<V>> clusterSets, int numClusters) {//O(N * V * E)
        List<V> leftoutVertexes = new ArrayList<>(graph.vertices);
        Set<V> clusterVertexes = new HashSet<>();
        Map<V, V> clusterBuddies = new HashMap<>();
        boolean asHub = false;
        for (Set<V> cluster : clusterSets) { //V
            clusterVertexes.addAll(cluster);
        }
        leftoutVertexes.removeAll(clusterVertexes); //O(V2)
        if (clusterSets.size() != numClusters) { //N
            for (V vertex : leftoutVertexes) { //V
                if (vertex.getClass().getSimpleName().equals("Local")) {
                    Local local = (Local) vertex;
                    if (local.isHub()) {
                        asHub = true;
                    }
                }
            }
            if (asHub) { //V
                clusterSets.add(new HashSet<>(leftoutVertexes)); //V
            } else {
                boolean isPossible = false;
                do {
                    Edge<V, E> smallestCentralityHubEdge = getEdgeWithLessCentralityAndHub(graph, leftoutVertexes); //V*E
                    V hub;
                    if (leftoutVertexes.contains(smallestCentralityHubEdge.getVOrig())) { //1
                        hub = smallestCentralityHubEdge.getVDest(); //1
                    } else {
                        hub = smallestCentralityHubEdge.getVOrig(); //1
                    }
                    if (checkIfWithoutHubClusterExists(hub, clusterSets)) {  //N * (V/N)
                        isPossible = true;//1
                        for (Set<V> set : clusterSets) {//N
                            set.remove(hub);//1
                        }
                        leftoutVertexes.add(hub);//1
                        clusterSets.add(new HashSet<>(leftoutVertexes));//1
                    } else {
                        graph.removeEdge(smallestCentralityHubEdge.getVOrig(), smallestCentralityHubEdge.getVDest());//1
                        graph.removeEdge(smallestCentralityHubEdge.reverse().getVOrig(), smallestCentralityHubEdge.reverse().getVDest());//1
                    }
                } while (!isPossible);
                //O(N * V * E)
            }
        } else {
            Map<Edge<V, E>, Double> edgeBetweenness = edgeBetweennessCentrality(graph);
            for (V vertex : leftoutVertexes) { //V
                V clusterBelonger;
                Edge<V, E> smallestCentralityEdge = getEdgeWithLessCentrality(vertex, edgeBetweenness); //E
                if (vertex.equals(smallestCentralityEdge.getVOrig())) {//1
                    clusterBelonger = smallestCentralityEdge.getVDest();//1
                } else {
                    clusterBelonger = smallestCentralityEdge.getVOrig();//1
                }
                clusterBuddies.put(vertex, clusterBelonger);//1
            }
            //V*E

            for (V vertex : clusterBuddies.keySet()) { //V
                for (Set<V> cluster : clusterSets) { //N
                    if (cluster.contains(clusterBuddies.get(vertex))) {
                        cluster.add(vertex);
                        break;
                    }
                }
            }
            //N*V
        }
    }

    /**
     * Verifica se ao se retirar um hub se o cluster ainda existe (ainda contem outros hubs)
     * @param hub hub
     * @param clusterSets clusters
     * @return true - se o cluster ainda tiver hubs, false se o contrario
     * @param <V> vertices
     */
    private static <V> boolean checkIfWithoutHubClusterExists(V hub, Set<Set<V>> clusterSets) { //N * (V/N)
        Set<V> cluster = null;
        for (Set<V> set : clusterSets) {
            if (set.contains(hub)) {
                cluster = new HashSet<>(set);
            }
        }
        if (cluster != null) {
            cluster.remove(hub);
            for (V vertex : cluster) {
                if (vertex.getClass().getSimpleName().equals("Local")) {
                    Local local = (Local) vertex;
                    if (local.isHub()) {
                        return true;
                    }
                }
            }
        }
        return false;
    }

    /**
     * Obtem a edge com menor centralidade onde o vertice de origem ou destino pertence ao vertices isolados
     * @param graph grafo
     * @param leftoutVertexes vertices isolados
     * @return edge com menor centralidade e com hub conectado a um vertice isolado
     * @param <E> integer
     * @param <V> vertice
     */
    private static <E, V> Edge<V, E> getEdgeWithLessCentralityAndHub(MapGraph<V, E> graph, List<V> leftoutVertexes) {//V*E
        Map<Edge<V, E>, Double> edgeBetweenness = edgeBetweennessCentrality(graph);
        Map<Edge<V, E>, Double> edgesVertex = new HashMap<>();
        double smallestCentrality = Double.POSITIVE_INFINITY;
        Edge<V, E> chosenOne = null;
        for (V vertex : leftoutVertexes) { //V
            for (Edge<V, E> edge : graph.edges()) { // E
                if ((edge.getVOrig().equals(vertex) && checkOtherVertex(edge.getVDest()) || (edge.getVDest().equals(vertex) && checkOtherVertex(edge.getVOrig())))) {
                    edgesVertex.put(edge, edgeBetweenness.get(edge));
                }
            }
        }
        //V*E
        for (Edge<V, E> edge : edgesVertex.keySet()) { //E
            if (edgesVertex.get(edge) < smallestCentrality) {
                smallestCentrality = edgesVertex.get(edge);
                chosenOne = edge;
            }
        }
        return chosenOne;
    }

    /**
     * verifica se o outro vertice da edge é um hub
     * @param vDest vertice, potencialmente um hub
     * @return true se o vertice for um hub
     * @param <V> vertice
     */
    private static <V> boolean checkOtherVertex(V vDest) { //1
        if (vDest.getClass().getSimpleName().equals("Local")) {
            Local local = (Local) vDest;
            return local.isHub();
        }
        return false;
    }

    /**
     * Obtencao da edge com menor centralidade ligada a um vertice passado como parametro
     * @param vertex vertice
     * @param edgeBetweenness mapa com a centralidade de cada edge
     * @return a edge com menor centralidade
     * @param <V> vertice
     * @param <E> integer
     */
    private static <V, E> Edge<V, E> getEdgeWithLessCentrality(V vertex, Map<Edge<V, E>, Double> edgeBetweenness) { //E
        Edge<V, E> lessCentralEdge = null;
        double smallCentrality = Double.POSITIVE_INFINITY;

        for (Edge<V, E> edge : edgeBetweenness.keySet()) {
            if (edge.getVOrig().equals(vertex) || edge.getVDest().equals(vertex)) {
                if (edgeBetweenness.get(edge) < smallCentrality) {
                    lessCentralEdge = edge;
                }
            }
        }
        return lessCentralEdge;
    }

    /**
     * Verificacao da existencia de vertices isolados
     * @param graph grafo
     * @param clusterSets clusters
     * @return true se existem vertices isolados, falso se não existirem
     * @param <E> integer
     * @param <V> vertices
     */
    private static <E, V> boolean checkLeftOutVertexes(MapGraph<V, E> graph, Set<Set<V>> clusterSets) {
        int vertexesClusters = 0;
        for (Set<V> cluster : clusterSets) {
            vertexesClusters += cluster.size();
        }
        return vertexesClusters == graph.vertices.size();
    }

    /**
     * Verifica se os clusters existentes estão isolados
     * @param graph grafo
     * @param clusters clusters
     * @return confirmação de que os clusters estao ou nao isolados
     * @param <E> integer
     * @param <V> vertices
     */
    private static <E, V> boolean areClustersIsolated(MapGraph<V, E> graph, Map<V, Set<V>> clusters) { //O(N^2 * m) m -average n in clusters -> N clusters
        for (Set<V> cluster : clusters.values()) {
            for (Set<V> nextOne : clusters.values()) {
                if (cluster != nextOne) {
                    List<V> clusterV = cluster.stream().toList();
                    List<V> nextOneV = nextOne.stream().toList();
                    for (int i = 0; i < clusterV.size() - 1; i++) {
                        for (int j = 0; j < nextOneV.size() - 1; j++) {
                            if ((clusterV.get(i) != nextOneV.get(j)) && (graph.edge(clusterV.get(i), nextOneV.get(j)) != null)) {
                                return false;
                            }
                        }
                    }
                }
            }
        }
        return true;
    }

    /**
     * Obtem o indice de centralidade das edges do grafo, seguindo o Algoritmo de Girvan Newman e de Brandes
     * @param graph grafo
     * @return mapa com as edges e a sua centralidade
     * @param <V> vertices
     * @param <E> integer
     */
    private static <V, E> Map<Edge<V, E>, Double> edgeBetweennessCentrality(MapGraph<V, E> graph) {//O(V^2 * E)
        Map<Edge<V, E>, Double> result = new HashMap<>();
        Map<Edge<V, E>, Double> edgeBetweenness = new HashMap<>();
        boolean btnFiltered = false;
        Map<V, List<Integer>> vertexScores = new HashMap<>();
        List<Integer> sourceVertexMap;
        int sourceLevel = 1;

        for (Edge<V, E> edge : graph.edges()) { //O(V)
            result.put(edge, 0.0); //1
        }

        for (V vertex : graph.vertices) { //V
            edgeBetweenness.clear(); //V

            initializeVertexScoresAndLevels(vertexScores, graph); //O(V)

            sourceVertexMap = vertexScores.get(vertex); //1
            sourceVertexMap.set(0, sourceLevel); //1
            sourceVertexMap.set(1, 1); //1

            List<V> listPath = Algorithms.breadthFirstSearch(graph, vertex); //O(V + E)

            //levels
            for (V node : listPath) { //O(V2)
                int currentNodeLevel = vertexScores.get(node).get(0);
                for (V adj : graph.adjVertices(node)) {
                    if (vertexScores.get(adj).get(0) == -1) {
                        sourceVertexMap = vertexScores.get(adj);
                        sourceVertexMap.set(0, currentNodeLevel + 1);
                    }
                }
            }

            filterAndFillEdgeBetweennessMap(graph, edgeBetweenness, vertexScores); //O(E)

            if (!btnFiltered) {
                filterAndFillEdgeBetweennessMap(graph, result, vertexScores); //O(E)
                btnFiltered = true;
            }
            getVertexesScores(graph, listPath, vertexScores); //O(V2)
            calculateEdgeBetwenness(listPath, edgeBetweenness, vertexScores); //O(V * E)
            addEdgeBetwennessToResult(edgeBetweenness, result); //O(E)
        }
        return result;
    }

    /**
     * Adiciona ao resultado final o valor de centralidade das edges a cada iteracao
     * @param edgeBetweenness mapa com as centralidades das edges
     * @param result resultado
     * @param <V> vertices
     * @param <E> integer
     */
    private static <V, E> void addEdgeBetwennessToResult(Map<Edge<V, E>, Double> edgeBetweenness, Map<Edge<V, E>, Double> result) { //O(E)
        for (Edge<V, E> edge : edgeBetweenness.keySet()) {
            if (!result.containsKey(edge)) {
                result.put(edge, edgeBetweenness.get(edge));
            } else {
                result.put(edge, result.get(edge) + edgeBetweenness.get(edge));
            }
        }
    }

    /**
     * Filtra e preenche o mapa da centralidade das edges
     * @param graph grafo
     * @param edgeBetweenness mapa com as centralidades
     * @param vertexScores mapa com os niveis e valores dos vertices
     * @param <V> vertices
     * @param <E> integer
     */
    private static <V, E> void filterAndFillEdgeBetweennessMap(MapGraph<V, E> graph, Map<Edge<V, E>, Double> edgeBetweenness, Map<V, List<Integer>> vertexScores) { //O(E)
        List<Edge<V, E>> edgesToRemove = new ArrayList<>();
        List<Edge<V, E>> edges = new ArrayList<>(graph.edges());
        for (Edge<V, E> edge : edges) {
            if (vertexScores.get(edge.getVOrig()).get(0) >= vertexScores.get(edge.getVDest()).get(0)) {
                edgesToRemove.add(edge);
            }
        }
        edges.removeAll(edgesToRemove);
        for (Edge<V, E> edge : edges) {
            edgeBetweenness.put(edge, 0.0);
        }
    }

    /**
     * Calcula o indice de centralidade das edges do grafo para cada iteracao da pesquisa do grafo
     * @param listPath lista obtida atraves do breadth-first-search
     * @param edgeBetweenness mapa das centralidades das edges
     * @param vertexScores mapa com os niveis e valores dos vertices
     * @param <V> vertices
     * @param <E> integer
     */
    private static <V, E> void calculateEdgeBetwenness(List<V> listPath, Map<Edge<V, E>, Double> edgeBetweenness, Map<V, List<Integer>> vertexScores) { //O(V * E)
        Map<V, Double> sumEdges = new HashMap<>();
        List<V> vOrigEdgesVDest = new ArrayList<>();

        for (int i = listPath.size() - 1; i > -1; i--) {
            sumEdges.clear();
            for (Edge<V, E> edge : edgeBetweenness.keySet()) {
                if (edge.getVOrig().equals(listPath.get(i))) {
                    double edgeSoloScore = (double) vertexScores.get(edge.getVOrig()).get(1) / vertexScores.get(edge.getVDest()).get(1);
                    edgeBetweenness.put(edge, edgeSoloScore);
                    vOrigEdgesVDest.add(edge.getVDest());
                }
            }
            if (!vOrigEdgesVDest.isEmpty()) {
                for (V destination : vOrigEdgesVDest) {
                    for (Edge<V, E> edge : edgeBetweenness.keySet()) {
                        if (edge.getVOrig().equals(destination)) {
                            if (sumEdges.containsKey(destination)) {
                                sumEdges.put(destination, sumEdges.get(destination) + edgeBetweenness.get(edge));
                            } else {
                                sumEdges.put(destination, edgeBetweenness.get(edge));
                            }

                        }
                    }
                }
            }
            for (Edge<V, E> edge : edgeBetweenness.keySet()) {
                if (edge.getVOrig().equals(listPath.get(i))) {
                    if (sumEdges.containsKey(edge.getVDest())) {
                        edgeBetweenness.put(edge, edgeBetweenness.get(edge) + sumEdges.get(edge.getVDest()));
                    }
                }
            }
            vOrigEdgesVDest.clear();
        }
    }

    /**
     * Obtem a pontuaçao de cada vertice aquando a iteracao atual do grafo
     * @param graph grafo
     * @param listPath lista bfs
     * @param vertexScores  mapa com os niveis e valores dos vertices
     * @param <V> vertices
     * @param <E> integer
     */
    private static <V, E> void getVertexesScores(MapGraph<V, E> graph, List<V> listPath, Map<V, List<Integer>> vertexScores) { //O(V2)
        MapGraph<V, E> copycat = new MapGraph<>(graph);
        for (V vertex : listPath) {
            List<Edge<V, E>> incomingEdges = copycat.incomingEdges(vertex).stream().toList();
            for (Edge<V, E> edge : incomingEdges) {
                int scoreVOrig = vertexScores.get(edge.getVOrig()).get(0);
                int scoreVertex = vertexScores.get(vertex).get(0);
                if (scoreVOrig < scoreVertex) {
                    vertexScores.get(vertex).set(1, vertexScores.get(vertex).get(1) + 1);
                    copycat.removeEdge(edge.getVOrig(), edge.getVDest());
                    copycat.removeEdge(edge.getVDest(), edge.getVOrig());
                }
            }
        }
    }

    /**
     * Inicializa o mapa com os niveis e valores dos vertices
     * @param vertexScores  mapa com os niveis e valores dos vertices
     * @param graph grafo
     * @param <V> vertices
     * @param <E> integer
     */
    private static <V, E> void initializeVertexScoresAndLevels(Map<V, List<Integer>> vertexScores, MapGraph<V, E> graph) { //O(V)
        for (V vertex : graph.vertices) {
            List<Integer> sourceVertexMap = new LinkedList<>();
            sourceVertexMap.add(0, -1);
            sourceVertexMap.add(1, 0);
            vertexScores.put(vertex, sourceVertexMap);
        }
    }

}