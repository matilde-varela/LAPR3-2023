-----------------------------------------------
--FUNÇÃO---------------------------------------
CREATE OR REPLACE FUNCTION fncListaComponentesFatores(p_nome_parcela Parcela.nomeParcela%TYPE,
                                                      p_data_inicial Operacao.dataOperacao%TYPE,
                                                      p_data_final Operacao.dataOperacao%TYPE)
    RETURN SYS_REFCURSOR IS
    listaComponentesParcela SYS_REFCURSOR;

BEGIN
OPEN listaComponentesParcela FOR
        WITH Operacoes AS (
            SELECT DISTINCT nomeParcela, idOperacao
            FROM (
                SELECT oc.nomeParcela, oc.idOperacao
                FROM OperacaoCultura oc
                UNION ALL
                SELECT opp.nomeParcela, opp.idOperacao
                FROM OperacaoParcela opp
            )
        ), Fatores AS (
            SELECT ops.nomeParcela as NOME_PARCELA,
                   op.quantidade as QUANTIDADE_FATOR,
     			   afp.nomeComercial as NOME_COMERCIAL,
                   cq.formulaQuimica as COMPONENTE,
                   cq.quantidade as QUANTIDADE
            FROM Operacoes ops
            INNER JOIN Operacao op ON ops.idOperacao = op.idOperacao
            INNER JOIN AplicacaoFatorProducao afp ON op.idOperacao = afp.idOperacao
            INNER JOIN FatorProducao f ON afp.nomeComercial = f.nomeComercial
            INNER JOIN ConstituicaoQuimica cq ON f.nomeComercial = cq.nomeComercial
            WHERE ops.nomeParcela = p_nome_parcela
            AND op.dataOperacao BETWEEN p_data_inicial AND p_data_final
        )
SELECT fs.NOME_PARCELA,
       fs.NOME_COMERCIAL,
       fs.COMPONENTE,
       SUM((fs.QUANTIDADE * fs.QUANTIDADE_FATOR) / 100) as QUANTIDADE_ELEMENTO
FROM Fatores fs
GROUP BY fs.NOME_PARCELA, fs.NOME_COMERCIAL, fs.COMPONENTE
ORDER BY fs.NOME_PARCELA, fs.NOME_COMERCIAL, fs.COMPONENTE;

RETURN listaComponentesParcela;
END;
/
-----------------------------------------------
-----------------------------------------------
SET SERVEROUTPUT ON
-----------------------------------------------
--BLOCO ANONIMO--------------------------------
DECLARE
aplicacaoFatorProducaoInexistente   EXCEPTION;
    listaComponentesParcela             SYS_REFCURSOR;
    v_nome_Parcela                      Parcela.nomeParcela%type;
	v_nome_comercial                    AplicacaoFatorProducao.nomeComercial%type;
    v_componente                        ConstituicaoQuimica.formulaQuimica%type;
    v_quantidade                        ConstituicaoQuimica.quantidade%type;
BEGIN
    listaComponentesParcela := fncListaComponentesFatores('Lameiro do moinho',TO_DATE('01/01/2019', 'DD/MM/YYYY'), TO_DATE('06/07/2023', 'DD/MM/YYYY'));

FETCH listaComponentesParcela INTO v_nome_Parcela, v_nome_comercial, v_componente, v_quantidade;

    IF listaComponentesParcela%ROWCOUNT = 0 THEN
            RAISE  aplicacaoFatorProducaoInexistente;
    ELSE
            DBMS_OUTPUT.PUT_LINE('PARCELA: ' || v_nome_parcela);
            DBMS_OUTPUT.PUT_LINE( RPAD('NOME COMERCIAL',28, ' ') || '|  ' || RPAD('COMPONENTE',20, ' ') ||  '|  ' || RPAD('QUANTIDADE (kg)',20, ' '));
            LOOP
                DBMS_OUTPUT.PUT_LINE(RPAD(v_nome_comercial,28, ' ') || '|  ' || RPAD(v_componente,20, ' ') ||  '|  ' || RPAD(v_quantidade,20, ' '));
                FETCH listaComponentesParcela
                    INTO v_nome_Parcela, v_nome_comercial, v_componente, v_quantidade;
                EXIT WHEN  listaComponentesParcela%NOTFOUND;
            END LOOP;
    END IF;
    CLOSE listaComponentesParcela;

