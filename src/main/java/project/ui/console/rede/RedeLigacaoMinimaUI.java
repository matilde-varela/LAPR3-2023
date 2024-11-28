package project.ui.console.rede;

import project.controller.rede.RedeLigacaoMinimaController;
import project.domain.Local;
import project.domain.RedeHub;
import project.structure.Edge;
import project.structure.MapGraph;

import java.util.ArrayList;
import java.util.Collection;

public class RedeLigacaoMinimaUI implements Runnable {

    RedeLigacaoMinimaController controller = new RedeLigacaoMinimaController();

    /**
     * Runs this operation.
     */
    @Override
    public void run() {
//        try {
            RedeHub rede = RedeHub.getInstance();
            MapGraph<Local, Integer> mst = controller.kruskallAlgorithm(rede.getRedeDistribuicao());
            printMinimumSpanningTree(mst);
//        } catch(Exception e){
//            System.out.println("ERRO: Não foi possível executar a funcionalidade.");
//        }
    }

    private void printMinimumSpanningTree(MapGraph<Local, Integer> mst) {
        System.out.println("\nRede de Ligação Mínima\n");

        ArrayList<Local> locaisRede = mst.vertices;

        printVertex(locaisRede);

        Collection  <Edge<Local, Integer>> edges = mst.edges();

        System.out.println("----------------------------------------------------------------------------------");
        System.out.printf("| %-78s |\n", "Distância entre os Locais");
        System.out.println("----------------------------------------------------------------------------------");
        System.out.printf("| %-58s | %-17s |\n", "Aresta", "Distância");
        System.out.println("----------------------------------------------------------------------------------");

        for (Edge<Local, Integer> edge : edges){
            System.out.printf("| %-27s -> %-27s | %17s |\n", edge.getVOrig(), edge.getVDest(), "Weight: " + edge.getWeight());
        }
        System.out.println("----------------------------------------------------------------------------------");

        int mstTotalWeight = controller.getTotalWeightOfMinimumSpanningTree(mst);
        double totalWeightKilometer = mstTotalWeight * 0.001;
        System.out.printf("\nCusto Total da rede: %d m / %.3f km\n\n", mstTotalWeight, totalWeightKilometer);
    }

    private void printVertex(ArrayList<Local> locaisRede) {
        System.out.println("---------------------------------");
        System.out.printf("|  %-27s  |\n", "Locais da Rede");
        System.out.println("---------------------------------");
        System.out.printf("| %-6s | %-20s |\n", "ID", "Coordenadas");
        System.out.println("---------------------------------");
        for (Local local : locaisRede) {
            System.out.printf("| %-6s | %20s |\n", local.getNumId(), local.getCoordenadas());
        }
        System.out.println("---------------------------------\n");
    }
}
