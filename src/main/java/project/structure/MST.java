package project.structure;


import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedList;

public class MST {

    public static <V, E extends Comparable<E>> MapGraph<V, E > getMstWithKruskallAlgorithm(Graph<V, E> g) {
        MapGraph<V, E> mst = new MapGraph<>(true);

        ArrayList<V> vertices = g.vertices();
        for (V vert : vertices) {
            mst.addVertex(vert);
        }


        ArrayList<Edge<V, E>> edgesList = (ArrayList<Edge<V, E>>) g.edges();
        edgesList.sort(Comparator.comparing(Edge::getWeight));

        LinkedList<V> connectedVerts;

        for (Edge<V, E> edge : edgesList) {
            connectedVerts = Algorithms.DepthFirstSearch(mst, edge.getVOrig());
            assert connectedVerts != null;
            if (!connectedVerts.contains(edge.getVDest())) {
                mst.addEdge(edge.getVOrig(), edge.getVDest(), edge.getWeight());
            }
        }

        return filterMstKruskall(mst);
    }

    private static <V, E extends Comparable<E>> MapGraph<V, E> filterMstKruskall(Graph<V, E> mst) {
        ArrayList<Edge<V,E>> edgesList = new ArrayList<>(mst.edges());
        edgesList.sort(Comparator.comparing(Edge::getWeight));

        int i = 0;
        while (edgesList.size() != (mst.numVertices() - 1)) {
            if (mst.edges().contains(edgesList.get(i).reverse())) {
                edgesList.remove(edgesList.get(i).reverse());
            }
            ++i;
        }

        MapGraph<V, E> result = new MapGraph<>(true);
        result.vertices().addAll(mst.vertices());
        for (Edge<V, E> edge : edgesList) {
            result.addEdge(edge.getVOrig(), edge.getVDest(), edge.getWeight());
        }

        return result;
    }


    public static <V, E extends Number> MapGraph<V, E> getMstWithPrimAlgorithm(Graph<V, E> redeDistribuicao) {
        ArrayList<V> vertices = redeDistribuicao.vertices();
        int numVert = vertices.size();
        double[] dist = new double[numVert];
        int[] path = new int[numVert];
        boolean[] visited = new boolean[numVert];

        for (int n = 0; n < numVert; n++) {
            dist[n] = Double.POSITIVE_INFINITY;
            path[n] = -1;
            visited[n] = false;
        }

        int vOrig = 0;
        dist[vOrig] = 0;

        while (vOrig != -1) {
            visited[vOrig] = true;
            ArrayList<V> adjacentVerts = new ArrayList<>(redeDistribuicao.adjVertices(vertices.get(vOrig)));
            for (V vAdj : adjacentVerts) {
                Edge<V, E> edge = redeDistribuicao.edge(vertices.get(vOrig), vAdj);
                int adjIndex = vertices.indexOf(vAdj);
                if (!visited[adjIndex] && dist[adjIndex] > edge.getWeight().doubleValue()) {
                    dist[adjIndex] = edge.getWeight().doubleValue();
                    path[adjIndex] = vOrig;
                }
            }
            vOrig = getVertMinDist(dist, visited);
        }
        return filterMstPrim(buildMst(redeDistribuicao, path));
    }

    private static <V, E extends Number> MapGraph<V,E> filterMstPrim(MapGraph<V,E> mst) {
        ArrayList<Edge<V,E>> edges = new ArrayList<>(mst.edges());
        edges.sort(Comparator.comparingDouble(edge -> edge.getWeight().doubleValue()));

        int i = 0;
        while (edges.size() != (mst.numVertices() - 1)) {
            if (mst.edges().contains(edges.get(i).reverse())) {
                edges.remove(edges.get(i).reverse());
            }
            ++i;
        }

        MapGraph<V, E> result = new MapGraph<>(true);
        for (V vert : mst.vertices()) {
            result.addVertex(vert);
        }
        for (Edge<V, E> edge : edges) {
            result.addEdge(edge.getVOrig(), edge.getVDest(), edge.getWeight());
        }

        return result;
    }

    private static int getVertMinDist(double[] dist, boolean[] visited) {
        int minIndex = -1;
        double minDist = Double.POSITIVE_INFINITY;

        for (int i = 0; i < dist.length; i++) {
            if (!visited[i] && dist[i] < minDist) {
                minDist = dist[i];
                minIndex = i;
            }
        }
        return minIndex;
    }

    private static <V, E extends Number> MapGraph<V, E> buildMst(Graph<V, E> graph, int[] path) {
        MapGraph<V, E> mst = new MapGraph<>(false);

        for (V vertex : graph.vertices()) {
            mst.addVertex(vertex);
        }

        for (int i = 0; i < path.length; i++) {
            if (path[i] != -1) {
                V vOrig = graph.vertices().get(path[i]);
                V vDest = graph.vertices().get(i);
                E weight = graph.edge(vOrig, vDest).getWeight();
                mst.addEdge(vOrig, vDest, weight);
            }
        }

        return mst;
    }

    public static <V, E extends Number> int totalWeightMinimumSpanningTree(CommonGraph<V, E> mst) {
        int totalWeight = 0;
        for (Edge<V, E> edge : mst.edges()) {
            totalWeight += edge.getWeight().intValue();
        }
        return totalWeight;
    }

}
