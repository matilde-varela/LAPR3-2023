package project.domain;

import project.structure.Algorithms;
import project.structure.Edge;
import project.structure.Path;
import project.structure.MapGraph;

import java.time.LocalTime;
import java.util.*;
import static project.structure.Algorithms.shortestPaths;

public class RedeHub {
    private static final RedeHub instance = new RedeHub();

    final private MapGraph<Local, Integer> redeDistribuicao;

    private RedeHub() {
        this.redeDistribuicao = new MapGraph<>(false);
    }

    public static RedeHub getInstance() {
        return instance;
    }

    public void addHub(String numId, Double lat, Double lon) {
        Local vert = new Local(numId, lat, lon);
        redeDistribuicao.addVertex(vert);
    }

    public void addRoute(Local orig, Local dest, Integer distance) {
        redeDistribuicao.addEdge(orig, dest, distance);
    }

    @Override
    public String toString() {
        return redeDistribuicao.toString();
    }

    public MapGraph<Local, Integer> getRedeDistribuicao() {
        return redeDistribuicao;
    }


    public Map<Local, Integer> calculateInfluence(MapGraph<Local, Integer> graph) {
        Map<Local, Integer> influence = new HashMap<>();
        for (Local vertex : graph.vertices()) {
            influence.put(vertex, graph.outDegree(vertex));
        }

        return influence;
    }

    public Map<Local, Integer> calculateProximity(MapGraph<Local, Integer> graph) {
        Map<Local, Integer> proximity = new HashMap<>();

        for (Local vertex : graph.vertices()) {
            Integer proximityValue = calculateVertexProximity(graph, vertex);
            proximity.put(vertex, proximityValue);
        }

        return proximity;
    }

    private Integer calculateVertexProximity(MapGraph<Local, Integer> graph, Local vertex) {
        ArrayList<Integer> dists = new ArrayList<>();
        Algorithms.shortestPaths(graph, vertex, Comparator.naturalOrder(), Integer::sum, 0, new ArrayList<>(), dists);

        int proximitySum = 0;
        for (Integer dist : dists) {
            if (dist != null) {
                proximitySum += dist;
            }
        }

        return proximitySum;
    }

    public Map<Local, Integer> calculateCentrality(MapGraph<Local, Integer> graph) {
        Map<Local, Integer> centrality = Algorithms.betweennessCentrality(graph);

        return centrality;
    }

    public Map<Local, List<Integer>> getTopNMap(Map<Local, List<Integer>> map, Integer n) {
        List<Map.Entry<Local, List<Integer>>> entries = new ArrayList<>(map.entrySet());
        entries.sort((entry1, entry2) -> {
            List<Integer> values1 = entry1.getValue();
            List<Integer> values2 = entry2.getValue();

            int compareCentrality = Integer.compare(values2.get(2), values1.get(2));
            if (compareCentrality != 0) {
                return compareCentrality;
            }

            int compareInfluence = Integer.compare(values2.get(0), values1.get(0));
            if (compareInfluence != 0) {
                return compareInfluence;
            }

            return Integer.compare(values1.get(1), values2.get(1));
        });

        Map<Local, List<Integer>> sortedFinalMap = new LinkedHashMap<>();
        for (Map.Entry<Local, List<Integer>> entry : entries) {
            sortedFinalMap.put(entry.getKey(), entry.getValue());
        }

        return getTopNHubs(sortedFinalMap, n);
    }

    public Map<Local, List<Integer>> getTopNHubs(Map<Local, List<Integer>> map, Integer n) {
        Map<Local, List<Integer>> topNHubsMap = new LinkedHashMap<>();

        int count = 0;
        for (Map.Entry<Local, List<Integer>> entry : map.entrySet()) {
            if (count < n) {
                topNHubsMap.put(entry.getKey(), entry.getValue());
                count++;
            } else {
                break;
            }
        }

        return topNHubsMap;
    }

