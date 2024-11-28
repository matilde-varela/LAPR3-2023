package project.controller.operacao;

import project.data_access.*;
import project.domain.Planta;

import java.sql.SQLException;
import java.util.Date;
import java.util.List;
import java.util.Objects;

public class RegistarOperacaoColheitaController {
    private OperacaoRepository operacaoRepository;
    private UnitsRepository unitsRepository;
    private FieldsRepository fieldsRepository;
    private CultureRepository cultureRepository;
    private ProductsRepository productsRepository;
    private PlantsRepository plantsRepository;
    private DatesRepository datesRepository;

    public RegistarOperacaoColheitaController() {
        getOperacaoRepository();
        getUnitsRepository();
        getCultureRepository();
        getFieldsRepository();
        getDatesRepository();
        getProductsRepository();
        getPlantsRepository();
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

    private ProductsRepository getProductsRepository() {
        if (Objects.isNull(productsRepository)) {
            Repositories repositories = Repositories.getInstance();
            productsRepository = repositories.getProductsRepository();
        }
        return productsRepository;
    }

    private PlantsRepository getPlantsRepository() {
        if (Objects.isNull(plantsRepository)) {
            Repositories repositories = Repositories.getInstance();
            plantsRepository = repositories.getPlantsRepository();
        }
        return plantsRepository;
    }

    private DatesRepository getDatesRepository() {
        if (Objects.isNull(datesRepository)) {
            Repositories repositories = Repositories.getInstance();
            datesRepository = repositories.getDatesRepository();
        }
        return datesRepository;
    }

    public List<String> getUnitTypes() throws SQLException {
        return unitsRepository.getUnitDesignations();
    }

    public List<String> getFieldsNames() throws SQLException {
        return fieldsRepository.getFieldsNames();
    }

    public List<Planta> getCulturesByField(String nomeParcela) throws SQLException {
        return cultureRepository.getCulturesByField(nomeParcela);
    }

    public List<String> getProductsByField(String variedade, String nomeComum) throws SQLException {
        return productsRepository.getProductsByField(variedade, nomeComum);
    }

    public List<String> getPermanencyType(String variedade, String nomeComum) throws SQLException {
        return plantsRepository.getPermanencyType(variedade, nomeComum);
    }

    public boolean registerOperation(String nomeParcela, Planta cultura, String nomeProduto, Date dataOperacao, String tipoUnidade, Double quantidade, Date dataFim) throws SQLException {
        return operacaoRepository.registerColheitaOperation(nomeParcela, cultura.getNomeComum(), cultura.getVariedade(), nomeProduto, dataOperacao, tipoUnidade, quantidade, dataFim);
    }
}
