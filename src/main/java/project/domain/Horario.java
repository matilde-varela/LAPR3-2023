package project.domain;

import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.Objects;

/**
 * The type Horario.
 */
public class Horario {
    private LocalTime horaAbertura;
    private LocalTime horaFecho;

    /**
     * Instantiates a new Horario.
     *
     * @param horaAbertura the hora abertura
     * @param horaFecho    the hora fecho
     */
    public Horario(LocalTime horaAbertura, LocalTime horaFecho){
        this.horaAbertura = horaAbertura;
        this.horaFecho = horaFecho;
    }

    public Horario(String numId){
        getCorrectHorario(numId);
    }


    /**
     * Gets hora abertura.
     *
     * @return the hora abertura
     */
    public LocalTime getHoraAbertura() {
        return horaAbertura;
    }

    /**
     * Sets hora abertura.
     *
     * @param horaAbertura the hora abertura
     */
    public void setHoraAbertura(LocalTime horaAbertura) {
        this.horaAbertura = horaAbertura;
    }

    /**
     * Gets hora fecho.
     *
     * @return the hora fecho
     */
    public LocalTime getHoraFecho() {
        return horaFecho;
    }

    /**
     * Sets hora fecho.
     *
     * @param horaFecho the hora fecho
     */
    public void setHoraFecho(LocalTime horaFecho) {
        this.horaFecho = horaFecho;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Horario horario = (Horario) o;
        return Objects.equals(horaAbertura, horario.horaAbertura) && Objects.equals(horaFecho, horario.horaFecho);
    }

    @Override
    public int hashCode() {
        return Objects.hash(horaAbertura, horaFecho);
    }

    @Override
    public String toString() {
        return "Horario{" + "horaAbertura=" + horaAbertura + ", horaFecho=" + horaFecho + "}";
    }

    public void getCorrectHorario(String numId){
        int num = Integer.parseInt(numId.substring(2));
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm");
        try {
            if (num >= 1 && num <= 105) {
                horaAbertura = LocalTime.parse("09:00", formatter);
                horaFecho = LocalTime.parse("14:00", formatter);
            } else if (num >= 106 && num <= 215) {
                horaAbertura = LocalTime.parse("11:00", formatter);
                horaFecho = LocalTime.parse("16:00", formatter);
            } else if (num >= 216 && num <= 323) {
                horaAbertura = LocalTime.parse("12:00", formatter);
                horaFecho = LocalTime.parse("17:00", formatter);
            } else {
                horaAbertura = LocalTime.parse("00:00", formatter);
                horaFecho = LocalTime.parse("00:00", formatter);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