    // ----------------------------------------------------US EI07--START--------------------------------------------------------------------------//
    public static Path calculateBestDeliveryRoute(Local localInicio, LocalTime hora, int autonomia, double averageVelocity, int tempoRecarga, int tempoDescarga) {
        int hubsAindaAbertosNumero = 0;
        Local tempLocal = localInicio;
        LocalTime tempHora = hora, tempoRestante = LocalTime.of(0, 0), horaInicial = hora;
        List<Local> locaisVisitados = new ArrayList<>();
        LinkedList<Local> tempCaminho = new LinkedList<>(), melhorCaminho = new LinkedList<>();

        while (tempoRestante != null) {
            tempoRestante = null;
            for (Local hub : getHubs()) {
                if (!locaisVisitados.contains(hub)) {
                    LinkedList<Local> caminho = new LinkedList<>();
                    Algorithms.shortestPathWithAutonomy(instance.getRedeDistribuicao(), autonomia, tempLocal, hub, Comparator.naturalOrder(), Integer::sum, 0, caminho);
                    if (getFinishingTimeWithEverything(caminho, hora, autonomia, averageVelocity, tempoRecarga, tempoDescarga, getAllHubsInRoute(caminho, locaisVisitados).size()).isBefore(hub.getHorario().getHoraFecho()) && getFinishingTimeWithEverything(caminho, hora, autonomia, averageVelocity, tempoRecarga, tempoDescarga, getAllHubsInRoute(caminho, locaisVisitados).size()).isAfter(hub.getHorario().getHoraAbertura())) {
                        if (tempoRestante == null || getStillOpenHubs(getFinishingTimeWithEverything(caminho, hora, autonomia, averageVelocity, tempoRecarga, tempoDescarga, getAllHubsInRoute(caminho, locaisVisitados).size())).size() > hubsAindaAbertosNumero && subTime(hub.getHorario().getHoraFecho(), getFinishingTimeWithEverything(caminho, hora, autonomia, averageVelocity, tempoRecarga, tempoDescarga, getAllHubsInRoute(caminho, locaisVisitados).size())).isBefore(tempoRestante)) {
                            tempCaminho = caminho;
                            tempoRestante = subTime(hub.getHorario().getHoraFecho(), getFinishingTimeWithEverything(caminho, hora, autonomia, averageVelocity, tempoRecarga, tempoDescarga, getAllHubsInRoute(caminho, locaisVisitados).size()));
                            tempHora = getFinishingTimeWithEverything(caminho, hora, autonomia, averageVelocity, tempoRecarga, tempoDescarga, getAllHubsInRoute(caminho, locaisVisitados).size());
                            hubsAindaAbertosNumero = getStillOpenHubs(tempHora).size();
                        }
                    }
                }
            }
            if (tempoRestante != null) {
                if (melhorCaminho.isEmpty()) {
                    melhorCaminho.addAll(tempCaminho);
                } else {
                    melhorCaminho.removeLast();
                    melhorCaminho.addAll(tempCaminho);
                }

                tempLocal = melhorCaminho.get(melhorCaminho.size() - 1);
                for (int i = 0; i < getAllHubsInRoute(tempCaminho, locaisVisitados).size(); i++) {
                    locaisVisitados.add(getAllHubsInRoute(tempCaminho, locaisVisitados).get(i));
                }
                hora = tempHora;
            }
        }

        Path path = analyzeData(autonomia, melhorCaminho);
        path.setTemposDeChegada(getTimeTable(path, horaInicial, autonomia, averageVelocity, tempoRecarga, tempoDescarga));
        return path;
    }


    public static LocalTime getFinishingTimeWithEverything(LinkedList<Local> caminho, LocalTime horaComeco, int autonomia, double averageVelocity, int tempoRecarga, int tempoDescarga, int numeroDescargas) {
        LocalTime horaFim = LocalTime.of(0,0);
        Path path = analyzeData(autonomia, caminho);
        horaFim = addTime(horaFim, getFinishingTimeRoute(path.getDistanciaTotal(), averageVelocity,horaComeco));
        for (int i = 0; i < path.getCarregamentos().size(); i++) {
            horaFim.plusMinutes(tempoRecarga);
        }
        for (int i = 0; i < numeroDescargas; i++) {
            horaFim.plusMinutes(tempoDescarga);
        }
        return horaFim;
    }

