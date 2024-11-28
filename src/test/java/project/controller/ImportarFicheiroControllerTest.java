package project.controller;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import project.domain.Local;
import project.domain.RedeHub;
import project.structure.MapGraph;

import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class ImportarFicheiroControllerTest {

    private static final ImportarFicheiroController controller = new ImportarFicheiroController();
    private static boolean resultImportLocais;
    private static boolean result;
    private static RedeHub r;
    MapGraph<Local, Integer> redeGrafo;

    @Test
    void testImportWateringPlanSuccess() {
        result = controller.importWateringPlan("src/test/java/project/testFiles/ficheiroCorreto.txt");
        assertTrue(result);
    }

    @Test
    void testImportWateringPlanFailure() {
        result = controller.importWateringPlan("src/test/java/project/testFiles/ficheiroHoraErrada.txt");
        assertFalse(result);
    }

    @Test
    void testImportRedeDistribuicaoCorrect() {
        assertTrue(resultImportLocais);
    }

    @Test
    void testImportRedeDistribuicaoCorrectNumAdjVertices() {
        Local l1 = new Local("CT156", 39.7478, -8.9322);
        int numArestas = r.getRedeDistribuicao().adjVertices(l1).size();
        assertEquals(4, numArestas);
    }

    @Test
    void testImportRedeDistribuicaoCorrectAdjVertices() {
        List<Local> verts = new ArrayList<>();

        Local l1 = new Local("CT156", 39.7478, -8.9322);
        Local l2 = new Local("CT53", 39.6603, -8.8247);
        Local l3 = new Local("CT140", 39.7444, -8.8072);
        Local l4 = new Local("CT291", 39.5892, -9.0194);
        Local l5 = new Local("CT186", 39.6, -9.0667);
        verts.add(l2);
        verts.add(l3);
        verts.add(l4);
        verts.add(l5);
        for (Local l : verts) {
            assertTrue(r.getRedeDistribuicao().adjVertices(l1).contains(l));
        }
    }

    @Test
    void testImportRedeDistribuicaoForValidVertex() {
        Local l3 = new Local("CT156", 39.7478, -8.9322);
        boolean success1 = r.getRedeDistribuicao().validVertex(l3);

        assertTrue(success1);
    }

    @Test
    void testImportRedeDistribuicaoCorrectWeight() {
        Local l1 = new Local("CT156", 39.7478, -8.9322);
        Local l2 = new Local("CT53", 39.6603, -8.8247);
        int expected = 14830;

        int actual = r.getRedeDistribuicao().edge(l1, l2).getWeight();

        assertEquals(expected, actual);

    }

    @Test
    void testImportRedeDistribuicaoCorrectNumberVertex() {
        int exp = 323;
        int actual = r.getRedeDistribuicao().numVerts;

        assertEquals(exp, actual);
    }

    @Test
    void testImportRedeDistribuicaoCorrectNumberEdges() {
        int exp = 1566;
        int actual = r.getRedeDistribuicao().numEdges();

        assertEquals(exp, actual);
    }

    @BeforeEach
    public void setUp() {
        resultImportLocais = controller.importRedeDistribuicao("src/test/java/project/testFiles/redeDistribuicao/locais_big.csv", "src/test/java/project/testFiles/redeDistribuicao/distancias_big.csv");
        r = RedeHub.getInstance();
        redeGrafo = r.getRedeDistribuicao();
    }

    @AfterEach
    public void tearDown() {
        redeGrafo = null;
    }
}