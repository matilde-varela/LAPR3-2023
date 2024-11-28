-----------------------------------------------
--FUNÇÃO---------------------------------------
CREATE OR REPLACE FUNCTION listaOperacoes(p_nomeParcela Parcela.nomeParcela%type,
                                          p_data_inicial Operacao.dataOperacao%type,
                                          p_data_final Operacao.dataOperacao%type)
    RETURN SYS_REFCURSOR IS
    listaOperacoesParcela SYS_REFCURSOR;

BEGIN
    OPEN listaOperacoesParcela FOR
        WITH Operacoes AS (SELECT nomeParcela,
                                  idOperacao
                           FROM (SELECT nomeParcela, idOperacao
                                 FROM OperacaoCultura
                                 UNION ALL
                                 SELECT nomeParcela, idOperacao
                                 FROM OperacaoParcela))

        SELECT OT.nomeParcela, O.designacaoOperacaoAgricola, O.quantidade, O.dataOperacao
        FROM Operacoes OT
                 INNER JOIN Operacao O
                            ON OT.idOperacao = O.idOperacao
                 INNER JOIN TipoOperacaoAgricola TOA
                            ON O.designacaoOperacaoAgricola = TOA.designacaoOperacaoAgricola
        WHERE OT.nomeParcela = p_nomeParcela
          AND O.dataOperacao BETWEEN p_data_inicial AND p_data_final
        ORDER BY OT.nomeParcela;

    RETURN listaOperacoesParcela;
END;
/
-----------------------------------------------
-----------------------------------------------
SET SERVEROUTPUT ON
-----------------------------------------------
--BLOCO ANONIMO--------------------------------
DECLARE
    listaOperacoesParcela      SYS_REFCURSOR;

    nomeParcela                Parcela.nomeParcela%type;
    designacaoOperacaoAgricola TipoOperacaoAgricola.designacaoOperacaoAgricola%type;
    quantidade                 Operacao.quantidade%type;
    dataOperacao               Operacao.dataOperacao%type;
    operacoesInexistente EXCEPTION;
BEGIN
    listaOperacoesParcela := listaOperacoes('Campo Novo', TO_DATE('01/07/2023', 'DD-MM-YYYY'),
                                            TO_DATE('02/10/2023','DD-MM-YYYY'));

    FETCH listaOperacoesParcela INTO nomeParcela, designacaoOperacaoAgricola, quantidade, dataOperacao;

    IF listaOperacoesParcela%ROWCOUNT = 0 THEN
        RAISE operacoesInexistente;
    ELSE
        DBMS_OUTPUT.PUT_LINE('PARCELA: ' || nomeParcela);
        DBMS_OUTPUT.PUT_LINE( RPAD('TIPO OPERAÇÃO',30, ' ') || '|  ' || RPAD('QUANTIDADE',20, ' ') ||  '|  ' || RPAD('DATA OPERAÇÃO',20, ' '));
        LOOP
            EXIT WHEN listaOperacoesParcela%notfound;
            IF( quantidade < 1) THEN
                DBMS_OUTPUT.PUT_LINE(RPAD(designacaoOperacaoAgricola,30, ' ') || '|  ' || RPAD(TO_CHAR(quantidade,'FM99999990.9999'),20, ' ') ||  '|  ' || RPAD(dataOperacao,20, ' '));
            ELSE
                DBMS_OUTPUT.PUT_LINE(RPAD(designacaoOperacaoAgricola,30, ' ') || '|  ' || RPAD(quantidade,20, ' ') ||  '|  ' || RPAD(dataOperacao,20, ' '));
            END IF;
            FETCH listaOperacoesParcela INTO nomeParcela, designacaoOperacaoAgricola, quantidade, dataOperacao;
        END LOOP;
    END IF;

    CLOSE listaOperacoesParcela;
EXCEPTION
    WHEN operacoesInexistente THEN
        RAISE_APPLICATION_ERROR(-20001, 'Não existem operações no período indicado.');
