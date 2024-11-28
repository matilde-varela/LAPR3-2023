--------------------------------------------------------------------------
--TESTE 1-------------------------------------------------------------------
--Verifica que a função lança a exceção qtdCulturaZero - não se pode plantar 0 unidades de área.
DECLARE
    v_desigOp              tipoOperacaoAgricola.designacaoOperacaoAgricola%TYPE := 'Semeadura';
    v_desigUnidadeCultura  tipoUnidade.DESIGNACAOUNIDADE%TYPE                   := 'm2';
    v_qtdCultura           NUMBER                                               := 0;
    v_desigUnidadeOperacao tipoUnidade.DESIGNACAOUNIDADE%TYPE                   := 'kg';
    v_qtdOp                NUMBER                                               := 3;
    v_dataOp               DATE                                                 := TO_DATE('01/03/2022', 'DD/MM/YYYY');
    v_nomeParcela          parcela.nomeParcela%TYPE                             := 'Campo Grande';
    v_nomeComum            planta.nomeComum%TYPE                                := 'Cenoura';
    v_variedade            planta.variedade%TYPE                                := 'CARSON HYBRID';
    v_success              NUMBER;
    v_error_message        VARCHAR2(200);

BEGIN

    BEGIN
        v_success := registarOperacaoSemeadura(
                v_desigOp,
                v_desigUnidadeCultura,
                v_qtdCultura,
                v_desigUnidadeOperacao,
                v_qtdOp,
                v_dataOp,
                v_nomeParcela,
                v_nomeComum,
                v_variedade
            );

    EXCEPTION
        WHEN OTHERS THEN
            v_error_message := SQLERRM;
    END;

    IF v_error_message IS NOT NULL
        AND INSTR(v_error_message, 'A quantidade indicada é inválida') > 0
        AND INSTR(v_error_message, 'Não pode plantar 0 m2') > 0 THEN
        DBMS_OUTPUT.PUT_LINE('O teste passou. A exceção qtdCulturaZero foi lançada.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('O teste falhou. A exceção qtdCulturaZero não foi lançada.');
    END IF;
END;

--------------------------------------------------------------------------
--TESTE 2-------------------------------------------------------------------
--Verifica que a função lança a exceção qtdOpZero - não se pode plantar nada com 0 kg de sementes.
DECLARE
    v_desigOp              tipoOperacaoAgricola.designacaoOperacaoAgricola%TYPE := 'Semeadura';
    v_desigUnidadeCultura  tipoUnidade.DESIGNACAOUNIDADE%TYPE                   := 'm2';
    v_qtdCultura           NUMBER                                               := 0.2;
    v_desigUnidadeOperacao tipoUnidade.DESIGNACAOUNIDADE%TYPE                   := 'kg';
    v_qtdOp                NUMBER                                               := 0;
    v_dataOp               DATE                                                 := TO_DATE('01/03/2022', 'DD/MM/YYYY');
    v_nomeParcela          parcela.nomeParcela%TYPE                             := 'Campo Grande';
    v_nomeComum            planta.nomeComum%TYPE                                := 'Cenoura';
    v_variedade            planta.variedade%TYPE                                := 'CARSON HYBRID';
    v_success              NUMBER;
    v_error_message        VARCHAR2(200);

BEGIN
    BEGIN
        v_success := registarOperacaoSemeadura(
                v_desigOp,
                v_desigUnidadeCultura,
                v_qtdCultura,
                v_desigUnidadeOperacao,
                v_qtdOp,
                v_dataOp,
                v_nomeParcela,
                v_nomeComum,
                v_variedade
            );

    EXCEPTION
        WHEN OTHERS THEN
            v_error_message := SQLERRM;
    END;

    IF v_error_message IS NOT NULL AND INSTR(v_error_message, 'ERRO: A quantidade indicada é inválida. Não pode plantar nada com 0 kg de sementes.') > 0 THEN
        DBMS_OUTPUT.PUT_LINE('O teste passou. A exceção qtdOpZero foi lançada.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('O teste falhou. A exceção qtdOpZero não foi lançada.');
    END IF;

END;

--------------------------------------------------------------------------
--TESTE 3-------------------------------------------------------------------
--Verifica que a função lança a exceção quantidadeMaiorAreaParcela - a extensão de área em que se deseja semear é superior
-- à área total da parcela.
DECLARE
    v_desigOp              tipoOperacaoAgricola.designacaoOperacaoAgricola%TYPE := 'Semeadura';
    v_desigUnidadeCultura  tipoUnidade.DESIGNACAOUNIDADE%TYPE                   := 'ha';
    v_qtdCultura           NUMBER                                               := 13;
    v_desigUnidadeOperacao tipoUnidade.DESIGNACAOUNIDADE%TYPE                   := 'kg';
    v_qtdOp                NUMBER                                               := 2;
    v_dataOp               DATE                                                 := TO_DATE('01/03/2022', 'DD/MM/YYYY');
    v_nomeParcela          parcela.nomeParcela%TYPE                             := 'Campo Grande';
    v_nomeComum            planta.nomeComum%TYPE                                := 'Cenoura';
    v_variedade            planta.variedade%TYPE                                := 'CARSON HYBRID';
    v_success              NUMBER;
    v_error_message        VARCHAR2(200);

BEGIN
    BEGIN
        v_success := registarOperacaoSemeadura(
                v_desigOp,
                v_desigUnidadeCultura,
                v_qtdCultura,
                v_desigUnidadeOperacao,
                v_qtdOp,
                v_dataOp,
                v_nomeParcela,
                v_nomeComum,
                v_variedade
            );

    EXCEPTION
        WHEN OTHERS THEN
            v_error_message := SQLERRM;
    END;

    IF v_error_message IS NOT NULL AND INSTR(v_error_message, 'ERRO: A quantidade indicada supera a área da parcela escolhida.') > 0 THEN
        DBMS_OUTPUT.PUT_LINE('O teste passou. A exceção quantidadeMaiorAreaParcela foi lançada.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('O teste falhou. A exceção quantidadeMaiorAreaParcela não foi lançada.');
    END IF;

END;

--------------------------------------------------------------------------
--TESTE 4-------------------------------------------------------------------
--Verifica que a função lança a exceção alreadyExists - já existe na base de dados um registo de operação com as mesmas informações.
SET SERVEROUTPUT ON;

DECLARE
    v_desigOp      tipoOperacaoAgricola.designacaoOperacaoAgricola%TYPE := 'Semeadura';
    v_desigUnidadeCultura tipoUnidade.DESIGNACAOUNIDADE%TYPE                   := 'm2';
    v_qtdCultura          NUMBER                                               := 5;
    v_desigUnidadeOperacao tipoUnidade.DESIGNACAOUNIDADE%TYPE                   := 'kg';
    v_qtdOp          NUMBER                                               := 3;
    v_dataOp       DATE                                                 := TO_DATE('02/03/2022', 'DD/MM/YYYY');
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

SET SERVEROUTPUT ON;

DECLARE
    v_desigOp      tipoOperacaoAgricola.designacaoOperacaoAgricola%TYPE := 'Semeadura';
    v_desigUnidadeCultura tipoUnidade.DESIGNACAOUNIDADE%TYPE                   := 'm2';
    v_qtdCultura          NUMBER                                               := 5;
    v_desigUnidadeOperacao tipoUnidade.DESIGNACAOUNIDADE%TYPE                   := 'kg';
    v_qtdOp          NUMBER                                               := 3;
    v_dataOp       DATE                                                 := TO_DATE('02/03/2022', 'DD/MM/YYYY');
    v_nomeParcela  parcela.nomeParcela%TYPE                             := 'Campo Grande';
    v_nomeComum    planta.nomeComum%TYPE                                := 'Cenoura';
    v_variedade    planta.variedade%TYPE                                := 'CARSON HYBRID';
    v_success      NUMBER;
    v_error_message        VARCHAR2(200);
BEGIN

    BEGIN
        v_success := registarOperacaoSemeadura(
                v_desigOp,
                v_desigUnidadeCultura,
                v_qtdCultura,
                v_desigUnidadeOperacao,
                v_qtdOp,
                v_dataOp,
                v_nomeParcela,
                v_nomeComum,
                v_variedade
            );

    EXCEPTION
        WHEN OTHERS THEN
            v_error_message := SQLERRM;
    END;

    IF v_error_message IS NOT NULL AND INSTR(v_error_message, 'ERRO: Os dados introduzidos já existem no sistema.') > 0 THEN
        DBMS_OUTPUT.PUT_LINE('O teste passou. A exceção alreadyExists foi lançada.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('O teste falhou. A exceção alreadyExists não foi lançada.');
    END IF;
END;
/
--------------------------------------------------------------------------
--TESTE 5-------------------------------------------------------------------
--Verifica que a função lança a exceção semAreaDisponivel - não existe área disponível na parcela escolhida para instalar
--uma nova cultura.

--ESTE TESTE QUER QUE A PARCELA 'CAMPO GRANDE' ESTEJA VAZIA, ISTO É SEM TER CULTURAS INSTALADAS ATIVAS (COM DATA FINAL NULL)

SET SERVEROUTPUT ON;

DECLARE
    v_desigOp      tipoOperacaoAgricola.designacaoOperacaoAgricola%TYPE := 'Semeadura';
    v_desigUnidadeCultura tipoUnidade.DESIGNACAOUNIDADE%TYPE                   := 'ha';
    v_qtdCultura          NUMBER                                               := 3;
    v_desigUnidadeOperacao tipoUnidade.DESIGNACAOUNIDADE%TYPE                   := 'kg';
    v_qtdOp          NUMBER                                               := 2.3;
    v_dataOp       DATE                                                 := TO_DATE('03/03/2023', 'DD/MM/YYYY');
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

SET SERVEROUTPUT ON;

DECLARE
    v_desigOp      tipoOperacaoAgricola.designacaoOperacaoAgricola%TYPE := 'Semeadura';
    v_desigUnidadeCultura tipoUnidade.DESIGNACAOUNIDADE%TYPE                   := 'm2';
    v_qtdCultura          NUMBER                                               := 1;
    v_desigUnidadeOperacao tipoUnidade.DESIGNACAOUNIDADE%TYPE                   := 'kg';
    v_qtdOp          NUMBER                                               := 0.5;
    v_dataOp       DATE                                                 := TO_DATE('04/03/2022', 'DD/MM/YYYY');
    v_nomeParcela  parcela.nomeParcela%TYPE                             := 'Campo Grande';
    v_nomeComum    planta.nomeComum%TYPE                                := 'Cenoura';
    v_variedade    planta.variedade%TYPE                                := 'CARSON HYBRID';
    v_success      NUMBER;
    v_error_message        VARCHAR2(200);
BEGIN

    BEGIN
        v_success := registarOperacaoSemeadura(
                v_desigOp,
                v_desigUnidadeCultura,
                v_qtdCultura,
                v_desigUnidadeOperacao,
                v_qtdOp,
                v_dataOp,
                v_nomeParcela,
                v_nomeComum,
                v_variedade
            );

    EXCEPTION
        WHEN OTHERS THEN
            v_error_message := SQLERRM;
    END;

    IF v_error_message IS NOT NULL AND INSTR(v_error_message, 'ERRO: A parcela selecionada não têm área disponível para instalar uma nova cultura.') > 0 THEN
        DBMS_OUTPUT.PUT_LINE('O teste passou. A exceção semAreaDisponivel foi lançada.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('O teste falhou. A exceção semAreaDisponivel não foi lançada.');
    END IF;
END;
/

