package project.exception;

import org.junit.Test;

import static org.junit.Assert.fail;

public class ExcecaoHoraTest {

    /**
     * Testa o método verificarFormatoHora com letras no campo de horas.
     * Deve lançar uma exceção do tipo ExcecaoHora.
     *
     * @throws ExcecaoHora quando o formato da hora é inválido
     */
    @Test (expected = ExcecaoHora.class)
    public void verificarHoraComLetraEmHoras() throws ExcecaoHora {
        String erro = "aa:00";
        ExcecaoHora.verificarHora(erro);
    }

    /**
     * Testa o método verificarFormatoHora com letras no campo de minutos.
     * Deve lançar uma exceção do tipo ExcecaoHora.
     *
     * @throws ExcecaoHora quando o formato da hora é inválido.
     */
    @Test (expected = ExcecaoHora.class)
    public void verificarHoraComLetraEmMinutos() throws ExcecaoHora {
        String erro = "08:b0";
        ExcecaoHora.verificarHora(erro);
    }

    /**
     * Testa o método verificarFormatoHora com horas maiores que 24.
     * Deve lançar uma exceção do tipo ExcecaoHora.
     *
     * @throws ExcecaoHora quando o formato da hora é inválido.
     */
    @Test (expected = ExcecaoHora.class)
    public void verificarHoraComHorasMaior() throws ExcecaoHora {
        String erro = "25:00";
        ExcecaoHora.verificarHora(erro);
    }

    /**
     * Testa o método verificarFormatoHora com minutos maiores que 59.
     * Deve lançar uma exceção do tipo ExcecaoHora.
     *
     * @throws ExcecaoHora quando o formato da hora é inválido.
     */
    @Test (expected = ExcecaoHora.class)
    public void verificarHoraComMinutosMaior() throws ExcecaoHora {
        String erro = "08:60";
        ExcecaoHora.verificarHora(erro);
    }
    /**
     * Testa o método verificarFormatoHora com horas menores que 0.
     * Deve lançar uma exceção do tipo ExcecaoHora.
     *
     * @throws ExcecaoHora quando o formato da hora é inválido.
     */
    @Test (expected = ExcecaoHora.class)
    public void verificarHoraComHorasMenor() throws ExcecaoHora {
        String erro = "-2:00";
        ExcecaoHora.verificarHora(erro);
    }

    /**
     * Testa o método verificarFormatoHora com minutos menores que 0.
     * Deve lançar uma exceção do tipo ExcecaoHora.
     *
     * @throws ExcecaoHora quando o formato da hora é inválido.
     */
    @Test (expected = ExcecaoHora.class)
    public void verificarHoraComMinutosMenor() throws ExcecaoHora {
        String erro = "08:-2";
        ExcecaoHora.verificarHora(erro);
    }
    /**
     * Testa o método verificarFormatoHora com um formato de hora válido.
     * Não deve lançar uma exceção.
     *
     * @throws ExcecaoHora quando o formato da hora é inválido.
     */
    @Test
    public void verificaHoraCorreta(){
        String erro = "08:00";
        try {
            ExcecaoHora.verificarHora(erro);
        }catch (ExcecaoHora e){
            fail(e.getMessage());
        }
    }
}