package project.ui.console.operacao;

import project.controller.operacao.RegistarOperacaoSemeaduraController;
import project.ui.console.utils.Utils;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class RegistarOperacaoSemeaduraUI implements Runnable {

    private RegistarOperacaoSemeaduraController controller;

    private Date dataOperacao;
    private String nomeParcela;
    private String tipoUnidadeCultura;
    private Double quantidadeOperacao;
    private Double quantidadeCultura;
    private String nomeComum;
    private String variedade;
    private String permanencia;

    public RegistarOperacaoSemeaduraUI() {
        controller = new RegistarOperacaoSemeaduraController();
    }

    @Override
    public void run() {
        try {
            int index;
            System.out.println("-------------------------------------------");
            System.out.println("| Registar uma nova Operação de Semeadura |");
            System.out.println("-------------------------------------------");

            List<String> fields = controller.getFieldsNames();
            index = Utils.showAndSelectIndex(fields, "Selecione a parcela:");
            verificarIndex(index);
            nomeParcela = fields.get(index);

            List<String> cultures = controller.getCultures();
            index = Utils.showAndSelectIndex(cultures, "Selecione a cultura:");
            verificarIndex(index);
            String cultura = cultures.get(index);
            processCultureChoice(cultura);

            if (permanencia.equals("Permanente")) {
                tipoUnidadeCultura = "un";
                System.out.println("\nCultura é do tipo Permanente - unidade por defeito 'un'.");
            } else {
                List<String> unitTypes = new ArrayList<>();
                unitTypes.add("ha");
                unitTypes.add("m2");
                index = Utils.showAndSelectIndex(unitTypes, "Indique o tipo de unidade:");
                tipoUnidadeCultura = unitTypes.get(index);
            }

            if (permanencia.equals("Permanente")) {
                quantidadeCultura = Utils.readDoubleFromConsole("Indique as unidades de plantas que vai semear: ");
            } else {
                quantidadeCultura = Utils.readDoubleFromConsole("Indique a extensão da área a semear: ");
            }

            quantidadeOperacao = Utils.readDoubleFromConsole("Indique a quantidade de sementes a utilizar (kg): ");

            dataOperacao = Utils.readDateFromConsole("Indique a data da operação (formato: dd/mm/yyyy): ");

            boolean opStatus = controller.registerOperation(nomeParcela, nomeComum, quantidadeCultura, variedade, dataOperacao, tipoUnidadeCultura, quantidadeOperacao);
            if (opStatus) {
                System.out.println("\nOperação de semeadura registada com sucesso.\n");
            } else {
                System.out.println("\nFalha em registar a operação de semeadura.\n");
            }
        } catch (SQLException e) {
            System.out.println("\nFalha em registar a operação de semeadura.\n" + e.getMessage().split("\n")[0].substring(11) + "\n");
        } catch (RuntimeException e){
            System.out.println(e.getMessage());
        }
    }

    private void processCultureChoice(String cultura) {
        String[] culturaInfo = cultura.split("\\|");
        permanencia = culturaInfo[1].trim();

        String[] plantaInfo = culturaInfo[0].split(" ");
        for (String info : plantaInfo) {
            boolean justUpper = true;
            for (char c : info.toCharArray()) {
                if (Character.isLowerCase(c)) {
                    justUpper = false;
                    break;
                }
            }
            if (!justUpper) {
                nomeComum = concatenateWithSpace(nomeComum, info);
            } else {
                variedade = concatenateWithSpace(variedade, info);
            }
        }
        variedade = variedade.trim();
        nomeComum = nomeComum.trim();
    }

    private String concatenateWithSpace(String original, String info) {
        if (original == null) {
            return info;
        } else {
            return original + " " + info;
        }
    }

    private void verificarIndex(int index) {
        if (index == -1) {
            throw new RuntimeException("\nA cancelar registo da operação ...\n");
        }
    }

}
