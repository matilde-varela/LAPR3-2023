--------------------------------------------------------------------------
--TRIGGERS----------------------------------------------------------------
CREATE OR REPLACE TRIGGER preventUpdateDeleteLog
BEFORE UPDATE OR DELETE ON Log
    FOR EACH ROW
BEGIN
    RAISE_APPLICATION_ERROR(-20001, 'Ação não permitida. Atualizações ou exclusões na tabela Log são proibidas.');
END;
/


--------------------------------------
--Insert para testar depois o UPDATE e o DELETE
INSERT INTO LOG (idRegistoLog, idOperacao, designacaoOperacaoAgricola, designacaoUnidade, idEstadoOperacao, quantidade, dataOperacao, dadosAdicionais) VALUES (TO_DATE('02/09/2023 - 23:00', 'DD/MM/YYYY - HH24:MI'), 120, 'Rega', 'min', 1, 111, TO_DATE('02/07/2023 - 23:00', 'DD/MM/YYYY - HH24:MI'), 'SOMETHING');
/


--------------------------------------------------------------------------
--FUNÇÃO------------------------------------------------------------------
--Tentar dar update na tabela Log
CREATE OR REPLACE FUNCTION fncUpdateInLog(p_idRegistoLog IN DATE)
    RETURN VARCHAR2
    IS v_result VARCHAR2(100);
BEGIN
    UPDATE Log
    SET dadosAdicionais = 'NOTHING'
    WHERE idRegistoLog = p_idRegistoLog;

    v_result := 'Atualização realizada com sucesso.';
RETURN v_result;
EXCEPTION
    WHEN OTHERS THEN
        v_result := 'Erro ao atualizar o registro na tabela Log.';
RETURN v_result;
END;
/


--------------------------------------------------------------------------
--TESTE-------------------------------------------------------------------
--Verifica se é efetuado o UPDATE na tabela log.
SET SERVEROUTPUT ON;

DECLARE
v_idRegistoLog DATE := TO_DATE('02/09/2023 - 23:00', 'DD/MM/YYYY - HH24:MI');
    result VARCHAR2(100);
BEGIN
    result := fncUpdateInLog(v_idRegistoLog);
    DBMS_OUTPUT.PUT_LINE(result);
END;
/

--------------------------------------------------------------------------
--FUNÇÃO------------------------------------------------------------------
--Tentar dar delete na tabela Log
CREATE OR REPLACE FUNCTION fncDeleteInLog(p_idRegistoLog IN DATE)
    RETURN VARCHAR2
    IS v_result VARCHAR2(100);
BEGIN
    DELETE FROM Log
    WHERE idRegistoLog = p_idRegistoLog;

    v_result := 'Registro excluído com sucesso.';
    RETURN v_result;
EXCEPTION
    WHEN OTHERS THEN
        v_result := 'Erro ao excluir o registro na tabela Log.';
RETURN v_result;
END;
/

--------------------------------------------------------------------------
--TESTE-------------------------------------------------------------------
--Verifica se é efetuado o DELETE na tabela log.
SET SERVEROUTPUT ON;

DECLARE
    v_idRegistoLog DATE := TO_DATE('02/09/2023 - 23:00', 'DD/MM/YYYY - HH24:MI');
    result VARCHAR2(100);
BEGIN
    result := fncDeleteInLog(v_idRegistoLog);
    DBMS_OUTPUT.PUT_LINE(result);
END;
/