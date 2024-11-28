package project.controller.rede;

import project.domain.Local;
import project.domain.RedeHub;
import project.structure.MapGraph;

import java.util.*;

public class LocalizacaoIdealHubsController {

    public Map<Local, List<Integer>> getTopNTotal(MapGraph<Local,Integer> graph, Integer n){
        RedeHub redeHub = RedeHub.getInstance();
        Map<Local, Integer> influence = redeHub.calculateInfluence(graph);
        Map<Local, Integer> proximity = redeHub.calculateProximity(graph);
        Map<Local, Integer> centrality = redeHub.calculateCentrality(graph);
        Map<Local, List<Integer>> finalMap = new HashMap<>();
        for (Local key : influence.keySet()) {
            List<Integer> values = new ArrayList<>();
            values.add(influence.get(key));
            values.add(proximity.get(key));
            values.add(centrality.get(key));
            finalMap.put(key, values);
        }

        return redeHub.getTopNMap(finalMap, n);
    }
}
