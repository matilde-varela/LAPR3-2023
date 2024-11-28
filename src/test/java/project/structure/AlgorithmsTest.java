package project.structure;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import project.domain.ImportarFicheiro;
import project.domain.Local;
import project.domain.RedeHub;
import project.exception.ExcecaoFicheiro;

import java.io.IOException;
import java.util.*;

import static org.junit.jupiter.api.Assertions.*;

class AlgorithmsTest {

    RedeHub rede = RedeHub.getInstance();
    MapGraph<Local, Integer> redeGrafo;

    @BeforeEach
    public void setUp() {
        try {
            String locais = "files/locais_small.csv";
            String distancias = "files/distancias_small.csv";
            ImportarFicheiro.importRedeDistribuicao(locais, distancias);
            redeGrafo = rede.getRedeDistribuicao();
        } catch (ExcecaoFicheiro | IOException e) {
            System.out.println(e.getMessage());
        }
    }

    @AfterEach
    void tearDown() {
        redeGrafo = null;
    }

    @Test
    void depthFirstSearch() {
        assertNull(Algorithms.DepthFirstSearch(redeGrafo, new Local("Sardinha")));

        LinkedList<Local> path = Algorithms.DepthFirstSearch(redeGrafo, new Local("CT5"));
        assert path != null;
        assertEquals(17, path.size());

        assertEquals(new Local("CT5"), path.peekFirst());

        assertEquals(new Local("CT5"), path.removeFirst());
        assertTrue(new LinkedList<>(Arrays.asList(new Local("CT10"), new Local("CT13"), new Local("CT11"),
                new Local("CT12"), new Local("CT14"), new Local("CT7"), new Local("CT8"), new Local("CT6"),
                new Local("CT17"), new Local("CT16"), new Local("CT3"), new Local("CT12"), new Local("CT1"),
                new Local("CT15"), new Local("CT4"), new Local("CT9"))).contains(path.removeFirst()));

        path = Algorithms.DepthFirstSearch(redeGrafo, new Local("CT16"));
        List<String> expected = new LinkedList<>(Arrays.asList("CT16", "CT3", "CT12", "CT1", "CT10", "CT13", "CT11", "CT5",
                "CT9", "CT17", "CT6", "CT4", "CT2", "CT14", "CT7", "CT8", "CT15"));
        List<String> pathIds = new ArrayList<>();
        assert path != null;
        for (Local local : path) {
            pathIds.add(local.getNumId());
        }
        assertEquals(expected, pathIds);
    }

    @Test
    void minimumSpanningTreeAlgorithmsTest() {
        MapGraph<Local, Integer> mst1 = MST.getMstWithPrimAlgorithm(redeGrafo);
        MapGraph<Local, Integer> mst2 = MST.getMstWithKruskallAlgorithm(redeGrafo);

        System.out.println("\nÁrvore de Cobertura de Custo Mínimo usando o alg. Kruskall " + mst2);
        System.out.println("\nÁrvore de Cobertura de Custo Mínimo usando o alg. Prim " + mst1);
        assertEquals(mst1, mst2);
    }

    @Test
    void totalWeightMinimumSpanningTree() {
        MapGraph<Local, Integer> mst1 = MST.getMstWithPrimAlgorithm(redeGrafo);
        MapGraph<Local, Integer> mst2 = MST.getMstWithKruskallAlgorithm(redeGrafo);

        int primTotalWeight = MST.totalWeightMinimumSpanningTree(mst1);
        int kruskallTotalWeight = MST.totalWeightMinimumSpanningTree(mst2);

        assertEquals(primTotalWeight, kruskallTotalWeight);
    }

    @Test
    void checkIfNoLocalsAreReapeated() {
        List<Local> hubs = redeGrafo.getHubsVertexList();
        int numClusters = 5;
        Set<Set<Local>> clusters = Algorithms.getNClusters(redeGrafo, numClusters, hubs);

        for (Set<Local> cluster : clusters) {
            assertEquals(cluster.size(), cluster.stream().distinct().count(),
                    "Foram encontrados locais duplicados nos clusters.");
        }
    }


    @Test
    void checkIfNoLocalsAreLeftOut() {
        List<Local> hubs = redeGrafo.getHubsVertexList();
        int numClusters = 3;
        Set<Set<Local>> clusters = Algorithms.getNClusters(redeGrafo, numClusters, hubs);
        int vertexesClusters = 0;
        for (Set<Local> cluster : clusters) {
            vertexesClusters += cluster.size();
        }
        assertEquals(redeGrafo.vertices.size(), vertexesClusters);
    }

}