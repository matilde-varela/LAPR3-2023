package project.domain;

import project.data_access.OperacaoRepository;
import project.data_access.Repositories;

import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.Objects;

public class ControladorRega {

    private OperacaoRepository operacaoRepository;

    public ControladorRega() {
        getOperacaoRepository();
    }

    private OperacaoRepository getOperacaoRepository() {
        if (Objects.isNull(operacaoRepository)) {
            Repositories repositories = Repositories.getInstance();
            operacaoRepository = repositories.getOperacaoRepository();
        }
        return operacaoRepository;
    }

    /**
     * Utiliza a informaçâo da classe SistemaDeRega e da função checkIsWateringDay() para ver que parcela está a ser regada no momento indicado e quanto tempo falta para a próxima parcela ser regada.
     *
     * @param tempo
     * @param data
     */
    public String checkIsWateringHour(LocalTime tempo, LocalDate data) {
        StringBuilder verification = new StringBuilder();

        for (Rega rega : SistemaDeRega.getPlanoDeRegas()) {
            if(rega.getData().equals(data) && rega.getHoraInicio().isBefore(tempo) && rega.getHoraFim().isAfter(tempo)){
                verification.append("Parcela a ser regada neste momento: "+rega.getIdSetor()+" | Tempo restante: "+(rega.getHoraFim().getMinute()-tempo.getMinute())+" minutos.\n" );
            }
        }

        return (verification.isEmpty()) ? "Não há parcelas a serem regadas agora." : verification.toString();
    }

    /**
     * Se o utilizador não inserir nenhum dia nem hora o processo utiliza o dia e a hora atuais.
     * // * @param planoRega.txt
     */
    public String checkIsWateringNoData() {
        return checkIsWateringHour(LocalTime.now(), LocalDate.now());
    }

    public boolean sendRegisterToDataBase(Rega rega) throws SQLException {
        if(!rega.getMixDay()) {
            return operacaoRepository.registerRegaOperation(rega);
        }
        return operacaoRepository.registerFertirregaOperation(rega);
    }
}