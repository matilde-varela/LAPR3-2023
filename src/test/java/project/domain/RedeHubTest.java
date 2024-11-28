package project.domain;


import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import project.exception.ExcecaoFicheiro;
import project.structure.MapGraph;

import java.io.IOException;
import java.util.*;

import static org.junit.jupiter.api.Assertions.*;
import static project.domain.RedeHub.*;

class RedeHubTest {

    RedeHub redeHub = RedeHub.getInstance();
    MapGraph<Local, Integer> redeGrafo;

    @BeforeEach
    void setUp() throws ExcecaoFicheiro, IOException {
            String locais = "files/locais_small.csv";
            String distancias = "files/distancias_small.csv";
            ImportarFicheiro.importRedeDistribuicao(locais,distancias);
            redeGrafo = redeHub.getRedeDistribuicao();
    }

    @AfterEach
    void tearDown() {
        redeGrafo = null;
    }
    @Test
    void calculateInfluenceWorks() {
        Local local1 = new Local("CT15", new CoordenadasGps(41.7, -8.8333));
        Local local2 = new Local("CT12", new CoordenadasGps(41.1495, -8.6108));
        Local local3 = new Local("CT1", new CoordenadasGps(40.6389, -8.6553));
        Local local4 = new Local("CT10", new CoordenadasGps(39.7444, -8.8072));
        Local local5 = new Local("CT13", new CoordenadasGps(39.2369, -8.685));
        Local local6 = new Local("CT14", new CoordenadasGps(38.5243, -8.8926));
        Local local7 = new Local("CT8", new CoordenadasGps(37.0161, -7.935));

        Integer influenceValue1 = 2;
        Integer influenceValue2 = 4;
        Integer influenceValue3 = 4;
        Integer influenceValue4 = 5;
        Integer influenceValue5 = 4;
        Integer influenceValue6 = 4;
        Integer influenceValue7 = 2;

        Map<Local, Integer> expected = new HashMap<>();
        expected.put(local1, influenceValue1);
        expected.put(local2, influenceValue2);
        expected.put(local3, influenceValue3);
        expected.put(local4, influenceValue4);
        expected.put(local5, influenceValue5);
        expected.put(local6, influenceValue6);
        expected.put(local7, influenceValue7);


        Map<Local, Integer> result = redeHub.calculateInfluence(redeGrafo);

        for (Map.Entry<Local, Integer> entry : expected.entrySet()) {
            Local key = entry.getKey();
            Integer expectedValue = entry.getValue();

            assertEquals(expectedValue, result.get(key));
        }
    }

    @Test
    void calculateInfluenceFails() {
        Local local1 = new Local("CT15", new CoordenadasGps(41.7, -8.8333));
        Local local2 = new Local("CT12", new CoordenadasGps(41.1495, -8.6108));
        Local local3 = new Local("CT1", new CoordenadasGps(40.6389, -8.6553));
        Local local4 = new Local("CT10", new CoordenadasGps(39.7444, -8.8072));
        Local local5 = new Local("CT13", new CoordenadasGps(39.2369, -8.685));
        Local local6 = new Local("CT14", new CoordenadasGps(38.5243, -8.8926));
        Local local7 = new Local("CT8", new CoordenadasGps(37.0161, -7.935));

        Integer influenceValue1 = 10;
        Integer influenceValue2 = 15;
        Integer influenceValue3 = 22;
        Integer influenceValue4 = 23;
        Integer influenceValue5 = 0;
        Integer influenceValue6 = 30;
        Integer influenceValue7 = 8;

        Map<Local, Integer> expected = new HashMap<>();
        expected.put(local1, influenceValue1);
        expected.put(local2, influenceValue2);
        expected.put(local3, influenceValue3);
        expected.put(local4, influenceValue4);
        expected.put(local5, influenceValue5);
        expected.put(local6, influenceValue6);
        expected.put(local7, influenceValue7);

        Map<Local, Integer> result = redeHub.calculateInfluence(redeGrafo);

        for (Map.Entry<Local, Integer> entry : expected.entrySet()) {
            Local key = entry.getKey();
            Integer expectedValue = entry.getValue();

            assertNotEquals(expectedValue, result.get(key));
        }
    }

