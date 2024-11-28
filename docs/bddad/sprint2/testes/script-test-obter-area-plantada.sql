-----------------------------------------------
--FUNÇÃO---------------------------------------
CREATE OR REPLACE NONEDITIONABLE FUNCTION obterAreaPlantada(nomePar IN parcela.nomeParcela%TYPE,
                                                            nomeCom IN culturaInstalada.nomeComum%TYPE,
                                                            vard IN culturaInstalada.variedade%TYPE,
                                                            dataIni IN culturaInstalada.dataInicial%TYPE)
    RETURN NUMBER IS
    areaPlantada culturaInstalada.quantidade%TYPE;

BEGIN
    BEGIN
        SELECT quantidade INTO areaPlantada
        FROM culturaInstalada
        WHERE nomeParcela LIKE nomePar
          AND nomeComum LIKE nomeCom
          AND variedade LIKE vard
          AND dataInicial LIKE dataIni;

        RETURN areaPlantada;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN -1;
        WHEN OTHERS THEN
            RETURN null;
    END;
END;
/
--------------------------------------------------------------------------
--TESTE-------------------------------------------------------------------
--Verifica se a area retornada pela função é a suposta
DECLARE
    test_dataInicial DATE := TO_DATE('12/10/2023 - 00:00', 'DD/MM/YYYY - HH24:MI');
    test_nomeParcela parcela.nomeParcela%TYPE := 'Campo Novo';
    test_nomeComum planta.nomeComum%TYPE := 'Tremoço';
    test_variedade planta.variedade%TYPE := 'AMARELO';
    test_area NUMBER; --:= 1.1;
    failedTest EXCEPTION;
BEGIN

    test_area := obterAreaPlantada( test_nomeParcela, test_nomeComum, test_variedade, test_dataInicial);

    IF test_area = 1.1   THEN
        DBMS_OUTPUT.PUT_LINE('TESTE PASSOU');
    ELSE
        RAISE failedTest;
    END IF;

    EXCEPTION
        WHEN failedTest THEN
             DBMS_OUTPUT.PUT_LINE('TESTE FALHOU');
END;
/