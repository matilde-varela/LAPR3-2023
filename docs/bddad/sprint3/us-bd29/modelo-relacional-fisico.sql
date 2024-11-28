CREATE TABLE AplicacaoFatorProducao (
nomeComercial varchar2(50) CONSTRAINT nnAplicacaoFatorProducaoNomeComercial NOT NULL,
idOperacao    number(5) CONSTRAINT nnAplicacaoFatorProducaoIdOperacao NOT NULL,
CONSTRAINT pkAplicacaoFatorProducaoIdOperacaoNomeComercial PRIMARY KEY (nomeComercial,
                                                                        idOperacao));

CREATE TABLE CalendarioAcaoAgricola (
variedade                  varchar2(50) CONSTRAINT nnCalendarioAcaoAgricolaVariedade NOT NULL,
designacaoTipoAcaoAgricola varchar2(50) CONSTRAINT nnCalendarioAcaoAgricolaDesignacaoTipoAcaoAgricola NOT NULL,
intervaloTempo             varchar2(70) CONSTRAINT nnCalendarioAcaoAgricolaIntervaloTempo NOT NULL,
nomeComum                  varchar2(50) CONSTRAINT nnCalendarioAcaoAgricolaNomeComum NOT NULL,
CONSTRAINT pkCalendarioAcaoAgricolaPKComponente PRIMARY KEY (variedade, nomeComum, designacaoTipoAcaoAgricola, intervaloTempo));

CREATE TABLE CatalogoReceitaFertirrega (
idReceitaFertirrega number(5) CONSTRAINT nnCatalogoReceitaFertirregaIdReceitaFertirrega NOT NULL,
nomeComercial       varchar2(50) CONSTRAINT nnCatalogoReceitaFertirregaNomeComercial NOT NULL,
designacaoUnidade   varchar2(5) CONSTRAINT nnCatalogoReceitaFertirregaDesignacaoUnidade NOT NULL,
quantidade          number(10, 5) CONSTRAINT nnCatalogoReceitaFertirregaQuantidade NOT NULL,
CONSTRAINT pkCatalogoReceitaFertirrega PRIMARY KEY (idReceitaFertirrega, nomeComercial));

CREATE TABLE Classificacao (
classificacao varchar2(50) CONSTRAINT nnClassificacaoClassificacao  NOT NULL,
CONSTRAINT pkClassificacaoClassificacao  PRIMARY KEY (classificacao));

CREATE TABLE ComponenteQuimico (
formulaQuimica varchar2(50) CONSTRAINT nnComponenteQuimicoFormulaQuimica  NOT NULL,
CONSTRAINT pkComponenteQuimicoFormulaQuimica PRIMARY KEY (formulaQuimica));

CREATE TABLE ConstituicaoQuimica (
formulaQuimica    varchar2(50) CONSTRAINT nnConstituicaoQuimicaFormulaQuimica NOT NULL,
nomeComercial     varchar2(50) CONSTRAINT nnConstituicaoQuimicaNomeComercial NOT NULL,
designacaoUnidade varchar2(5) CONSTRAINT nnConstituicaoQuimicaDesignacaoUnidade NOT NULL,
quantidade        number(11, 5) CONSTRAINT nnConstituicaoQuimicaQuantidade NOT NULL,
CONSTRAINT pkConstituicaoQuimicaFormulaQuimicaNomeComercial PRIMARY KEY (formulaQuimica,
                                              nomeComercial),
CONSTRAINT ckConstituicaoQuimicaQuantidadePercentagem CHECK (quantidade BETWEEN 0 AND 100));

---------------------------------------------------------------------------------------------------------------------
CREATE TABLE CulturaInstalada (
dataInicial                date CONSTRAINT nnCulturaInstaladaDataInicial NOT NULL,
nomeParcela                varchar2(50) CONSTRAINT nnCulturaInstaladaNomeParcela NOT NULL,
variedade                  varchar2(50) CONSTRAINT nnCulturaInstaladaVariedade NOT NULL,
nomeComum                  varchar2(50) CONSTRAINT nnCulturaInstaladaNomeComum NOT NULL,
designacaoUnidade          varchar2(5) CONSTRAINT nnCulturaInstaladaDesignacaoUnidade NOT NULL,
quantidade                 number(11, 2) CONSTRAINT nnCulturaInstaladaQuantidade NOT NULL,
dataFinal                  date,
CONSTRAINT pkCulturaInstaladaParcelaVariedadeNComumDataInicio PRIMARY KEY (nomeParcela, variedade, nomeComum, dataInicial),
CONSTRAINT ckCulturaInstaladaData CHECK (dataFinal >= dataInicial));