EXCEPTION
    WHEN aplicacaoFatorProducaoInexistente THEN
        RAISE_APPLICATION_ERROR(-20001, 'Não existem aplicações de fator produção no período indicado.');
END;
/


-----------------------------------------------
--TESTE----------------------------------------
-- Verifica se a função retorna os componentes quimicos e as suas quantidade para a parcela selecionada e entre as datas selecionadas.
DECLARE
testeFail                EXCEPTION;
    listaComponentesParcela  SYS_REFCURSOR;
    v_nome_Parcela           Parcela.nomeParcela%type;
	v_nome_comercial         AplicacaoFatorProducao.nomeComercial%type;
    v_componente             ConstituicaoQuimica.formulaQuimica%type;
    v_quantidade             ConstituicaoQuimica.quantidade%type;
    teste_nome_Parcela       Parcela.nomeParcela%type;
    teste_data_inicial       Operacao.dataOperacao%type;
    teste_data_final         Operacao.dataOperacao%type;
BEGIN
    v_nome_Parcela := 'Campo Novo';
    teste_nome_Parcela := 'Campo Novo';
    teste_data_inicial := TO_DATE('2016-10-05', 'YYYY-MM-DD');
    teste_data_final :=  TO_DATE('2023-10-11', 'YYYY-MM-DD');
    listaComponentesParcela := fncListaComponentesFatores('Campo Novo',TO_DATE('2016-10-05', 'YYYY-MM-DD'), TO_DATE('2023-10-11', 'YYYY-MM-DD'));

FETCH listaComponentesParcela INTO v_nome_Parcela, v_nome_comercial, v_componente, v_quantidade;

IF listaComponentesParcela%ROWCOUNT = 0 THEN
        RAISE testeFail;
ELSE
        LOOP
            EXIT WHEN listaComponentesParcela%NOTFOUND;
            IF(v_nome_Parcela != teste_nome_Parcela) THEN
                RAISE testeFail;
END IF;
FETCH listaComponentesParcela
    INTO v_nome_Parcela, v_nome_comercial, v_componente, v_quantidade;
END LOOP;
        DBMS_OUTPUT.PUT_LINE('TESTE PASSOU');
END IF;
CLOSE listaComponentesParcela;

EXCEPTION
    WHEN testeFail THEN
    DBMS_OUTPUT.PUT_LINE('TESTE FALHOU');
END;
/

-----------------------------------------------
--EXEMPLO OUTPUT-------------------------------
--PARCELA: Lameiro do moinho
--NOME COMERCIAL              |  COMPONENTE          |  QUANTIDADE (kg)
--BIOFERTIL N6                |  B                   |  ,00078
--BIOFERTIL N6                |  Ca                  |  23,34
--BIOFERTIL N6                |  K2O                 |  93,36
--BIOFERTIL N6                |  Matéria Orgânica    |  2061,7
--BIOFERTIL N6                |  MgO                 |  11,67
--BIOFERTIL N6                |  N                   |  248,96
--BIOFERTIL N6                |  P2O5                |  97,25
--EPSO Microtop               |  B                   |  ,207
--EPSO Microtop               |  Mg                  |  2,07
--EPSO Microtop               |  Mn                  |  ,23
--EPSO Microtop               |  S                   |  2,852
--Fertimax Extrume de Cavalo  |  B                   |  ,00046
--Fertimax Extrume de Cavalo  |  Ca                  |  18,4
--Fertimax Extrume de Cavalo  |  K2O                 |  4,6
--Fertimax Extrume de Cavalo  |  Matéria Orgânica    |  575
--Fertimax Extrume de Cavalo  |  MgO                 |  3,45
--Fertimax Extrume de Cavalo  |  N                   |  34,5
--Fertimax Extrume de Cavalo  |  P2O5                |  9,2
