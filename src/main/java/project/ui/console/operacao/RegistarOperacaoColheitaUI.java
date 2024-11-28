package project.ui.console.operacao;

import project.controller.operacao.RegistarOperacaoColheitaController;
import project.domain.Planta;
import project.ui.console.utils.Utils;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.*;

public class RegistarOperacaoColheitaUI implements Runnable {
    private RegistarOperacaoColheitaController controller;
    private String designacaoUnidade;
    private Double quantidade;
    private Date dataOperacao;
    private String nomeParcela;
    private Planta cultura;
    private String nomeProduto;
    private Date dataFim;
    private String tipoPermanencia;
    private int opcaoCultura;
    private boolean statusOperacao;

    SimpleDateFormat formatter = new SimpleDateFormat("dd-MM-yyyy");

    public RegistarOperacaoColheitaUI(){
        controller = new RegistarOperacaoColheitaController();
    }

    @Override
    public void run() {
        try {
            int index;
            System.out.println("-----------------------------------------");
            System.out.println("Registar uma nova Operação de Colheita");
            System.out.println("-----------------------------------------");

            List<String> fields = controller.getFieldsNames();
            index = Utils.showAndSelectIndex(fields, "Selecione a parcela:");
            verificarIndex(index);
            nomeParcela = fields.get(index);

            List<Planta> culturasInstaladas = controller.getCulturesByField(nomeParcela);
            index = Utils.showAndSelectIndex(culturasInstaladas, "Selecione a cultura:");
            verificarIndex(index);
            cultura = culturasInstaladas.get(index);

            List<String> produtos = controller.getProductsByField(cultura.getVariedade(), cultura.getNomeComum());
            index = Utils.showAndSelectIndex(produtos, "Selecione o produto:");
            verificarIndex(index);
            nomeProduto = produtos.get(index);

            dataOperacao = Utils.readDateFromConsole("Indique a data da operação (formato: dd/mm/yyyy): \n");

            quantidade = Utils.readDoubleFromConsole("Quantidade: ");

            List<String> unitTypes = controller.getUnitTypes();
            index = Utils.showAndSelectIndex(unitTypes, "Selecione o tipo de unidade desejado:");
            designacaoUnidade = unitTypes.get(index);

            List<String> permanencias = controller.getPermanencyType(cultura.getVariedade(), cultura.getNomeComum());
            tipoPermanencia = permanencias.get(0);

            if (tipoPermanencia.equals("Permanente")){
                dataFim = null;
            } else {
                opcaoCultura = Utils.selectYesOrNoOption();

                if (opcaoCultura == 1){
                    dataFim = dataOperacao;
                } else {
                    dataFim = null;
                }
            }

            statusOperacao = controller.registerOperation(nomeParcela, cultura, nomeProduto, dataOperacao, designacaoUnidade, quantidade, dataFim);

            if (statusOperacao) {
                System.out.println("\nOperação de colheita registada com sucesso.");
            } else {
                System.out.println("\nERRO: Falha ao registar a operação de colheita.\n");
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
