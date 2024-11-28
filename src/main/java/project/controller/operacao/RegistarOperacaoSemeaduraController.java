package project.controller.operacao;

import project.data_access.*;

import java.util.*;
import java.sql.SQLException;

public class RegistarOperacaoSemeaduraController {

    private OperacaoRepository operacaoRepository;
    private UnitsRepository unitsRepository;
    private FieldsRepository fieldsRepository;
    private CultureRepository cultureRepository;

    public RegistarOperacaoSemeaduraController() {
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

    public  List<String> getFieldsNames() throws SQLException {
        return fieldsRepository.getFieldsNames();
    }

    public List<String> getCultures() throws SQLException {
        return cultureRepository.getCultures();
    }

    public boolean registerOperation(String nomeParcela , String nomeComum, Double quantidadeCultura, String variedade, Date dataOperacao, String tipoUnidadeCultura, Double quantidadeOperacao) throws SQLException {
        return operacaoRepository.registerSemeaduraOperation(nomeParcela, nomeComum, quantidadeCultura, variedade, dataOperacao, tipoUnidadeCultura, quantidadeOperacao);
    }

}