    @Test
    void calculateProximityWorks() {
        Local local1 = new Local("CT15", new CoordenadasGps(41.7, -8.8333));
        Local local2 = new Local("CT12", new CoordenadasGps(41.1495, -8.6108));
        Local local3 = new Local("CT1", new CoordenadasGps(40.6389, -8.6553));
        Local local4 = new Local("CT10", new CoordenadasGps(39.7444, -8.8072));
        Local local5 = new Local("CT13", new CoordenadasGps(39.2369, -8.685));
        Local local6 = new Local("CT14", new CoordenadasGps(38.5243, -8.8926));
        Local local7 = new Local("CT8", new CoordenadasGps(37.0161, -7.935));

        Integer proximityValue1 = 4264395;
        Integer proximityValue2 = 3437328;
        Integer proximityValue3 = 3005527;
        Integer proximityValue4 = 2979452;
        Integer proximityValue5 = 3335004;
        Integer proximityValue6 = 4244871;
        Integer proximityValue7 = 6499026;

        Map<Local, Integer> expected = new HashMap<>();
        expected.put(local1, proximityValue1);
        expected.put(local2, proximityValue2);
        expected.put(local3, proximityValue3);
        expected.put(local4, proximityValue4);
        expected.put(local5, proximityValue5);
        expected.put(local6, proximityValue6);
        expected.put(local7, proximityValue7);


        Map<Local, Integer> result = redeHub.calculateProximity(redeGrafo);

        for (Map.Entry<Local, Integer> entry : expected.entrySet()) {
            Local key = entry.getKey();
            Integer expectedValue = entry.getValue();

            assertEquals(expectedValue, result.get(key));
        }
    }

    @Test
    void calculateProximityFails() {
        Local local1 = new Local("CT15", new CoordenadasGps(41.7, -8.8333));
        Local local2 = new Local("CT12", new CoordenadasGps(41.1495, -8.6108));
        Local local3 = new Local("CT1", new CoordenadasGps(40.6389, -8.6553));
        Local local4 = new Local("CT10", new CoordenadasGps(39.7444, -8.8072));
        Local local5 = new Local("CT13", new CoordenadasGps(39.2369, -8.685));
        Local local6 = new Local("CT14", new CoordenadasGps(38.5243, -8.8926));
        Local local7 = new Local("CT8", new CoordenadasGps(37.0161, -7.935));

        Integer proximityValue1 = 111234;
        Integer proximityValue2 = 687513;
        Integer proximityValue3 = 78965;
        Integer proximityValue4 = 462454;
        Integer proximityValue5 = 324641;
        Integer proximityValue6 = 454871;
        Integer proximityValue7 = 462034;

        Map<Local, Integer> expected = new HashMap<>();
        expected.put(local1, proximityValue1);
        expected.put(local2, proximityValue2);
        expected.put(local3, proximityValue3);
        expected.put(local4, proximityValue4);
        expected.put(local5, proximityValue5);
        expected.put(local6, proximityValue6);
        expected.put(local7, proximityValue7);


        Map<Local, Integer> result = redeHub.calculateProximity(redeGrafo);

        for (Map.Entry<Local, Integer> entry : expected.entrySet()) {
            Local key = entry.getKey();
            Integer expectedValue = entry.getValue();

            assertNotEquals(expectedValue, result.get(key));
        }
    }

    @Test
    void calculateCentralityWorks() {
        Local local1 = new Local("CT15", new CoordenadasGps(41.7, -8.8333));
        Local local2 = new Local("CT12", new CoordenadasGps(41.1495, -8.6108));
        Local local3 = new Local("CT1", new CoordenadasGps(40.6389, -8.6553));
        Local local4 = new Local("CT10", new CoordenadasGps(39.7444, -8.8072));
        Local local5 = new Local("CT13", new CoordenadasGps(39.2369, -8.685));
        Local local6 = new Local("CT14", new CoordenadasGps(38.5243, -8.8926));
        Local local7 = new Local("CT8", new CoordenadasGps(37.0161, -7.935));

        Integer centralityValue1 = 12;
        Integer centralityValue2 = 14;
        Integer centralityValue3 = 14;
        Integer centralityValue4 = 15;
        Integer centralityValue5 = 14;
        Integer centralityValue6 = 11;
        Integer centralityValue7 = 13;

        Map<Local, Integer> expected = new HashMap<>();
        expected.put(local1, centralityValue1);
        expected.put(local2, centralityValue2);
        expected.put(local3, centralityValue3);
        expected.put(local4, centralityValue4);
        expected.put(local5, centralityValue5);
        expected.put(local6, centralityValue6);
        expected.put(local7, centralityValue7);


        Map<Local, Integer> result = redeHub.calculateCentrality(redeGrafo);
        for (Map.Entry<Local, Integer> entry : expected.entrySet()) {
            Local key = entry.getKey();
            Integer expectedValue = entry.getValue();

            assertEquals(expectedValue, result.get(key));
        }
    }

