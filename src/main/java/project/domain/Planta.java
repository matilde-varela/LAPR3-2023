package project.domain;

public class Planta {
    String nomeComum;
    String variedade;

    public Planta(String nomeComum, String variedade) {
        this.nomeComum = nomeComum;
        this.variedade = variedade;
    }

    public String getNomeComum() {
        return nomeComum;
    }

    public String getVariedade() {
        return variedade;
    }

    @Override
    public String toString() {
        return "Nome Comum: " + nomeComum + " | Variedade: " + variedade;
    }
}
