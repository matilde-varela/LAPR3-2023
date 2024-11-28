package project.controller.sistema_rega;
import project.domain.SistemaDeRega;
import java.time.LocalDate;
import java.time.LocalTime;

public class ControladorRegaController {
    public ControladorRegaController() {
    }

    public String checkWateringInRealTime() {
        if (checkDate(LocalDate.now())) {
            return SistemaDeRega.getControladorRega().checkIsWateringNoData();
        } else {
            return "ERRO: O dia indicado está fora do espaço de tempo ativo do plano de rega importado.";
        }
    }

    public String checkWateringInSimulatedTime(LocalDate day, LocalTime time) {
        if (checkDate(day)) {
            return SistemaDeRega.getControladorRega().checkIsWateringHour(time, day);
        } else {
            return "ERRO: O dia indicado está fora do espaço de tempo ativo do plano de rega importado.";
        }
    }

    /**
     * O método vai utilizar a data que lhe demos e testa se esta data está antes ou depois do tempo ao qual o plano de rega foi planeado para ser ativado.
     *
     * @param data
     * @return
     */
    public Boolean checkDate(LocalDate data) {
        if (SistemaDeRega.getInicioDoPlanoDeRega().equals(data) || SistemaDeRega.getInicioDoPlanoDeRega().plusDays(30).equals(data)) {
            return true;
        }
        return (SistemaDeRega.getInicioDoPlanoDeRega().isBefore(data) && SistemaDeRega.getInicioDoPlanoDeRega().plusDays(30).isAfter(data));
    }

    public boolean checkIfPlanIsPresent() {
        return SistemaDeRega.getPlanoDeRegas() != null;
    }

    public boolean exportWateringPlan() {
        if (checkDate(LocalDate.now())) {
            return SistemaDeRega.generateWateringRegisters();
        } else {
            return false;
        }
    }
}
