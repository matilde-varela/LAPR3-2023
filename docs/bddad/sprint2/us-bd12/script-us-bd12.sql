------------------------------------------------
--FUNÇÕES---------------------------------------
CREATE OR REPLACE NONEDITIONABLE FUNCTION registarOperacaoMonda(desigOp IN tipoOperacaoAgricola.designacaoOperacaoAgricola%TYPE,
                                                                qtd IN NUMBER,
                                                                dataOp IN DATE,
                                                                nomePar IN parcela.nomeParcela%TYPE,
                                                                nomeCom IN planta.nomeComum%TYPE,
                                                                vard IN planta.variedade%TYPE)
    RETURN NUMBER IS
    success NUMBER := 1;
    desigUnidade tipoUnidade.designacaoUnidade%TYPE;
    datas   SYS_REFCURSOR;
    dataIni DATE;
    idOp    Number;
    invalidOperation exception;
    invalidArea exception;
    invalidCulture exception;
    dataF DATE;
BEGIN
    BEGIN
        datas := obterdatainicialcultura(nomePar, nomeCom,vard);

        LOOP
            FETCH
                datas
                INTO
                dataIni;
            EXIT WHEN datas%notfound;
            desigUnidade := obterUnidadeAreaCultura(nomePar,nomeCom,vard,dataIni);

            IF(verificarSeOperacaoExiste('Monda', desigUnidade, qtd ,dataOp, nomePar, nomeCom, vard) = 0) THEN

                IF((obterAreaPlantada(nomePar,nomeCom,vard,dataIni) >= qtd) ) THEN

                    IF (qtd >= 0) THEN
                        dataF := obterDataFinal(nomePar,nomeCom,vard,dataIni);

                        IF (dataF < dataOp) THEN
                            RAISE invalidCulture;

                        ELSE
                            idOp := novoIdOperacao();

                            INSERT INTO operacao (idOperacao, designacaoOperacaoAgricola, designacaoUnidade, quantidade, dataOperacao)
                            VALUES (idOp, desigOp, desigUnidade, qtd, dataOp);

                            INSERT INTO operacaocultura (idOperacao, nomeParcela, dataInicial, nomeComum,variedade)
                            VALUES (idOp, nomePar, dataIni,nomeCom,vard);

                            success := 0;
                        END IF;
                    ELSE
                        RAISE invalidArea;
                    END IF;
                ELSE
                    RAISE invalidArea;
                END IF;
            ELSE
                RAISE invalidOperation;
            END IF;
        END LOOP;

        IF( success = 1) THEN

            ROLLBACK;
        ELSE
            COMMIT;
        END IF;

    EXCEPTION
        WHEN invalidCulture THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20001, 'ERRO: A cultura selecionada não se encontra na parcela.');
        WHEN invalidArea THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20001, 'ERRO: Não é possível mondar a quantidade pretendida.');
        WHEN invalidOperation THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20001, 'ERRO: Os dados introduzidos já existem no sistema.');
        WHEN OTHERS THEN
            ROLLBACK;
            success := 1;
    END;
    RETURN success;
END;
/
----------------------------------------------------
CREATE OR REPLACE FUNCTION obterUnidadeAreaCultura(nomePar IN parcela.nomeParcela%TYPE,
                                                   nomeCom IN culturaInstalada.nomeComum%TYPE,
                                                   vard IN culturaInstalada.variedade%TYPE,
                                                   dataIni IN culturaInstalada.dataInicial%TYPE )
    RETURN VARCHAR2 IS
    unidade tipoUnidade.designacaoUnidade%TYPE;
BEGIN
    BEGIN
        select designacaoUnidade INTO unidade
        from culturaInstalada
        where nomeParcela = nomePar
          and nomeComum = nomeCom
          and variedade = vard
          and dataInicial = dataIni;

        return unidade;
    EXCEPTION
        WHEN no_data_found THEN
            return null;
        WHEN OTHERS THEN
            return null;
    END;