    @Test
    void calculateCentralityFails() {
        Local local1 = new Local("CT15", new CoordenadasGps(41.7, -8.8333));
        Local local2 = new Local("CT12", new CoordenadasGps(41.1495, -8.6108));
        Local local3 = new Local("CT1", new CoordenadasGps(40.6389, -8.6553));
        Local local4 = new Local("CT10", new CoordenadasGps(39.7444, -8.8072));
        Local local5 = new Local("CT13", new CoordenadasGps(39.2369, -8.685));
        Local local6 = new Local("CT14", new CoordenadasGps(38.5243, -8.8926));

        Integer centralityValue1 = 20;
        Integer centralityValue2 = 32;
        Integer centralityValue3 = 1;
        Integer centralityValue4 = 41;
        Integer centralityValue5 = 53;
        Integer centralityValue6 = 19;

        Map<Local, Integer> expected = new HashMap<>();
        expected.put(local1, centralityValue1);
        expected.put(local2, centralityValue2);
        expected.put(local3, centralityValue3);
        expected.put(local4, centralityValue4);
        expected.put(local5, centralityValue5);
        expected.put(local6, centralityValue6);


        Map<Local, Integer> result = redeHub.calculateCentrality(redeGrafo);

        for (Map.Entry<Local, Integer> entry : expected.entrySet()) {
            Local key = entry.getKey();
            Integer expectedValue = entry.getValue();

            assertNotEquals(expectedValue, result.get(key));
        }
    }

    @Test
    void getTopNMapWorks(){
        Integer n = 3;
        Map<Local, List<Integer>> expectedMap = new LinkedHashMap<>();
        Map<Local, List<Integer>> realMap = new HashMap<>();
        Local local1 = new Local("CT10", new CoordenadasGps(39.7444, -8.8072));
        Local local2 = new Local("CT6", new CoordenadasGps(40.2111,-8.4291));
        Local local3 = new Local("CT1", new CoordenadasGps(40.6389, -8.6553));
        Local local4 = new Local("CT13", new CoordenadasGps(39.2369, -8.685));
        Local local5 = new Local("CT12", new CoordenadasGps(41.1495, -8.6108));

        List<Integer> values1 = new ArrayList<>();
        values1.add(5);
        values1.add(2979452);
        values1.add(15);
        expectedMap.put(local1, values1);
        realMap.put(local1, values1);

        List<Integer> values2 = new ArrayList<>();
        values2.add(4);
        values2.add(2826782);
        values2.add(14);
        expectedMap.put(local2, values2);
        realMap.put(local2, values2);

        List<Integer> values3 = new ArrayList<>();
        values3.add(4);
        values3.add(3005527);
        values3.add(14);
        expectedMap.put(local3, values3);
        realMap.put(local3, values3);

        List<Integer> values4 = new ArrayList<>();
        values4.add(4);
        values4.add(3335004);
        values4.add(14);
        realMap.put(local4, values4);

        List<Integer> values5 = new ArrayList<>();
        values5.add(4);
        values5.add(3437328);
        values5.add(14);
        realMap.put(local5, values5);

        assertEquals(expectedMap, redeHub.getTopNMap(realMap, n));
    }

