package project.ui.console.menu;

import project.ui.console.*;
import project.ui.console.sistema_rega.ControladorRegaUI;
import project.ui.console.utils.Utils;
import java.util.ArrayList;
import java.util.List;

public class MenuSistemaDeRega implements Runnable{

    /**
     * Contrói uma SistemaDeRegaUI.
     */
    public MenuSistemaDeRega() {
    }

    /**
     * Corre a interface do sistema de rega ao dispôr as opções das funcionalidades.
     */
    public void run() {
        List<MenuItem> options = new ArrayList<>();
        options.add(new MenuItem("Importar ficheiro do plano de rega.", new ImportarFicheiroUI("Plano de Rega")));
        options.add(new MenuItem("Controlador de Rega.", new ControladorRegaUI()));
        int option = 0;
        do {
            option = Utils.showAndSelectIndex(options, "Sistema de Rega");
            if ((option >= 0) && (option < options.size())) {
               options.get(option).run();
            }
        } while (option != -1);
    }
}