CREATE TABLE PlanoRega (
dataInicial date CONSTRAINT nnPlanoRegaDataInicial NOT NULL,
nomeParcela varchar2(50) CONSTRAINT nnPlanoRegaNomeParcela NOT NULL,
variedade   varchar2(50) CONSTRAINT nnPlanoRegaVariedade NOT NULL,
nomeComum   varchar2(50) CONSTRAINT nnPlanoRegaNomeComum NOT NULL,
designacaoSetor     varchar2(10) CONSTRAINT nnPlanoRegaDesignacaoSetor NOT NULL,
dataInicio  date CONSTRAINT nnPlanoRegaDataInicio NOT NULL,
dataFim     date,
CONSTRAINT pkPlanoRegaParcelaVariedadeNComumDataInicioDesigSetor PRIMARY KEY (dataInicial, nomeParcela, variedade, nomeComum, designacaoSetor),
CONSTRAINT ckPlanoRegaData CHECK (dataFim >= dataInicial));

CREATE TABLE CulturaInstaladaEstadoFenologico (
nomeParcela                varchar2(50) NOT NULL,
variedade                  varchar2(50) NOT NULL,
nomeComum                  varchar2(50) NOT NULL,
dataInicial                date NOT NULL,
designacaoEstadoFenologico varchar2(100) NOT NULL,
CONSTRAINT pkCulturaInstaladaEstadoFenologicoParcVarNComumDataInicioDesigEstado PRIMARY KEY (nomeParcela,variedade,nomeComum,dataInicial,designacaoEstadoFenologico));
---------------------------------------------------------------------------------------------------------------------

CREATE TABLE DataAcaoAgricola (
intervaloTempo             varchar2(70) CONSTRAINT nnDataAcaoAgricolaIntervaloTempo NOT NULL,
designacaoTipoAcaoAgricola varchar2(50) CONSTRAINT nnDataAcaoAgricolaDesignacaoTipoAcaoAgricola NOT NULL,
CONSTRAINT pkDataAcaoAgricolaDesignacaoTipoAcaoAgricolaIntervaloTempo PRIMARY KEY (designacaoTipoAcaoAgricola,
                                                     intervaloTempo));

CREATE TABLE Edificio (
nomeEdificio           varchar2(50) CONSTRAINT nnEdificioNomeEdificio NOT NULL,
designacaoTipoEdificio varchar2(50) CONSTRAINT nnEdificioDesignacaoTipoEdificio NOT NULL,
designacaoUnidade      varchar2(5),
dimensao               number(10) CONSTRAINT nnEdificioDimensao NOT NULL,
CONSTRAINT pkEdificioNomeEdificio PRIMARY KEY (nomeEdificio));

---------------------------------------------------------------------------------------------------------------------
CREATE TABLE EstadoFenologico (
designacaoEstadoFenologico varchar2(100) CONSTRAINT nnEstadoFenologicoDesignacaoEstadoFenologico NOT NULL,
CONSTRAINT pkEstadoFenologicoDesignacaoEstadoFenologico PRIMARY KEY (designacaoEstadoFenologico));

---------------------------------------------------------------------------------------------------------------------

CREATE TABLE EstadoOperacao (
idEstadoOperacao         number(1) CONSTRAINT nnEstadoOperacaoIdEstadoOperacao NOT NULL,
designacaoEstadoOperacao varchar2(50) CONSTRAINT nnEstadoOperacaoDesignacaoEstadoOperacao NOT NULL,
CONSTRAINT pkEstadoOperacaoIdEstadoOperacao PRIMARY KEY (idEstadoOperacao));


