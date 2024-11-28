package project.controller.rede;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import project.domain.ImportarFicheiro;
import project.domain.Local;
import project.domain.RedeHub;
import project.structure.MapGraph;

import java.util.ArrayList;
import java.util.LinkedList;

import static org.junit.Assert.assertTrue;

public class PercursoEntreLocaisControllerTest {

    private final PercursoEntreLocaisController controller = new PercursoEntreLocaisController();
    RedeHub rede = RedeHub.getInstance();
    MapGraph<Local, Integer> redeGrafo;


    @Test
    public void getPathsBetweenLocations() {
        LinkedList<Local> locations1 = new LinkedList<>();
        Local l1 = new Local("CT1");
        Local l2 = new Local("CT12");
        Local l3 = new Local("CT3");
        locations1.add(l1);
        locations1.add(l2);
        locations1.add(l3);

        LinkedList<Local> locations2 = new LinkedList<>();
        Local l4 = new Local("CT1");
        Local l5 = new Local("CT12");
        Local l6 = new Local("CT15");
        Local l7 = new Local("CT3");
        locations2.add(l4);
        locations2.add(l5);
        locations2.add(l6);
        locations2.add(l7);

        ArrayList<LinkedList<Local>> paths = controller.getPathsBetweenLocations("CT1", "CT3",200000);

        assertTrue(paths.contains(locations1));
        assertTrue(paths.contains(locations2));

    }

    @Test
    public void getDistancesOfPaths() {
        ArrayList<LinkedList<Local>> paths = controller.getPathsBetweenLocations("CT1", "CT3",200000);
        ArrayList<ArrayList<Integer>> actual = controller.getDistancesOfPaths(paths);

        ArrayList<Integer> expected = new ArrayList<>();
        expected.add(113344);
        expected.add(62877);
        expected.add(50467);
        ArrayList<Integer> expected1 = new ArrayList<>();
        expected1.add(177192);
        expected1.add(62877);
        expected1.add(70717);
        expected1.add(43598);

        assertTrue(actual.contains(expected));
        assertTrue(actual.contains(expected1));
    }


    @Test
    public void getTotalTime() {
        ArrayList<LinkedList<Local>> paths = controller.getPathsBetweenLocations("CT1", "CT3",200000);
        ArrayList<ArrayList<Integer>> distances = controller.getDistancesOfPaths(paths);
        int velocidade = 50;

        ArrayList<Double> actual = controller.getTotalTime(distances, velocidade);

        assertTrue(actual.contains(2266.88));
        assertTrue(actual.contains(3543.84));
    }

    @Before
    public void setUp() throws Exception {
        ImportarFicheiro.importRedeDistribuicao("files/locais_small.csv", "files/distancias_small.csv");
        redeGrafo = rede.getRedeDistribuicao();
    }

    @After
    public void tearDown() {
        redeGrafo = null;
    }
}