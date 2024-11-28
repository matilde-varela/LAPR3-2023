.....................................................................................................................................................................................................................................-----------------------------------------------
--FUNÇÃO---------------------------------------
CREATE OR REPLACE FUNCTION fncListaConsumoCulturas(p_ano_civil NUMBER)
       RETURN SYS_REFCURSOR IS
       listaConsumoCulturas SYS_REFCURSOR;
       verifExistenciaRegas NUMBER(10):=0;
       consumoInexistente EXCEPTION;

BEGIN

SELECT COUNT(*)
INTO verifExistenciaRegas
FROM Operacao
WHERE designacaoOperacaoAgricola = 'Rega' AND EXTRACT(YEAR FROM dataOperacao) = p_ano_civil AND designacaoUnidade = 'min';

IF verifExistenciaRegas = 0 THEN
    RAISE consumoInexistente;
END IF;

OPEN listaConsumoCulturas FOR
    WITH TotalIrrigacao AS (
        SELECT CI.nomeParcela, CI.variedade, CI.nomeComum, CI.dataInicial AS data_inicial_cultura, EXTRACT(YEAR FROM O.dataOperacao) AS ano_operacao, SUM(O.quantidade) AS total_minutos
        FROM CulturaInstalada CI
        INNER JOIN PlanoRega PR ON CI.nomeParcela = PR.nomeParcela
            AND CI.variedade = PR.variedade
            AND CI.nomeComum = PR.nomeComum
            AND CI.dataInicial = PR.dataInicial
        INNER JOIN Setor S ON PR.designacaoSetor = S.designacaoSetor
        INNER JOIN Rega R ON S.designacaoSetor = R.designacaoSetor
        INNER JOIN Operacao O ON R.idOperacao = O.idOperacao
        WHERE O.designacaoOperacaoAgricola = 'Rega' OR O.designacaoOperacaoAgricola = 'Fertirrega'
            AND O.designacaoUnidade = 'min'
            AND EXTRACT(YEAR FROM O.dataOperacao) = p_ano_civil
        GROUP BY CI.nomeParcela, CI.variedade, CI.nomeComum, CI.dataInicial, EXTRACT(YEAR FROM O.dataOperacao)
    )
SELECT TI.nomeParcela, TI.variedade, TI.nomeComum,
       TI.data_inicial_cultura, TI.ano_operacao, TI.total_minutos
FROM TotalIrrigacao TI
WHERE (TI.total_minutos, TI.ano_operacao) IN (
    SELECT MAX(total_minutos), ano_operacao
    FROM TotalIrrigacao
    GROUP BY ano_operacao
);

RETURN listaConsumoCulturas;

EXCEPTION
    WHEN consumoInexistente THEN
        RAISE_APPLICATION_ERROR(-20001, 'Não existe consumo de água no ano civil indicado.');
END fncListaConsumoCulturas;
/

-----------------------------------------------
-----------------------------------------------
SET SERVEROUTPUT ON
-----------------------------------------------
--BLOCO ANONIMO--------------------------------
DECLARE
listaConsumoCulturas    SYS_REFCURSOR;
    v_nome_parcela          CulturaInstalada.nomeParcela%type;
    v_variedade             CulturaInstalada.variedade%type;
    v_nome_comum            CulturaInstalada.nomeComum%type;
    v_data_inicial          CulturaInstalada.dataInicial%type;
    v_total_minutos         Operacao.quantidade%type;
    v_ano_operacao          NUMBER;

BEGIN
    listaConsumoCulturas := fncListaConsumoCulturas(2023);

FETCH listaConsumoCulturas INTO v_nome_parcela, v_variedade, v_nome_comum, v_data_inicial, v_ano_operacao, v_total_minutos;

LOOP
    DBMS_OUTPUT.PUT_LINE('Nome da Parcela: ' || v_nome_parcela || ', Variedade: ' || v_variedade || ', Nome Comum: ' || v_nome_comum ||
                                        ', Data Inicial Cultura: ' || TO_CHAR(v_data_inicial, 'DD-MM-YYYY') || ', Ano das Operações: ' || v_ano_operacao ||
                                        ', Total de Minutos: ' || v_total_minutos);

    FETCH listaConsumoCulturas INTO v_nome_parcela, v_variedade, v_nome_comum, v_data_inicial, v_ano_operacao, v_total_minutos;
    EXIT WHEN listaConsumoCulturas%NOTFOUND;
END LOOP;

CLOSE listaConsumoCulturas;
END;
/

-----------------------------------------------
--TESTE----------------------------------------
--Para o ano 2023, onde existem Regas
--Logo o resultado será: TESTE PASSOU
DECLARE
testeFail                EXCEPTION;
    listaConsumoCulturas    SYS_REFCURSOR;
    v_nome_parcela          CulturaInstalada.nomeParcela%type;
    v_variedade             CulturaInstalada.variedade%type;
    v_nome_comum            CulturaInstalada.nomeComum%type;
    v_data_inicial          CulturaInstalada.dataInicial%type;
    v_total_minutos         Operacao.quantidade%type;
    v_ano_operacao          NUMBER;
    teste_ano_civil         NUMBER;

BEGIN
    teste_ano_civil := 2023;
    listaConsumoCulturas := fncListaConsumoCulturas(teste_ano_civil);

FETCH listaConsumoCulturas INTO v_nome_parcela, v_variedade, v_nome_comum, v_data_inicial, v_ano_operacao, v_total_minutos;

IF listaConsumoCulturas%ROWCOUNT = 0 THEN
       RAISE testeFail;
ELSE
    LOOP
        EXIT WHEN listaConsumoCulturas%NOTFOUND;
        IF(v_ano_operacao != teste_ano_civil) THEN
            RAISE testeFail;
    END IF;
        FETCH listaConsumoCulturas
            INTO v_nome_parcela, v_variedade, v_nome_comum, v_data_inicial, v_ano_operacao, v_total_minutos;
    END LOOP;
        DBMS_OUTPUT.PUT_LINE('TESTE PASSOU');
END IF;
CLOSE listaConsumoCulturas;

EXCEPTION
    WHEN testeFail THEN
    DBMS_OUTPUT.PUT_LINE('TESTE FALHOU');
END;
/

-----------------------------------------------
--TESTE----------------------------------------
--Para o ano 2020, onde não existem Regas
--Logo o resultado será: TESTE PASSOU
DECLARE
consumo_inexistente     EXCEPTION;
    PRAGMA EXCEPTION_INIT(consumo_inexistente, -20001);
    listaConsumoCulturas    SYS_REFCURSOR;
    v_nome_parcela          CulturaInstalada.nomeParcela%type;
    v_variedade             CulturaInstalada.variedade%type;
    v_nome_comum            CulturaInstalada.nomeComum%type;
    v_data_inicial          CulturaInstalada.dataInicial%type;
    v_total_minutos         Operacao.quantidade%type;
    v_ano_operacao          NUMBER;

BEGIN
    listaConsumoCulturas := fncListaConsumoCulturas(2020);

    FETCH listaConsumoCulturas INTO v_nome_parcela, v_variedade, v_nome_comum, v_data_inicial, v_ano_operacao, v_total_minutos;

    DBMS_OUTPUT.PUT_LINE('TESTE FALHOU - Não foi encontrada nenhuma exceção');

    CLOSE listaConsumoCulturas;

EXCEPTION
    WHEN consumo_inexistente THEN
        DBMS_OUTPUT.PUT_LINE('TESTE PASSOU - A exceção "consumoInexistente" foi encontrada');
END;
/