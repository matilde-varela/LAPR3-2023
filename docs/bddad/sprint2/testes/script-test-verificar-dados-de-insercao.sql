Set SERVEROUTPUT ON;

CREATE OR REPLACE FUNCTION verificarDadosDeInsercao(
    desigOp IN tipoOperacaoAgricola.designacaoOperacaoAgricola%TYPE,
    desigUnidade IN tipoUnidade.designacaoUnidade%TYPE,
    qtd IN NUMBER,
    dataOp IN DATE,
    nmFator IN aplicacaofatorproducao.nomecomercial%TYPE
) RETURN BOOLEAN IS
    valid BOOLEAN;
BEGIN
    IF desigOp IN ('Fertilização', 'Aplicação fitofármaco', 'Aplicação de fator de produção') THEN
        IF desigUnidade = 'kg' THEN
            IF qtd < 100 THEN
                valid := TRUE;
            END IF;
        END IF;
    ELSE
        valid := FALSE;
    END IF;
    RETURN valid;
END;
/
-------------Testes:-----------------
-------------Teste: Inputs Válidos------------
DECLARE
    test_desigOp tipoOperacaoAgricola.designacaoOperacaoAgricola%TYPE := 'Aplicação fitofármaco';
    test_desigUnidade tipoUnidade.designacaoUnidade%TYPE := 'kg';
    test_qtd NUMBER := 1;
    test_dataOp DATE := TO_DATE('23/11/2024', 'DD/MM/YYYY');
    test_nmFator aplicacaofatorproducao.nomecomercial%TYPE := 'BIOFERTIL N6';
    test_result BOOLEAN;
    failedTest EXCEPTION;
BEGIN
    test_result := verificarDadosDeInsercao(test_desigOp,test_desigUnidade,test_qtd,test_dataOp,test_nmFator);

    IF(test_result = TRUE) THEN
        DBMS_OUTPUT.PUT_LINE('TESTE PASSOU');
    ELSE
        RAISE failedTest;
    END IF;

EXCEPTION
    WHEN failedTest THEN
        DBMS_OUTPUT.PUT_LINE('TESTE FALHOU.');
END;
/
-------------Teste: Inputs Inválidos(designação)------------
DECLARE
    test_desigOp tipoOperacaoAgricola.designacaoOperacaoAgricola%TYPE := 'Aplicação fico';
    test_desigUnidade tipoUnidade.designacaoUnidade%TYPE := 'kg';
    test_qtd NUMBER := 1;
    test_dataOp DATE := TO_DATE('23/11/2024', 'DD/MM/YYYY');
    test_nmFator aplicacaofatorproducao.nomecomercial%TYPE := 'BIOFERTIL N6';
    test_result BOOLEAN;
    failedTest EXCEPTION;
BEGIN
    test_result := verificarDadosDeInsercao(test_desigOp,test_desigUnidade,test_qtd,test_dataOp,test_nmFator);

    IF(test_result = TRUE) THEN
        DBMS_OUTPUT.PUT_LINE('TESTE FALHOU.');
    ELSE
        RAISE failedTest;
    END IF;

EXCEPTION
    WHEN failedTest THEN
        DBMS_OUTPUT.PUT_LINE('TESTE PASSOU.');
END;
/
-------------Teste: Inputs Inválidos(tipo de unidade)------------
DECLARE
    test_desigOp tipoOperacaoAgricola.designacaoOperacaoAgricola%TYPE := 'Aplicação fitofármaco';
    test_desigUnidade tipoUnidade.designacaoUnidade%TYPE := 'ha';
    test_qtd NUMBER := 1;
    test_dataOp DATE := TO_DATE('23/11/2024', 'DD/MM/YYYY');
    test_nmFator aplicacaofatorproducao.nomecomercial%TYPE := 'BIOFERTIL N6';
    test_result BOOLEAN;
    failedTest EXCEPTION;
BEGIN
    test_result := verificarDadosDeInsercao(test_desigOp,test_desigUnidade,test_qtd,test_dataOp,test_nmFator);

    IF(test_result = TRUE) THEN
        DBMS_OUTPUT.PUT_LINE('TESTE FALHOU.');
    ELSE
        RAISE failedTest;
    END IF;

EXCEPTION
    WHEN failedTest THEN
        DBMS_OUTPUT.PUT_LINE('TESTE PASSOU.');
END;
/
-------------Teste: Inputs Inválidos(qtd)------------
DECLARE
    test_desigOp tipoOperacaoAgricola.designacaoOperacaoAgricola%TYPE := 'Aplicação fitofármaco';
    test_desigUnidade tipoUnidade.designacaoUnidade%TYPE := 'kg';
    test_qtd NUMBER := 1203;
    test_dataOp DATE := TO_DATE('23/11/2024', 'DD/MM/YYYY');
    test_nmFator aplicacaofatorproducao.nomecomercial%TYPE := 'BIOFERTIL N6';
    test_result BOOLEAN;
    failedTest EXCEPTION;
BEGIN
    test_result := verificarDadosDeInsercao(test_desigOp,test_desigUnidade,test_qtd,test_dataOp,test_nmFator);

    IF(test_result = TRUE) THEN
        DBMS_OUTPUT.PUT_LINE('TESTE FALHOU.');
    ELSE
        RAISE failedTest;
    END IF;

EXCEPTION
    WHEN failedTest THEN
        DBMS_OUTPUT.PUT_LINE('TESTE PASSOU.');
END;
/