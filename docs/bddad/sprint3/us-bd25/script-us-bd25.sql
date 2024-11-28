create or replace TRIGGER nova_Operacao
    BEFORE INSERT
    ON Operacao
    FOR EACH ROW
DECLARE
    v_proxvalor NUMBER;
BEGIN
    SELECT NVL(MAX(idOperacao), 0) + 1 INTO v_proxvalor FROM Operacao;
    :NEW.idOperacao := v_proxvalor;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERRO: ' || SQLERRM);
END;
/
--------------------------------------------------------------------------------------------------------------
---FUNÇÕES COMPLENTARES PARA OS TESTES------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
create or replace FUNCTION registarOperacao(
    desigOp IN tipoOperacaoAgricola.designacaoOperacaoAgricola%TYPE,
    desigUnidadeOperacao IN tipoUnidade.designacaoUnidade%TYPE,
    v_idEstadoOperacao IN estadoOperacao.idEstadoOperacao%TYPE,
    qtdOp IN NUMBER,
    dataOp IN DATE,
    v_registo IN TIMESTAMP)
    RETURN NUMBER IS
    v_success NUMBER;
    qtdInvalida EXCEPTION;
BEGIN
    BEGIN

        IF qtdOp <= 0 THEN
            v_success := 0;
            RAISE qtdInvalida;
        ELSE

            INSERT INTO Operacao(designacaoOperacaoAgricola, designacaoUnidade, idEstadoOperacao, quantidade,
                                 dataOperacao, instanteRegistoOperacao)
            VALUES (desigOp, desigUnidadeOperacao, v_idEstadoOperacao, qtdOp, dataOp, v_registo);

            v_success := 1;
        END IF;

    EXCEPTION
        WHEN qtdInvalida THEN
            RAISE_APPLICATION_ERROR(-20006, 'ERRO: A quantidade indicada é inválida (igual ou inferior a 0).');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20007, 'ERRO: Nao foi possivel registar a operacao.');

    END;

    RETURN v_success;
END;
/
--------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION obterIdOperacao(
    desigOp IN tipoOperacaoAgricola.designacaoOperacaoAgricola%TYPE,
    desigUnidadeOperacao IN tipoUnidade.designacaoUnidade%TYPE,
    v_idEstadoOperacao IN estadoOperacao.idEstadoOperacao%TYPE,
    qtdOp IN NUMBER,
    dataOp IN DATE,
    v_registo IN TIMESTAMP)
    RETURN NUMBER IS
    v_idOp NUMBER;
BEGIN
    BEGIN

        SELECT idOperacao
        INTO v_idOp
        FROM Operacao op
        WHERE op.designacaoOperacaoAgricola = desigOp
          AND op.designacaoUnidade = desigUnidadeOperacao
          AND op.idEstadoOperacao = v_idEstadoOperacao
          AND op.dataOperacao = dataOp
          AND op.quantidade = qtdOp
          AND op.instanteRegistoOperacao = v_registo;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20008, 'ERRO: Não foi possivel obter o id da operacao.');
    END;

    RETURN v_idOp;
END;
/
--------------------------------------------------------------------------------------------------------------