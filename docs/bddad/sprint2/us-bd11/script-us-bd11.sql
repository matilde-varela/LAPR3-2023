create or replace NONEDITIONABLE FUNCTION registarOperacaoSemeadura(
    desigOp IN tipoOperacaoAgricola.designacaoOperacaoAgricola%TYPE,
    desigUnidadeCultura IN tipoUnidade.designacaoUnidade%TYPE,
    qtdCultura IN NUMBER,
    desigUnidadeOperacao IN tipoUnidade.designacaoUnidade%TYPE,
    qtdOp IN NUMBER,
    dataOp IN DATE,
    nomeParcela IN parcela.nomeParcela%TYPE,
    nomeComum IN planta.nomeComum%TYPE,
    variedade IN planta.variedade%TYPE
) RETURN NUMBER IS
    success NUMBER := 0;
    idOp    NUMBER;
    qtdIsValid NUMBER := 0;
    areaOcupada  NUMBER;
    alreadyExists EXCEPTION;
    semAreaDisponivel EXCEPTION;
    qtdCulturaZero EXCEPTION;
    qtdOpZero EXCEPTION;
    quantidadeMaiorAreaParcela EXCEPTION;
BEGIN
    BEGIN

        IF (qtdCultura <=0) THEN
            RAISE qtdCulturaZero;
        ELSIF (qtdOp <= 0) THEN
            RAISE qtdOpZero;
        END IF;

        IF verificarSeOperacaoExiste(desigOp, desigUnidadeOperacao, qtdOp, dataOp, nomeParcela, nomeComum, variedade)= 0 THEN
            areaOcupada := obterAreaOcupadaPorCulturas(nomeParcela);

            qtdIsValid := validarArea(areaOcupada, desigUnidadeCultura, qtdCultura, nomeParcela);

            IF qtdIsValid = 1 THEN

                idOp := novoIdOperacao();

                INSERT INTO operacao (idOperacao, designacaoOperacaoAgricola, designacaoUnidade, quantidade, dataOperacao)
                VALUES (idOp, desigOp, desigUnidadeOperacao, qtdOp, dataOp);

                INSERT INTO culturaInstalada (dataInicial, nomeParcela, variedade, nomeComum, designacaoUnidade, quantidade,dataFinal)
                VALUES (dataOp, nomeParcela, variedade, nomeComum, desigUnidadeCultura, qtdCultura,NULL);

                INSERT INTO operacaocultura (idOperacao, nomeParcela, dataInicial, nomeComum, variedade)
                VALUES (idOp, nomeParcela, dataOp, nomeComum, variedade);

                success := 1;
            ELSIF qtdIsValid = -1 THEN
                RAISE semAreaDisponivel;
            ELSIF qtdIsValid = -2 THEN
                RAISE quantidadeMaiorAreaParcela;
            END IF;
        ELSE
            RAISE alreadyExists;
        END IF;

        COMMIT;

    EXCEPTION
        WHEN alreadyExists THEN
            RAISE_APPLICATION_ERROR(-20001, 'ERRO: Os dados introduzidos já existem no sistema.');
            ROLLBACK;
        WHEN semAreaDisponivel THEN
            RAISE_APPLICATION_ERROR(-20002, 'ERRO: A parcela selecionada não têm área disponível para instalar uma nova cultura.');
            ROLLBACK;
        WHEN quantidadeMaiorAreaParcela THEN
            RAISE_APPLICATION_ERROR(-20003, 'ERRO: A quantidade indicada supera a área da parcela escolhida.');
            ROLLBACK;
        WHEN qtdCulturaZero THEN
            RAISE_APPLICATION_ERROR(-20004, 'ERRO: A quantidade indicada é inválida. Não pode plantar 0 ' || desigUnidadeCultura || '.');
            ROLLBACK;
        WHEN qtdOpZero THEN
            RAISE_APPLICATION_ERROR(-20005, 'ERRO: A quantidade indicada é inválida. Não pode plantar nada com 0 kg de sementes.');
            ROLLBACK;
    END;

    RETURN success;
END;
    /
--------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION obterAreaOcupadaPorCulturas(
    parcelaNome IN parcela.nomeParcela%TYPE
) RETURN NUMBER IS
    areaOcupada  NUMBER := 0;
    areas        SYS_REFCURSOR;
    qtd          NUMBER;
    desigUnidade VARCHAR2(50);
BEGIN
    OPEN areas FOR
        SELECT TRUNC(QUANTIDADE, 4), DESIGNACAOUNIDADE
        FROM CULTURAINSTALADA c
        WHERE c.NOMEPARCELA LIKE parcelaNome
          AND DATAFINAL IS NULL;

    FETCH areas INTO qtd, desigUnidade;

    WHILE areas%FOUND
        LOOP
            IF desigUnidade = 'ha' THEN
                areaOcupada := areaOcupada + qtd;
            ELSIF desigUnidade = 'm2' THEN
                qtd := qtd / 10000;
                areaOcupada := areaOcupada + qtd;
            END IF;

            FETCH areas INTO qtd, desigUnidade;
        END LOOP;

    CLOSE areas;

    RETURN ROUND(areaOcupada, 4);
