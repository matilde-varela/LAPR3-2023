package project.exception;

import java.time.LocalDate;

public class ExcecaoData extends Exception{
    public ExcecaoData(String s) {
        super(s);
    }

    public static void verificarData(String data) throws ExcecaoData {
        validarFormato(data);

        String[] partes = data.split("/");
        int dia = Integer.parseInt(partes[0]);
        int mes = Integer.parseInt(partes[1]);
        int ano = Integer.parseInt(partes[2]);

        if (ano < 2010) {
            throw new ExcecaoData("ERRO: Ano inválido.");
        }
        if ( mes < 1 || mes > 12) {
            throw new ExcecaoData("ERRO: Mês inválido.");
        }
        if (dia > diasNoMes(mes, ano)) {
            throw new ExcecaoData("ERRO: Dia inválido.");
        }
    }

    private static void validarFormato(String data) throws ExcecaoData {
        if (!data.matches("\\d{2}/\\d{2}/\\d{4}") ) {
            throw new ExcecaoData("ERRO: Formato de data inválido. O formato deve ser dd/mm/aaaa.");
        }
    }
    private static int diasNoMes(int mes, int ano) {
        int[] diasPorMes = {0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};

        if (mes == 2 && (ano % 4 == 0 && (ano % 100 != 0 || ano % 400 == 0))) {
            return 29;
        }
        return diasPorMes[mes];
    }

    public static void validarDataDeOperacao(String data) throws ExcecaoData {
        String[] partes = data.split("/");
        int dia = Integer.parseInt(partes[0]);
        int mes = Integer.parseInt(partes[1]);
        int ano = Integer.parseInt(partes[2]);

        LocalDate d = LocalDate.of(ano,mes,dia);
        if(d.isAfter(LocalDate.now())){
            throw new ExcecaoData("ERRO: Não é possível registar operações no futuro.");
        }

    }
}
