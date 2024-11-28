-----------------------------------------------
--FUNÇÃO---------------------------------------
CREATE OR REPLACE NONEDITIONABLE FUNCTION obterDataFinal(nomePar IN parcela.nomeParcela%TYPE,
                                                         nomeCom IN culturaInstalada.nomeComum%TYPE,
                                                         vard IN culturaInstalada.variedade%TYPE,
                                                         dataIni IN culturaInstalada.dataInicial%TYPE)
    RETURN DATE IS
    dataF CulturaInstalada.dataFinal%TYPE;
BEGIN
    BEGIN
        SELECT dataFinal INTO dataF
        FROM culturaInstalada
        WHERE nomeParcela = nomePar
          AND nomeComum = nomeCom
          AND variedade = vard
          AND dataInicial = dataIni;

        RETURN dataF;

    EXCEPTION
        WHEN OTHERS THEN
            RETURN NULL;
    END;
END;
/
--------------------------------------------------------------------------
--TESTE--------------------------------------------------------------------
--VERIFICA QUE PARA CULTURA INSTALADA QUE TEM DATA FINAL RETORNA A DATA CORRETA
DECLARE
    test_dataInicial DATE                     := TO_DATE('10/10/2020', 'DD/MM/YYYY');
    test_dataFinal   DATE                     := TO_DATE('30/03/2021', 'DD/MM/YYYY');
    test_nomeParcela parcela.nomeParcela%TYPE := 'Campo da bouça';
    test_nomeComum   planta.nomeComum%TYPE    := 'Tremoço';
    test_variedade   planta.variedade%TYPE    := 'AMARELO';
    success          DATE;
    failedTest EXCEPTION;
BEGIN
    success := temDataFinal(test_nomeParcela, test_nomeComum, test_variedade, test_dataInicial);

    IF success = test_dataFinal THEN
        DBMS_OUTPUT.PUT_LINE('TESTE PASSOU');
    ELSE
        RAISE failedTest;
    END IF;

EXCEPTION
    WHEN failedTest THEN
        DBMS_OUTPUT.PUT_LINE('TESTE FALHOU');
END;
/
