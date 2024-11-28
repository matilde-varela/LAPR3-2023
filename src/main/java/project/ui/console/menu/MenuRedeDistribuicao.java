package project.ui.console.menu;

import project.ui.console.ImportarFicheiroUI;
import project.ui.console.rede.*;
import project.ui.console.utils.Utils;

import java.util.ArrayList;
import java.util.List;

public class MenuRedeDistribuicao implements Runnable {

    /**
     * Runs this operation.
     */
    @Override
    public void run() {
        List<MenuItem> options = new ArrayList<>();
        options.add(new MenuItem("Importar ficheiros dos dados.", new ImportarFicheiroUI("Rede Distruição")));
        options.add(new MenuItem("Importar ficheiro horário", new ImportarFicheiroUI("Novos Horários")));
        options.add(new MenuItem("Localização ideal de N hubs.", new LocalizacaoIdealHubsUI()));
        options.add(new MenuItem("Percurso mínimo possível.", new PercursoMinimoUI()));
        options.add(new MenuItem("Rede de ligação mínima.", new RedeLigacaoMinimaUI()));
        options.add(new MenuItem("Percursos entre local e hub.", new PercursoEntreLocaisUI()));
        options.add(new MenuItem("Circuito de entrega", new CircuitoEntregaUI()));
        options.add(new MenuItem("Rede de ligação maxíma.", new MaiorPercursoHubsUI()));
        options.add(new MenuItem("Rede dividida em N Clusters", new ClustersHubsUI()));
        int option = 0;
        do {
            option = Utils.showAndSelectIndex(options, "Rede de Distribuição");
            if ((option >= 0) && (option < options.size())) {
                options.get(option).run();
            }
        } while (option != -1);
    }
}
