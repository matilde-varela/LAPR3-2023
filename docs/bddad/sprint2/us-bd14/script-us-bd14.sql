SET SERVEROUTPUT ON;
-------Função em si--------
CREATE OR REPLACE FUNCTION RegistoAplicacaoFatorProducao(desigOp IN tipoOperacaoAgricola.designacaoOperacaoAgricola%TYPE,
                                                         desigUnidade IN tipoUnidade.designacaoUnidade%TYPE,
                                                         qtd IN NUMBER,
                                                         dataOp IN DATE,
                                                         nmFator IN aplicacaofatorproducao.nomecomercial%TYPE,
                                                         nmParcela IN operacaocultura.nomeparcela%TYPE,
                                                         dataIni IN operacaocultura.datainicial%TYPE,
                                                         nmComum IN operacaocultura.nomecomum%TYPE,
                                                         varie IN operacaocultura.variedade%TYPE
) RETURN NUMBER IS
    resultado NUMBER := 0;
    idOp NUMBER;
    invalidOperacao EXCEPTION;
    invalidInputs EXCEPTION;
BEGIN
    BEGIN
    idOp := novoIdOperacao();

    IF NOT verificarDadosDeInsercao(desigOp, desigUnidade, qtd, dataOp, nmFator) THEN
        RAISE invalidInputs;
    ELSE
        IF verificarSeAplicacaoFatorProducaoExiste(desigOp, desigUnidade, qtd, dataOp, nmFator) = 0 THEN
            BEGIN
                INSERT INTO operacao (idOperacao, designacaoOperacaoAgricola, designacaoUnidade, quantidade, dataOperacao)
                VALUES (idOp, desigOp, desigUnidade, qtd, dataOp);

                INSERT INTO operacaocultura (idOperacao, nomeParcela, dataInicial, nomeComum, variedade)
                VALUES (idOp, nmParcela, dataIni, nmComum, varie);

                INSERT INTO aplicacaofatorproducao (nomecomercial, idoperacao)
                VALUES (nmFator, idOp);

                INSERT INTO operacaoparcela (idOperacao, nomeParcela)
                VALUES (idOp, nmParcela);

            EXCEPTION
                WHEN OTHERS THEN
                   resultado := 1;
                   DBMS_OUTPUT.PUT_LINE('ERRO: OPERAÇÃO NÃO REALIZADA DEVIDO A ERRO DURANTE A SUA REALIZAÇÃO.');
                   RETURN resultado;
            END;
        ELSE
           RAISE invalidOperacao;
        END IF;
    END IF;
    END;
    RETURN resultado;
---------Exceções-----------------------------------
EXCEPTION
    WHEN invalidOperacao THEN
        resultado := 1;
        DBMS_OUTPUT.PUT_LINE('ERRO: OPERAÇÃO JÁ EXISTENTE NA BASE DE DADOS.');
        RETURN resultado;
    WHEN invalidInputs THEN
        resultado := 1;
        DBMS_OUTPUT.PUT_LINE('ERRO: INPUTS ERRADOS');
        RETURN resultado;
END;
/
--------Verificação se a Operação já existia--------
CREATE OR REPLACE FUNCTION verificarSeAplicacaoFatorProducaoExiste(
    desigOp IN tipoOperacaoAgricola.designacaoOperacaoAgricola%TYPE,
    desigUnidade IN tipoUnidade.designacaoUnidade%TYPE,
    qtd IN NUMBER,
    dataOp IN DATE,
    nmFator IN aplicacaofatorproducao.nomecomercial%TYPE
) RETURN NUMBER IS
    found NUMBER := 0;
BEGIN
    SELECT COUNT(*)
    INTO found
    FROM operacao op
         INNER JOIN aplicacaofatorproducao afp ON op.idOperacao = afp.idOperacao
    WHERE op.designacaooperacaoagricola = desigOp
      AND op.dataoperacao = dataOp
      AND op.designacaounidade = desigUnidade
      AND op.quantidade = qtd
      AND afp.nomeComercial = nmFator;

    RETURN found;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 0;
END;
/
--------Verificação dos Inputs---------
CREATE OR REPLACE FUNCTION verificarDadosDeInsercao(
    desigOp IN tipoOperacaoAgricola.designacaoOperacaoAgricola%TYPE,
    desigUnidade IN tipoUnidade.designacaoUnidade%TYPE,
    qtd IN NUMBER,
    dataOp IN DATE,
    nmFator IN aplicacaofatorproducao.nomecomercial%TYPE
) RETURN BOOLEAN IS
    valid BOOLEAN;
BEGIN
    IF desigOp IN ('Fertilização', 'Aplicação fitofármaco', 'Aplicação de fator de produção') THEN
        IF desigUnidade = 'kg' THEN
            IF qtd < 10 THEN
                valid := TRUE;
            END IF;
        END IF;
    ELSE
        valid := FALSE;
    END IF;
    RETURN valid;
END;
/
-----Criação de um novo id válido-----
CREATE OR REPLACE FUNCTION novoIdOperacao RETURN NUMBER AS
    newIdOperation NUMBER;
BEGIN
    SELECT NVL(MAX(idOperacao), 0) + 1 INTO newIdOperation FROM operacao;
    RETURN newIdOperation;
