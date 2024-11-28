-----------------------------------------------
--FUNÇÃO---------------------------------------
CREATE OR REPLACE FUNCTION novoIdOperacao
    RETURN NUMBER AS
    newIdOperation NUMBER;
BEGIN
    SELECT NVL(MAX(idOperacao), 0) + 1
    INTO newIdOperation
    FROM operacao;
    RETURN newIdOperation;
END;
/
--------------------------------------------------------------------------
--TESTE-------------------------------------------------------------------
--Verifica se o novo id de operação é o número a seguir ao ultimo
DECLARE
    test_idOperacao NUMBER;
    test_novoIdOperacao NUMBER;
    failedTest EXCEPTION;
BEGIN
    SELECT COUNT(*) INTO test_idOperacao FROM OPERACAO;
    test_novoIdOperacao := novoIdOperacao();

    IF test_novoIdOperacao = (test_idOperacao + 1)   THEN
        DBMS_OUTPUT.PUT_LINE('TESTE PASSOU');
    ELSE
        RAISE failedTest;
    END IF;

EXCEPTION
    WHEN failedTest THEN
        DBMS_OUTPUT.PUT_LINE('TESTE FALHOU');
END;
/