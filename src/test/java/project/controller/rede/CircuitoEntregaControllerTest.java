package project.controller.rede;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import project.domain.ImportarFicheiro;
import project.domain.Local;
import project.domain.RedeHub;
import project.structure.MapGraph;

import java.util.*;

import static org.junit.jupiter.api.Assertions.*;

public class CircuitoEntregaControllerTest {

    private final CircuitoEntregaController controller = new CircuitoEntregaController();

    RedeHub rede = RedeHub.getInstance();
    MapGraph<Local, Integer> redeGrafo;

    @Before
    public void setUp() throws Exception {
        ImportarFicheiro.importRedeDistribuicao("files/locais_small.csv", "files/distancias_small.csv");
        redeGrafo = rede.getRedeDistribuicao();
    }

    @After
    public void tearDown() {
        redeGrafo = null;
    }

    @Test
    public void nearestResultWorks() {
        int n = 5;
        String origem = "CT3";
        int autonomia = 300000;
        List<Local> carregamento = new ArrayList<>();
        List<Integer> distancias = new ArrayList<>();

        List<Local> expected = new ArrayList<>();
        Local local1 = redeGrafo.vertex(p -> p.getNumId().equals("CT1"));
        Local local2 = redeGrafo.vertex(p -> p.getNumId().equals("CT2"));
        Local local3 = redeGrafo.vertex(p -> p.getNumId().equals("CT3"));
        Local local8 = redeGrafo.vertex(p -> p.getNumId().equals("CT8"));
        Local local10 = redeGrafo.vertex(p -> p.getNumId().equals("CT10"));
        Local local11 = redeGrafo.vertex(p -> p.getNumId().equals("CT11"));
        Local local12 = redeGrafo.vertex(p -> p.getNumId().equals("CT12"));
        Local local13 = redeGrafo.vertex(p -> p.getNumId().equals("CT13"));
        Local local14 = redeGrafo.vertex(p -> p.getNumId().equals("CT14"));

        expected.add(local3);
        expected.add(local12);
        expected.add(local1);
        expected.add(local10);
        expected.add(local13);
        expected.add(local11);
        expected.add(local2);
        expected.add(local8);
        expected.add(local14);
        expected.add(local13);
        expected.add(local10);
        expected.add(local1);
        expected.add(local12);
        expected.add(local3);

        assertEquals(expected, controller.nearestResult(origem, n, autonomia, carregamento, distancias));
    }

    @Test
    public void nearestResultFails() {
        int n = 5;
        String origem = "CT4";
        int autonomia = 300000;
        List<Local> carregamento = new ArrayList<>();
        List<Integer> distancias = new ArrayList<>();

        List<Local> expected = new ArrayList<>();
        Local local1 = redeGrafo.vertex(p -> p.getNumId().equals("CT1"));
        Local local2 = redeGrafo.vertex(p -> p.getNumId().equals("CT2"));
        Local local3 = redeGrafo.vertex(p -> p.getNumId().equals("CT3"));
        Local local8 = redeGrafo.vertex(p -> p.getNumId().equals("CT8"));
        Local local10 = redeGrafo.vertex(p -> p.getNumId().equals("CT10"));
        Local local11 = redeGrafo.vertex(p -> p.getNumId().equals("CT11"));
        Local local13 = redeGrafo.vertex(p -> p.getNumId().equals("CT13"));
        Local local14 = redeGrafo.vertex(p -> p.getNumId().equals("CT14"));
        Local local15 = redeGrafo.vertex(p -> p.getNumId().equals("CT15"));
        Local local16 = redeGrafo.vertex(p -> p.getNumId().equals("CT16"));

        expected.add(local10);
        expected.add(local13);
        expected.add(local11);
        expected.add(local3);
        expected.add(local15);
        expected.add(local1);
        expected.add(local2);
        expected.add(local8);
        expected.add(local14);
        expected.add(local1);
        expected.add(local16);
        expected.add(local10);

        assertNotEquals(expected, controller.nearestResult(origem, n, autonomia, carregamento, distancias));
    }

    @Test
    public void getHubsByCollaboratorsWorks() {
        int n = 5;
        Local org = redeGrafo.vertex(p -> p.getNumId().equals("CT3"));

        List <Local> expected = new ArrayList<>();
        expected.add(redeGrafo.vertex(p -> p.getNumId().equals("CT13")));
        expected.add(redeGrafo.vertex(p -> p.getNumId().equals("CT12")));
        expected.add(redeGrafo.vertex(p -> p.getNumId().equals("CT11")));
        expected.add(redeGrafo.vertex(p -> p.getNumId().equals("CT10")));
        expected.add(redeGrafo.vertex(p -> p.getNumId().equals("CT8")));

        List<Local> actual = controller.getHubsByCollaborators(n, org);

        assertEquals(expected.size(), actual.size());

        for (int i = 0; i < expected.size(); i++) {
            Local expectedLocal = expected.get(i);
            Local actualLocal = actual.get(i);

            assertEquals(expectedLocal, actualLocal);
        }
    }


