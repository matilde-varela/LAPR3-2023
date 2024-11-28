package project.domain;

import project.controller.rede.LocalizacaoIdealHubsController;
import project.exception.ExcecaoFicheiro;
import project.exception.ExcecaoHora;
import project.structure.MapGraph;

import java.io.*;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

public class ImportarFicheiro {
    private static final String TODOS_DIAS = "T";

    private static final String DIAS_PARES = "P";

    private static final String DIAS_IMPARES = "I";
    private static final String TRES_DIAS = "3";
    private static Integer n;
    private static final Set<LocalTime> timeTurns = new TreeSet<>();
    private static final Map<String, List<String>> lineRega = new LinkedHashMap<>();
    private static final Map<String, List<String>> lineFertirrega = new LinkedHashMap<>();

    public static boolean importWateringPlan(String filepath) {
        try {
            ExcecaoFicheiro.verificarFicheiro(filepath, ".txt");
            ExcecaoFicheiro.verificarEstruturaFicheiro(new File(filepath));
            ExcecaoFicheiro.validarPlanoRega(new File(filepath));

            List<Rega> plano = new ArrayList<>();
            readDataFromWateringPlanFile(filepath);
            setWateringPlan(plano);
            SistemaDeRega.setPlanoDeRega(plano);
            SistemaDeRega.scheduleNextTask(0);
            SistemaDeRega.setInicioDoPlanoDeRega(LocalDate.now());
            return true;
        } catch (ExcecaoFicheiro | IOException e) {
            return false;
        }
    }

    private static void setWateringPlan(List<Rega> plano) {
        LocalDate currentDate = LocalDate.now();
        for (int i = 1; i <= 30; i++) {
            for (LocalTime hora : timeTurns) {
                if (LocalTime.now().isBefore(hora) || !currentDate.equals(LocalDate.now())) {
                    LocalTime tempHora = hora;

                    for (String setor : lineRega.keySet()) {
                        String regularidade = lineRega.get(setor).get(1);
                        int minutos = Integer.parseInt(lineRega.get(setor).get(0));

                        if (isRegaDay(currentDate, regularidade) && lineFertirrega.get(setor) != null) {
                            tempHora = tempHora.plusMinutes(minutos);
                            boolean aux = isFertirregaDay(lineFertirrega.get(setor).get(1), i);
                            plano.add(new Rega(setor, tempHora.minusMinutes(minutos), tempHora, currentDate, lineFertirrega.get(setor).get(0), aux));
                        } else if (isRegaDay(currentDate, regularidade)) {
                            tempHora = tempHora.plusMinutes(minutos);
                            plano.add(new Rega(setor, tempHora.minusMinutes(minutos), tempHora, currentDate));
                        }
                    }
                }
            }
            currentDate = currentDate.plusDays(1);
        }
    }

    private static boolean isRegaDay(LocalDate date, String regularidade) {
        return switch (regularidade) {
            case TODOS_DIAS -> true;
            case DIAS_IMPARES -> date.getDayOfMonth() % 2 == 1;
            case DIAS_PARES -> date.getDayOfMonth() % 2 == 0;
            case TRES_DIAS -> date.getDayOfMonth() % 3 == 0;
            default -> false;
        };
    }

    private static boolean isFertirregaDay(String regularidade, int planDay) {
        int regularidadeValue = Integer.parseInt(regularidade);
        return planDay % regularidadeValue == 0;
    }

    private static void readDataFromWateringPlanFile(String filepath) throws IOException {
        File file = new File(filepath);
        BufferedReader reader = new BufferedReader(new FileReader(file));
        String[] line = reader.readLine().split(",");

        for (String time : line) {
            time = time.trim();
            timeTurns.add(LocalTime.parse(time, DateTimeFormatter.ofPattern("HH:mm")));
        }
        String currentLine;
        while ((currentLine = reader.readLine()) != null) {
            List<String> valores = new ArrayList<>();
            line = currentLine.split(",");
            valores.add(line[1]);
            valores.add(line[2]);
            lineRega.put(line[0], valores);
            if (line.length == 5) {
                List<String> valoresFertirrega = new ArrayList<>();
                valoresFertirrega.add(line[3]);
                valoresFertirrega.add(line[4]);
                lineFertirrega.put(line[0], valoresFertirrega);
            }
        }
        reader.close();
    }


    public static boolean importRedeDistribuicao(String locais, String distancias) throws ExcecaoFicheiro, IOException {
        importFicheiroLocais(locais);
        importFicheiroDistancias(distancias);
        setHubs(locais);
        return true;
    }

    private static void setHubs(String locais) {
        if (locais.contains("small")) {
            n = 8;
        } else {
            n = 20;
        }
        LocalizacaoIdealHubsController controller = new LocalizacaoIdealHubsController();
        RedeHub rede = RedeHub.getInstance();
        MapGraph<Local, Integer> graph = rede.getRedeDistribuicao();
        Map<Local, List<Integer>> topNMap = controller.getTopNTotal(graph, n);

        for (Local ideal : topNMap.keySet()) {
            if (graph.validVertex(ideal)) {
                graph.vertex(p -> p.equals(ideal)).setHub(true);
            }
        }

    }

    private static void importFicheiroDistancias(String distancias) throws IOException {
        RedeHub redeHub = RedeHub.getInstance();
        //--------------------------------------
        BufferedReader reader = new BufferedReader(new FileReader(distancias));
        String currentLine;
        reader.readLine();
        String[] line;
        while ((currentLine = reader.readLine()) != null) {
            line = currentLine.split(",");
            redeHub.addRoute(new Local(line[0]), new Local(line[1]), Integer.parseInt(line[2]));
        }
    }

    private static void importFicheiroLocais(String locais) throws IOException {
        RedeHub redeHub = RedeHub.getInstance();
        //--------------------------------------
        BufferedReader reader = new BufferedReader(new FileReader(locais));
        String currentLine;
        reader.readLine();
        String[] line;
        while ((currentLine = reader.readLine()) != null) {
            line = currentLine.split(",");
            redeHub.addHub(line[0], Double.parseDouble(line[1]), Double.parseDouble(line[2]));
        }
    }

    public static boolean importarFicheiroHorarios(String ficheiro, Map<String, Horario> novosHorarios) {
        try {
            ExcecaoFicheiro.verificarFicheiro(ficheiro, ".csv");
            ExcecaoFicheiro.verificarFicheiroHorarios(new File(ficheiro));

            BufferedReader br = new BufferedReader(new FileReader(ficheiro));
            String linha;
            while ((linha = br.readLine()) != null) {
                String[] partes = linha.split(",");
                String hubId = partes[0].trim();
                LocalTime horaAbertura = LocalTime.parse(partes[1].trim());
                LocalTime horaFecho = LocalTime.parse(partes[2].trim());
                Horario novoHorario = new Horario(horaAbertura, horaFecho);
                novosHorarios.put(hubId, novoHorario);
            }
            return true;
        } catch (ExcecaoFicheiro | ExcecaoHora | IOException e) {
            return false;
        }
    }
}
