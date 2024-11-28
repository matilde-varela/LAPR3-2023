package project.domain;

import java.util.Objects;

public class Local {
    private String numId;
    private CoordenadasGps coordenadas;
    private Horario horario;
    private Boolean isHub;

    public Local(String numId, CoordenadasGps coordenadas, Horario horario) {
        this.numId = numId;
        this.coordenadas = coordenadas;
        this.horario = horario;
        this.isHub = false;
    }

    public Local(String numId, Double lat, Double lon, Horario horario) {
        this.numId = numId;
        this.coordenadas = new CoordenadasGps(lat, lon);
        this.horario = horario;
        this.isHub = false;
    }

    public Local(String numId, CoordenadasGps coordenadas) {
        this.numId = numId;
        this.coordenadas = coordenadas;
        this.horario = new Horario(numId);
        this.isHub = false;
    }
    public Local(String numId, Double lat, Double lon) {
        this.numId = numId;
        this.coordenadas = new CoordenadasGps(lat, lon);
        this.horario = new Horario(numId);
        this.isHub = false;
    }

    public Local(String numId) {
        this.numId = numId;
        this.isHub = false;
    }

    public String getNumId() {
        return numId;
    }

    public CoordenadasGps getCoordenadas() {
        return coordenadas;
    }

    public boolean hasNumId(String id) {
        return id.compareTo(this.numId) == 0;
    }

    public Horario getHorario(){
        return horario;
    }

    public void setHorario(Horario horario){
        this.horario = horario;
    }

    public Boolean isHub(){
        return isHub;
    }

    public void setHub(Boolean isHub){
        this.isHub = isHub;
    }
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Local hub = (Local) o;
        return Objects.equals(numId, hub.numId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(numId);
    }

    @Override
    public String toString() {
        if(isHub){
            return "[HUB - " + numId + "]";
        }
        return "[" + numId + "]";
    }
}
