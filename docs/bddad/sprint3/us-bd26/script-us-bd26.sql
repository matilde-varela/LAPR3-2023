--------------------------------------------------------------------------
--TRIGGERS----------------------------------------------------------------
create or replace NONEDITIONABLE TRIGGER registerLogOperacao
    AFTER INSERT OR UPDATE ON Operacao
    FOR EACH ROW
DECLARE
    vDadosAdicionaisOperacao VARCHAR2(255);
BEGIN
    vDadosAdicionaisOperacao := obterDadosAdicionaisOperacao(:NEW.idOperacao);

    if vDadosAdicionaisOperacao IS NOT NULL THEN
        INSERT INTO Log (idRegistoLog, idOperacao, designacaoOperacaoAgricola, designacaoUnidade, idEstadoOperacao, quantidade, dataOperacao, dadosAdicionais)
        VALUES (SYSDATE, :NEW.idOperacao, :NEW.designacaoOperacaoAgricola, :NEW.designacaoUnidade, :NEW.idEstadoOperacao, :NEW.quantidade, :NEW.dataOperacao, vDadosAdicionaisOperacao);
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001, 'ERRO: Não foi possível registar a operação.');
END;
/
--------------------------------------------------------------------------
create or replace NONEDITIONABLE TRIGGER registerLogOperacaoParcela
    AFTER INSERT OR UPDATE ON OperacaoParcela
    FOR EACH ROW
DECLARE
    op_info Operacao%ROWTYPE;
    vDadosAdicionaisOperacao VARCHAR2(255);
BEGIN
    op_info := obterInformacaoOperacao(:NEW.idOperacao);

    vDadosAdicionaisOperacao := 'Nome parcela: ' || :NEW.nomeParcela;

    IF (op_info.designacaoOperacaoAgricola IN ('Fertilização','Aplicação fitofármaco','Aplicação de fator de produção')) THEN
        vDadosAdicionaisOperacao := vDadosAdicionaisOperacao || ' | Fator produção: ' || obterFatoresProducao(:NEW.idOperacao);
    END IF;

    INSERT INTO Log (idRegistoLog, idOperacao, designacaoOperacaoAgricola, designacaoUnidade, idEstadoOperacao, quantidade, dataOperacao, dadosAdicionais)
    VALUES (SYSDATE, :NEW.idOperacao,op_info.designacaoOperacaoAgricola, op_info.designacaoUnidade, op_info.idEstadoOperacao, op_info.quantidade, op_info.dataOperacao, vDadosAdicionaisOperacao);

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001, 'ERRO: Não foi possível registar a operação.');
END;
/
--------------------------------------------------------------------------
create or replace NONEDITIONABLE TRIGGER registerLogOperacaoCultura
    AFTER INSERT OR UPDATE ON OperacaoCultura
    FOR EACH ROW
DECLARE
    op_info Operacao%ROWTYPE;
    design varchar2(15);
    vDadosAdicionaisOperacao VARCHAR2(255);
BEGIN
    op_info := obterInformacaoOperacao(:NEW.idOperacao);

    select designacaoTipoPermanencia into design from PlantaPermanencia where nomeComum = :NEW.nomeComum;

    vDadosAdicionaisOperacao := 'Nome parcela: ' || :NEW.nomeParcela ||  ' | Variedade: ' || :NEW.variedade || ' | Nome comum: ' || :NEW.nomeComum;

    IF(op_info.designacaoOperacaoAgricola = 'Colheita') THEN
        vDadosAdicionaisOperacao := vDadosAdicionaisOperacao || ' | Produtos colhidos: ' || obterProdutosColhidos(:NEW.idOperacao);
    ELSIF (op_info.designacaoOperacaoAgricola IN ('Fertilização','Aplicação fitofármaco','Aplicação de fator de produção')) THEN
        vDadosAdicionaisOperacao := vDadosAdicionaisOperacao || ' | Fator produção: ' || obterFatoresProducao(:NEW.idOperacao);
    ELSIF ((op_info.designacaoOperacaoAgricola = 'Plantação') AND ( design = 'Permanente')) THEN
        vDadosAdicionaisOperacao :=  vDadosAdicionaisOperacao || ' | ' || obterInfoPlantacaoPermanente(:NEW.idOperacao);
    END IF;

    INSERT INTO Log (idRegistoLog, idOperacao, designacaoOperacaoAgricola, designacaoUnidade, idEstadoOperacao, quantidade, dataOperacao, dadosAdicionais)
    VALUES (SYSDATE, :NEW.idOperacao,op_info.designacaoOperacaoAgricola, op_info.designacaoUnidade, op_info.idEstadoOperacao, op_info.quantidade, op_info.dataOperacao, vDadosAdicionaisOperacao);


EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001, 'ERRO: Não foi possível registar a operação.');
END;
/
--------------------------------------------------------------------------
create or replace NONEDITIONABLE TRIGGER registerLogRega
    AFTER INSERT OR UPDATE ON Rega
    FOR EACH ROW
DECLARE
    op_info Operacao%ROWTYPE;
    vDadosAdicionaisOperacao VARCHAR2(255);
BEGIN
    op_info := obterInformacaoOperacao(:NEW.idOperacao);

    IF(op_info.designacaoOperacaoAgricola = 'Fertirrega') THEN
        vDadosAdicionaisOperacao := 'Setor: ' || :NEW.designacaoSetor || ' | Fator produção: ' || obterFatoresProducao(:NEW.idOperacao);

        INSERT INTO Log (idRegistoLog, idOperacao, designacaoOperacaoAgricola, designacaoUnidade, idEstadoOperacao, quantidade, dataOperacao, dadosAdicionais)
        VALUES (SYSDATE, :NEW.idOperacao,op_info.designacaoOperacaoAgricola, op_info.designacaoUnidade, op_info.idEstadoOperacao, op_info.quantidade, op_info.dataOperacao, vDadosAdicionaisOperacao);

    ELSE
        vDadosAdicionaisOperacao := 'Setor: ' || :NEW.designacaoSetor;

        INSERT INTO Log (idRegistoLog, idOperacao, designacaoOperacaoAgricola, designacaoUnidade, idEstadoOperacao, quantidade, dataOperacao, dadosAdicionais)
        VALUES (SYSDATE, :NEW.idOperacao,op_info.designacaoOperacaoAgricola, op_info.designacaoUnidade, op_info.idEstadoOperacao, op_info.quantidade, op_info.dataOperacao, vDadosAdicionaisOperacao);
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001, 'ERRO: Não foi possível registar a operação.');
END;
/
--------------------------------------------------------------------------
--FUNÇÃO------------------------------------------------------------------
create or replace NONEDITIONABLE FUNCTION fncExistsRegisterInLog(p_idOperacao in Operacao.idOperacao%TYPE)
    RETURN NUMBER
    IS v_log_count NUMBER;
BEGIN
    BEGIN
        SELECT COUNT(*)
        INTO v_log_count
        FROM Log
        WHERE idOperacao = p_idOperacao;

        RETURN v_log_count;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20001, 'ERRO: Não foi possível registar a operação.');
    END ;
END;
/
--------------------------------------------------------------------------
--FUNÇÃO------------------------------------------------------------------
create or replace NONEDITIONABLE FUNCTION obterInfoPlantacaoPermanente(p_idOp IN Operacao.idOperacao%TYPE)
    RETURN VARCHAR2
    IS
    dados VARCHAR2(255);
    infoNaoEncontrada EXCEPTION;
BEGIN
    SELECT LISTAGG('Compasso: ' || compasso || ', Distância Entre Filas: ' || distanciaEntreFilas, '; ')
                   WITHIN GROUP (ORDER BY idOperacao)
    INTO dados
    FROM PlantacaoPermanente
    WHERE idOperacao = p_idOp;

    IF dados IS NULL THEN
        RAISE infoNaoEncontrada;
    END IF;

    RETURN dados;
EXCEPTION
    WHEN infoNaoEncontrada THEN
        RAISE_APPLICATION_ERROR(-20001, 'ERRO: Não foi possível encontrar os dados da plantação permanente.');
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'ERRO: Não foi possível encontrar os dados da plantação permanente.');
END;
/
--------------------------------------------------------------------------
--FUNÇÃO------------------------------------------------------------------
create or replace NONEDITIONABLE FUNCTION obterDesigFatoresProducao(p_idOp IN Operacao.idOperacao%TYPE)
    RETURN VARCHAR2
    IS
    dados VARCHAR2(255);
    infoNaoEncontrada EXCEPTION;