END;
/
--------Bloco Anónimo de Teste(Válido)--------
DECLARE
     desigOp tipoOperacaoAgricola.designacaoOperacaoAgricola%TYPE := 'Aplicação fitofármaco';
     desigUnidade tipoUnidade.designacaoUnidade%TYPE := 'kg';
     qtd NUMBER := 1;
     dataOp DATE := TO_DATE('23/11/2024', 'DD/MM/YYYY');
     nmFator aplicacaofatorproducao.nomecomercial%TYPE := 'BIOFERTIL N6';
     nmParcela operacaocultura.nomeparcela%TYPE := 'Campo Grande';
     dataIni operacaocultura.datainicial%TYPE := TO_DATE('16/10/2006', 'DD/MM/YYYY');
     nmComum operacaocultura.nomecomum%TYPE := 'Oliveira';
     varie operacaocultura.variedade%TYPE := 'GALEGA';
     resultado NUMBER;
BEGIN
    resultado := RegistoAplicacaoFatorProducao(desigOp, desigUnidade, qtd, dataOp, nmFator, nmParcela, dataIni, nmComum, varie);
     IF(resultado = 0)THEN
        DBMS_OUTPUT.PUT_LINE('TESTE (INPUT VÁLIDO) PASSADO COM SUCESSO.');
     ELSE
        DBMS_OUTPUT.PUT_LINE('TESTE (INPUT VÁLIDO) NÃO PASSADO.');
     END IF;
END;
/
--------Bloco Anónimo de Teste(Inválido)--------
 DECLARE
     desigOp tipoOperacaoAgricola.designacaoOperacaoAgricola%TYPE := 'Aplicação fitoco';
     desigUnidade tipoUnidade.designacaoUnidade%TYPE := 'kg';
     qtd NUMBER := 1;
     dataOp DATE := TO_DATE('23/11/2024', 'DD/MM/YYYY');
     nmFator aplicacaofatorproducao.nomecomercial%TYPE := 'BIOFERTIL N6';
     nmParcela operacaocultura.nomeparcela%TYPE := 'Campo Grande';
     dataIni operacaocultura.datainicial%TYPE := TO_DATE('16/10/2006', 'DD/MM/YYYY');
     nmComum operacaocultura.nomecomum%TYPE := 'Oliveira';
     varie operacaocultura.variedade%TYPE := 'GALEGA';
     resultado NUMBER;
 BEGIN
    resultado := RegistoAplicacaoFatorProducao(desigOp, desigUnidade, qtd, dataOp, nmFator, nmParcela, dataIni, nmComum, varie);
     IF(resultado = 1)THEN
        DBMS_OUTPUT.PUT_LINE('TESTE (INPUT VÁLIDO NOME DA OPERACAO) PASSADO COM SUCESSO.');
     ELSE
        DBMS_OUTPUT.PUT_LINE('TESTE (INPUT VÁLIDO NOME DA OPERACAO) NÃO PASSADO.');
     END IF;
 END;
/
--------Bloco Anónimo de Teste(Inválido)--------
 DECLARE
     desigOp tipoOperacaoAgricola.designacaoOperacaoAgricola%TYPE := 'Aplicação fitofármaco';
     desigUnidade tipoUnidade.designacaoUnidade%TYPE := 'ha';
     qtd NUMBER := 1;
     dataOp DATE := TO_DATE('23/11/2024', 'DD/MM/YYYY');
     nmFator aplicacaofatorproducao.nomecomercial%TYPE := 'BIOFERTIL N6';
     nmParcela operacaocultura.nomeparcela%TYPE := 'Campo Grande';
     dataIni operacaocultura.datainicial%TYPE := TO_DATE('16/10/2006', 'DD/MM/YYYY');
     nmComum operacaocultura.nomecomum%TYPE := 'Oliveira';
     varie operacaocultura.variedade%TYPE := 'GALEGA';
     resultado NUMBER;
 BEGIN
    resultado := RegistoAplicacaoFatorProducao(desigOp, desigUnidade, qtd, dataOp, nmFator, nmParcela, dataIni, nmComum, varie);
     IF(resultado = 1)THEN
        DBMS_OUTPUT.PUT_LINE('TESTE (INPUT INVÁLIDO TIPO DE UNIDADE) PASSADO COM SUCESSO.');
     ELSE
        DBMS_OUTPUT.PUT_LINE('TESTE (INPUT INVÁLIDO TIPO DE UNIDADE) NÃO PASSADO.');
     END IF;
 END;
/
--------Bloco Anónimo de Teste(Inválido)--------
 DECLARE
     desigOp tipoOperacaoAgricola.designacaoOperacaoAgricola%TYPE := 'Aplicação fitofármaco';
     desigUnidade tipoUnidade.designacaoUnidade%TYPE := 'kg';
     qtd NUMBER := 13444;
     dataOp DATE := TO_DATE('23/11/2024', 'DD/MM/YYYY');
     nmFator aplicacaofatorproducao.nomecomercial%TYPE := 'BIOFERTIL N6';
     nmParcela operacaocultura.nomeparcela%TYPE := 'Campo Grande';
     dataIni operacaocultura.datainicial%TYPE := TO_DATE('16/10/2006', 'DD/MM/YYYY');
     nmComum operacaocultura.nomecomum%TYPE := 'Oliveira';
     varie operacaocultura.variedade%TYPE := 'GALEGA';
     resultado NUMBER;
 BEGIN
    resultado := RegistoAplicacaoFatorProducao(desigOp, desigUnidade, qtd, dataOp, nmFator, nmParcela, dataIni, nmComum, varie);
     IF(resultado = 1)THEN
        DBMS_OUTPUT.PUT_LINE('TESTE (INPUT INVÁLIDO DE QUANTIDADE) PASSADO COM SUCESSO.');
     ELSE
        DBMS_OUTPUT.PUT_LINE('TESTE (INPUT INVÁLIDO DE QUANTIDADE) NÃO PASSADO.');
     END IF;
 END;
/
