-----------------------------------------------
--FUNÇÃO---------------------------------------
CREATE OR REPLACE FUNCTION verificarSeOperacaoExiste(desigOp IN tipoOperacaoAgricola.designacaoOperacaoAgricola%TYPE,
                                                     desigUnidade IN tipoUnidade.designacaoUnidade%TYPE,
                                                     qtd IN NUMBER,
                                                     dataOp IN DATE,
                                                     nomeParcela IN parcela.nomeParcela%TYPE,
                                                     nomeComum IN culturainstalada.nomeComum%TYPE,
                                                     variedade IN culturainstalada.variedade%TYPE
) RETURN NUMBER IS
    found NUMBER := 0;
BEGIN
    BEGIN
        SELECT NVL(COUNT(*), 0) INTO found
        FROM OPERACAO op
                 INNER JOIN operacaoCultura cul ON op.idOperacao = cul.idOperacao
        WHERE op.designacaooperacaoagricola = desigOp
          AND op.dataoperacao = dataOp
          AND op.designacaounidade = desigUnidade
          AND op.quantidade = qtd
          AND cul.nomeComum = nomeComum
          AND cul.variedade = variedade
          AND cul.nomeParcela = nomeParcela;
    EXCEPTION
        WHEN OTHERS THEN
            found := 0;
    END;
    RETURN found;
END;
/
--------------------------------------------------------------------------
--TESTE-------------------------------------------------------------------
--Verifica que a função retorna 1, ou seja encontra uma operação igual.
DECLARE
    test_desigOp tipoOperacaoAgricola.designacaoOperacaoAgricola%TYPE := 'Monda';
    test_desigUnidade tipoUnidade.DESIGNACAOUNIDADE%TYPE := 'ha';
    test_qtd NUMBER := 0.5;
    test_dataOp DATE := TO_DATE('08/08/2023', 'DD/MM/YYYY');
    test_nomeParcela parcela.nomeParcela%TYPE := 'Campo Novo';
    test_nomeComum planta.nomeComum%TYPE := 'Cenoura';
    test_variedade planta.variedade%TYPE := 'DANVERS HALF LONG';
    test_success NUMBER;
    failedTest EXCEPTION;
BEGIN
    test_success := verificarSeOperacaoExiste(test_desigOp, test_desigUnidade, test_qtd, test_dataOp, test_nomeParcela, test_nomeComum, test_variedade);

    IF test_success = 1 THEN
        DBMS_OUTPUT.PUT_LINE('TESTE PASSOU');
    ELSE
        RAISE failedTest;
    END IF;

EXCEPTION
    WHEN failedTest THEN
        DBMS_OUTPUT.PUT_LINE('TESTE FALHOU.');
END;
/
--------------------------------------------------------------------------
--TESTE-------------------------------------------------------------------
--Verifica que a função retorna 0, ou seja não encontrou uma operação igual.
DECLARE
    test_desigOp tipoOperacaoAgricola.designacaoOperacaoAgricola%TYPE := 'Monda';
    test_desigUnidade tipoUnidade.DESIGNACAOUNIDADE%TYPE := 'ha';
    test_qtd NUMBER := 0.7;
    test_dataOp DATE := TO_DATE('24/11/2023', 'DD/MM/YYYY');
    test_nomeParcela parcela.nomeParcela%TYPE := 'Campo Novo';
    test_nomeComum planta.nomeComum%TYPE := 'Tremoço';
    test_variedade planta.variedade%TYPE := 'AMARELO';
    test_success NUMBER;
    failedTest EXCEPTION;
BEGIN
    test_success := verificarSeOperacaoExiste(test_desigOp, test_desigUnidade, test_qtd, test_dataOp, test_nomeParcela, test_nomeComum, test_variedade);

    IF test_success = 0 THEN
        DBMS_OUTPUT.PUT_LINE('TESTE PASSOU');
    ELSE
        RAISE failedTest;
    END IF;

EXCEPTION
    WHEN failedTest THEN
        DBMS_OUTPUT.PUT_LINE('TESTE FALHOU.');
END;
/