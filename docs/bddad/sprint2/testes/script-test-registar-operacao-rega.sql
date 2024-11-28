-----------------------------------------------
--FUNÇÃO---------------------------------------
create or replace NONEDITIONABLE FUNCTION registarOperacaoRega(
    desigOp IN tipoOperacaoAgricola.designacaoOperacaoAgricola%TYPE,
    desigUnidade IN tipoUnidade.designacaoUnidade%TYPE,
    qtd IN NUMBER,
    dataOp IN DATE,
    idSetor IN setor.idsetor%TYPE
) RETURN NUMBER IS
    success          NUMBER := 0;
    idOp             NUMBER;
    plantaInfoCursor SYS_REFCURSOR;
    dataInicio       DATE;
    nomeParcela      varchar2(50);
    nomeComum        varchar2(50);
    variedade        varchar2(50);
    semCulturas      EXCEPTION;
BEGIN
    BEGIN

        plantaInfoCursor := obterInfoPlantaSetor(idSetor);

        FETCH plantaInfoCursor INTO nomeParcela, nomeComum, variedade, dataInicio;

        IF plantaInfoCursor%ROWCOUNT != 0 THEN

            LOOP
                idOp := novoIdOperacao();

                INSERT INTO operacao(IDOPERACAO, DESIGNACAOOPERACAOAGRICOLA, DESIGNACAOUNIDADE, QUANTIDADE,
                                     DATAOPERACAO)
                VALUES (idOp, desigOp, desigUnidade, qtd, dataOp);

                INSERT INTO OperacaoCultura (IDOPERACAO, NOMEPARCELA, DATAINICIAL, NOMECOMUM, VARIEDADE)
                VALUES (idOp, nomeParcela, dataInicio, nomeComum, variedade);

                INSERT INTO rega(idOperacao, designacaoSetor)
                VALUES (idOp, idSetor);

                FETCH plantaInfoCursor INTO nomeParcela, nomeComum, variedade, dataInicio;

                EXIT WHEN plantaInfoCursor%NOTFOUND;

            END LOOP;

            success := 1;

        ELSE
            RAISE semCulturas;
        END IF;

    EXCEPTION
        WHEN semCulturas THEN
            success := 0;
            RAISE_APPLICATION_ERROR(-20001, 'Não existem culturas instaladas definidas para o setor escolhido.');
            ROLLBACK;
    END;

    RETURN success;
END;
/
--------------------------------------------------------------------------
create or replace NONEDITIONABLE FUNCTION obterInfoPlantaSetor(
    idSetor IN setor.idsetor%TYPE
) RETURN SYS_REFCURSOR IS
    infoPlanta SYS_REFCURSOR;
BEGIN
    OPEN infoPlanta FOR
        SELECT NOMEPARCELA, NOMECOMUM, VARIEDADE, DATAINICIALCULTURAINSTALADA
        FROM SETORCULTURAINSTALADA
        WHERE DESIGNACAO = idSetor;
    RETURN infoPlanta;
END;
--------------------------------------------------------------------------
SET SERVEROUTPUT ON;
--TESTE-------------------------------------------------------------------
DECLARE
    v_desigOp tipoOperacaoAgricola.DESIGNACAOOPERACAOAGRICOLA%TYPE := 'Rega';
    v_desigUnidade tipounidade.DESIGNACAOUNIDADE%TYPE := 'min';
    v_qtd NUMBER := 26;
    v_dataOp DATE := TO_DATE('29/11/2023 - 07:30', 'DD/MM/YYYY - HH24:MI');
    v_idSetor setor.IDSETOR%TYPE := 21;
    v_success NUMBER;
BEGIN

    v_success := registarOperacaoRega(v_desigOp, v_desigUnidade, v_qtd, v_dataOp, v_idSetor);

    IF v_success = 1 THEN
        DBMS_OUTPUT.PUT_LINE('success');
    ELSE
        DBMS_OUTPUT.PUT_LINE('failure');
    END IF;

END;
/