package project.ui.console.rede;

import project.controller.rede.LocalizacaoIdealHubsController;
import project.domain.Local;
import project.domain.RedeHub;
import project.structure.MapGraph;
import project.ui.console.utils.Utils;

import java.util.List;
import java.util.Map;

/**
 * The type Localizacao ideal hubs ui.
 */
public class LocalizacaoIdealHubsUI implements Runnable {
    private final LocalizacaoIdealHubsController controller = new LocalizacaoIdealHubsController();

    /**
     * Runs this operation.
     */
    @Override
    public void run() {
        try {
            RedeHub redeHub = RedeHub.getInstance();
            MapGraph<Local, Integer> graph = redeHub.getRedeDistribuicao();

            String question = "Insira um valor N para o número de Hubs a serem selecionados:";
            int n = Utils.readIntegerFromConsole(question);
            printTopNHubs(controller.getTopNTotal(graph, n), n);
        } catch (Exception e) {
            System.out.println("ERRO: Não foi possível executar a funcionalidade.");
        }

    }

    /**
     * Makes the output for the Top N hubs
     *
     * @param hubs map with the information about the bus
     * @param n    number of the top
     */
    private void printTopNHubs(Map<Local, List<Integer>> hubs, Integer n) {
        System.out.println("\n-----------------------------------------------------------------------------------------------------");
        System.out.println("|                                  Top " + n + " localidades para os Hubs:                                  |");
        System.out.println("-----------------------------------------------------------------------------------------------------");

        for (Map.Entry<Local, List<Integer>> entry : hubs.entrySet()) {
            Local hub = entry.getKey();
            List<Integer> values = entry.getValue();

            System.out.print("Localidade: " + hub.getNumId() + " | Horário: " + getHubOperatingHours(hub.getNumId()));
            System.out.print(" | Centrality: " + values.get(2));
            System.out.print(" | Influence: " + values.get(0));
            System.out.print(" | Proximity: " + values.get(1) + " m");
            System.out.println();
        }
        System.out.println();
    }

    /**
     * Gets the hours for a hub based on the identifier.
     *
     * @param numId the hub identifier
     * @return the operating hours as a String
     */
    private String getHubOperatingHours(String numId) {
        int num = Integer.parseInt(numId.substring(2));

        if (num >= 1 && num <= 105) {
            return "9h:00 – 14h:00";
        } else if (num >= 106 && num <= 215) {
            return "11h:00 – 16h:00";
        } else if (num >= 216 && num <= 323) {
            return "12h:00 – 17h:00";
        } else {
            return "Unknown operating hours";
        }
    }

}
