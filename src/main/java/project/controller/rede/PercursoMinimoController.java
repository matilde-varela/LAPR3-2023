package project.controller.rede;

import project.domain.Local;
import project.domain.RedeHub;
import project.structure.Path;

import java.util.LinkedList;

public class PercursoMinimoController {

    public static Path analyzeData(int autonomia, LinkedList<Local> caminho){
        return RedeHub.analyzeData(autonomia, caminho);
    }

}