END;
/
/
----------------------------------------------------
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
----------------------------------------------------
CREATE OR REPLACE FUNCTION verificarSeOperacaoExiste(
    desigOp IN tipoOperacaoAgricola.designacaoOperacaoAgricola%TYPE,
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
----------------------------------------------------
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
----------------------------------------------------
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
----------------------------------------------------
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
------------------------------------------------
--DADOS-----------------------------------------
--08/09/2023,
--Cenoura
--Danvers Half Long
--0.5
------------
--08/10/2023
--Cenoura
--Danvers Half Long
--0.5
------------------------------------------------
--BLOCO ANÓNIMO---------------------------------
SET SERVEROUTPUT ON;
------------------------------------------------
DECLARE
    v_desigOp tipoOperacaoAgricola.designacaoOperacaoAgricola%TYPE := 'Monda';
    v_qtd NUMBER := 0.5;
    v_dataOp DATE := TO_DATE('08/09/2023', 'DD/MM/YYYY');
    v_nomeParcela parcela.nomeParcela%TYPE := 'Campo Novo';
    v_nomeComum planta.nomeComum%TYPE := 'Cenoura';
    v_variedade planta.variedade%TYPE := 'DANVERS HALF LONG';
    v_success NUMBER;

BEGIN
    v_success := registarOperacaoMonda(v_desigOp, v_qtd, v_dataOp, v_nomeParcela, v_nomeComum, v_variedade);

    IF v_success = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Operation registered successfully!');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Failed to register operation.');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Failed to register operation.');
END;
/
--------------------------------------------------------------------------
--TESTE-------------------------------------------------------------------
DECLARE
    test_desigOp tipoOperacaoAgricola.designacaoOperacaoAgricola%TYPE := 'Monda';
    test_qtd NUMBER := 0.2;
    test_dataOp DATE := SYSDATE;
    test_nomeParcela parcela.nomeParcela%TYPE := 'Campo Novo';
    test_nomeComum planta.nomeComum%TYPE := 'Tremoço';
    test_variedade planta.variedade%TYPE := 'AMARELO';
    test_success NUMBER;
    failedTest EXCEPTION;
BEGIN
    DBMS_OUTPUT.PUT_LINE('TESTE DA FUNÇÃO: verifica que operação é registada para parâmetros válidos.');
    test_success := registarOperacaoMonda(test_desigOp,  test_qtd, test_dataOp, test_nomeParcela, test_nomeComum, test_variedade);

    IF test_success = 0 THEN
        DBMS_OUTPUT.PUT_LINE('TESTE PASSOU');
    ELSE
        RAISE failedTest;
    END IF;

EXCEPTION
    WHEN failedTest THEN
        DBMS_OUTPUT.PUT_LINE('TESTE FALHOU');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('TESTE FALHOU');
END;
/
--------------------------------------------------------------------------
--TESTE-------------------------------------------------------------------
DECLARE
    test_desigOp tipoOperacaoAgricola.designacaoOperacaoAgricola%TYPE := 'Monda';
    test_qtd NUMBER := 9;
    test_dataOp DATE := TO_DATE('22/11/2023 - 23:59', 'DD/MM/YYYY - HH24:MI');
    test_nomeParcela parcela.nomeParcela%TYPE := 'Campo Novo';
    test_nomeComum planta.nomeComum%TYPE := 'Tremoço';
    test_variedade planta.variedade%TYPE := 'AMARELO';
    test_success NUMBER;
    failedTest EXCEPTION;
BEGIN
    DBMS_OUTPUT.PUT_LINE('TESTE DA QUANTIDADE: verifica que não regista operação com quantidade superior à área plantada.');
    test_success := registarOperacaoMonda(test_desigOp, test_qtd, test_dataOp, test_nomeParcela, test_nomeComum, test_variedade);

    IF test_success = 0 THEN
        DBMS_OUTPUT.PUT_LINE('TESTE PASSOU');
    ELSE
        RAISE failedTest;
    END IF;

EXCEPTION
    WHEN failedTest THEN
        DBMS_OUTPUT.PUT_LINE('TESTE FALHOU');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('TESTE PASSOU');