CREATE TABLE FatorProducao (
nomeComercial   varchar2(50) CONSTRAINT nnFatorProducaoNomeComercial NOT NULL,
idStock         number(5) CONSTRAINT nnFatorProducaoIdStock NOT NULL,
classificacao   varchar2(50) CONSTRAINT nnFatorProducaoClassificacao NOT NULL,
estadoMateria   varchar2(50) CONSTRAINT nnFatorProducaoEstadoMateria NOT NULL,
metodoAplicacao varchar2(50) CONSTRAINT nnFatorProducaoMetodoAplicacao NOT NULL,
fabricante      varchar2(50) CONSTRAINT nnFatorProducaoFabricante NOT NULL,
pH              number(5, 1),
CONSTRAINT pkFatorProducaoNomeComercial PRIMARY KEY (nomeComercial),
CONSTRAINT ckFatorProducaopH CHECK (ph BETWEEN 0.0 AND 14.0));

CREATE TABLE Formulacao (
estadoMateria varchar2(50) CONSTRAINT nnFormulacaoEstadoMateria NOT NULL,
CONSTRAINT pkFormulacaoEstadoMateria PRIMARY KEY (estadoMateria));

---------------------------------------------------------------------------------------------------------------------
CREATE TABLE Log (
idRegistoLog               date CONSTRAINT nnLogIdRegistoLog NOT NULL,
idOperacao                 number(5) CONSTRAINT nnLogIdOperacao NOT NULL,
designacaoOperacaoAgricola varchar2(50) CONSTRAINT nnLogDesignacaoOperacaoAgricola NOT NULL,
designacaoUnidade          varchar2(5) CONSTRAINT nnLogDesignacaoUnidade NOT NULL,
idEstadoOperacao           number(1) CONSTRAINT nnLogIdEstadoOperacao NOT NULL,
quantidade                 number(10, 1) CONSTRAINT nnLogQuantidade NOT NULL,
dataOperacao               date CONSTRAINT nnLogDataOperacao NOT NULL,
dadosAdicionais            varchar2(255),
CONSTRAINT pkLogIdRegistoLog PRIMARY KEY (idRegistoLog));
---------------------------------------------------------------------------------------------------------------------

CREATE TABLE MetodoAplicacao (
metodoAplicacao varchar2(50) CONSTRAINT nnMetodoAplicacaoMetodoAplicacao  NOT NULL,
CONSTRAINT pkMetodoAplicacaoMetodoAplicacao PRIMARY KEY (metodoAplicacao));
---------------------------------------------------------------------------------------------------------------------
CREATE TABLE Operacao (
idOperacao                 number(5) CONSTRAINT nnOperacaoIdOperacao NOT NULL,
designacaoOperacaoAgricola varchar2(50) CONSTRAINT nnOperacaoDesignacaoOperacaoAgricola NOT NULL,
designacaoUnidade          varchar2(5) CONSTRAINT nnOperacaoDesignacaoUnidade NOT NULL,
idEstadoOperacao           number(1) CONSTRAINT nnOperacaoIdEstadoOperacao NOT NULL,
quantidade                 number(10, 1) CONSTRAINT nnOperacaoQuantidade NOT NULL,
dataOperacao               date CONSTRAINT nnOperacaoDataOperacao NOT NULL,
instanteRegistoOperacao    timestamp(0) with local time zone DEFAULT CURRENT_TIMESTAMP CONSTRAINT nnOperacaoInstanteRegistoOperacao  NOT NULL,
CONSTRAINT pkOperacaoIdOperacao PRIMARY KEY (idOperacao));
---------------------------------------------------------------------------------------------------------------------

CREATE TABLE OperacaoCultura (
idOperacao  number(5) CONSTRAINT nnOperacaoCulturaIdOperacao NOT NULL,
nomeParcela varchar2(50) CONSTRAINT nnOperacaoCulturaNomeParcela NOT NULL,
variedade   varchar2(50) CONSTRAINT nnOperacaoCulturaVariedade  NOT NULL,
nomeComum   varchar2(50) CONSTRAINT nnOperacaoCulturaNomeComum NOT NULL,
dataInicial date CONSTRAINT nnOperacaoCulturaDataInicial NOT NULL,
CONSTRAINT pkOperacaoCulturaIdOperacao PRIMARY KEY (idOperacao));

CREATE TABLE OperacaoParcela (
idOperacao  number(5) CONSTRAINT nnOperacaoParcelaIdOperacao NOT NULL,
nomeParcela varchar2(50) CONSTRAINT nnOperacaoParcelaNomeParcela NOT NULL,
CONSTRAINT pkOperacaoParcelaIdOperacao PRIMARY KEY (idOperacao));

