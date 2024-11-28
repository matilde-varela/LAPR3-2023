package project.ui.console.sistema_rega;

import project.controller.sistema_rega.ControladorRegaController;
import project.exception.ExcecaoData;
import project.exception.ExcecaoHora;
import project.ui.console.utils.Utils;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class ControladorRegaUI implements Runnable {

    private final ControladorRegaController controller;

    public ControladorRegaUI() {
        this.controller = new ControladorRegaController();
    }

    @Override
    public void run() {
        List<String> options = new ArrayList<>();

        if (controller.checkIfPlanIsPresent()) {
            options.add("Verificar rega em Tempo Real.");
            options.add("Verificar rega em Tempo Simulado.");
            options.add("Gerar registo do Plano de Rega.");
            int option;
            String result;
            do {
                option = Utils.showAndSelectIndex(options, "Controlador de Rega:");
                switch (option) {
                    case 0 -> {
                        result = controller.checkWateringInRealTime();
                        showOutput(result);
                    }
                    case 1 -> {
                        LocalTime time = getTime();
                        LocalDate day = getDay();
                        result = controller.checkWateringInSimulatedTime(day, time);
                        showOutput(result);
                    }
                    case 2 -> {
                        if (controller.exportWateringPlan()) {
                            result = "O ficheiro com os registos do Plano de Rega foi criado.\n";
                        } else {
                            result = "ERRO: O ficheiro com os registos do Plano de Rega não foi criado.\n";
                        }
                        showOutput(result);
                    }
                    default -> {
                    }
                }
            } while (option != -1);
        } else {
            System.out.println("Neste momento não existe um Plano de Rega em vigor.\nPor favor, faça primeiro o importe de um ficheiro Plano de Rega.\n");
        }
    }


    private void showOutput(String result) {
        if (result != null) {
            System.out.println();
            System.out.println(result);
            System.out.println();
        }
    }

    private LocalDate getDay() {
        Scanner scanner = new Scanner(System.in);
        String data = null;
        while (data == null) {
            try {
                System.out.println("Defina um dia (formato dd/mm/yyyy):");
                data = scanner.nextLine();
                ExcecaoData.verificarData(data);
            } catch (ExcecaoData e) {
                System.out.printf("%s\n\n",e.getMessage());
                data = null;
            }
        }
        return LocalDate.parse(data, DateTimeFormatter.ofPattern("dd/MM/yyyy"));
    }

    private LocalTime getTime() {
        Scanner scanner = new Scanner(System.in);
        String time = null;
        while (time == null) {
            try {
                System.out.println("Defina uma hora (formato hh:mm):");
                time = scanner.nextLine();
                ExcecaoHora.verificarHora(time);
            } catch (ExcecaoHora e) {
                System.out.printf("%s\n\n",e.getMessage());
                time = null;
            }
        }
        return LocalTime.parse(time, DateTimeFormatter.ofPattern("HH:mm"));
    }
}
