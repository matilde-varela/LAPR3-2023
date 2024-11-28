package project.ui.console.rede;

import project.controller.rede.ClustersHubsController;
import project.domain.Local;
import project.domain.RedeHub;
import project.structure.MapGraph;
import project.ui.console.utils.Utils;

import java.util.List;
import java.util.Set;


public class ClustersHubsUI implements Runnable {
    private final ClustersHubsController controller = new ClustersHubsController();

    @Override
    public void run() {
        RedeHub redeHub = RedeHub.getInstance();
        MapGraph<Local, Integer> graph = redeHub.getRedeDistribuicao();
        List<Local> hubs = graph.getHubsVertexList();

        if (hubs.size() == 0){
            System.out.println("Os ficheiros dos locais e distâncias para preencher o grafo ainda não foram disponibilizados.\n");
            return;
        }

        System.out.println("\nNúmero de Hubs na Rede: " + hubs.size());

        int numClusters = Utils.readIntegerFromConsole("Qual o número de clusters que deseja?");

        if (numClusters <= hubs.size()){

            Set<Set<Local>> clusters = controller.getNClusters(graph, numClusters, hubs);

            int i = 1;
            System.out.println();
            for (Set<Local> cluster : clusters) {
                System.out.print("------------------------\n");
                System.out.printf("|   ## Cluster #%d ###  |\n", i);
                System.out.print("------------------------\n");
                for (Local locality : cluster) {
                    System.out.printf("| %20s |\n", locality);
                }
                System.out.println("------------------------\n");
                ++i;
            }
        }else {
            System.out.println("Cada cluster tem de ter pelo menos 1 hub.");
            System.out.printf("Posto isto, o número de clusters desejados é inválido, pois é superior ao número de hubs na rede (%d)\n\n", hubs.size());
        }
    }

}