END;
/
-----------------------------------------------
--TESTE----------------------------------------
-- Verifica se a função retorna as operações apenas da parcela que pretendemos e se as datas das operações estão dentro do intervalo definido.
DECLARE
    listaOperacoesParcela      SYS_REFCURSOR;
    nomeParcela                Parcela.nomeParcela%type;
    designacaoOperacaoAgricola TipoOperacaoAgricola.designacaoOperacaoAgricola%type;
    quantidade                 Operacao.quantidade%type;
    dataOperacao               Operacao.dataOperacao%type;
    test_nomeParcela   Parcela.nomeParcela%type;
    test_dataInicial   Operacao.dataOperacao%type;
    test_dataFinal     Operacao.dataOperacao%type;
    failedTest EXCEPTION;
BEGIN
    nomeParcela := 'Lameiro da ponte';
    test_nomeParcela := 'Lameiro da ponte';
    test_dataInicial := TO_DATE('2016-10-05', 'YYYY-MM-DD');
    test_dataFinal   := TO_DATE('2020-10-11', 'YYYY-MM-DD');

    listaOperacoesParcela := listaOperacoes('Lameiro da ponte', TO_DATE('2016-10-05', 'YYYY-MM-DD'),
                                            TO_DATE('2020-10-11', 'YYYY-MM-DD'));

    FETCH listaOperacoesParcela INTO nomeParcela, designacaoOperacaoAgricola, quantidade, dataOperacao;

    IF listaOperacoesParcela%ROWCOUNT = 0 THEN
        RAISE failedTest;
    ELSE
        LOOP
            EXIT WHEN listaOperacoesParcela%notfound;
            IF(nomeParcela != test_nomeParcela) THEN
                RAISE failedTest;
            END IF;
            IF( NOT dataOperacao  BETWEEN test_dataInicial AND  test_dataFinal) THEN
                RAISE failedTest;
            END IF;
            FETCH listaOperacoesParcela INTO nomeParcela, designacaoOperacaoAgricola, quantidade, dataOperacao;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('TESTE PASSOU');
    END IF;

    CLOSE listaOperacoesParcela;
EXCEPTION
    WHEN failedTest THEN
        DBMS_OUTPUT.PUT_LINE('TESTE FALHOU');
END;
/

-----------------------------------------------
--EXEMPLO OUTPUT-------------------------------

-- PARCELA: Campo Novo
-- TIPO OPERAÇÃO                 |  QUANTIDADE          |  DATA OPERAÇÃO
-- Rega                          |  120                 |  23.07.08 - 04:00
-- Rega                          |  120                 |  23.07.15 - 04:00
-- Rega                          |  150                 |  23.07.22 - 04:00
-- Rega                          |  150                 |  23.07.29 - 04:00
-- Rega                          |  120                 |  23.08.05 - 21:30
-- Rega                          |  120                 |  23.08.12 - 21:30
-- Rega                          |  120                 |  23.08.19 - 21:30
-- Rega                          |  120                 |  23.08.26 - 21:30
-- Rega                          |  120                 |  23.08.31 - 21:30
-- Rega                          |  120                 |  23.09.05 - 21:30
-- Rega                          |  120                 |  23.07.09 - 06:20
-- Rega                          |  120                 |  23.07.16 - 06:20
-- Rega                          |  120                 |  23.07.23 - 06:20
-- Rega                          |  120                 |  23.07.30 - 06:20
-- Rega                          |  120                 |  23.08.07 - 06:20
-- Rega                          |  120                 |  23.08.14 - 06:20
-- Rega                          |  120                 |  23.08.21 - 06:20
-- Rega                          |  120                 |  23.08.28 - 06:20
-- Rega                          |  120                 |  23.09.06 - 06:20
-- Rega                          |  120                 |  23.09.13 - 07:00
-- Rega                          |  120                 |  23.09.20 - 07:00
-- Colheita                      |  8000                |  23.09.15 - 00:00
-- Colheita                      |  5000                |  23.09.25 - 00:00
-- Colheita                      |  900                 |  23.09.18 - 00:00
-- Colheita                      |  1500                |  23.09.22 - 00:00
-- Aplicação de fator de produção|  1800                |  23.07.03 - 00:00
-- Semeadura                     |  1,2                 |  23.07.05 - 00:00
-- Monda                         |  0.5                 |  23.08.08 - 00:00
-- Mobilização do solo           |  0.5                 |  23.07.04 - 00:00