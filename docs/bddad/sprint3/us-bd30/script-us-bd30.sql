SET SERVEROUTPUT ON;
--------------------------------------------------------------------------
---FUNÇÃO-----------------------------------------------------------------
CREATE OR REPLACE FUNCTION fncAnularOperacao(
    p_idOp IN Operacao.idOperacao%TYPE
) RETURN BOOLEAN IS
    anulado BOOLEAN;
    invalido EXCEPTION;
    desig TipoOperacaoAgricola.designacaoOperacaoAgricola%TYPE;
BEGIN
    select designacaoOperacaoAgricola
    into desig
    from Operacao
    where idOperacao = p_idOp;

    IF (fncValidoParaAnulacao(p_idOp)) THEN
        IF (desig IN ('Plantação', 'Sementeira', 'Semeadura', 'Incorporação no solo')) THEN
            IF (fncTemOperacaoDependente(p_idOp) = FALSE) THEN
                UPDATE Operacao
                SET idEstadoOperacao = -1
                WHERE idOperacao = p_idOp;
                anulado := TRUE;
            END IF;
        ELSE
            UPDATE Operacao
            SET idEstadoOperacao = -1
            WHERE idOperacao = p_idOp;
            anulado := TRUE;
        END IF;
    END IF;
    RETURN anulado;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20002, 'ERRO: Operação com o id especificado não encontrada.');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001, 'ERRO: Não foi possível anular a operação. Por favor tente novamente.');
END;
/
--------------------------------------------------------------------------
---TESTE------------------------------------------------------------------
--Caso de sucesso

--Inserção dos dados necessários------------------------------------------
DECLARE
    v_idOperacao NUMBER := novoIdOperacao();
    v_desigOp tipoOperacaoAgricola.DESIGNACAOOPERACAOAGRICOLA%TYPE := 'Rega';
    v_qtd NUMBER := 60;
    v_desigUnidade tipoUnidade.DESIGNACAOUNIDADE%TYPE := 'min';
    v_dataOperacao DATE := SYSDATE;
    v_setor Setor.designacaoSetor%TYPE := 11;
BEGIN
    INSERT INTO Operacao (idOperacao, designacaoOperacaoAgricola, designacaoUnidade, idEstadoOperacao, quantidade, dataOperacao) VALUES (v_idOperacao, v_desigOp, v_desigUnidade, 1, v_qtd, v_dataOperacao);
    INSERT INTO Rega (idOperacao, designacaoSetor) VALUES (v_idOperacao, v_setor);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERRO: não inseriu os dados.');
END;
/
--Anulação da operação----------------------------------------------------
DECLARE
    v_idOperacao NUMBER;
    failedTest EXCEPTION;
BEGIN
    select MAX(idOperacao)
    into v_idOperacao
    from Operacao;

    IF (fncAnularOperacao(v_idOperacao)) THEN
        DBMS_OUTPUT.PUT_LINE('TESTE PASSOU');
    ELSE
        RAISE failedTest;
    END IF;
EXCEPTION
    WHEN failedTest THEN
        DBMS_OUTPUT.PUT_LINE('TESTE FALHOU');
END;
/
--Confirmação--------------------------------------------------------------
DECLARE
    v_idOperacao NUMBER;
    v_designacaoOperacaoAgricola VARCHAR(50);
    v_idEstadoOperacao NUMBER;
    v_estadoOperacao VARCHAR(50);
BEGIN
    select idOperacao, designacaoOperacaoAgricola, idEstadoOperacao
    into v_idOperacao, v_designacaoOperacaoAgricola, v_idEstadoOperacao
    from operacao
    where idOperacao = (select MAX(idOperacao) from Operacao);

    select designacaoEstadoOperacao
    into v_estadoOperacao
    from EstadoOperacao
    where idestadooperacao = v_idEstadoOperacao;

    DBMS_OUTPUT.PUT_LINE('ID OPERAÇÃO: ' || v_idOperacao || ' | TIPO DE OPERAÇÃO: ' || v_designacaoOperacaoAgricola || ' | ESTADO DA OPERAÇÃO: ' || v_estadoOperacao);
END;
/
--------------------------------------------------------------------------
---TESTE------------------------------------------------------------------
--Caso de insucesso
DECLARE
    v_idOperacao Operacao.idOperacao%TYPE := novoIdOperacao();

    failedTest EXCEPTION;
BEGIN
    select idOperacao
    into v_idOperacao
    from operacao
    where dataOperacao = TO_DATE('02/10/2023 - 06:00', 'DD/MM/YYYY - HH24:MI');

    IF (fncAnularOperacao(v_idOperacao)) THEN
        RAISE failedTest;
    ELSE
        DBMS_OUTPUT.PUT_LINE('TESTE PASSOU - a anulação da operação não foi realizada.');
    END IF;

EXCEPTION
    WHEN failedTest THEN
        DBMS_OUTPUT.PUT_LINE('TESTE FALHOU');
