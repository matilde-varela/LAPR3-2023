SET SERVEROUTPUT ON;

-----------------------Obter os Dados-----------------------
CREATE OR REPLACE FUNCTION obterAplicacaoFatoresProducao(
    dataInicial IN operacao.dataoperacao%TYPE,
    dataFinal IN operacao.dataoperacao%TYPE,
    nomePar IN Parcela.nomeParcela%TYPE
) RETURN SYS_REFCURSOR IS
    listaAplicacaoFatoresProducao SYS_REFCURSOR;
BEGIN
    OPEN listaAplicacaoFatoresProducao FOR
        WITH allops AS (
            SELECT idoperacao, nomeparcela, nomecomum, variedade
            FROM operacaocultura
            UNION
            SELECT idoperacao, nomeparcela, 'Todas' AS nomecomum, 'Todas' AS variedade
            FROM operacaoparcela
        )
        SELECT fp.classificacao, afp.nomecomercial, allop.nomeparcela, allop.nomecomum, allop.variedade, op.dataoperacao
        FROM aplicacaofatorproducao afp
                 INNER JOIN allops allop ON allop.idoperacao = afp.idoperacao
                 INNER JOIN operacao op ON op.idoperacao = afp.idoperacao
                 INNER JOIN fatorproducao fp ON fp.nomecomercial = afp.nomecomercial
        WHERE op.dataoperacao BETWEEN dataInicial AND dataFinal
          AND allop.nomeParcela = nomePar
        ORDER BY fp.classificacao, op.dataoperacao;

    RETURN listaAplicacaoFatoresProducao;
END;
/

-----------------------Mostrar os Dados--------------------------
DECLARE
    listaFatoresParcela SYS_REFCURSOR;
    a_classificacao fatorproducao.classificacao%TYPE;
    a_nomecomercial aplicacaofatorproducao.nomecomercial%TYPE;
    a_nomeparcela operacaocultura.nomeparcela%TYPE;
    a_nomecomum operacaocultura.nomecomum%TYPE;
    a_variedade operacaocultura.variedade%TYPE;
    a_dataoperacao operacao.dataoperacao%TYPE;

    aplicacaoFatorProducaoInexistente EXCEPTION;
BEGIN
    listaFatoresParcela := obterAplicacaoFatoresProducao(TO_DATE('2019-01-01', 'YYYY-MM-DD'), TO_DATE('2023-07-06', 'YYYY-MM-DD'),'Lameiro do moinho');

    FETCH listaFatoresParcela INTO a_classificacao, a_nomecomercial, a_nomeparcela, a_nomecomum, a_variedade, a_dataoperacao;

    IF listaFatoresParcela%ROWCOUNT = 0 THEN
        RAISE aplicacaoFatorProducaoInexistente;
    ELSE
        DBMS_OUTPUT.PUT_LINE(' | Classificacao | Nome Comercial | Nome Parcela | Nome Comum  | Variedade | ' || 'Data Operação'|| ' | ');
        LOOP
            DBMS_OUTPUT.PUT_LINE(' | ' ||a_classificacao || ' | ' || a_nomecomercial || ' | ' || a_nomeparcela || ' | ' || a_nomecomum || ' | ' || a_variedade || ' | ' || a_dataoperacao|| ' | ');
            FETCH listaFatoresParcela INTO a_classificacao, a_nomecomercial, a_nomeparcela, a_nomecomum, a_variedade, a_dataoperacao;
            EXIT WHEN listaFatoresParcela%NOTFOUND;
        END LOOP;
    END IF;

    CLOSE listaFatoresParcela;

EXCEPTION
    WHEN aplicacaoFatorProducaoInexistente THEN
        RAISE_APPLICATION_ERROR(-20001, 'Não existem aplicações de fator produção no período indicado.');
END;
/