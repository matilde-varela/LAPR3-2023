package project.ui.console.operacao;

import project.controller.operacao.RegistarOperacaoAplicacaoFatoresController;
import project.domain.Planta;
import project.ui.console.utils.Utils;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

public class RegistarOperacaoAplicacaoFatorProducaoUI implements Runnable {

    private RegistarOperacaoAplicacaoFatoresController controller;

    SimpleDateFormat formatter = new SimpleDateFormat("dd-MM-yyyy");
    private String designacaoOperacao;
    private String designacaoUnidade;
    private Integer quantidade;
    private Date dataOperacao;
    private String nomeFator;
    private String nomeParcela;
    private Date dataInicial;
    private String nomeComum;
    private String variedade;

    public RegistarOperacaoAplicacaoFatorProducaoUI() {
        controller = new RegistarOperacaoAplicacaoFatoresController();
    }

    @Override
    public void run() {
        try {
            int index;
            System.out.println("-----------------------------------------");
            System.out.println(" Registar aplicação de fator de produção ");
            System.out.println("-----------------------------------------");

            designacaoOperacao = Utils.readLineFromConsole("Indique a designação da operação (Fertilização / Aplicação fitofármaco / Aplicação de fator de produção):");

            List<String> fields = controller.getFieldsNames();
            index = Utils.showAndSelectIndex(fields, "Selecione a parcela:");
            verificarIndex(index);
            nomeParcela = fields.get(index);

            List<Planta> culturasInstaladas = controller.getCulturesByField(nomeParcela);
            index = Utils.showAndSelectIndex(culturasInstaladas, "Selecione a cultura:");
            verificarIndex(index);
            nomeComum = culturasInstaladas.get(index).getNomeComum();

            variedade = culturasInstaladas.get(index).getVariedade();

            List<String> unitTypes = controller.getUnitTypes();
            index = Utils.showAndSelectIndex(unitTypes, "Indique o tipo de unidade:");
            verificarIndex(index);
            designacaoUnidade = unitTypes.get(index);

            dataOperacao = Utils.readDateFromConsole("Indique a data da operação (formato: dd/mm/yyyy): \n");

            dataInicial = dataOperacao;

            quantidade = Utils.readIntegerFromConsole("Indique a quantidade a aplicar:");

            boolean opStatus = controller.registerAplication(designacaoOperacao, designacaoUnidade, quantidade, dataOperacao, nomeFator, nomeParcela, dataInicial, nomeComum, variedade);

            if (opStatus) {
                System.out.println("\nAplicação de fator de produção registada com sucesso.\n");
            } else {
                System.out.println("\nERRO: Falha ao registar a operação de monda.\n");
            }

        } catch (SQLException e) {
            System.out.println(e.getMessage().split("\n")[0].substring(11) + "\n");
        } catch (RuntimeException e) {
            System.out.println(e.getMessage());
        }
    }

    private void verificarIndex(int index) {
        if (index == -1) {
            throw new RuntimeException("\nA cancelar registo da operação ...\n");
        }
    }
}
