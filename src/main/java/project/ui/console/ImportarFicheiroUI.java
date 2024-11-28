package project.ui.console;

import project.controller.ImportarFicheiroController;
import project.domain.Horario;
import project.domain.Local;
import project.domain.RedeHub;
import project.exception.ExcecaoFicheiro;
import project.structure.MapGraph;

import java.util.*;

public class ImportarFicheiroUI implements Runnable {

    private final ImportarFicheiroController controller;
    private final String fileTypeName;
    private boolean successfulImport = false;

    public ImportarFicheiroUI(String fileType) {
        this.controller = new ImportarFicheiroController();
        fileTypeName = fileType;
    }

    @Override
    public void run() {
        switch (fileTypeName) {
            case "Plano de Rega":
                try {
                    System.out.println("Insira o caminho para o ficheiro:");
                    String filepath = getfilepath();

                    successfulImport = controller.importWateringPlan(filepath);
                } catch (Exception e) {
                    System.out.printf("%s\n\n", e.getMessage());
                }
                break;
            case "Rede Distruição":
                try {
                    System.out.println("Insira o caminho para o ficheiro dos locais:");
                    String locaisFilePath = getfilepath();
                    ExcecaoFicheiro.verificarFicheiro(locaisFilePath, ".csv");

                    System.out.println("Insira o caminho para o ficheiro das distâncias:");
                    String distanciaFilePath = getfilepath();
                    ExcecaoFicheiro.verificarFicheiro(distanciaFilePath, ".csv");

                    successfulImport = controller.importRedeDistribuicao(locaisFilePath, distanciaFilePath);
                    RedeHub rede = RedeHub.getInstance();
                    System.out.println(rede.toString());
                } catch (Exception e) {
                    System.out.printf("%s\n\n", e.getMessage());
                }
                break;
            case "Novos Horários":
                try {
                    System.out.println("Insira o caminho para o ficheiro dos horários:");
                    String horariosFilePath = getfilepath();
                    Map<String, Horario> novosHorarios = new LinkedHashMap<>();
                   successfulImport = controller.importarFicheiroHorarios(horariosFilePath, novosHorarios);

                    RedeHub rede = RedeHub.getInstance();
                    MapGraph<Local, Integer> graph = rede.getRedeDistribuicao();
                    for (String hubId : novosHorarios.keySet()) {
                        boolean hubExiste = false;
                        for (Local vertex : graph.vertices()) {
                            if (vertex.getNumId().equals(hubId) && vertex.isHub()) {
                                Horario novoHorario = novosHorarios.get(hubId);
                                vertex.setHorario(novoHorario);
                                System.out.println("Horários redefinidos para o hub: " + hubId);
                                System.out.println("Novos Horários: " + vertex.getHorario() + "\n");
                                hubExiste = true;
                            }
                        }
                        if (!hubExiste) {
                            System.out.println("ERRO: Hub " + hubId + " não encontrado.\n");
                        }
                    }
                    System.out.println();
                } catch (Exception e) {
                    System.out.printf("%s\n\n", e.getMessage());
                }
                break;
            default:
                break;
        }
        checkIfImportWasASuccess(successfulImport, fileTypeName);
    }

    private void checkIfImportWasASuccess(boolean successfulImport, String fileTypeName) {
        if (successfulImport) {
            System.out.printf("O ficheiro %s foi importado com sucesso.\n\n", fileTypeName);
        } else {
            System.out.printf("O ficheiro %s não foi importado.\n\n", fileTypeName);
        }
    }

    private String getfilepath() {
        Scanner scanner = new Scanner(System.in);
        return scanner.nextLine();
    }

}