    public static LocalTime getFinishingTimeRoute(int distanciaTotal ,double averageVelocity, LocalTime horaComeco) {
        LocalTime horaFim = LocalTime.of(0, 0);
        double tempoPercursoDouble = ((double) (distanciaTotal) / 1000) / averageVelocity;
        LocalTime tempoPercurso = LocalTime.of((int) tempoPercursoDouble, (int) ((tempoPercursoDouble - (int) tempoPercursoDouble) * 60));
        horaFim = addTime(horaComeco, tempoPercurso);
        return horaFim;
    }

    public static Map<Local, List<LocalTime>> getTimeTable(Path path, LocalTime horaComeco, int autonomia, double averageVelocity, int tempoRecarga, int tempoDescarga) {
        Map<Local, List<LocalTime>> timeTable = new LinkedHashMap<>();
        for (int i = 1; i < path.getPercurso().size(); i++) {
            LocalTime afterEverything = getFinishingTimeRoute(instance.redeDistribuicao.edge(path.getPercurso().get(i-1), path.getPercurso().get(i)).getWeight(), averageVelocity, horaComeco);

            List<LocalTime> listOfTimes = new ArrayList<>();
            if (path.getCarregamentos().contains(i)) {
                if (path.getPercurso().get(i).isHub()) {
                    listOfTimes.add(afterEverything.plusMinutes(tempoDescarga));
                    listOfTimes.add(afterEverything.plusMinutes(tempoRecarga));
                    timeTable.put(path.getPercurso().get(i), listOfTimes);
                    horaComeco = afterEverything.plusMinutes(tempoRecarga).plusMinutes(tempoDescarga);
                } else {
                    listOfTimes.add(afterEverything);
                    listOfTimes.add(afterEverything.plusMinutes(tempoRecarga));
                    timeTable.put(path.getPercurso().get(i), listOfTimes);
                    horaComeco = afterEverything.plusMinutes(tempoRecarga);
                }
            } else {
                if (path.getPercurso().get(i).isHub()) {
                    listOfTimes.add(afterEverything);
                    listOfTimes.add(afterEverything.plusMinutes(tempoDescarga));
                    timeTable.put(path.getPercurso().get(i), listOfTimes);
                    horaComeco = afterEverything.plusMinutes(tempoDescarga);
                } else {
                    listOfTimes.add(afterEverything);
                    listOfTimes.add(afterEverything);
                    timeTable.put(path.getPercurso().get(i), listOfTimes);
                    horaComeco = afterEverything;
                }
            }
        }
        return timeTable;
    }

    public static List<Local> getAllHubsInRoute(LinkedList<Local> caminho, List<Local> locaisVisitados) {
        List<Local> lista = new ArrayList<>();
        for (int i = 1; i < caminho.size(); i++) {
            if (caminho.get(i).isHub()) {
                lista.add(caminho.get(i));
            }
        }
        return lista;
    }

    public static LocalTime addTime(LocalTime time1, LocalTime time2) {
        return time1.plusHours(time2.getHour()).plusMinutes(time2.getMinute()).plusSeconds(time2.getSecond());
    }

    public static LocalTime subTime(LocalTime time1, LocalTime time2) {
        return time1.minusHours(time2.getHour()).minusMinutes(time2.getMinute()).minusSeconds(time2.getSecond());
    }

    public static List<Local> getStillOpenHubs(LocalTime hora) {
        List<Local> result = new ArrayList<>();
        for (Local local : getHubs()) {
            if (local.isHub() && local.getHorario().getHoraAbertura().isBefore(hora) && local.getHorario().getHoraFecho().isAfter(hora)) {
                result.add(local);
            }
        }
        return result;
    }

    public static List<Local> getHubs() {
        List<Local> result = new ArrayList<>();
        for (Local local : instance.getRedeDistribuicao().vertices()) {
            if (local.isHub()) {
                result.add(local);
            }
        }
        return result;
    }

// ----------------------------------------------------US EI07--END--------------------------------------------------------------------------//

