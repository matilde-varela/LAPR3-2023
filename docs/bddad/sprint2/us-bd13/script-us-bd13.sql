---------------------------------------------------
----------------------FUNÇÕES----------------------
---------------------------------------------------
CREATE OR REPLACE FUNCTION registarOperacaoColheita(p_des_operacao IN TipoOperacaoAgricola.designacaoOperacaoAgricola%TYPE,
                                                    p_des_unidade IN TipoUnidade.designacaoUnidade%TYPE,
                                                    p_quantidade IN NUMBER,
                                                    p_data_operacao IN DATE,
                                                    p_nome_parcela IN Parcela.nomeParcela%TYPE,
                                                    p_nome_comum IN Planta.nomeComum%TYPE,
                                                    p_variedade IN Planta.variedade%TYPE,
                                                    p_nome_produto IN Produto.nomeProduto%TYPE,
                                                    p_dataFinal IN DATE
) RETURN NUMBER IS
    l_success NUMBER := 1;
    datas SYS_REFCURSOR;
    dataInicio DATE;
    idOp NUMBER;
    operacaoInvalida EXCEPTION;
    culturaInvalida EXCEPTION;
    quantidadeInvalida EXCEPTION;

BEGIN
    BEGIN
        IF(verificarSeOperacaoExiste('Colheita', p_des_unidade, p_quantidade, p_data_operacao, p_nome_parcela, p_nome_comum, p_variedade) = 0 ) THEN
            datas := obterdatainicialcultura(p_nome_parcela, p_nome_comum, p_variedade);
            LOOP
                FETCH
                    datas
                    INTO
                        dataInicio;
                EXIT WHEN datas%NOTFOUND;
                IF(p_quantidade >= 0) THEN
                    IF(temDataFinal(p_nome_parcela, p_nome_comum, p_variedade, dataInicio)) THEN
                        RAISE culturaInvalida;
                    ELSE
                        idOp := novoIdOperacao();
                        IF p_dataFinal IS NULL THEN
                            INSERT INTO Operacao (idOperacao, designacaoOperacaoAgricola, designacaoUnidade, quantidade, dataOperacao)
                            VALUES (idOp, p_des_operacao, p_des_unidade, p_quantidade, p_data_operacao);
                            INSERT INTO OperacaoCultura (idOperacao, nomeParcela, dataInicial, nomeComum, variedade)
                            VALUES (idOp, p_nome_parcela, dataInicio, p_nome_comum, p_variedade);
                            INSERT INTO Colheita (idOperacao, nomeProduto)
                            VALUES (idOp, p_nome_produto);
                            l_success := 0;
                        ELSE
                            UPDATE CulturaInstalada
                            SET dataFinal = p_dataFinal
                            WHERE dataInicial = dataInicio
                              AND nomeParcela = p_nome_parcela
                              AND variedade = p_variedade
                              AND nomeComum = p_nome_comum;
                            INSERT INTO Operacao (idOperacao, designacaoOperacaoAgricola, designacaoUnidade, quantidade, dataOperacao)
                            VALUES (idOp, p_des_operacao, p_des_unidade, p_quantidade, p_data_operacao);
                            INSERT INTO OperacaoCultura (idOperacao, nomeParcela, dataInicial, nomeComum, variedade)
                            VALUES (idOp, p_nome_parcela, dataInicio, p_nome_comum, p_variedade);
                            INSERT INTO Colheita (idOperacao, nomeProduto)
                            VALUES (idOp, p_nome_produto);
                            l_success := 0;
                        END IF;
                    END IF;
                ELSE
                    RAISE quantidadeInvalida;
                END IF;
            END LOOP;
        ELSE
            RAISE operacaoInvalida;
        END IF;

        IF(l_success = 1) THEN
            ROLLBACK;
        ELSE
            COMMIT;
        END IF;

    EXCEPTION
        WHEN culturaInvalida THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20001, 'ERRO: A cultura selecionada já não se encontra na parcela selecionada.');
    WHEN quantidadeInvalida THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20001, 'ERRO: Não é possível colher a quantidade pretendida.');
    WHEN operacaoInvalida THEN
            ROLLBACK;
                RAISE_APPLICATION_ERROR(-20001, 'ERRO: Os dados introduzidos já existem no sistema.');
    WHEN OTHERS THEN
            ROLLBACK;
            l_success := 1;
    END;
RETURN l_success;
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
    END;
END;
/

