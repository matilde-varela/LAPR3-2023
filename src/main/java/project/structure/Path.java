package project.structure;

import project.domain.Local;

import java.time.LocalTime;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

public class Path {

    private int distanciaTotal;
    private LinkedList<Local> percurso;
    private ArrayList<Integer> carregamentos;
    private Map<Local, List<LocalTime>> temposDeChegada;
    private boolean flag;

    public Path(int distanciaTotal, LinkedList<Local> percurso, ArrayList<Integer> carregamentos, boolean flag) {
        this.distanciaTotal = distanciaTotal;
        this.percurso = percurso;
        this.carregamentos = carregamentos;
        this.flag = flag;
    }

    public Path(int distanciaTotal, LinkedList<Local> percurso, ArrayList<Integer> carregamentos, Map<Local, List<LocalTime>> temposDeChegada, boolean flag) {
        this.distanciaTotal = distanciaTotal;
        this.percurso = percurso;
        this.carregamentos = carregamentos;
        this.temposDeChegada = temposDeChegada;
        this.flag = true;
    }

    public int getDistanciaTotal() {
        return distanciaTotal;
    }

    public void setDistanciaTotal(int distanciaTotal) {
        this.distanciaTotal = distanciaTotal;
    }

    public LinkedList<Local> getPercurso() {
        return percurso;
    }

    public void setPercurso(LinkedList<Local> percurso) {
        this.percurso = percurso;
    }

    public ArrayList<Integer> getCarregamentos() {
        return carregamentos;
    }

    public void setCarregamentos(ArrayList<Integer> carregamentos) {
        this.carregamentos = carregamentos;
    }

    public Map<Local, List<LocalTime>> getTemposDeChegada() {
        return temposDeChegada;
    }

    public void setTemposDeChegada(Map<Local, List<LocalTime>> temposDeChegada) {
        this.temposDeChegada = temposDeChegada;
    }

    public void setFlag(boolean flag) {
        this.flag = flag;
    }

    public boolean isFlag() {
        return flag;
    }

    @Override
    public boolean equals(Object o) {
        if (o == this) {
            return true;
        }
        Path c = (Path) o;
        if(c.isFlag() == (this.isFlag() && c.carregamentos.equals(this.carregamentos) && c.distanciaTotal == this.distanciaTotal && c.percurso.equals(this.percurso))){
            return true;
        }
        return false;
    }
}
