package project.domain;


import java.text.SimpleDateFormat;
import java.time.format.DateTimeFormatter;
import java.util.Date;

public class Operacao {

    private final Integer idOperacao;

    private final String designacaoOperacaoAgricola;

    private final String designacaoUnidade;
    private final Double quantidade;
    private final Date dataOperacao;

    public Operacao(Integer idOperacao, String designacaoOperacaoAgricola, String designacaoUnidade, Double quantidade, Date dataOperacao) {
        this.idOperacao = idOperacao;
        this.designacaoOperacaoAgricola = designacaoOperacaoAgricola;
        this.designacaoUnidade = designacaoUnidade;
        this.quantidade = quantidade;
        this.dataOperacao = dataOperacao;
    }


    public Integer getIdOperacao() {
        return idOperacao;
    }

    public String getDesignacaoOperacaoAgricola() {
        return designacaoOperacaoAgricola;
    }

    public String getDesignacaoUnidade() {
        return designacaoUnidade;
    }

    public Double getQuantidade() {
        return quantidade;
    }

    public Date getDataOperacao() {
        return dataOperacao;
    }

    @Override
    public String toString() {
        return String.format("| %4d | %22s | %10s | %10.2f | %7s |", idOperacao, designacaoOperacaoAgricola, dataOperacao.toString(), quantidade, designacaoUnidade);
    }
}