END;
/
--------------------------------------------------------------------------
--TESTE-------------------------------------------------------------------
DECLARE
    test_desigOp tipoOperacaoAgricola.designacaoOperacaoAgricola%TYPE := 'Monda';
    test_qtd NUMBER := -0.6;
    test_dataOp DATE := TO_DATE('25/11/2023 - 17:25', 'DD/MM/YYYY - HH24:MI');
    test_nomeParcela parcela.nomeParcela%TYPE := 'Campo Novo';
    test_nomeComum planta.nomeComum%TYPE := 'Tremoço';
    test_variedade planta.variedade%TYPE := 'AMARELO';
    test_success NUMBER;
    failedTest EXCEPTION;
BEGIN
    DBMS_OUTPUT.PUT_LINE('TESTE DA QUANTIDADE: verifica que não regista operação com quantidade negativa.');
    test_success := registarOperacaoMonda(test_desigOp,  test_qtd, test_dataOp, test_nomeParcela, test_nomeComum, test_variedade);

    IF test_success = 1 THEN
        DBMS_OUTPUT.PUT_LINE('TESTE PASSOU');
    ELSE
        RAISE failedTest;
    END IF;

EXCEPTION
    WHEN failedTest THEN
        DBMS_OUTPUT.PUT_LINE('TESTE FALHOU');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('TESTE PASSOU');
END;
/
--------------------------------------------------------------------------
--TESTE-------------------------------------------------------------------
DECLARE
    test_desigOp tipoOperacaoAgricola.designacaoOperacaoAgricola%TYPE := 'Monda';
    test_qtd NUMBER := 0.5;
    test_dataOp DATE := TO_DATE('08/08/2023 - 00:00', 'DD/MM/YYYY - HH24:MI');
    test_nomeParcela parcela.nomeParcela%TYPE := 'Campo Novo';
    test_nomeComum planta.nomeComum%TYPE := 'Cenoura';
    test_variedade planta.variedade%TYPE := 'DANVERS HALF LONG';
    test_success NUMBER;
    failedTest EXCEPTION;
BEGIN
    DBMS_OUTPUT.PUT_LINE('TESTE DA OPERAÇÃO EXISTENTE: verifica que não regista operação existente.');
    test_success := registarOperacaoMonda(test_desigOp, test_qtd, test_dataOp, test_nomeParcela, test_nomeComum, test_variedade);

    IF test_success = 1 THEN
        DBMS_OUTPUT.PUT_LINE('TESTE PASSOU');
    ELSE
        RAISE failedTest;
    END IF;

EXCEPTION
    WHEN failedTest THEN
        DBMS_OUTPUT.PUT_LINE('TESTE FALHOU');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('TESTE PASSOU');
END;
/
--------------------------------------------------------------------------
--TESTE-------------------------------------------------------------------
DECLARE
    test_desigOp tipoOperacaoAgricola.designacaoOperacaoAgricola%TYPE := 'Monda';
    test_qtd NUMBER := 0.2;
    test_dataOp DATE := TO_DATE('26/11/2023 - 00:00', 'DD/MM/YYYY - HH24:MI');
    test_nomeParcela parcela.nomeParcela%TYPE := 'Campo Novo';
    test_nomeComum planta.nomeComum%TYPE := 'Cenoura';
    test_variedade planta.variedade%TYPE := 'DANVERS HALF LONG';
    test_success NUMBER;
    failedTest EXCEPTION;
BEGIN
    DBMS_OUTPUT.PUT_LINE('TESTE DA CULTURA TERMINADA: verifica que não regista operação para cultura com data final, ou seja terminada.');
    test_success := registarOperacaoMonda(test_desigOp, test_qtd, test_dataOp, test_nomeParcela, test_nomeComum, test_variedade);

    IF test_success = 1 THEN
        DBMS_OUTPUT.PUT_LINE('TESTE PASSOU');
    ELSE
        RAISE failedTest;
    END IF;

EXCEPTION
    WHEN failedTest THEN
        DBMS_OUTPUT.PUT_LINE('TESTE FALHOU');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('TESTE PASSOU');
END;
/
------------------------------------------------
--CONFIRMAÇÃO-----------------------------------
select *
from  operacaoCultura oc
          inner join Operacao o
                     on oc.idoperacao = o.idoperacao
order by dataoperacao;
------------------------------------------------
select * from culturaInstalada;
------------------------------------------------




