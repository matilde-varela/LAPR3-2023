-------------------------------------------------------------------------------------------------------
-- Função --
-------------------------------------------------------------------------------------------------------
create or replace FUNCTION fncListaProdutosPorParcela(
    p_data_inicial IN DATE,
    p_data_final IN DATE
)
    RETURN SYS_REFCURSOR IS
    lista SYS_REFCURSOR;
BEGIN
    OPEN lista FOR
        SELECT opCul.nomeParcela, p.nomeComum, p.variedade, p.nomeProduto
        FROM operacaoCultura opCul
                 INNER JOIN operacao op ON opCul.idOperacao = op.idOperacao
                 INNER JOIN producao p ON p.nomeComum = opCul.nomeComum AND p.variedade = opCul.variedade
        WHERE UPPER(op.DESIGNACAOOPERACAOAGRICOLA) LIKE 'COLHEITA'
          AND op.dataOperacao BETWEEN p_data_inicial AND p_data_final
        GROUP BY opCul.nomeParcela, p.nomeComum, p.variedade, p.nomeProduto
        ORDER BY opCul.nomeParcela, p.nomeProduto, p.variedade;
    RETURN (lista);
END;
-------------------------------------------------------------------------------------------------------
-- Bloco Anónimo --
-------------------------------------------------------------------------------------------------------
SET SERVEROUTPUT ON;

DECLARE
    semColheitas EXCEPTION;
    dataErradas EXCEPTION;
    listaProdutosCursor SYS_REFCURSOR;
    v_dataInicial DATE := TO_DATE('12/10/2005', 'DD/MM/YYYY');
    v_dataFinal DATE := TO_DATE('06/05/2022', 'DD/MM/YYYY');
    v_nomeParcela operacaoCultura.nomeParcela%TYPE;
    v_nomeComum producao.nomeComum%TYPE;
    v_nomeProduto producao.nomeProduto%TYPE;
    v_variedade producao.variedade%TYPE;

BEGIN

    IF v_dataInicial > v_dataFinal THEN
        RAISE dataErradas;
    END IF;

    listaProdutosCursor := fncListaProdutosPorParcela(v_dataInicial, v_dataFinal);

    FETCH listaProdutosCursor INTO v_nomeParcela, v_nomeComum, v_variedade, v_nomeProduto;

    IF listaProdutosCursor%ROWCOUNT = 0 THEN
        RAISE semColheitas;
    ELSE
        DBMS_OUTPUT.PUT_LINE('TIPOS DE PRODUTOS COLHIDOS ENTRE ' || TO_CHAR(v_dataInicial, 'DD-MON-YYYY') || ' E ' || TO_CHAR(v_dataFinal, 'DD-MON-YYYY'));
        DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------------');
        DBMS_OUTPUT.PUT_LINE( '|' || RPAD('PARCELA',20, ' ') || '|  ' || RPAD('PLANTA',20, ' ') ||  '|  ' || RPAD('VARIEDADE',20, ' ') ||  '|  ' || RPAD('PRODUTO',15, ' ') || '|');
        DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------------');
        LOOP
            DBMS_OUTPUT.PUT_LINE('|' || RPAD(v_nomeParcela,20, ' ') || '|  ' || RPAD(v_nomeComum,20, ' ') ||  '|  ' || RPAD(v_variedade,20, ' ') ||  '|  ' || RPAD(v_nomeProduto,15, ' ') || '|');
            FETCH listaProdutosCursor INTO v_nomeParcela, v_nomeComum, v_variedade, v_nomeProduto;
            EXIT WHEN listaProdutosCursor%NOTFOUND;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------------');
    END IF;

    CLOSE listaProdutosCursor;

EXCEPTION
    WHEN semColheitas THEN
        RAISE_APPLICATION_ERROR(-20001, 'Não houve operações de colheita no período indicado.');
    WHEN dataErradas THEN
        RAISE_APPLICATION_ERROR(-20001, 'A data inicial do intervalo é mais recente do que a data final.');
END;
/

-----------------------------------------------
--TESTE 1----------------------------------------
-- Data de inicio do intervalo é mais recente do a data final proposta.

SET SERVEROUTPUT ON;

DECLARE
    semColheitas EXCEPTION;
    dataErradas EXCEPTION;
    listaProdutosCursor SYS_REFCURSOR;
    v_dataInicial DATE := TO_DATE('12/10/2005', 'DD/MM/YYYY');
    v_dataFinal DATE := TO_DATE('06/05/2005', 'DD/MM/YYYY');
    v_nomeParcela operacaoCultura.nomeParcela%TYPE;
    v_nomeComum producao.nomeComum%TYPE;
    v_nomeProduto producao.nomeProduto%TYPE;
    v_variedade producao.variedade%TYPE;