CREATE TABLE Parcela (
nomeParcela       varchar2(50) CONSTRAINT nnParcelaNomeParcela NOT NULL,
designacaoUnidade varchar2(5) CONSTRAINT nnParcelaDesignacaoUnidade NOT NULL,
area              number(10, 1) CONSTRAINT nnParcelaArea NOT NULL,
CONSTRAINT pkParcelaNomeParcela PRIMARY KEY (nomeParcela));

CREATE TABLE Planta (
variedade                 varchar2(50) CONSTRAINT nnPlantaVariedade NOT NULL,
nomeComum                 varchar2(50) CONSTRAINT nnPlantaNomeComum NOT NULL,
especie                   varchar2(50) CONSTRAINT nnPlantaEspecie NOT NULL,
CONSTRAINT pkPlantaVariedadeNomeComum PRIMARY KEY (variedade,
                                               nomeComum));

CREATE TABLE PlantacaoPermanente (
idOperacao          number(5) CONSTRAINT nnPlantacaoPermanenteIdOperacao NOT NULL,
distanciaEntreFilas number(10) CONSTRAINT nnPlantacaoPermanenteDistanciaEntreFilas NOT NULL,
compasso number(10) CONSTRAINT nnPlantacaoPermanenteCompasso NOT NULL,
CONSTRAINT pkPlantacaoPermanenteIdOperacao PRIMARY KEY (idOperacao));

CREATE TABLE PlantaPermanencia (
nomeComum                 varchar2(50) CONSTRAINT nnPlantaPermanenciaNomeComum NOT NULL,
designacaoTipoPermanencia varchar2(15) CONSTRAINT nnPlantaPermanenciaDesignacaoTipoPermanencia NOT NULL,
CONSTRAINT pkPlantaPermanenciaNomeComum PRIMARY KEY (nomeComum));

CREATE TABLE Producao (
nomeProduto varchar2(50) CONSTRAINT nnProducaoNomeProduto NOT NULL,
variedade   varchar2(50) CONSTRAINT nnProducaoVariedade NOT NULL,
nomeComum   varchar2(50) CONSTRAINT nnProducaoNomeComum NOT NULL,
CONSTRAINT pkProducaoNomeProdutoVariedadeNomeComum PRIMARY KEY (nomeProduto, variedade, nomeComum));

CREATE TABLE Produto (
nomeProduto varchar2(50) CONSTRAINT nnProdutoNomeProduto NOT NULL,
idStock     number(5) CONSTRAINT nnProdutoIdStock NOT NULL,
CONSTRAINT pkProdutoNomeProduto PRIMARY KEY (nomeProduto));

CREATE TABLE ProdutoColhido (
idOperacao        number(5) CONSTRAINT nnProdutoColhidoIdOperacao NOT NULL,
nomeProduto       varchar2(50) CONSTRAINT nnProdutoColhidoNomeProduto NOT NULL,
designacaoUnidade varchar2(5) CONSTRAINT nnProdutoColhidoDesignacaoUnidade NOT NULL,
quantidade        number(10) CONSTRAINT nnProdutoColhidoQuantidade NOT NULL,
CONSTRAINT pkProdutoColhidoIdOperacaoNomeProduto PRIMARY KEY (idOperacao, nomeProduto));

CREATE TABLE ReceitaFertirrega (
idReceitaFertirrega number(5) CONSTRAINT nnReceitaFertirregaIdReceitaFertirrega NOT NULL,
CONSTRAINT pkReceitaFertirregaIdReceitaFertirrega PRIMARY KEY (idReceitaFertirrega));

CREATE TABLE Rega (
idOperacao      number(5) CONSTRAINT nnRegaIdOperacao NOT NULL,
designacaoSetor varchar2(10) CONSTRAINT nnRegaDesignacaoSetor NOT NULL,
CONSTRAINT pkRegaIdOperacao PRIMARY KEY (idOperacao));

CREATE TABLE Setor (
designacaoSetor           varchar2(10) CONSTRAINT nnSetorDesignacaoSetor NOT NULL,
nomeEdificio      varchar2(50) CONSTRAINT nnSetorNomeEdificio NOT NULL,
designacaoUnidade varchar2(5) CONSTRAINT nnSetorDesignacaoUnidade NOT NULL,
caudalMaximo      number(10) CONSTRAINT nnSetorCaudalMaximo NOT NULL,
dataInicio        date CONSTRAINT nnSetorDataInicio NOT NULL,
dataFim           date,
CONSTRAINT pkSetorDesignacaoSetor PRIMARY KEY (designacaoSetor),
CONSTRAINT ckSetorDataVerificacao CHECK (dataFim >= dataInicio));