----------------------------------------------------
CREATE OR REPLACE FUNCTION temDataFinal(nomePar IN parcela.nomeParcela%TYPE,
                                        nomeCom IN culturaInstalada.nomeComum%TYPE,
                                        vard IN culturaInstalada.variedade%TYPE,
                                        dataIni IN culturaInstalada.dataInicial%TYPE)
    RETURN BOOLEAN IS
    dataF CulturaInstalada.dataFinal%TYPE;
BEGIN
    BEGIN
    SELECT dataFinal INTO dataF
    FROM culturaInstalada
    WHERE nomeParcela = nomePar
      AND nomeComum = nomeCom
      AND variedade = vard
      AND dataInicial = dataIni;

if dataF is null then
        return false;
else
        RETURN TRUE;
end if;
EXCEPTION
        WHEN OTHERS THEN
            RETURN FALSE;
END;
END;
/



------------------------------------------------
------------------BLOCO ANÓNIMO-----------------
------------------------------------------------

SET SERVEROUTPUT ON;

DECLARE
    v_des_operacao1 TipoOperacaoAgricola.designacaoOperacaoAgricola%TYPE := 'Colheita';
    v_des_unidade1 TipoUnidade.designacaoUnidade%TYPE := 'kg';
    v_quantidade1 NUMBER := 123.0;
    v_data_operacao1 DATE := TO_DATE('27/11/2023', 'DD/MM/YYYY');
    v_nome_parcela1 parcela.nomeParcela%TYPE := 'Campo Novo';
    v_nome_comum1 Planta.nomeComum%TYPE := 'Tremoço';
    v_variedade1 Planta.variedade%TYPE := 'AMARELO';
    v_nome_produto1 Produto.nomeProduto%TYPE := 'Tremoço';
    v_dataFinal1 DATE := null;
    v_result1 NUMBER;
BEGIN
    v_result1 := registarOperacaoColheita(v_des_operacao1, v_des_unidade1, v_quantidade1, v_data_operacao1, v_nome_parcela1, v_nome_comum1, v_variedade1, v_nome_produto1, v_dataFinal1);

    IF v_result1 = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Operation registered successfully!');
ELSE
        DBMS_OUTPUT.PUT_LINE('Failed to register operation.');
END IF;
END;

--------------------------------------------------------------------------
--TESTE-------------------------------------------------------------------
DECLARE
    teste_des_operacao TipoOperacaoAgricola.designacaoOperacaoAgricola%TYPE := 'Colheita';
    teste_des_unidade TipoUnidade.designacaoUnidade%TYPE := 'kg';
    teste_quantidade NUMBER := -123.0;
    teste_data_operacao DATE := TO_DATE('27/11/2023', 'DD/MM/YYYY');
    teste_nome_parcela parcela.nomeParcela%TYPE := 'Campo Novo';
    teste_nome_comum Planta.nomeComum%TYPE := 'Tremoço';
    teste_variedade Planta.variedade%TYPE := 'AMARELO';
    teste_nome_produto Produto.nomeProduto%TYPE := 'Tremoço';
    teste_dataFinal DATE := null;
    teste_result NUMBER;
    failedTest EXCEPTION;
BEGIN
    DBMS_OUTPUT.PUT_LINE('TESTE DA QUANTIDADE: verifica que não regista operação com quantidade negativa.');
    teste_result := registarOperacaoColheita(teste_des_operacao, teste_des_unidade, teste_quantidade, teste_data_operacao, teste_nome_parcela, teste_nome_comum, teste_variedade, teste_nome_produto, teste_dataFinal);

    IF teste_result = 1 THEN
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
    teste_des_operacao TipoOperacaoAgricola.designacaoOperacaoAgricola%TYPE := 'Colheita';
    teste_des_unidade TipoUnidade.designacaoUnidade%TYPE := 'kg';
    teste_quantidade NUMBER := 123.0;
    teste_data_operacao DATE := TO_DATE('24/11/2023', 'DD/MM/YYYY');
    teste_nome_parcela parcela.nomeParcela%TYPE := 'Campo Novo';
    teste_nome_comum Planta.nomeComum%TYPE := 'Tremoço';
    teste_variedade Planta.variedade%TYPE := 'AMARELO';
    teste_nome_produto Produto.nomeProduto%TYPE := 'Tremoço';
    teste_dataFinal DATE := null;
    teste_result NUMBER;
    failedTest EXCEPTION;
