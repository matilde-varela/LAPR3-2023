package project.controller.rede;

import project.domain.Local;
import project.structure.*;

import java.util.Comparator;

public class RedeLigacaoMinimaController {
    public MapGraph<Local, Integer> kruskallAlgorithm(MapGraph<Local, Integer> redeDistribuicao) {
        return MST.getMstWithKruskallAlgorithm(redeDistribuicao);
    }

    public int getTotalWeightOfMinimumSpanningTree(MapGraph<Local, Integer>  mst) {
        return MST.totalWeightMinimumSpanningTree(mst);
    }
}