    @Test
    public void getHubsByCollaboratorsFails() {
        int n = 5;
        Local org = redeGrafo.vertex(p -> p.getNumId().equals("CT3"));

        List <Local> expected = new ArrayList<>();
        expected.add(redeGrafo.vertex(p -> p.getNumId().equals("CT1")));
        expected.add(redeGrafo.vertex(p -> p.getNumId().equals("CT9")));
        expected.add(redeGrafo.vertex(p -> p.getNumId().equals("CT5")));
        expected.add(redeGrafo.vertex(p -> p.getNumId().equals("CT13")));
        expected.add(redeGrafo.vertex(p -> p.getNumId().equals("CT2")));

        List<Local> actual = controller.getHubsByCollaborators(n, org);

        assertEquals(expected.size(), actual.size());

        for (int i = 0; i < expected.size(); i++) {
            Local expectedLocal = expected.get(i);
            Local actualLocal = actual.get(i);

            assertNotEquals(expectedLocal, actualLocal);
        }
    }

    @Test
    public void getTempoTotalPercursoWorks() {
        LinkedList<Integer> distancias = new LinkedList<>();
        distancias.add(110133);
        distancias.add(82996);
        distancias.add(62877);
        distancias.add(110848);
        distancias.add(63448);
        distancias.add(121584);
        distancias.add(163996);
        distancias.add(125105);
        distancias.add(125105);
        distancias.add(163996);
        distancias.add(62655);
        distancias.add(90186);
        distancias.add(162527);
        distancias.add(1445456);

        double velocidadeMedia = 118.8;
        int tempoRecarga = 60;
        int tempoDescarga = 60;
        int n = 5;

        List<Local> locaisCarregamento = new ArrayList<>();
        locaisCarregamento.add(redeGrafo.vertex(p -> p.getNumId().equals("CT13")));
        locaisCarregamento.add(redeGrafo.vertex(p -> p.getNumId().equals("CT8")));
        locaisCarregamento.add(redeGrafo.vertex(p -> p.getNumId().equals("CT9")));

        LinkedList<Integer> expected = new LinkedList<>();
        expected.add(730);
        expected.add(180);
        expected.add(300);
        expected.add(1210);

        assertEquals(expected, controller.getTempoTotalPercurso(distancias, velocidadeMedia, locaisCarregamento, tempoRecarga, tempoDescarga, n));
    }

    @Test
    public void getTempoTotalPercursoFails() {
        LinkedList<Integer> distancias = new LinkedList<>();
        distancias.add(110133);
        distancias.add(110848);
        distancias.add(63448);
        distancias.add(90186);
        distancias.add(162527);
        distancias.add(82996);
        distancias.add(62877);
        distancias.add(1445456);

        double velocidadeMedia = 33;
        int tempoRecarga = 70;
        int tempoDescarga = 5;
        int n = 6;

        List<Local> locaisCarregamento = new ArrayList<>();
        locaisCarregamento.add(redeGrafo.vertex(p -> p.getNumId().equals("CT8")));
        locaisCarregamento.add(redeGrafo.vertex(p -> p.getNumId().equals("CT9")));

        LinkedList<Integer> expected = new LinkedList<>();
        expected.add(730);
        expected.add(180);
        expected.add(300);
        expected.add(1210);

        assertNotEquals(expected, controller.getTempoTotalPercurso(distancias, velocidadeMedia, locaisCarregamento, tempoRecarga, tempoDescarga, n));
    }

    @Test
    public void calculateNumberCollaboratorsWorks() {
        int n = 5;
        String origem = "CT3";

        Local local1 = redeGrafo.vertex(p -> p.getNumId().equals("CT13"));
        Local local2 = redeGrafo.vertex(p -> p.getNumId().equals("CT12"));
        Local local3 = redeGrafo.vertex(p -> p.getNumId().equals("CT11"));
        Local local4 = redeGrafo.vertex(p -> p.getNumId().equals("CT10"));
        Local local5 = redeGrafo.vertex(p -> p.getNumId().equals("CT8"));

        Map<Local, Integer> expected = new LinkedHashMap<>();
        expected.put(local1, 13);
        expected.put(local2, 12);
        expected.put(local3, 11);
        expected.put(local4, 10);
        expected.put(local5, 8);

        Map<Local, Integer> actual = controller.calculateNumberCollaborators(n, origem);

        assertEquals(expected, actual);
    }