BEGIN

    IF v_dataInicial > v_dataFinal THEN
        RAISE dataErradas;
    END IF;

    listaProdutosCursor := fncListaProdutosPorParcela(v_dataInicial, v_dataFinal);

    FETCH listaProdutosCursor INTO v_nomeParcela, v_nomeComum, v_variedade, v_nomeProduto;

    IF listaProdutosCursor%ROWCOUNT = 0 THEN
        RAISE semColheitas;
    ELSE
        DBMS_OUTPUT.PUT_LINE('TIPOS DE PRODUTOS COLHIDOS ENTRE ' || TO_CHAR(v_dataInicial, 'DD-MON-YYYY') || ' E ' || TO_CHAR(v_dataFinal, 'DD-MON-YYYY'));
        DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------------');
        DBMS_OUTPUT.PUT_LINE( '|' || RPAD('PARCELA',20, ' ') || '|  ' || RPAD('PLANTA',20, ' ') ||  '|  ' || RPAD('VARIEDADE',20, ' ') ||  '|  ' || RPAD('PRODUTO',15, ' ') || '|');
        DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------------');
        LOOP
            DBMS_OUTPUT.PUT_LINE('|' || RPAD(v_nomeParcela,20, ' ') || '|  ' || RPAD(v_nomeComum,20, ' ') ||  '|  ' || RPAD(v_variedade,20, ' ') ||  '|  ' || RPAD(v_nomeProduto,15, ' ') || '|');
            FETCH listaProdutosCursor INTO v_nomeParcela, v_nomeComum, v_variedade, v_nomeProduto;
            EXIT WHEN listaProdutosCursor%NOTFOUND;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------------');
    END IF;

    CLOSE listaProdutosCursor;

EXCEPTION
    WHEN semColheitas THEN
        RAISE_APPLICATION_ERROR(-20001, 'Não houve operações de colheita no período indicado.');
        RETURN;
    WHEN dataErradas THEN
        RAISE_APPLICATION_ERROR(-20002, 'A data inicial do intervalo é mais recente do que a data final.');
        RETURN;
END;
/

-----------------------------------------------
--EXEMPLO OUTPUT [TESTE 1]---------------------
-----------------------------------------------

-- Error starting at line : 3 in command
-- DECLARE
--     semColheitas EXCEPTION;
--     dataErradas EXCEPTION;
--     listaProdutosCursor SYS_REFCURSOR;
--     v_dataInicial DATE := TO_DATE('12/10/2005', 'DD/MM/YYYY');
--     v_dataFinal DATE := TO_DATE('06/05/2005', 'DD/MM/YYYY');
--     v_nomeParcela operacaoCultura.nomeParcela%TYPE;
--     v_nomeComum producao.nomeComum%TYPE;
--     v_nomeProduto producao.nomeProduto%TYPE;
--     v_variedade producao.variedade%TYPE;
--
-- BEGIN
--
--     IF v_dataInicial > v_dataFinal THEN
--         RAISE dataErradas;
--     END IF;
--
--     listaProdutosCursor := fncListaProdutosPorParcela(v_dataInicial, v_dataFinal);
--
--     FETCH listaProdutosCursor INTO v_nomeParcela, v_nomeComum, v_variedade, v_nomeProduto;
--
--     IF listaProdutosCursor%ROWCOUNT = 0 THEN
--         RAISE semColheitas;
--     ELSE
--         DBMS_OUTPUT.PUT_LINE('TIPOS DE PRODUTOS COLHIDOS ENTRE ' || TO_CHAR(v_dataInicial, 'DD-MON-YYYY') || ' E ' || TO_CHAR(v_dataFinal, 'DD-MON-YYYY'));
--         DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------------');
--         DBMS_OUTPUT.PUT_LINE( '|' || RPAD('PARCELA',20, ' ') || '|  ' || RPAD('PLANTA',20, ' ') ||  '|  ' || RPAD('VARIEDADE',20, ' ') ||  '|  ' || RPAD('PRODUTO',15, ' ') || '|');
--         DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------------');
--         LOOP
--             DBMS_OUTPUT.PUT_LINE('|' || RPAD(v_nomeParcela,20, ' ') || '|  ' || RPAD(v_nomeComum,20, ' ') ||  '|  ' || RPAD(v_variedade,20, ' ') ||  '|  ' || RPAD(v_nomeProduto,15, ' ') || '|');
--             FETCH listaProdutosCursor INTO v_nomeParcela, v_nomeComum, v_variedade, v_nomeProduto;
--             EXIT WHEN listaProdutosCursor%NOTFOUND;
--         END LOOP;
--         DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------------');
--     END IF;
--
--     CLOSE listaProdutosCursor;
--
-- EXCEPTION
--     WHEN semColheitas THEN
--         RAISE_APPLICATION_ERROR(-20001, 'Não houve operações de colheita no período indicado.');
--         RETURN;
--     WHEN dataErradas THEN
--         RAISE_APPLICATION_ERROR(-20002, 'A data inicial do intervalo é mais recente do que a data final.');
--         RETURN;
-- END;
-- Error report -
-- ORA-20002: A data inicial do intervalo é mais recente do que a data final.
-- ORA-06512: na linha 44


