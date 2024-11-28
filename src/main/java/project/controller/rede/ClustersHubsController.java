package project.controller.rede;

import project.domain.Local;
import project.structure.Algorithms;
import project.structure.MapGraph;

import java.util.List;
import java.util.Set;

public class ClustersHubsController {
    public Set<Set<Local>> getNClusters(MapGraph<Local, Integer> graph, int numClusters, List<Local> hublist) {
        return Algorithms.getNClusters(graph, numClusters, hublist);
    }
}