    @Test
    public void calculateNumberCollaboratorsFails() {
        int n = 6;
        String origem = "CT3";

        Local local1 = redeGrafo.vertex(p -> p.getNumId().equals("CT13"));
        Local local2 = redeGrafo.vertex(p -> p.getNumId().equals("CT12"));
        Local local3 = redeGrafo.vertex(p -> p.getNumId().equals("CT10"));
        Local local4 = redeGrafo.vertex(p -> p.getNumId().equals("CT8"));

        Map<Local, Integer> expected = new LinkedHashMap<>();
        expected.put(local1, 13);
        expected.put(local2, 12);
        expected.put(local3, 10);
        expected.put(local4, 8);

        Map<Local, Integer> actual = controller.calculateNumberCollaborators(n, origem);

        assertNotEquals(expected, actual);

    }

    @Test
    public void getTotalCollaboratorsWorks() {
        Local local1 = redeGrafo.vertex(p -> p.getNumId().equals("CT13"));
        Local local2 = redeGrafo.vertex(p -> p.getNumId().equals("CT12"));
        Local local3 = redeGrafo.vertex(p -> p.getNumId().equals("CT11"));
        Local local4 = redeGrafo.vertex(p -> p.getNumId().equals("CT10"));
        Local local5 = redeGrafo.vertex(p -> p.getNumId().equals("CT8"));

        Map<Local, Integer> colaboradores = new LinkedHashMap<>();
        colaboradores.put(local1, 13);
        colaboradores.put(local2, 12);
        colaboradores.put(local3, 11);
        colaboradores.put(local4, 10);
        colaboradores.put(local5, 8);

        int expected = 54;

        assertEquals(expected, controller.getTotalCollaborators(colaboradores));
    }

    @Test
    public void getTotalCollaboratorsFails() {
        Local local1 = redeGrafo.vertex(p -> p.getNumId().equals("CT1"));
        Local local2 = redeGrafo.vertex(p -> p.getNumId().equals("CT6"));
        Local local3 = redeGrafo.vertex(p -> p.getNumId().equals("CT12"));
        Local local4 = redeGrafo.vertex(p -> p.getNumId().equals("CT13"));
        Local local5 = redeGrafo.vertex(p -> p.getNumId().equals("CT7"));

        Map<Local, Integer> colaboradores = new LinkedHashMap<>();
        colaboradores.put(local1, 1);
        colaboradores.put(local2, 6);
        colaboradores.put(local3, 12);
        colaboradores.put(local4, 13);
        colaboradores.put(local5, 7);

        int wrongExpected = 50;

        assertNotEquals(wrongExpected, controller.getTotalCollaborators(colaboradores));
    }

    @Test
    public void checkNumberHubsWorks(){
        Local local1 = redeGrafo.vertex(p -> p.getNumId().equals("CT1"));
        Local local2 = redeGrafo.vertex(p -> p.getNumId().equals("CT6"));
        Local local3 = redeGrafo.vertex(p -> p.getNumId().equals("CT12"));
        Local local4 = redeGrafo.vertex(p -> p.getNumId().equals("CT13"));
        Local local5 = redeGrafo.vertex(p -> p.getNumId().equals("CT7"));
        Local local6 = redeGrafo.vertex(p -> p.getNumId().equals("CT8"));

        Map<Local, Integer> colaboradores = new LinkedHashMap<>();
        colaboradores.put(local1, 1);
        colaboradores.put(local2, 6);
        colaboradores.put(local3, 12);
        colaboradores.put(local4, 13);
        colaboradores.put(local5, 7);

        List<Local> circuit = new ArrayList<>();
        circuit.add(local6);
        circuit.add(local1);
        circuit.add(local5);
        circuit.add(local4);
        circuit.add(local3);
        circuit.add(local2);

        int expected = 5;

        assertEquals(expected, controller.checkNumberHubs(colaboradores, circuit));
    }

    @Test
    public void checkNumberHubsFails(){
        Local local1 = redeGrafo.vertex(p -> p.getNumId().equals("CT1"));
        Local local2 = redeGrafo.vertex(p -> p.getNumId().equals("CT6"));
        Local local3 = redeGrafo.vertex(p -> p.getNumId().equals("CT12"));
        Local local4 = redeGrafo.vertex(p -> p.getNumId().equals("CT13"));
        Local local5 = redeGrafo.vertex(p -> p.getNumId().equals("CT7"));
        Local local6 = redeGrafo.vertex(p -> p.getNumId().equals("CT8"));

        Map<Local, Integer> colaboradores = new LinkedHashMap<>();
        colaboradores.put(local1, 1);
        colaboradores.put(local2, 6);
        colaboradores.put(local3, 12);
        colaboradores.put(local4, 13);
        colaboradores.put(local5, 7);

        List<Local> circuit = new ArrayList<>();
        circuit.add(local6);
        circuit.add(local1);
        circuit.add(local5);
        circuit.add(local4);
        circuit.add(local3);
        circuit.add(local6);

        int expectedWrong = 1;

        assertNotEquals(expectedWrong, controller.checkNumberHubs(colaboradores, circuit));
    }

}