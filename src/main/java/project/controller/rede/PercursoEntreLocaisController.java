package project.controller.rede;

import project.domain.Local;
import project.domain.RedeHub;
import project.structure.MapGraph;

import java.util.ArrayList;
import java.util.LinkedList;

public class PercursoEntreLocaisController {

    private RedeHub rede;
    private MapGraph<Local, Integer> graph;

    public PercursoEntreLocaisController() {
        this.rede = RedeHub.getInstance();
        this.graph = rede.getRedeDistribuicao();
    }

    public ArrayList<LinkedList<Local>> getPathsBetweenLocations(String localOrigem, String localHub, int autonomia) {
        Local org = getVertex(localOrigem);
        Local hub = getVertex(localHub);

        return rede.getPathsBetweenLocations(org, hub,autonomia);
    }


    private Local getVertex(String localOrigem) { /////ADAPTAR >>>>>>>>>>>>>>>>>>>>
        return graph.vertex(p -> p.getNumId().equals(localOrigem));
    }

    public ArrayList<ArrayList<Integer>> getDistancesOfPaths(ArrayList<LinkedList<Local>> paths) {
        return rede.calculateDistances(paths);
    }

    public ArrayList<Double> getTotalTime(ArrayList<ArrayList<Integer>> distances, double veloMedia) {
        return rede.calculateTotalTime(distances, veloMedia);
    }
}