END;
/
--------------------------------------------------------------------------
--FUNÇÃO------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fncValidoParaAnulacao(
    p_idOp IN Operacao.idOperacao%TYPE
) RETURN BOOLEAN IS
    dataOp Operacao.dataOperacao%TYPE;
BEGIN
    SELECT dataOperacao
    INTO dataOp
    FROM Operacao
    WHERE idOperacao = p_idOp;

    IF SYSDATE - dataOp <= 3 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20002, 'ERRO: Operação não encontrada.');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001, 'ERRO: Não foi possível avaliar a data da operação.');
END;
/
--------------------------------------------------------------------------
--TESTE-------------------------------------------------------------------
DECLARE
    v_test BOOLEAN;
    v_idOperacao Operacao.idOperacao%TYPE := novoIdOperacao();
    v_desigOp tipoOperacaoAgricola.DESIGNACAOOPERACAOAGRICOLA%TYPE := 'Rega';
    v_desigUnidade tipounidade.DESIGNACAOUNIDADE%TYPE := 'min';
    v_qtd NUMBER := 26;
    v_dataOp DATE  := SYSDATE - 2;
    failedTest EXCEPTION;
BEGIN

    INSERT INTO Operacao(idOperacao, designacaoOperacaoAgricola, designacaoUnidade, idEstadoOperacao, quantidade, dataOperacao, instanteRegistoOperacao) VALUES (v_idOperacao, v_desigOp, v_desigUnidade, 1 , v_qtd, v_dataOp,CURRENT_TIMESTAMP);

    v_test :=  fncValidoParaAnulacao(v_idOperacao);

    IF v_test THEN
        DBMS_OUTPUT.PUT_LINE('TESTE PASSOU');
    ELSE
        RAISE failedTest;
    END IF;

EXCEPTION
    WHEN failedTest THEN
        DBMS_OUTPUT.PUT_LINE('TESTE FALHOU');

END;
/
--------------------------------------------------------------------------
--TESTE-------------------------------------------------------------------
DECLARE
    v_test BOOLEAN;
    v_idOperacao Operacao.idOperacao%TYPE := novoIdOperacao();
    v_desigOp tipoOperacaoAgricola.DESIGNACAOOPERACAOAGRICOLA%TYPE := 'Rega';
    v_desigUnidade tipounidade.DESIGNACAOUNIDADE%TYPE := 'min';
    v_qtd NUMBER := 26;
    v_dataOp DATE  := SYSDATE - 4;
    failedTest EXCEPTION;
BEGIN

    INSERT INTO Operacao(idOperacao, designacaoOperacaoAgricola, designacaoUnidade, idEstadoOperacao, quantidade, dataOperacao, instanteRegistoOperacao) VALUES (v_idOperacao, v_desigOp, v_desigUnidade, 1 , v_qtd, v_dataOp,CURRENT_TIMESTAMP);

    v_test :=  fncValidoParaAnulacao(v_idOperacao);

    IF v_test THEN
        RAISE failedTest;
    ELSE
        DBMS_OUTPUT.PUT_LINE('TESTE PASSOU');
    END IF;

EXCEPTION
    WHEN failedTest THEN
        DBMS_OUTPUT.PUT_LINE('TESTE FALHOU');

END;
/
--------------------------------------------------------------------------
--FUNÇÃO------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fncTemOperacaoDependente(
    p_idOp IN Operacao.idOperacao%TYPE
) RETURN BOOLEAN IS
    v_contador NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_contador
    FROM OperacaoCultura oc1
             INNER JOIN OperacaoCultura oc2 ON oc1.dataInicial = oc2.dataInicial
        AND oc1.nomeParcela = oc2.nomeParcela
        AND oc1.variedade = oc2.variedade
        AND oc1.nomeComum = oc2.nomeComum
    WHERE oc1.idOperacao <> p_idOp
      AND oc2.idOperacao = p_idOp;

    RETURN v_contador > 0;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001, 'ERRO: Não foi possível verificar se a operação tem outras dependentes.');
END;
/
--------------------------------------------------------------------------
--TESTE-------------------------------------------------------------------
DECLARE
    v_test BOOLEAN;
    v_idOperacao_un Operacao.idOperacao%TYPE := novoIdOperacao();
    v_idOperacao_tw Operacao.idOperacao%TYPE;
    v_desigOp tipoOperacaoAgricola.DESIGNACAOOPERACAOAGRICOLA%TYPE := 'Plantação';
    v_desigOp2 tipoOperacaoAgricola.DESIGNACAOOPERACAOAGRICOLA%TYPE := 'Aplicação de fator de produção';
    v_qtd NUMBER := 26;
    v_desigUnidade tipoUnidade.DESIGNACAOUNIDADE%TYPE := 'kg';
    v_dataC DATE := TO_DATE('29/12/2023', 'DD/MM/YYYY');
    v_nomeParcela parcela.nomeParcela%TYPE := 'Lameiro do moinho';
    v_nomeComum planta.nomeComum%TYPE := 'Macieira';
    v_variedade planta.variedade%TYPE := 'PORTA DA LOJA';
    v_dataOp DATE  :=  TO_DATE('30/12/2023', 'DD/MM/YYYY');
    failedTest EXCEPTION;
