--------------------------------------------------------------------------
--<Caso de sucesso>-----------------------------------------------------------------
DECLARE
    v_idOp NUMBER;
    v_proxIdOp NUMBER;
    v_discrepancia_encontrada NUMBER := 0;
    v_IDs_cursor SYS_REFCURSOR;
BEGIN
    OPEN v_IDs_cursor FOR
        SELECT idOperacao
        FROM Operacao
        ORDER BY idOperacao;

    FETCH v_IDs_cursor INTO v_idOp;

    LOOP
        FETCH v_IDs_cursor INTO v_proxIdOp;
        IF (v_proxIdOp != v_idOp + 1) AND (v_proxIdOp != v_idOp) THEN
            DBMS_OUTPUT.PUT_LINE('Falha encontrada na sequência de IDs: ' || v_idOp || ' - ' || v_proxIdOp);
            v_discrepancia_encontrada := 1;
        END IF;
        v_idOp := v_proxIdOp;
        EXIT WHEN v_IDs_cursor%NOTFOUND;
    END LOOP;

    IF v_discrepancia_encontrada = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Não foram encontradas discrepâncias na sequência de IDs.');
    END IF;

    CLOSE v_IDs_cursor;
END;
/
--------------------------------------------------------------------------
--TESTE 1-----------------------------------------------------------------
--Verificar se o número da operação é sequencial
--Criação (com sucesso) de duas operacoes
DECLARE
    v_idMaxAntigo                    NUMBER;
    v_idOp1                          NUMBER;
    v_idOp2                          NUMBER;
    v_idMaxNovo                      NUMBER;
    v_op1_success                    NUMBER;
    v_op2_success                    NUMBER;
    v_op1_designacaoOperacaoAgricola tipoOperacaoAgricola.designacaoOperacaoAgricola%TYPE := 'Rega';
    v_op1_designacaoUnidade          tipoUnidade.DESIGNACAOUNIDADE%TYPE                   := 'm2';
    v_op1_idEstadoOperacao           EstadoOperacao.idEstadoOperacao%TYPE                 := 0;
    v_op1_quantidade                 NUMBER                                               := 2.8;
    v_op1_dataOperacao               DATE                                                 := TO_DATE('15/10/2024', 'DD/MM/YYYY');
    v_op1_registo                    TIMESTAMP                                            := TO_TIMESTAMP('15/10/2024 14:10:00', 'DD/MM/YYYY HH24:MI:SS');
    v_op2_designacaoOperacaoAgricola tipoOperacaoAgricola.designacaoOperacaoAgricola%TYPE := 'Monda';
    v_op2_designacaoUnidade          tipoUnidade.DESIGNACAOUNIDADE%TYPE                   := 'ha';
    v_op2_idEstadoOperacao           EstadoOperacao.idEstadoOperacao%TYPE                 := 0;
    v_op2_quantidade                 NUMBER                                               := 0.7;
    v_op2_dataOperacao               DATE                                                 := TO_DATE('09/09/2024', 'DD/MM/YYYY');
    v_op2_registo                    TIMESTAMP                                            := TO_TIMESTAMP('09/09/2024 08:09:00', 'DD/MM/YYYY HH24:MI:SS');