    public static Path analyzeData(int autonomia, LinkedList<Local> caminho) {
        ArrayList<Integer> indexDeCarregamentos = new ArrayList<>();
        LinkedList<Local> percurso = caminho;
        int distanciaPercorrida = 0, bateria = autonomia;
        boolean flag = true;
        if (percurso != null) {
            for (int i = 0; i < percurso.size() - 1; i++) {
                int distanciaEntrePontos = instance.getRedeDistribuicao().edge(percurso.get(i), percurso.get(i + 1)).getWeight();
                distanciaPercorrida += distanciaEntrePontos;
                if (distanciaEntrePontos > bateria) {
                    if (distanciaEntrePontos <= autonomia) {
                        indexDeCarregamentos.add(i);
                        bateria = autonomia;
                    } else {
                        flag = false;
                    }
                } else {
                    bateria -= distanciaEntrePontos;
                }
            }
        } else {
            flag = false;
            return new Path(distanciaPercorrida, percurso, indexDeCarregamentos, flag);
        }
        return new Path(distanciaPercorrida, percurso, indexDeCarregamentos, flag);
    }

    public static LinkedList<Local> getShortestPathForFurthestNodes() {
        int maxDist = 0;
        LinkedList<Local> tempPath = new LinkedList<>();
        for (Local local : instance.getRedeDistribuicao().vertices) {
            ArrayList<LinkedList<Local>> path = new ArrayList<>();
            ArrayList<Integer> dist = new ArrayList<>();

            shortestPaths(instance.getRedeDistribuicao(), local, Comparator.naturalOrder(), Integer::sum, 0, path, dist);
            if (dist.get(getBiggestDist(dist)) > maxDist) {
                maxDist = dist.get(getBiggestDist(dist));
                tempPath = path.get(getBiggestDist(dist));
            }
        }
        return tempPath;
    }

    public static int getBiggestDist(ArrayList<Integer> dist) {
        int temp = 0, index = 0;
        for (int i = 0; i < dist.size(); i++) {
            if (dist.get(i) != null && temp < dist.get(i)) {
                temp = dist.get(i);
                index = i;
            }
        }
        return index;
    }

    public static Local getLocalByID(String id) {
        for (Local local : getInstance().getRedeDistribuicao().vertices) {
            if (local.getNumId().equals(id)) {
                return local;
            }
        }
        return null;
    }

    public ArrayList<LinkedList<Local>> getPathsBetweenLocations(Local org, Local hub, int autonomia) {
        return Algorithms.findPaths(redeDistribuicao, org, hub, autonomia);
    }

    public ArrayList<ArrayList<Integer>> calculateDistances(ArrayList<LinkedList<Local>> paths) {
        ArrayList<ArrayList<Integer>> distanciasPercurso = new ArrayList<>();
        int defaultValue = -1;
        int distTotal = 0;
        int d;
        int pathsSize = paths.size();

        for (int j = 0; j < pathsSize; j++) {
            LinkedList<Local> list = paths.get(j);
            int listSize = list.size();

            ArrayList<Integer> a = new ArrayList<>();

            for (int i = 0; i < listSize - 1; i++) {
                Edge<Local, Integer> e = redeDistribuicao.edge(list.get(i), list.get(i + 1));
                if (e != null) {
                    d = e.getWeight();
                    distTotal += d;
                    a.add(d);
                } else {
                    a.add(defaultValue);
                }
            }

            a.add(0, distTotal);
            distTotal = 0;
            distanciasPercurso.add(a);
        }

        return distanciasPercurso;
    }

    public ArrayList<Double> calculateTotalTime(ArrayList<ArrayList<Integer>> dists, double veloMedia) {
        ArrayList<Double> velocity = new ArrayList<>();

        for (ArrayList<Integer> d : dists) {
            double velo = d.get(0) / veloMedia;
            velocity.add(velo);
        }

        return velocity;
    }


    public List<Local> getHubsOrderedByCollaborators(int n, Local origem) {
        List<Local> hubs = new ArrayList<>();

        for (Local local : redeDistribuicao.vertices()) {
            if (local.isHub() && !local.equals(origem)) {
                hubs.add(local);
            }
        }

        hubs.sort((local1, local2) -> Integer.compare(Integer.parseInt(local2.getNumId().substring(2)),
                Integer.parseInt(local1.getNumId().substring(2))));


        return getTopNHubs(hubs, n);
    }

    private List<Local> getTopNHubs(List<Local> totalHubs, int n){
        List<Local> topNHubs = new ArrayList<>();

        if (totalHubs.size() >= n){
            for (int i = 0; i < n; i++) {
                topNHubs.add(totalHubs.get(i));
            }
        }

        return topNHubs;
    }