BEGIN

    INSERT INTO Operacao (idOperacao, designacaoOperacaoAgricola, designacaoUnidade, idEstadoOperacao, quantidade, dataOperacao, instanteRegistoOperacao) VALUES (v_idOperacao_un, v_desigOp, v_desigUnidade, 1 ,  v_qtd,  v_dataC, CURRENT_TIMESTAMP);
    INSERT INTO CulturaInstalada (dataInicial, nomeParcela, variedade, nomeComum, designacaoUnidade, quantidade,  dataFinal) VALUES (v_dataC ,v_nomeParcela,  v_variedade, v_nomeComum, v_desigUnidade, v_qtd, NULL);
    INSERT INTO OperacaoCultura (idOperacao, nomeParcela, dataInicial, nomeComum, variedade) VALUES (v_idOperacao_un, v_nomeParcela,v_dataC, v_nomeComum, v_variedade);

    v_idOperacao_tw   := novoIdOperacao();

    INSERT INTO Operacao (idOperacao, designacaoOperacaoAgricola, designacaoUnidade, idEstadoOperacao, quantidade, dataOperacao, instanteRegistoOperacao) VALUES (v_idOperacao_tw,v_desigOp2 , v_desigUnidade, 1 ,   v_qtd,  v_dataOp, CURRENT_TIMESTAMP);
    INSERT INTO AplicacaoFatorProducao(nomeComercial, idOperacao) VALUES ('Fertimax Extrume de Cavalo' ,v_idOperacao_tw);
    INSERT INTO OperacaoCultura (idOperacao, nomeParcela, dataInicial, nomeComum, variedade) VALUES (v_idOperacao_tw, v_nomeParcela, v_dataC, v_nomeComum, v_variedade);

    IF ( v_desigOp IN ('Plantação','Sementeira','Semeadura','Incorporação no solo')) THEN
        v_test :=  fncTemOperacaoDependente(v_idOperacao_un);
        IF v_test THEN
            DBMS_OUTPUT.PUT_LINE('Teste PASSOU');
        ELSE
            RAISE failedTest;
        END IF;
    ELSE
        RAISE failedTest;
    END IF;

EXCEPTION
    WHEN failedTest THEN
        DBMS_OUTPUT.PUT_LINE('TESTE FALHOU');

END;
/
--------------------------------------------------------------------------
--TESTE-------------------------------------------------------------------
DECLARE
    v_test BOOLEAN;
    v_idOperacao_un Operacao.idOperacao%TYPE := novoIdOperacao();
    v_desigOp tipoOperacaoAgricola.DESIGNACAOOPERACAOAGRICOLA%TYPE := 'Plantação';
    v_qtd NUMBER := 26;
    v_desigUnidade tipoUnidade.DESIGNACAOUNIDADE%TYPE := 'kg';
    v_dataC DATE := TO_DATE('29/12/2023', 'DD/MM/YYYY');
    v_nomeParcela parcela.nomeParcela%TYPE := 'Campo Novo';
    v_nomeComum planta.nomeComum%TYPE := 'Macieira';
    v_variedade planta.variedade%TYPE := 'PORTA DA LOJA';

    failedTest EXCEPTION;
BEGIN

    INSERT INTO Operacao (idOperacao, designacaoOperacaoAgricola, designacaoUnidade, idEstadoOperacao, quantidade, dataOperacao, instanteRegistoOperacao) VALUES (v_idOperacao_un, v_desigOp, v_desigUnidade, 1 ,  v_qtd,  v_dataC, CURRENT_TIMESTAMP);
    INSERT INTO CulturaInstalada (dataInicial, nomeParcela, variedade, nomeComum, designacaoUnidade, quantidade,  dataFinal) VALUES (v_dataC ,v_nomeParcela,  v_variedade, v_nomeComum, v_desigUnidade, v_qtd, NULL);
    INSERT INTO OperacaoCultura (idOperacao, nomeParcela, dataInicial, nomeComum, variedade) VALUES (v_idOperacao_un, v_nomeParcela,v_dataC, v_nomeComum, v_variedade);

    IF ( v_desigOp IN ('Plantação','Sementeira','Semeadura','Incorporação no solo')) THEN
        v_test :=  fncTemOperacaoDependente(v_idOperacao_un);
        IF v_test = FALSE THEN
            DBMS_OUTPUT.PUT_LINE('Teste PASSOU');
        ELSE
            RAISE failedTest;
        END IF;
    ELSE
        RAISE failedTest;
    END IF;

EXCEPTION
    WHEN failedTest THEN
        DBMS_OUTPUT.PUT_LINE('TESTE FALHOU');

END;
/
