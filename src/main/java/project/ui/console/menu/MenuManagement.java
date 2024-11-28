package project.ui.console.menu;

import project.ui.console.DatabaseConnectionTestUI;
import project.ui.console.utils.Utils;

import java.util.ArrayList;
import java.util.List;

public class MenuManagement implements Runnable {
    public MenuManagement(){

    }
    public void run() {
        List<MenuItem> options = new ArrayList<MenuItem>();
        options.add(new MenuItem("Testar conexão à Base de Dados", new DatabaseConnectionTestUI()));
//        options.add(new MenuItem("Testar SELECT", new SelectStatementTestUI()));
//        options.add(new MenuItem("Testar registo de rega", new RegaTesteUI()));
        int option = 0;
        do {
            option = Utils.showAndSelectIndex(options, "\n\nMenu gerenciamento:");
            if ((option >= 0) && (option < options.size())) {
                options.get(option).run();
            }
        } while (option != -1);

    }
}