    public List<Local> nearestResult(Local org, int n, int autonomia, List<Local> hubs,  List<Integer> distancias, List<Local> locaisCarregamento){
        List<Local> circuit = new ArrayList<>();

        if (!hubs.isEmpty()){
            circuit = Algorithms.nearestNeighbor(redeDistribuicao, n, org, hubs, Comparator.naturalOrder(), Integer::sum, 0, autonomia);
        }

        if (circuit.size() > 1){
            int count = 0;
            for (Local l : circuit) {
                if (org.equals(l)){
                    count++;
                }
            }

            if (count == 2){
                getDistancias(circuit, distancias);

                verificarLocaisCarregamento(circuit, distancias, autonomia, locaisCarregamento);

                return circuit;
            }
        }
        return new ArrayList<>();
    }


    public Map<Local, Integer> getNumberCollaborators(List<Local> hubs) {
        Map<Local, Integer> collaboratorsMap = new LinkedHashMap<>();

        for (Local local : hubs) {
            String numId = local.getNumId();
            int collaborators = extractCollaborators(numId);
            collaboratorsMap.put(local, collaborators);
        }

        return collaboratorsMap;
    }

    private int extractCollaborators(String numId) {
        int ctIndex = numId.indexOf("CT");

        if (ctIndex != -1) {
            String collaboratorsStr = numId.substring(ctIndex + 2);

            if (collaboratorsStr.matches("\\d+")) {
                return Integer.parseInt(collaboratorsStr);
            }
        }
        return 0;
    }

    public void getDistancias(List<Local> circuito, List<Integer> distancias){
        int total = 0;
        for (int i = 0; i < circuito.size() - 1; i++) {
            int distancia = redeDistribuicao.edge(circuito.get(i), circuito.get(i+1)).getWeight();
            distancias.add(distancia);
            total += distancia;
        }
        distancias.add(total);
    }


    public LinkedList<Integer> getTempoTotalPercurso(LinkedList<Integer> distancias, double velocidadeMedia, List<Local> locaisCarregamento, int tempoRecarga, int tempoDescarga, int n) {
        LinkedList<Integer> temposPercurso = new LinkedList<>();
        double velocidadeMetroSegundos = (velocidadeMedia * 1000) / 3600;
        int numCarregamentos = locaisCarregamento.size();
        int tempoCircuito = (int) ((distancias.getLast() / velocidadeMetroSegundos) / 60);
        int tempoCarregamento = numCarregamentos * tempoRecarga;
        int tempoDescargaHubs = tempoDescarga * n;
        int tempoTotal = tempoCircuito + tempoCarregamento + tempoDescargaHubs;

        temposPercurso.add(tempoCircuito);
        temposPercurso.add(tempoCarregamento);
        temposPercurso.add(tempoDescargaHubs);
        temposPercurso.add(tempoTotal);


        return temposPercurso;
    }

    public int getTotalCollaborators(Map<Local, Integer> numeroColaboradores) {
        int total = 0;
        for (Map.Entry<Local, Integer> entry : numeroColaboradores.entrySet()) {
            total += entry.getValue();
        }

        return total;
    }


    private void verificarLocaisCarregamento(List<Local> circuit, List<Integer> distancias, int autonomia, List<Local> locaisCarregamento) {
        int autonomiaRestante = autonomia;
        for (int i = 0; i < circuit.size() - 1; i++) {
            if (distancias.get(i) > autonomiaRestante){
                locaisCarregamento.add(circuit.get(i));
                autonomiaRestante = autonomia;
                autonomiaRestante = autonomiaRestante - distancias.get(i);
            } else {
                autonomiaRestante = autonomiaRestante - distancias.get(i);
            }
        }
    }

    public int checkNumberHubs(Map<Local, Integer> numeroColaboradores, List<Local> result) {
        int count = 0;
        for (Map.Entry<Local, Integer> entry : numeroColaboradores.entrySet()) {
            for (Local l : result) {
                if (entry.getKey().equals(l)){
                    count++;
                }
            }
        }

        return count;
    }
}