-----------------------------------------------
--TESTE 2----------------------------------------
-- Verifica se a função retorna os produtos obtidos em operações de colheitas para cada parcela no intervalo definido definido.
SET SERVEROUTPUT ON;

DECLARE
    semColheitas EXCEPTION;
    dataErradas EXCEPTION;
    listaProdutosCursor SYS_REFCURSOR;
    v_dataInicial DATE := TO_DATE('12/10/2005', 'DD/MM/YYYY');
    v_dataFinal DATE := TO_DATE('06/05/2022', 'DD/MM/YYYY');
    v_nomeParcela operacaoCultura.nomeParcela%TYPE;
    v_nomeComum producao.nomeComum%TYPE;
    v_nomeProduto producao.nomeProduto%TYPE;
    v_variedade producao.variedade%TYPE;

BEGIN

    IF v_dataInicial > v_dataFinal THEN
        RAISE dataErradas;
    END IF;

    listaProdutosCursor := fncListaProdutosPorParcela(v_dataInicial, v_dataFinal);

    FETCH listaProdutosCursor INTO v_nomeParcela, v_nomeComum, v_variedade, v_nomeProduto;

    IF listaProdutosCursor%ROWCOUNT = 0 THEN
        RAISE semColheitas;
    ELSE
        DBMS_OUTPUT.PUT_LINE('TIPOS DE PRODUTOS COLHIDOS ENTRE ' || TO_CHAR(v_dataInicial, 'DD-MON-YYYY') || ' E ' || TO_CHAR(v_dataFinal, 'DD-MON-YYYY'));
        DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------------');
        DBMS_OUTPUT.PUT_LINE( '|' || RPAD('PARCELA',20, ' ') || '|  ' || RPAD('PLANTA',20, ' ') ||  '|  ' || RPAD('VARIEDADE',20, ' ') ||  '|  ' || RPAD('PRODUTO',15, ' ') || '|');
        DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------------');
        LOOP
            DBMS_OUTPUT.PUT_LINE('|' || RPAD(v_nomeParcela,20, ' ') || '|  ' || RPAD(v_nomeComum,20, ' ') ||  '|  ' || RPAD(v_variedade,20, ' ') ||  '|  ' || RPAD(v_nomeProduto,15, ' ') || '|');
            FETCH listaProdutosCursor INTO v_nomeParcela, v_nomeComum, v_variedade, v_nomeProduto;
            EXIT WHEN listaProdutosCursor%NOTFOUND;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------------');
    END IF;

    CLOSE listaProdutosCursor;

EXCEPTION
    WHEN semColheitas THEN
        RAISE_APPLICATION_ERROR(-20001, 'Não houve operações de colheita no período indicado.');
    WHEN dataErradas THEN
        RAISE_APPLICATION_ERROR(-20001, 'A data inicial do intervalo é mais recente do que a data final.');
END;
/

-----------------------------------------------
--EXEMPLO OUTPUT [TESTE 2]---------------------
-----------------------------------------------

-- TIPOS DE PRODUTOS COLHIDOS ENTRE 12-OUT-2005 E 06-MAI-2022
-- --------------------------------------------------------------------------------------
-- |PARCELA             |  PLANTA              |  VARIEDADE           |  PRODUTO        |
-- --------------------------------------------------------------------------------------
-- |Campo da bouça      |  Milho               |  DOCE GOLDEN BANTAM  |  Milho          |
-- |Campo do poço       |  Milho               |  MAS 24.C            |  Milho          |
-- |Campo Grande        |  Oliveira            |  GALEGA              |  Azeitona       |
-- |Campo Grande        |  Oliveira            |  PICUAL              |  Azeitona       |
-- |Horta nova          |  Cenoura             |  DANVERS HALF LONG   |  Cenoura        |
-- |Horta nova          |  Cenoura             |  NELSON HYBRID       |  Cenoura        |
-- |Horta nova          |  Cenoura             |  SCARLET NANTES      |  Cenoura        |
-- |Horta nova          |  Cenoura             |  SUGARSNAX HYBRID    |  Cenoura        |
-- |Horta nova          |  Nabo                |  S. COSME            |  Nabo           |
-- |Lameiro da ponte    |  Macieira            |  FUJI                |  Maçã           |
-- |Lameiro da ponte    |  Macieira            |  JONAGORED           |  Maçã           |
-- |Lameiro da ponte    |  Macieira            |  ROYAL GALA          |  Maçã           |
-- |Vinha               |  Videira             |  DONA MARIA          |  Uvas           |
-- --------------------------------------------------------------------------------------