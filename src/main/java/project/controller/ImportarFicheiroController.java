package project.controller;

import project.domain.Horario;
import project.domain.ImportarFicheiro;

import java.io.IOException;
import java.util.Map;

public class ImportarFicheiroController {

    public boolean importWateringPlan(String filepath) {
        try {
            return ImportarFicheiro.importWateringPlan(filepath);
        } catch (Exception e) {
            return false;
        }

    }

    public boolean importRedeDistribuicao(String locais, String distancias) {
        try {
            return ImportarFicheiro.importRedeDistribuicao(locais, distancias);
        } catch (Exception e) {
            return false;
        }
    }

    public boolean importarFicheiroHorarios(String ficheiro, Map<String, Horario> novosHorarios){
        try {
            return ImportarFicheiro.importarFicheiroHorarios(ficheiro, novosHorarios);
        } catch (Exception e) {
            return false;
        }
    }
}
