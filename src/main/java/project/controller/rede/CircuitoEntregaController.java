package project.controller.rede;

import project.domain.Local;
import project.domain.RedeHub;
import project.structure.MapGraph;

import java.util.*;

public class CircuitoEntregaController {

    private RedeHub rede;
    private MapGraph<Local, Integer> graph;

    public CircuitoEntregaController(){
        this.rede = RedeHub.getInstance();
        this.graph = rede.getRedeDistribuicao();
    }

    public List<Local> nearestResult(String localOrigem, int n, int autonomia, List<Local> locaisCarregamento, List<Integer> distancias){
        Local org = getVertex(localOrigem);
        List<Local> hubs = getHubsByCollaborators(n, org);
        return rede.nearestResult(org, n, autonomia, hubs, distancias, locaisCarregamento);
    }

    private Local getVertex(String localOrigem) {
        return graph.vertex(p -> p.getNumId().equals(localOrigem));
    }

    public List<Local> getHubsByCollaborators(int n, Local org){
        return rede.getHubsOrderedByCollaborators(n, org);
    }

    public LinkedList<Integer> getTempoTotalPercurso(LinkedList<Integer> distancias, double velocidadeMedia, List<Local> locaisCarregamento, int tempoRecarga, int tempoDescarga, int n) {
        return rede.getTempoTotalPercurso(distancias, velocidadeMedia, locaisCarregamento, tempoRecarga, tempoDescarga, n);
    }

    public Map<Local, Integer> calculateNumberCollaborators(int n, String localOrigem) {
        Local org = getVertex(localOrigem);
        List<Local> hubs = getHubsByCollaborators(n, org);
        return rede.getNumberCollaborators(hubs);
    }

    public int getTotalCollaborators(Map<Local, Integer> numeroColaboradores) {
        return rede.getTotalCollaborators(numeroColaboradores);
    }

    public int checkNumberHubs(Map<Local, Integer> numeroColaboradores, List<Local> result) {
        return rede.checkNumberHubs(numeroColaboradores, result);
    }
}