EXCEPTION
    WHEN OTHERS THEN
        CLOSE areas;
        RETURN NULL;
END;
/
--------------------------------------------------------------------------------------------------------------

create or replace NONEDITIONABLE FUNCTION validarArea(
    areaOcupada IN NUMBER,
    desigUnidade IN operacao.designacaoUnidade%TYPE,
    qtd IN NUMBER,
    parcelaNome IN parcela.nomeParcela%TYPE
) RETURN NUMBER IS
    isValid      NUMBER;
    areaParcela  NUMBER;
    areaRestante NUMBER;
BEGIN
    BEGIN
        SELECT TRUNC(area, 4)
        INTO areaParcela
        FROM parcela p
        WHERE p.nomeparcela LIKE parcelaNome;

        areaRestante := TRUNC(areaParcela - areaOcupada, 4);

        IF areaRestante = 0 THEN
            isValid := -1;
        END IF;

        IF desigUnidade LIKE 'ha' AND TRUNC(qtd, 4) <= areaRestante THEN
            isValid := 1;
        ELSIF desigUnidade LIKE 'm2' AND TRUNC((qtd / 10000), 4) <= areaRestante THEN
            isValid := 1;
        END IF;

        IF desigUnidade LIKE 'ha' AND TRUNC(qtd, 4) > areaParcela THEN
            isValid := -2;
        ELSIF desigUnidade LIKE 'm2' AND TRUNC((qtd / 10000), 4) > areaParcela THEN
            isValid := -2;
        END IF;
        RETURN isValid;
    END;
END;
/
------------------------------------------------
------------------BLOCO ANÓNIMO-----------------
------------------------------------------------
SET SERVEROUTPUT ON;

DECLARE
    v_desigOp      tipoOperacaoAgricola.designacaoOperacaoAgricola%TYPE := 'Semeadura';
    v_desigUnidadeCultura tipoUnidade.DESIGNACAOUNIDADE%TYPE                   := 'm2';
    v_qtdCultura          NUMBER                                               := 0;
    v_desigUnidadeOperacao tipoUnidade.DESIGNACAOUNIDADE%TYPE                   := 'kg';
    v_qtdOp          NUMBER                                               := 3;
    v_dataOp       DATE                                                 := TO_DATE('01/03/2022', 'DD/MM/YYYY');
    v_nomeParcela  parcela.nomeParcela%TYPE                             := 'Campo Grande';
    v_nomeComum    planta.nomeComum%TYPE                                := 'Cenoura';
    v_variedade    planta.variedade%TYPE                                := 'CARSON HYBRID';
    v_success      NUMBER;
    areaOcupada    NUMBER;
    areaParcela    NUMBER;
BEGIN

    SELECT area
    INTO areaParcela
    FROM parcela
    WHERE nomeParcela = v_nomeParcela;

    areaOcupada := obterAreaOcupadaPorCulturas(v_nomeParcela);

    v_success := registarOperacaoSemeadura(v_desigOp, v_desigUnidadeCultura, v_qtdCultura, v_desigUnidadeOperacao, v_qtdOp, v_dataOp, v_nomeParcela, v_nomeComum,
                                           v_variedade);

    DBMS_OUTPUT.PUT_LINE('Area da Parcela: ' || areaParcela || ' Area Ocupada Antes do Registo: ' || areaOcupada);

    areaOcupada := obterAreaOcupadaPorCulturas(v_nomeParcela);

    DBMS_OUTPUT.PUT_LINE('Area da Parcela: ' || areaParcela || ' Area Ocupada Depois do Registo: ' || areaOcupada);

    IF v_success = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Operation registered successfully!');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Failed to register operation.');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

------------------------------------------------
-------------------CONFIRMAÇÃO------------------
------------------------------------------------
SELECT op.IDOPERACAO "ID_OPERACAO",
       op.DATAOPERACAO AS "DATA OPERACAO",
       opCul.NOMEPARCELA AS "PARCELA",
       op.DESIGNACAOOPERACAOAGRICOLA AS "TIPO OPERACAO AGRICOLA",
       op.QUANTIDADE AS "QUANTIDADE OPERACAO",
       op.DESIGNACAOUNIDADE AS "UNIDADE OPERACAO",
       opCul.NOMECOMUM AS "NOME COMUM",
       opCul.VARIEDADE VARIEDADE,
       culInst.QUANTIDADE AS "QUANTIDADE CULTURA",
       culInst.DESIGNACAOUNIDADE AS "UNIDADE CULTURA",
       culInst.DATAINICIAL AS "DATA INICIAL",
       culInst.DATAFINAL AS "DATA FINAL"
FROM operacao op
         INNER JOIN operacaoCultura opCul ON opCul.idOperacao = op.idOperacao
         INNER JOIN culturaInstalada culInst ON culInst.datainicial = op.dataOperacao
WHERE op.designacaoOperacaoAgricola = 'Semeadura'
  AND culInst.datafinal IS NULL;
--||----||----||----||----||----||----||----||--
SELECT *
FROM parcela;
--||----||----||----||----||----||----||----||--