    @Test
    void getTopNMapFails(){
        Integer n = 2;
        Map<Local, List<Integer>> expectedWrongMap = new LinkedHashMap<>();
        Map<Local, List<Integer>> realMap = new HashMap<>();
        Local local1 = new Local("CT10", new CoordenadasGps(39.7444, -8.8072));
        Local local2 = new Local("CT6", new CoordenadasGps(40.2111,-8.4291));
        Local local3 = new Local("CT1", new CoordenadasGps(40.6389, -8.6553));
        Local local4 = new Local("CT13", new CoordenadasGps(39.2369, -8.685));

        List<Integer> values2 = new ArrayList<>();
        values2.add(4);
        values2.add(2826782);
        values2.add(14);
        expectedWrongMap.put(local2, values2);
        realMap.put(local2, values2);

        List<Integer> values1 = new ArrayList<>();
        values1.add(5);
        values1.add(2979452);
        values1.add(15);
        expectedWrongMap.put(local1, values1);
        realMap.put(local1, values1);

        List<Integer> values4 = new ArrayList<>();
        values4.add(4);
        values4.add(3335004);
        values4.add(14);
        realMap.put(local4, values4);

        List<Integer> values3 = new ArrayList<>();
        values3.add(4);
        values3.add(3005527);
        values3.add(14);
        expectedWrongMap.put(local3, values3);
        realMap.put(local3, values3);

        assertNotEquals(expectedWrongMap, redeHub.getTopNMap(realMap, n));
    }

    @Test
    void getShortestPathForFurthestNodesTestValid() {
        LinkedList<Local> path1 = new LinkedList<>();

        Local local1 = new Local("CT15", new CoordenadasGps(41.7, -8.8333));
        Local local2 = new Local("CT12", new CoordenadasGps(41.1495, -8.6108));
        Local local3 = new Local("CT1", new CoordenadasGps(40.6389, -8.6553));
        Local local4 = new Local("CT10", new CoordenadasGps(39.7444, -8.8072));
        Local local5 = new Local("CT13", new CoordenadasGps(39.2369, -8.685));
        Local local6 = new Local("CT14", new CoordenadasGps(38.5243, -8.8926));
        Local local7 = new Local("CT8", new CoordenadasGps(37.0161, -7.935));

        path1.add(local1);
        path1.add(local2);
        path1.add(local3);
        path1.add(local4);
        path1.add(local5);
        path1.add(local6);
        path1.add(local7);

        LinkedList<Local> path2 = getShortestPathForFurthestNodes();

        assertEquals(path1, path2);
    }

    @Test
    void getShortestPathForFurthestNodesTestInvalid() {
        LinkedList<Local> path1 = new LinkedList<>();

        Local local1 = new Local("CT15", new CoordenadasGps(41.7, -8.8333));
        Local local2 = new Local("CT12", new CoordenadasGps(41.1495, -8.6108));
        Local local3 = new Local("CT1", new CoordenadasGps(40.6389, -8.6553));
        Local local4 = new Local("CT10", new CoordenadasGps(39.7444, -8.8072));
        Local local5 = new Local("CT13", new CoordenadasGps(39.2369, -8.685));
        Local local6 = new Local("CT14", new CoordenadasGps(38.5243, -8.8926));
        Local local7 = new Local("CT8", new CoordenadasGps(37.0161, -7.935));

        path1.add(local1);
        path1.add(local2);
        path1.add(local4);
        path1.add(local3);
        path1.add(local5);
        path1.add(local6);
        path1.add(local7);

        LinkedList<Local> path2 = getShortestPathForFurthestNodes();

        assertNotEquals(path1, path2);
    }

    @Test
    void getBiggestDistTestValid1() {
        ArrayList<Integer> dist = new ArrayList<>();
        dist.add(0);

        assertEquals(0, getBiggestDist(dist));
    }

    @Test
    void getBiggestDistTestValid3() {
        ArrayList<Integer> dist = new ArrayList<>();
        dist.add(1);
        dist.add(0);
        dist.add(8000);

        assertEquals(2, getBiggestDist(dist));
    }

    @Test
    void getBiggestDistTestValid5() {
        ArrayList<Integer> dist = new ArrayList<>();
        dist.add(1234);
        dist.add(10000);
        dist.add(1);
        dist.add(0);
        dist.add(8000);

        assertEquals(1, getBiggestDist(dist));
    }

}