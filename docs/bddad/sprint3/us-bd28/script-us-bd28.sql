CREATE OR REPLACE TRIGGER triggerDeleteOperacao
BEFORE DELETE ON operacao
BEGIN
   RAISE_APPLICATION_ERROR(-20001, 'Deletion is not allowed. Status updated.');
END;
/
-----------------------------------------------------------------
CREATE OR REPLACE TRIGGER triggerDeleteRega
BEFORE DELETE ON rega
BEGIN
   RAISE_APPLICATION_ERROR(-20001, 'Deletion is not allowed. Status updated.');
END;
/
-----------------------------------------------------------------
CREATE OR REPLACE TRIGGER triggerDeleteOperacaoCultura
BEFORE DELETE ON operacaoCultura
BEGIN
   RAISE_APPLICATION_ERROR(-20001, 'Deletion is not allowed. Status updated.');
END;
/
-----------------------------------------------------------------
CREATE OR REPLACE TRIGGER triggerDeleteParcela
BEFORE DELETE ON operacaoParcela
BEGIN
   RAISE_APPLICATION_ERROR(-20001, 'Deletion is not allowed. Status updated.');
END;
/
-----------------------------------------------------------------
CREATE OR REPLACE TRIGGER triggerDeleteAplicacaoFator
BEFORE DELETE ON aplicacaoFatorProducao
BEGIN
   RAISE_APPLICATION_ERROR(-20001, 'Deletion is not allowed. Status updated.');
END;
/