BEGIN

    SELECT NVL(MAX(idOperacao), 0)
    INTO v_idMaxAntigo
    FROM Operacao;

    DBMS_OUTPUT.PUT_LINE('ID mais recente (antes dos registos): ' || v_idMaxAntigo);

    --Op1
    v_op1_success := registarOperacao(v_op1_designacaoOperacaoAgricola,
                                      v_op1_designacaoUnidade,
                                      v_op1_idEstadoOperacao,
                                      v_op1_quantidade,
                                      v_op1_dataOperacao,
                                      v_op1_registo);

    --Op2
    v_op2_success := registarOperacao(v_op2_designacaoOperacaoAgricola,
                                      v_op2_designacaoUnidade,
                                      v_op2_idEstadoOperacao,
                                      v_op2_quantidade,
                                      v_op2_dataOperacao,
                                      v_op2_registo);
    --Op1 - ID
    v_idOp1 := obterIdOperacao(v_op1_designacaoOperacaoAgricola,
                               v_op1_designacaoUnidade,
                               v_op1_idEstadoOperacao,
                               v_op1_quantidade,
                               v_op1_dataOperacao,
                               v_op1_registo);
    --Op2 - ID
    v_idOp2 := obterIdOperacao(v_op2_designacaoOperacaoAgricola,
                               v_op2_designacaoUnidade,
                               v_op2_idEstadoOperacao,
                               v_op2_quantidade,
                               v_op2_dataOperacao,
                               v_op2_registo);

    SELECT NVL(MAX(idOperacao), 0)
    INTO v_idMaxNovo
    FROM Operacao;

    DBMS_OUTPUT.PUT_LINE('ID mais recente (depois dos registos): ' || v_idMaxNovo);

    IF (v_op1_success = 0 AND v_op2_success = 0) OR (v_idMaxNovo = v_idMaxAntigo) OR (v_idOp2 != (v_idOp1 + 1)) THEN
        DBMS_OUTPUT.PUT_LINE('O teste falhou.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('ID da Operacao 1: ' || v_idOp1);
        DBMS_OUTPUT.PUT_LINE('ID da Operacao 2: ' || v_idOp2);
        DBMS_OUTPUT.PUT_LINE('O teste passou.');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('O teste falhou.');
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/
--------------------------------------------------------------------------
--TESTE 2-----------------------------------------------------------------
--Verificar se não existem buracos na sequência dos ID das operações
--Criar 3 operações -> 1º com sucesso, 2ª sem sucesso, 3ª com sucesso
DECLARE
    v_idMaxAntigo                    NUMBER;
    v_idOp1                          NUMBER;
    v_idOp2                          NUMBER;
    v_idOp3                          NUMBER;
    v_idMaxNovo                      NUMBER;
    v_op1_success                    NUMBER                                               := 0;
    v_op2_success                    NUMBER                                               := 0;
    v_op3_success                    NUMBER                                               := 0;
    v_op1_designacaoOperacaoAgricola tipoOperacaoAgricola.designacaoOperacaoAgricola%TYPE := 'Rega';
    v_op1_designacaoUnidade          tipoUnidade.DESIGNACAOUNIDADE%TYPE                   := 'm2';
    v_op1_idEstadoOperacao           EstadoOperacao.idEstadoOperacao%TYPE                 := 0;
    v_op1_quantidade                 NUMBER                                               := 2.8;
    v_op1_dataOperacao               DATE                                                 := TO_DATE('17/10/2024', 'DD/MM/YYYY');
    v_op1_registo                    TIMESTAMP                                            := TO_TIMESTAMP('17/10/2024 14:10:00', 'DD/MM/YYYY HH24:MI:SS');
    v_op2_designacaoOperacaoAgricola tipoOperacaoAgricola.designacaoOperacaoAgricola%TYPE := 'Monda';
    v_op2_designacaoUnidade          tipoUnidade.DESIGNACAOUNIDADE%TYPE                   := 'ha';
    v_op2_idEstadoOperacao           EstadoOperacao.idEstadoOperacao%TYPE                 := 0;
    v_op2_quantidade                 NUMBER                                               := 0;
    v_op2_dataOperacao               DATE                                                 := TO_DATE('11/09/2024', 'DD/MM/YYYY');
    v_op2_registo                    TIMESTAMP                                            := TO_TIMESTAMP('11/09/2024 08:09:00', 'DD/MM/YYYY HH24:MI:SS');
    v_op3_designacaoOperacaoAgricola tipoOperacaoAgricola.designacaoOperacaoAgricola%TYPE := 'Colheita';
    v_op3_designacaoUnidade          tipoUnidade.DESIGNACAOUNIDADE%TYPE                   := 'kg';
    v_op3_idEstadoOperacao           EstadoOperacao.idEstadoOperacao%TYPE                 := 0;
    v_op3_quantidade                 NUMBER                                               := 150.5;
    v_op3_dataOperacao               DATE                                                 := TO_DATE('21/10/2024', 'DD/MM/YYYY');
    v_op3_registo                    TIMESTAMP                                            := TO_TIMESTAMP('21/10/2024 11:30:00', 'DD/MM/YYYY HH24:MI:SS');
    v_num_op_da_ser_registada        NUMBER                                               := 0;

BEGIN
    SELECT NVL(MAX(idOperacao), 0) INTO v_idMaxAntigo FROM Operacao;

    DBMS_OUTPUT.PUT_LINE('ID mais recente (antes dos registos): ' || v_idMaxAntigo);

    v_num_op_da_ser_registada := v_num_op_da_ser_registada + 1;
    --Op1
    v_op1_success := registarOperacao(v_op1_designacaoOperacaoAgricola,
                                      v_op1_designacaoUnidade,
                                      v_op1_idEstadoOperacao,
                                      v_op1_quantidade,
                                      v_op1_dataOperacao,
                                      v_op1_registo);

    -- Op1 - ID
    v_idOp1 := obterIdOperacao(v_op1_designacaoOperacaoAgricola,
                               v_op1_designacaoUnidade,
                               v_op1_idEstadoOperacao,
                               v_op1_quantidade,
                               v_op1_dataOperacao,
                               v_op1_registo);

    v_num_op_da_ser_registada := v_num_op_da_ser_registada + 1;
    --Op2
    v_op2_success := registarOperacao(v_op2_designacaoOperacaoAgricola,
                                      v_op2_designacaoUnidade,
                                      v_op2_idEstadoOperacao,
                                      v_op2_quantidade,
                                      v_op2_dataOperacao,
                                      v_op2_registo);

    -- Op2 - ID
    v_idOp2 := obterIdOperacao(v_op2_designacaoOperacaoAgricola,
                               v_op2_designacaoUnidade,
                               v_op2_idEstadoOperacao,
                               v_op2_quantidade,
                               v_op2_dataOperacao,
                               v_op2_registo);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('A operacao ' || v_num_op_da_ser_registada || ' não foi registada na base de dados.');
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        DBMS_OUTPUT.PUT_LINE('ID da primeira operacao:' || v_idOp1);
        DBMS_OUTPUT.PUT_LINE('A registar a terceira operacao.');

        v_num_op_da_ser_registada := v_num_op_da_ser_registada + 1;
        --Op3
        v_op3_success := registarOperacao(v_op3_designacaoOperacaoAgricola,
                                          v_op3_designacaoUnidade,
                                          v_op3_idEstadoOperacao,
                                          v_op3_quantidade,
                                          v_op3_dataOperacao,
                                          v_op3_registo);

        -- Op3 - ID
        v_idOp3 := obterIdOperacao(v_op3_designacaoOperacaoAgricola,
                                   v_op3_designacaoUnidade,
                                   v_op3_idEstadoOperacao,
                                   v_op3_quantidade,
                                   v_op3_dataOperacao,
                                   v_op3_registo);

        DBMS_OUTPUT.PUT_LINE('ID da terceira operacao:' || v_idOp3);

        SELECT NVL(MAX(idOperacao), 0) INTO v_idMaxNovo FROM Operacao;
        DBMS_OUTPUT.PUT_LINE('ID mais recente (depois dos registos): ' || v_idMaxNovo);

        IF (v_op1_success = 1 AND v_op2_success = 0 AND v_op3_success = 1) AND (v_idMaxNovo = v_idMaxAntigo + 2) AND
           (v_idOp3 = v_idOp1 + 1) THEN
            DBMS_OUTPUT.PUT_LINE('O teste passou.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('O teste falhou.');
        END IF;

END;
/
--------------------------------------------------------------------------