package project.data_access;

public class Repositories {

    private static final Repositories instance = new Repositories();
    private OperacaoRepository operacaoRepository;
    private UnitsRepository unitsRepository;
    private FieldsRepository fieldsRepository;
    private CultureRepository cultureRepository;
    private ProductsRepository productsRepository;
    private PlantsRepository plantsRepository;
    private DatesRepository datesRepository;

    public UnitsRepository getUnitsRepository() {
        return unitsRepository;
    }

    public FieldsRepository getFieldsRepository() {
        return fieldsRepository;
    }

    public CultureRepository getCultureRepository() {
        return cultureRepository;
    }

    private Repositories() {
        operacaoRepository = new OperacaoRepository();
        unitsRepository = new UnitsRepository();
        fieldsRepository = new FieldsRepository();
        cultureRepository = new CultureRepository();
        datesRepository = new DatesRepository();
        productsRepository = new ProductsRepository();
        plantsRepository = new PlantsRepository();
    }

    public static Repositories getInstance() {
        return instance;
    }

    public OperacaoRepository getOperacaoRepository() {
        return operacaoRepository;
    }

    public ProductsRepository getProductsRepository(){
        return productsRepository;
    }

    public PlantsRepository getPlantsRepository(){
        return plantsRepository;
    }

    public DatesRepository getDatesRepository(){
        return datesRepository;
    }

}
