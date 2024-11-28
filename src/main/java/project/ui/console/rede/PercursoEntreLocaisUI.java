package project.ui.console.rede;

import project.controller.rede.PercursoEntreLocaisController;
import project.domain.Local;
import project.ui.console.utils.Utils;

import java.util.ArrayList;
import java.util.LinkedList;

public class PercursoEntreLocaisUI implements Runnable {
    /*
     local de origem
     hub
     Kms de autonomia
     velocidade média
       */
    private PercursoEntreLocaisController controller;

    private int autonomia;
    private double veloMedia;
    private String localOrigem;
    private String hub;

    public PercursoEntreLocaisUI() {
        this.controller = new PercursoEntreLocaisController();
    }

    /**
     * Runs this operation.
     */
    @Override
    public void run() {
        autonomia = Utils.readIntegerFromConsole("Indique a autonomia do veículo (km):");
        autonomia *= 1000;
        veloMedia = Utils.readDoubleFromConsole("Indique a velocidade média de deslocamente (m/s):");
        localOrigem = Utils.readLineFromConsole("Indique o local de origem do percurso:");
        hub = Utils.readLineFromConsole("Indique o hub que pretende alcançar:");

        ArrayList<LinkedList<Local>> paths = controller.getPathsBetweenLocations(localOrigem, hub,autonomia);
        ArrayList<ArrayList<Integer>> distances = controller.getDistancesOfPaths(paths);
        ArrayList<Double> time = controller.getTotalTime(distances, veloMedia);
        printResults(paths, distances, time);
    }

    private void printResults(ArrayList<LinkedList<Local>> paths, ArrayList<ArrayList<Integer>> distances, ArrayList<Double> time) {
        for (int i = 0; i < paths.size(); i++) {
            System.out.println("PERCURSO " + (i + 1));
            System.out.println("=================================");
            printPath(paths.get(i), distances.get(i), time.get(i));
        }
    }

    private void printPath(LinkedList<Local> locals, ArrayList<Integer> integers, Double aDouble) {
        System.out.println("DISTÂNCIA TOTAL: " + integers.get(0) + " m");
        System.out.println("TEMPO TOTAL: " + aDouble + " s");
        System.out.printf("|%40s  <>  %-40s|%-20s|\n", "DE", "PARA", "DISTÂNCIA (m)");
        if (locals.size() > 1) {
            for (int i = 0; i < locals.size() - 1; i++) {
                String format2 = "|%40s  <>  %-40s|%-20d|\n";
                System.out.printf(format2, locals.get(i), locals.get(i + 1), integers.get(i + 1));
            }
        }
        System.out.println("\n");
    }
}