BEGIN
    DBMS_OUTPUT.PUT_LINE('TESTE DA FUNÇÃO: verifica que operação é registada para parâmetros válidos.');
    teste_result := registarOperacaoColheita(teste_des_operacao, teste_des_unidade, teste_quantidade, teste_data_operacao, teste_nome_parcela, teste_nome_comum, teste_variedade, teste_nome_produto, teste_dataFinal);

    IF teste_result = 0 THEN
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
    teste_des_operacao TipoOperacaoAgricola.designacaoOperacaoAgricola%TYPE := 'Colheita';
    teste_des_unidade TipoUnidade.designacaoUnidade%TYPE := 'kg';
    teste_quantidade NUMBER := 123.0;
    teste_data_operacao DATE := TO_DATE('11/11/2023', 'DD/MM/YYYY');
    teste_nome_parcela parcela.nomeParcela%TYPE := 'Campo Novo';
    teste_nome_comum Planta.nomeComum%TYPE := 'Tremoço';
    teste_variedade Planta.variedade%TYPE := 'AMARELO';
    teste_nome_produto Produto.nomeProduto%TYPE := 'Tremoço';
    teste_dataFinal DATE := null;
    teste_result NUMBER;
    failedTest EXCEPTION;
BEGIN
    DBMS_OUTPUT.PUT_LINE('TESTE DA FUNÇÃO: verifica que operação é registada para parâmetros válidos.');
    teste_result := registarOperacaoColheita(teste_des_operacao, teste_des_unidade, teste_quantidade, teste_data_operacao, teste_nome_parcela, teste_nome_comum, teste_variedade, teste_nome_produto, teste_dataFinal);

    IF teste_result = 0 THEN
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
    teste_des_operacao TipoOperacaoAgricola.designacaoOperacaoAgricola%TYPE := 'Colheita';
    teste_des_unidade TipoUnidade.designacaoUnidade%TYPE := 'kg';
    teste_quantidade NUMBER := 1200.0;
    teste_data_operacao DATE := TO_DATE('12/08/2022', 'DD/MM/YYYY');
    teste_nome_parcela parcela.nomeParcela%TYPE := 'Campo Novo';
    teste_nome_comum Planta.nomeComum%TYPE := 'Vinha';
    teste_variedade Planta.variedade%TYPE := 'CARDINAL';
    teste_nome_produto Produto.nomeProduto%TYPE := 'Uvas';
    teste_dataFinal DATE := null;
    teste_result NUMBER;
    failedTest EXCEPTION;
BEGIN
    DBMS_OUTPUT.PUT_LINE('TESTE DA OPERAÇÃO EXISTENTE: verifica que não regista operação existente.');
    teste_result := registarOperacaoColheita(teste_des_operacao, teste_des_unidade, teste_quantidade, teste_data_operacao, teste_nome_parcela, teste_nome_comum, teste_variedade, teste_nome_produto, teste_dataFinal);

    IF teste_result = 1 THEN
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
    teste_des_operacao TipoOperacaoAgricola.designacaoOperacaoAgricola%TYPE := 'Colheita';
    teste_des_unidade TipoUnidade.designacaoUnidade%TYPE := 'kg';
    teste_quantidade NUMBER := 1200.0;
    teste_data_operacao DATE := TO_DATE('08/08/2023', 'DD/MM/YYYY');
    teste_nome_parcela parcela.nomeParcela%TYPE := 'Campo Novo';
    teste_nome_comum Planta.nomeComum%TYPE := 'Cenoura';
    teste_variedade Planta.variedade%TYPE := 'CARDINAL';
    teste_nome_produto Produto.nomeProduto%TYPE := 'DANVERS HALF LONG';
    teste_dataFinal DATE := null;
    teste_result NUMBER;
    failedTest EXCEPTION;
BEGIN
    DBMS_OUTPUT.PUT_LINE('TESTE DA CULTURA TERMINADA: verifica que não regista operação para cultura com data final, ou seja terminada.');
    teste_result := registarOperacaoColheita(teste_des_operacao, teste_des_unidade, teste_quantidade, teste_data_operacao, teste_nome_parcela, teste_nome_comum, teste_variedade, teste_nome_produto, teste_dataFinal);

    IF teste_result = 1 THEN
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
-------------------CONFIRMAÇÃO------------------
------------------------------------------------
select *
from  operacaoCultura oc
          inner join Operacao o
                     on oc.idoperacao = o.idoperacao
where o.designacaoOperacaoAgricola = 'Colheita'
order by dataoperacao DESC;
--||----||----||----||----||----||----||----||--
select * from culturaInstalada;
--||----||----||----||----||----||----||----||--
select * from colheita;
--||----||----||----||----||----||----||----||--