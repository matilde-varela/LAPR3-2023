package project.controller.operacao;

import project.data_access.*;
import project.domain.Planta;

import java.sql.SQLException;
import java.util.Date;
import java.util.List;
import java.util.Objects;

public class RegistarOperacaoAplicacaoFatoresController {

    private OperacaoRepository operacaoRepository;
    private UnitsRepository unitsRepository;
    private FieldsRepository fieldsRepository;
    private CultureRepository cultureRepository;

    public RegistarOperacaoAplicacaoFatoresController() {
        getOperacaoRepository();
        getUnitsRepository();
        getCultureRepository();
        getFieldsRepository();
    }

    private OperacaoRepository getOperacaoRepository() {
        if (Objects.isNull(operacaoRepository)) {
            Repositories repositories = Repositories.getInstance();
            operacaoRepository = repositories.getOperacaoRepository();
        }
        return operacaoRepository;
    }

    private UnitsRepository getUnitsRepository() {
        if (Objects.isNull(unitsRepository)) {
            Repositories repositories = Repositories.getInstance();
            unitsRepository = repositories.getUnitsRepository();
        }
        return unitsRepository;
    }

    private CultureRepository getCultureRepository() {
        if (Objects.isNull(cultureRepository)) {
            Repositories repositories = Repositories.getInstance();
            cultureRepository = repositories.getCultureRepository();
        }
        return cultureRepository;
    }

    private FieldsRepository getFieldsRepository() {
        if (Objects.isNull(fieldsRepository)) {
            Repositories repositories = Repositories.getInstance();
            fieldsRepository = repositories.getFieldsRepository();
        }
        return fieldsRepository;
    }


    public List<String> getUnitTypes() throws SQLException {
        return unitsRepository.getUnitDesignations();
    }

    public  List<String> getFieldsNames() throws SQLException {
        return fieldsRepository.getFieldsNames();
    }

    public List<String> getCultures() throws SQLException {
        return cultureRepository.getCultures();
    }

    public List<Planta> getCulturesByField(String nomeParcela) throws SQLException {
        return cultureRepository.getCulturesByField(nomeParcela);
    }
    public boolean registerAplication(String designacaoOperacao, String designacaoUnidade, Integer qtd, Date dataOperacao, String nomeFator, String nomeParcela, Date dataInicial, String nomeComum, String variedade) throws SQLException {
        return operacaoRepository.registarAplicacaoFatorProducao(designacaoOperacao, designacaoUnidade, qtd, dataOperacao, nomeFator, nomeParcela, dataInicial, nomeComum, variedade);
    }

    public boolean verifyIfOperationExists(String desigOp, String desigUnidade, Integer qtd, Date dataOp, String nmFator) throws SQLException {
        return operacaoRepository.verifyIfAplicationOperationExists(desigOp, desigUnidade, qtd, dataOp, nmFator);

    }


}