BEGIN
    SELECT LISTAGG(nomeComercial, ', ') WITHIN GROUP (ORDER BY nomeComercial)
    INTO dados
    FROM AplicacaoFatorProducao
    WHERE idOperacao = p_idOp;

    IF dados IS NULL THEN
        RAISE infoNaoEncontrada;
    END IF;

    RETURN dados;
EXCEPTION
    WHEN infoNaoEncontrada THEN
        RAISE_APPLICATION_ERROR(-20001, 'ERRO: Não foi possível encontrar os fatores de produção usados na fertirrega.');
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'ERRO: Não foi possível encontrar os fatores de produção usados na fertirrega.');

END;
/
--------------------------------------------------------------------------
--FUNÇÃO------------------------------------------------------------------
create or replace NONEDITIONABLE FUNCTION obterProdutosColhidos(p_idOp IN Operacao.idOperacao%TYPE)
    RETURN VARCHAR2
    IS
    dados VARCHAR2(255);
    infoNaoEncontrada EXCEPTION;
BEGIN
    SELECT LISTAGG(nomeProduto || ' (' || quantidade || ' ' || designacaoUnidade || ')', ', ') WITHIN GROUP (ORDER BY nomeProduto)
    INTO vReceita
    FROM ProdutoColhido
    WHERE idOperacao = p_idOp;

    IF dados IS NULL THEN
        RAISE infoNaoEncontrada;
    END IF;

    RETURN dados;
EXCEPTION
    WHEN infoNaoEncontrada THEN
        RAISE_APPLICATION_ERROR(-20001, 'ERRO: Não foi possível encontrar os produtos colhidos.');
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'ERRO: Não foi possível encontrar os produtos colhidos.');
END;
/
--------------------------------------------------------------------------
--FUNÇÃO------------------------------------------------------------------
create or replace NONEDITIONABLE FUNCTION obterDadosAdicionaisOperacao(p_idOp IN Operacao.idOperacao%TYPE)
    RETURN VARCHAR2
    IS
    vDadosAdicionais VARCHAR2(255);
BEGIN
    SELECT dadosAdicionais INTO vDadosAdicionais
    FROM Log
    WHERE idOperacao = p_idOp
      AND ROWNUM = 1;

    RETURN vDadosAdicionais;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        return null;
END;
/
--------------------------------------------------------------------------
--FUNÇÃO------------------------------------------------------------------
create or replace NONEDITIONABLE FUNCTION obterInformacaoOperacao(p_idOperacao IN NUMBER)
    RETURN Operacao%ROWTYPE
    IS
    v_operacao Operacao%ROWTYPE;
BEGIN
    SELECT *
    INTO v_operacao
    FROM Operacao
    WHERE idOperacao = p_idOperacao;

    RETURN v_operacao;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001, 'ERRO: Não foi possível obter a informação da operação.');
END;
/
--------------------------------------------------------------------------
--TESTE-------------------------------------------------------------------
--Verifica se é efetuado o registo na tabela log.
SET SERVEROUTPUT ON;

DECLARE
    v_idOperacao Operacao.idOperacao%TYPE := novoIdOperacao();
    v_desigOp tipoOperacaoAgricola.DESIGNACAOOPERACAOAGRICOLA%TYPE := 'Rega';
    v_desigUnidade tipounidade.DESIGNACAOUNIDADE%TYPE := 'min';
    v_qtd NUMBER := 26;
    v_dataOp DATE := TO_DATE('29/11/2023 - 07:30', 'DD/MM/YYYY - HH24:MI');
    v_idSetor setor.designacaoSetor%TYPE := 21;
    failedTest EXCEPTION;
BEGIN

    INSERT INTO Operacao(idOperacao, designacaoOperacaoAgricola, designacaoUnidade, idEstadoOperacao, quantidade, dataOperacao, instanteRegistoOperacao) VALUES (v_idOperacao, v_desigOp, v_desigUnidade, 1 , v_qtd, v_dataOp,CURRENT_TIMESTAMP);
    INSERT INTO Rega (idOperacao, designacaoSetor) VALUES (v_idOperacao, v_idSetor);

    IF fncExistsRegisterInLog(v_idOperacao) = 1  THEN
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
--Caso de sucesso - confirmação de registos
select * from log;
