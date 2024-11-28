package project.ui.console.rede;

import project.controller.rede.MaiorPercursoHubsController;
import project.domain.Local;
import project.domain.RedeHub;
import project.exception.ExcecaoData;
import project.exception.ExcecaoHora;
import project.structure.Path;
import project.ui.console.utils.Utils;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class MaiorPercursoHubsUI implements Runnable {
    public static Scanner read = new Scanner(System.in);
    private static MaiorPercursoHubsController controller = new MaiorPercursoHubsController();

    @Override
    public void run() {
        List<String> options = new ArrayList<>();
        options.add("Tempo Simulado");
        options.add("Tempo Real");
        int option;
        do {
            option = Utils.showAndSelectIndex(options, "Melhor Percurso De Entregas:");
            switch (option) {
                case 0 -> {
                    LocalTime time = getTime();
                    melhorRotaDisplay("Simulado", time);
                }
                case 1 -> {
                    LocalTime currentTime = LocalTime.now();
                    LocalTime time = LocalTime.of(currentTime.getHour(), currentTime.getMinute());
                    melhorRotaDisplay("Real", time);
                }
            }
        } while (option != -1);
    }

    public static void melhorRotaDisplay(String tipo, LocalTime hora) {
        try {
            System.out.println("|-------------------------------------------------------|");
            System.out.print("| Melhor Rota Para Entrega De Cabazes (Tempo ");
            System.out.println(String.format("%9s) |", tipo));
            System.out.println("|-------------------------------------------------------|");
            Local localInicio = getLocal();
            int autonomia = Integer.parseInt(getVariable("Qual A Autonomia Do Veiculo? (Km) ")) * 1000;
            double averageVelocity = Double.parseDouble(getVariable("Qual A Velocidade Média Do Veiculo? (Km/h)"));
            int tempoRecarga = Integer.parseInt(getVariable("Qual O Tempo De Recarga Do Veiculo? (Min)"));
            int tempoDescarga = Integer.parseInt(getVariable("Qual O Tempo De Descarga De Cabazes Do Veiculo? (Min)"));
            Path path = controller.calculateBestDeliveryRoute(localInicio, hora, autonomia, averageVelocity, tempoRecarga, tempoDescarga);
            double tempoTotal = (double) path.getDistanciaTotal() / (averageVelocity * 1000);
            if (path.isFlag()) {
                System.out.println(String.format("| Local Inicial: %11s | Local Final: %11s |", path.getPercurso().get(0).getNumId(), path.getPercurso().get(path.getPercurso().size() - 1).getNumId()));
                System.out.println("|-------------------------------------------------------|");
                System.out.println("|                        Percurso:                      |");
                System.out.println("|-------------------------------------------------------|");
                System.out.println(String.format("|               Distância Total Percorrida: %6d (m)  |", path.getDistanciaTotal()));
                System.out.println("|-------------------------------------------------------|");
                System.out.println(String.format("| %27s                           |", path.getPercurso().get(0).getNumId()));
                for (int i = 1; i < path.getPercurso().size(); i++) {
                    System.out.println(String.format("| %26s                            |", "V"));
                    if (path.getPercurso().get(i).isHub()) {
                        System.out.println(String.format("| HUB %23s                           |", path.getPercurso().get(i).getNumId()));
                    } else {
                        System.out.println(String.format("| %27s                           |", path.getPercurso().get(i).getNumId()));
                    }
                }
                System.out.println("|-------------------------------------------------------|");
                System.out.println("|                        Horário:                       |");
                System.out.println("|-------------------------------------------------------|");
                System.out.println("|   Local   |   Horário Chegada   |    Horário Saída    |");
                System.out.println("|-------------------------------------------------------|");
                System.out.println(String.format("| %9s | %19s | %19s |", path.getPercurso().get(0).getNumId(), "Local Inicial", hora));
                for (Local local : path.getTemposDeChegada().keySet()) {
                    if (!local.equals(path.getPercurso().get(path.getPercurso().size() - 1))) {
                        System.out.println(String.format("| %9s | %19s | %19s |", local.getNumId(), path.getTemposDeChegada().get(local).get(0), path.getTemposDeChegada().get(local).get(1)));
                    } else {
                        System.out.println(String.format("| %9s | %19s |---Final-da-Viagem---|", local.getNumId(), path.getTemposDeChegada().get(local).get(0)));
                    }
                }
                System.out.println("|-------------------------------------------------------|");
                System.out.println("|                Tempo Total Do Percurso:               |");
                System.out.println("|-------------------------------------------------------|");
                System.out.println(String.format("| %26s Horas                      |", controller.getFinishingTimeRoute(path, LocalTime.of(0, 0), autonomia, averageVelocity, tempoRecarga, tempoDescarga)));
                System.out.println("|-------------------------------------------------------|");
                System.out.println("|                     Carregamentos:                    |");
                System.out.println("|-------------------------------------------------------|");
                for (int i = 0; i < path.getCarregamentos().size(); i++) {
                    System.out.println(String.format("| %27s                           |", path.getPercurso().get(path.getCarregamentos().get(i))));
                }
                System.out.println("|-------------------------------------------------------|");
                System.out.println(String.format("|                Numero De Carregamentos: %3d           |", path.getCarregamentos().size()));
                System.out.println("|-------------------------------------------------------|");

                System.out.println("");
                System.out.println("");
            } else {
                System.out.println("|-------------------------------------------------------|");
                System.out.println("|          Não É Possível Realizar O Percurso           |");
                System.out.println("|-------------------------------------------------------|");
            }
        } catch (Exception e) {
            System.out.println("|-------------------------------------------------------|");
            System.out.println("|            Erro A Realizar A Funcionalidade           |");
            System.out.println("|-------------------------------------------------------|");
        }
    }

    private static String getVariable(String pergunta) {
        String returna;
        int lenght = 53, lenghtQuesion = pergunta.length();
        lenght -= lenghtQuesion;
        lenght = lenght / 2;
        System.out.print("|");
        for (int i = 0; i < lenght + 1; i++) {
            System.out.print(" ");
        }
        System.out.print(String.format("%s", pergunta));
        for (int i = 0; i < lenght + 1; i++) {
            System.out.print(" ");
        }
        System.out.println("|");
        System.out.println("|-------------------------------------------------------|");
        returna = read.next();
        System.out.println("|-------------------------------------------------------|");
        return returna;
    }

    private LocalDate getDay() {
        String data = null;
        while (data == null) {
            try {
                System.out.println("Defina O Dia Do Começo Do Percurso (formato dd/mm/yyyy):");
                data = read.nextLine();
                ExcecaoData.verificarData(data);
            } catch (ExcecaoData e) {
                System.out.printf("%s\n\n", e.getMessage());
                data = null;
            }
        }
        return LocalDate.parse(data, DateTimeFormatter.ofPattern("dd/MM/yyyy"));
    }

    private LocalTime getTime() {
        String time = null;
        while (time == null) {
            try {
                System.out.println("Defina A Hora De Saída Do Veículo (formato hh:mm):");
                time = read.nextLine();
                ExcecaoHora.verificarHora(time);
            } catch (ExcecaoHora e) {
                System.out.printf("%s\n\n", e.getMessage());
                time = null;
            }
        }
        return LocalTime.parse(time, DateTimeFormatter.ofPattern("HH:mm"));
    }

    private static Local getLocal() {
        int i = 0;
        List<Local> listOfNonHubs = new ArrayList<>();
        System.out.println("|-------------------------------------------------------|");
        System.out.println("|               Qual O Local De Partida?:               |");
        System.out.println("|-------------------------------------------------------|");
        System.out.println("|                        Lista:                         |");
        System.out.println("|-------------------------------------------------------|");
        for (Local local : RedeHub.getInstance().getRedeDistribuicao().vertices) {
            if (!local.isHub()) {
                listOfNonHubs.add(local);
            }
        }
        while (!listOfNonHubs.isEmpty()) {
            System.out.println(String.format("| %51s   |", showAndDeleteLocals(listOfNonHubs)));
        }
        System.out.println("\nIntroduza O Nome Do Local De Partida Do Veículo De Entrega (CTXX):");
        String stringID = read.next();
        while (RedeHub.getLocalByID(stringID) == null) {
            System.out.println("Id Inválido.");
            System.out.println("\nIntroduza O Nome Do Local De Partida Do Veículo De Entrega (CTXX):");
            stringID = read.next();
        }
        return RedeHub.getLocalByID(stringID);
    }

    public static String showAndDeleteLocals(List<Local> listOfNonHubs) {
        StringBuilder stringBuilder = new StringBuilder();
        for (int i = 0; i < listOfNonHubs.size(); i++) {
            stringBuilder.append(listOfNonHubs.get(i) + " ");
            if (i == 5) {
                return stringBuilder.toString();
            }
            listOfNonHubs.remove(listOfNonHubs.get(i));
        }
        return stringBuilder.toString();
    }

}
