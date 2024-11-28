package project.ui.console.operacao;

import project.controller.operacao.RegistarOperacaoMondaController;
import project.domain.Planta;
import project.ui.console.utils.Utils;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

public class RegistarOperacaoMondaUI implements Runnable {
    private RegistarOperacaoMondaController controller;

    SimpleDateFormat formatter = new SimpleDateFormat("dd-MM-yyyy");
    private Date dataOperacao;
    private String nomeParcela;
    private Planta cultura;
    private String tipoUnidade;
    private Double quantidade;

    public RegistarOperacaoMondaUI() {
        controller = new RegistarOperacaoMondaController();
    }

    @Override
    public void run() {
        try {
            int index;
            System.out.println("-----------------------------------------");
            System.out.println("--Registar operação de monda-------------");
            System.out.println("-----------------------------------------");

            List<String> fields = controller.getFieldsNames();
            index = Utils.showAndSelectIndex(fields, "Selecione a parcela:");
            verificarIndex(index);
            nomeParcela = fields.get(index);

            List<Planta> culturasInstaladas = controller.getCulturesByField(nomeParcela);
            index = Utils.showAndSelectIndex(culturasInstaladas, "Selecione a cultura:");
            verificarIndex(index);
            cultura = culturasInstaladas.get(index);

            quantidade = Utils.readDoubleFromConsole("Indique a quantidade a mondar:");

            dataOperacao = Utils.readDateFromConsole("Indique a data da operação (formato: dd/mm/yyyy): \n");

            boolean opStatus = controller.registerMondaOperation(nomeParcela, cultura, dataOperacao, quantidade);

            if (opStatus) {
                System.out.println("\nOperação de monda registada com sucesso.\n");
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
