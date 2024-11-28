-----------------------------------------------
--FUNÇÃO---------------------------------------
CREATE OR REPLACE FUNCTION obterdatainicialcultura(nomePar IN parcela.nomeParcela%TYPE,
                                                   nomeCom IN planta.nomeComum%TYPE,
                                                   vard IN planta.variedade%TYPE)
    RETURN SYS_REFCURSOR IS
    datas SYS_REFCURSOR;
BEGIN
    BEGIN
        open datas for
            select datainicial
            from culturaInstalada
            where nomeParcela = nomePar
              and nomeComum = nomeCom
              and variedade = vard;
        return datas;
    EXCEPTION
        WHEN no_data_found THEN
            return null;
        WHEN OTHERS THEN
            return null;
    END;
END;
/
--------------------------------------------------------------------------
--TESTE-------------------------------------------------------------------
--Verifica que a função retorna cursor com a data inicial esperada.
DECLARE
    test_dataInicialCursor SYS_REFCURSOR;
    test_dataInicial DATE;
    test_nomeParcela parcela.nomeParcela%TYPE := 'Campo Novo';
    test_nomeComum planta.nomeComum%TYPE := 'Tremoço';
    test_variedade planta.variedade%TYPE := 'AMARELO';
    failedTest EXCEPTION;
BEGIN
    test_dataInicialCursor := obterDataInicialCultura( test_nomeParcela, test_nomeComum, test_variedade);


    FETCH test_dataInicialCursor INTO test_dataInicial;

    IF test_dataInicialCursor%ROWCOUNT = 0 THEN
        RAISE failedTest;
    ELSE
        LOOP
            EXIT WHEN test_dataInicialCursor%notfound;
            IF(test_dataInicial !=  TO_DATE('12/10/2023 - 00:00', 'DD/MM/YYYY - HH24:MI')) THEN
                RAISE failedTest;
            END IF;
            FETCH test_dataInicialCursor INTO test_dataInicial;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('TESTE PASSOU');
    END IF;

    EXCEPTION
        WHEN failedTest THEN
             DBMS_OUTPUT.PUT_LINE('TESTE FALHOU');
END;
/