CREATE TABLE Stock (
idStock           number(5) CONSTRAINT nnStockIdStock NOT NULL,
nomeEdificio      varchar2(50) CONSTRAINT nnStockNomeEdificio NOT NULL,
designacaoUnidade varchar2(5) CONSTRAINT nnStockDesignacaoUnidade NOT NULL,
quantidade        number(11) CONSTRAINT nnStockQuantidade NOT NULL,
CONSTRAINT pkStockIdStock PRIMARY KEY (idStock));

CREATE TABLE TipoAcaoAgricola (
designacaoTipoAcaoAgricola varchar2(50) CONSTRAINT nnTipoAcaoAgricolaDesignacaoTipoAcaoAgricola NOT NULL,
CONSTRAINT pkTipoAcaoAgricolaDesignacaoTipoAcaoAgricola PRIMARY KEY (designacaoTipoAcaoAgricola));

CREATE TABLE TipoEdificio (
designacaoTipoEdificio varchar2(50) CONSTRAINT nnTipoEdificioDesignacaoTipoEdificio NOT NULL,
CONSTRAINT pkTipoEdificioDesignacaoTipoEdificio PRIMARY KEY (designacaoTipoEdificio));

CREATE TABLE TipoOperacaoAgricola (
designacaoOperacaoAgricola varchar2(50) CONSTRAINT nnTipoOperacaoAgricolaDesignacaoOperacaoAgricola NOT NULL,
CONSTRAINT pkTipoOperacaoAgricolaDesignacaoOperacaoAgricola PRIMARY KEY (designacaoOperacaoAgricola));

CREATE TABLE TipoPermanencia (
designacaoTipoPermanencia varchar2(15) CONSTRAINT nnTipoPermanenciadesignacao NOT NULL,
CONSTRAINT pkTipoPermanenciadesignacao PRIMARY KEY (designacaoTipoPermanencia));

CREATE TABLE TipoUnidade (
designacaoUnidade varchar2(5) CONSTRAINT nnTipoUnidadeDesignacaoUnidade NOT NULL,
CONSTRAINT pkTipoUnidadeDesignacaoUnidade PRIMARY KEY (designacaoUnidade));


