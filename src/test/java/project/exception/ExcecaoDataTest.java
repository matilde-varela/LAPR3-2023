package project.exception;

import org.junit.Test;

import static org.junit.Assert.*;

public class ExcecaoDataTest {

    @Test(expected = ExcecaoData.class)
    public void verificarDataComMesMaior() throws ExcecaoData {
        String data = "10/14/2023";
        ExcecaoData.verificarData(data);
    }

    @Test(expected = ExcecaoData.class)
    public void verificarDataComDiaMaior() throws ExcecaoData {
        String data = "33/12/2023";
        ExcecaoData.verificarData(data);
    }

    @Test(expected = ExcecaoData.class)
    public void verificarDataComMesMenor() throws ExcecaoData {
        String data = "10/0/2023";
        ExcecaoData.verificarData(data);
    }

    @Test(expected = ExcecaoData.class)
    public void verificarDataComDiaMenor() throws ExcecaoData {
        String data = "0/12/2023";
        ExcecaoData.verificarData(data);
    }

    @Test(expected = ExcecaoData.class)
    public void verificarDataComAnoMenor() throws ExcecaoData {
        String data = "10/12/0";
        ExcecaoData.verificarData(data);
    }

    @Test(expected = ExcecaoData.class)
    public void verificarDataComLetraEmDia() throws ExcecaoData {
        String data = "bb/12/2023";
        ExcecaoData.verificarData(data);
    }

    @Test(expected = ExcecaoData.class)
    public void verificarDataComLetraEmMes() throws ExcecaoData {
        String data = "10/bb/2023";
        ExcecaoData.verificarData(data);
    }

    @Test(expected = ExcecaoData.class)
    public void verificarDataComLetraEmAno() throws ExcecaoData {
        String data = "10/12/aaaa";
        ExcecaoData.verificarData(data);
    }

    @Test(expected = ExcecaoData.class)
    public void verificarDataComDiaNaoDoMes() throws ExcecaoData {
        String data = "31/02/2023";
        ExcecaoData.verificarData(data);
    }

    @Test
    public void verificarDataCorreta()  {
        String data = "10/02/2023";
        try {
            ExcecaoData.verificarData(data);
        } catch (ExcecaoData e){
            fail(e.getMessage());
        }
    }
}
