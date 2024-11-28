package project.domain;


import java.util.Date;

public class OperacaoCultura extends Operacao{

    private String nomeParcela;
    private String nomeComum;
    private String variedade;
    private Date dataInicial;
    private Date dataFinal;

    public OperacaoCultura(Integer idOperacao, String designacaoOperacaoAgricola, String designacaoUnidade, Double quantidade, Date dataOperacao, String nomeParcela, String nomeComum, String variedade, Date dataInicial, Date dataFinal) {
        super(idOperacao, designacaoOperacaoAgricola, designacaoUnidade, quantidade, dataOperacao);
        this.nomeComum = nomeComum;
        this.nomeParcela = nomeParcela;
        this.variedade = variedade;
        this.dataInicial = dataInicial;
        this.dataFinal = dataFinal;
    }

    public OperacaoCultura(Integer idOperacao, String designacaoOperacaoAgricola, String designacaoUnidade, Double quantidade, Date dataOperacao, String nomeParcela, String nomeComum, String variedade, Date dataInicial) {
        super(idOperacao, designacaoOperacaoAgricola, designacaoUnidade, quantidade, dataOperacao);
        this.nomeComum = nomeComum;
        this.nomeParcela = nomeParcela;
        this.variedade = variedade;
        this.dataInicial = dataInicial;
        this.dataFinal = null;
    }

    public String getNomeParcela() {
        return nomeParcela;
    }

    public String getNomeComum() {
        return nomeComum;
    }

    public String getVariedade() {
        return variedade;
    }

    public Date getDataInicial() {
        return dataInicial;
    }

    public Date getDataFinal() {
        return dataFinal;
    }

    public void setDataFinal(Date dataFinal) {
        this.dataFinal = dataFinal;
    }

    @Override
    public String toString() {
        StringBuilder stringBuilder = new StringBuilder();
        stringBuilder.append(super.toString());
        stringBuilder.append(String.format(" %20s | %20s | %20s | %12s | %10s |", nomeParcela, nomeComum, variedade, dataInicial.toString(), (dataFinal == null) ? "0000-00-00" : dataFinal.toString()));
        return  stringBuilder.toString() ;
    }


}