ALTER TABLE Producao ADD CONSTRAINT FKProducaoNomeProduto FOREIGN KEY (nomeProduto) REFERENCES Produto (nomeProduto);
ALTER TABLE Stock ADD CONSTRAINT FKStockNomeEdificio FOREIGN KEY (nomeEdificio) REFERENCES Edificio (nomeEdificio);
ALTER TABLE FatorProducao ADD CONSTRAINT FKFatorProducaoMetodoAplicacao FOREIGN KEY (metodoAplicacao) REFERENCES MetodoAplicacao (metodoAplicacao);
ALTER TABLE FatorProducao ADD CONSTRAINT FKFatorProducaoClassificacao FOREIGN KEY (classificacao) REFERENCES Classificacao (classificacao);
ALTER TABLE FatorProducao ADD CONSTRAINT FKFatorProducaoEstadoMateria FOREIGN KEY (estadoMateria) REFERENCES Formulacao (estadoMateria);
ALTER TABLE CatalogoReceitaFertirrega ADD CONSTRAINT FKCatalogoReceitaFertirregaDesignacaoUnidade FOREIGN KEY (designacaoUnidade) REFERENCES TipoUnidade (designacaoUnidade);
ALTER TABLE AplicacaoFatorProducao ADD CONSTRAINT FKAplicacaoFatorProducaoNomeComercial FOREIGN KEY (nomeComercial) REFERENCES FatorProducao (nomeComercial);
ALTER TABLE Edificio ADD CONSTRAINT FKEdificioDesignacaoTipoEdificio FOREIGN KEY (designacaoTipoEdificio) REFERENCES TipoEdificio (designacaoTipoEdificio);
ALTER TABLE FatorProducao ADD CONSTRAINT FKFatorProducaoIdStock FOREIGN KEY (idStock) REFERENCES Stock (idStock);
ALTER TABLE Parcela ADD CONSTRAINT FKParcelaDesignacaoUnidade FOREIGN KEY (designacaoUnidade) REFERENCES TipoUnidade (designacaoUnidade);
ALTER TABLE Stock ADD CONSTRAINT FKStockDesignacaoUnidade FOREIGN KEY (designacaoUnidade) REFERENCES TipoUnidade (designacaoUnidade);
ALTER TABLE Edificio ADD CONSTRAINT FKEdificioDesignacaoUnidade FOREIGN KEY (designacaoUnidade) REFERENCES TipoUnidade (designacaoUnidade);
ALTER TABLE ConstituicaoQuimica ADD CONSTRAINT FKConstituicaoQuimicaFormulaQuimica FOREIGN KEY (formulaQuimica) REFERENCES ComponenteQuimico (formulaQuimica);
ALTER TABLE ConstituicaoQuimica ADD CONSTRAINT FKConstituicaoQuimicaDesignacaoUnidade FOREIGN KEY (designacaoUnidade) REFERENCES TipoUnidade (designacaoUnidade);
ALTER TABLE Produto ADD CONSTRAINT FKProdutoIdStock FOREIGN KEY (idStock) REFERENCES Stock (idStock);
ALTER TABLE OperacaoParcela ADD CONSTRAINT FKOperacaoParcelaNomeParcela FOREIGN KEY (nomeParcela) REFERENCES Parcela (nomeParcela);
ALTER TABLE ConstituicaoQuimica ADD CONSTRAINT FKConstituicaoQuimicaNomeComercial FOREIGN KEY (nomeComercial) REFERENCES FatorProducao (nomeComercial);
ALTER TABLE DataAcaoAgricola ADD CONSTRAINT FKDataAcaoAgricolaDesignacaoTipoAcaoAgricola FOREIGN KEY (designacaoTipoAcaoAgricola) REFERENCES TipoAcaoAgricola (designacaoTipoAcaoAgricola);
ALTER TABLE CalendarioAcaoAgricola ADD CONSTRAINT FKCalendarioAcaoAgricolaVariedadeNomeComum FOREIGN KEY (variedade, nomeComum) REFERENCES Planta (variedade, nomeComum);
ALTER TABLE CalendarioAcaoAgricola ADD CONSTRAINT FKCalendarioAcaoAgricolaIntervaloTempoDesignacaoTipoAcaoAgricola FOREIGN KEY (intervaloTempo, designacaoTipoAcaoAgricola) REFERENCES DataAcaoAgricola (intervaloTempo, designacaoTipoAcaoAgricola);
ALTER TABLE Setor ADD CONSTRAINT FKSetorNomeEdificio FOREIGN KEY (nomeEdificio) REFERENCES Edificio (nomeEdificio);
ALTER TABLE Rega ADD CONSTRAINT FKRegaDesignacaoSetor FOREIGN KEY (designacaoSetor) REFERENCES Setor (designacaoSetor);
ALTER TABLE Producao ADD CONSTRAINT FKProducaoVariedadeNomeComum FOREIGN KEY (variedade, nomeComum) REFERENCES Planta (variedade, nomeComum);
ALTER TABLE Setor ADD CONSTRAINT FKSetorDesignacaoUnidade FOREIGN KEY (designacaoUnidade) REFERENCES TipoUnidade (designacaoUnidade);
ALTER TABLE PlantaPermanencia ADD CONSTRAINT FKPlantaPermanenciaDesignacaoTipoPermanencia FOREIGN KEY (designacaoTipoPermanencia) REFERENCES TipoPermanencia (designacaoTipoPermanencia);
ALTER TABLE AplicacaoFatorProducao ADD CONSTRAINT FKAplicacaoFatorProducaoIdOperacao FOREIGN KEY (idOperacao) REFERENCES Operacao (idOperacao);
ALTER TABLE OperacaoCultura ADD CONSTRAINT FKOperacaoCulturaIdOperacao FOREIGN KEY (idOperacao) REFERENCES Operacao (idOperacao);
ALTER TABLE OperacaoParcela ADD CONSTRAINT FKOperacaoParcelaIdOperacao FOREIGN KEY (idOperacao) REFERENCES Operacao (idOperacao);
ALTER TABLE Rega ADD CONSTRAINT FKRegaIdOperacao FOREIGN KEY (idOperacao) REFERENCES Operacao (idOperacao);
ALTER TABLE Operacao ADD CONSTRAINT FKOperacaoDesignacaoOperacaoAgricola FOREIGN KEY (designacaoOperacaoAgricola) REFERENCES TipoOperacaoAgricola (designacaoOperacaoAgricola);
ALTER TABLE Operacao ADD CONSTRAINT FKOperacaoDesignacaoUnidade FOREIGN KEY (designacaoUnidade) REFERENCES TipoUnidade (designacaoUnidade);
ALTER TABLE Operacao ADD CONSTRAINT FKOperacaoIdEstadoOperacao FOREIGN KEY (idEstadoOperacao) REFERENCES EstadoOperacao (idEstadoOperacao);
ALTER TABLE Planta ADD CONSTRAINT FKPlantaNomeComum FOREIGN KEY (nomeComum) REFERENCES PlantaPermanencia (nomeComum);
ALTER TABLE CulturaInstalada ADD CONSTRAINT FKCulturaInstaladaDesignacaoUnidade FOREIGN KEY (designacaoUnidade) REFERENCES TipoUnidade (designacaoUnidade);
ALTER TABLE CulturaInstalada ADD CONSTRAINT FKCulturaInstaladaNomeParcela FOREIGN KEY (nomeParcela) REFERENCES Parcela (nomeParcela);
ALTER TABLE CulturaInstalada ADD CONSTRAINT FKCulturaInstaladaVariedadeNomeComum FOREIGN KEY (variedade, nomeComum) REFERENCES Planta (variedade, nomeComum);
ALTER TABLE CatalogoReceitaFertirrega ADD CONSTRAINT FKCatalogoReceitaFertirregaNomeComercial FOREIGN KEY (nomeComercial) REFERENCES FatorProducao (nomeComercial);
ALTER TABLE CatalogoReceitaFertirrega ADD CONSTRAINT FKCatalogoReceitaFertirregaIdReceitaFertirrega FOREIGN KEY (idReceitaFertirrega) REFERENCES ReceitaFertirrega (idReceitaFertirrega);
ALTER TABLE OperacaoCultura ADD CONSTRAINT FKOperacaoCulturaNomeParcelaVariedadeNomeComumDataInicial FOREIGN KEY (nomeParcela, variedade, nomeComum, dataInicial) REFERENCES CulturaInstalada (nomeParcela, variedade, nomeComum, dataInicial);
ALTER TABLE Log ADD CONSTRAINT FKRegistosLogIdOperacao FOREIGN KEY (idOperacao) REFERENCES Operacao (idOperacao);
ALTER TABLE ProdutoColhido ADD CONSTRAINT FKProdutoColhidoNomeProduto FOREIGN KEY (nomeProduto) REFERENCES Produto (nomeProduto);
ALTER TABLE ProdutoColhido ADD CONSTRAINT FKProdutoColhidoDesignacaoUnidade FOREIGN KEY (designacaoUnidade) REFERENCES TipoUnidade (designacaoUnidade);
ALTER TABLE ProdutoColhido ADD CONSTRAINT FKProdutoColhidoIdOperacao FOREIGN KEY (idOperacao) REFERENCES Operacao (idOperacao);
ALTER TABLE PlantacaoPermanente ADD CONSTRAINT FKPlantacaoPermanenteIdOperacao FOREIGN KEY (idOperacao) REFERENCES Operacao (idOperacao);
ALTER TABLE CulturaInstaladaEstadoFenologico ADD CONSTRAINT FKCulturaInstaladaDesignacaoEstadoFenologico FOREIGN KEY (designacaoEstadoFenologico) REFERENCES EstadoFenologico (designacaoEstadoFenologico);
ALTER TABLE PlanoRega ADD CONSTRAINT FKPlanoRegaNomeParcelaVariedadeNomeComumDataInicial FOREIGN KEY (dataInicial, nomeParcela, variedade, nomeComum) REFERENCES CulturaInstalada (dataInicial, nomeParcela, variedade, nomeComum);
ALTER TABLE PlanoRega ADD CONSTRAINT FKPlanoRegaDesignacaoSetor FOREIGN KEY (designacaoSetor) REFERENCES Setor (designacaoSetor);