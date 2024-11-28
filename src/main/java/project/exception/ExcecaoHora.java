package project.exception;

public class ExcecaoHora extends Exception {
    public ExcecaoHora(String s) {
        super(s);
    }

    public static void verificarHora(String hora) throws ExcecaoHora {
        validarFormato(hora);

        String[] partes = hora.split(":");
        int horas = Integer.parseInt(partes[0]);
        int minutos = Integer.parseInt(partes[1]);


        if (horas < 0 || horas > 23) {
            throw new ExcecaoHora("ERRO: Hora fora do intervalo válido (0-23 horas).");
        }
        if (minutos < 0 || minutos > 59) {
            throw new ExcecaoHora("ERRO: Minutos fora do intervalo válido (0-59 minutos).");
        }
    }

    private static void validarFormato(String hora) throws ExcecaoHora {
        if (!hora.matches("\\d{2}:\\d{2}") ) {
            throw new ExcecaoHora("ERRO: Formato de hora inválido. O formato deve ser hh:mm.");
        }
    }
}
