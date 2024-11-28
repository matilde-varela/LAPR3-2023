--------------------------------------------------------------------------
--<Caso de sucesso>-------------------------------------------------------------------
DECLARE
    v_idMix NUMBER := 22;
    v_success NUMBER;

BEGIN

    v_success := registarReceitaFertirrega(v_idMix, sys.odcivarchar2list('Tecniferti MOL', 'Kiplant AllGrip', 'soluSOP 52'),
                                           sys.odcivarchar2list('Tecniferti', 'Asfertglobal', 'K+S'),
                                           sys.odcinumberlist(60, 2, 2.5),
                                           sys.odcivarchar2list('l/ha', 'l/ha', 'kg/ha'));

    IF v_success = 1 THEN
        DBMS_OUTPUT.PUT_LINE('A receita foi registada na base de dados.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Houve um erro a registar a receita na base de dados.');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Houve um erro a registar a receita na base de dados.');
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/
--------------------------------------------------------------------------
--<Caso de insucesso>-------------------------------------------------------------------
DECLARE
    v_idMix NUMBER := 23;
    v_success NUMBER;

BEGIN

    v_success := registarReceitaFertirrega(v_idMix, sys.odcivarchar2list('Tecniferti MOL', 'Kiplant AllFit Plus'),
                                           sys.odcivarchar2list('Tecniferti', 'Asfertglobal'),
                                           sys.odcinumberlist(60, 2.5),
                                           sys.odcivarchar2list('l/ha', 'l/ha'));

    IF v_success = 1 THEN
        DBMS_OUTPUT.PUT_LINE('A receita foi registada na base de dados.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Houve um erro a registar a receita na base de dados.');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Houve um erro a registar a receita na base de dados.');
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/
--------------------------------------------------------------------------
--TESTE 1-------------------------------------------------------------------
--Receita de Fertirrega é definida na base de dados com sucesso.
DECLARE
    v_idMix NUMBER := 15;
    v_success NUMBER;

BEGIN

    v_success := registarReceitaFertirrega(v_idMix, sys.odcivarchar2list('EPSO Top', 'soluSOP 52', 'Floracal Flow SL'),
                                           sys.odcivarchar2list('K+S', 'K+S', 'Plymag'),
                                           sys.odcinumberlist(2, 7.3, 0.5),
                                           sys.odcivarchar2list('kg/ha', 'kg/ha', 'l/ha'));

    IF v_success = 1 THEN
        DBMS_OUTPUT.PUT_LINE('O teste passou.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('O teste falhou.');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('O teste falhou.');

END;
/
--------------------------------------------------------------------------
--TESTE 2-------------------------------------------------------------------
--O ID da receita de fertirrega já se encontra presente na base de dados.
DECLARE
    v_idMix NUMBER := 10;
    v_success NUMBER;
    v_error_message        VARCHAR2(200);

BEGIN

    BEGIN
        v_success := registarReceitaFertirrega(v_idMix, sys.odcivarchar2list('EPSO Top', 'soluSOP 52', 'Floracal Flow SL'),
                                               sys.odcivarchar2list('K+S', 'K+S', 'Plymag'),
                                               sys.odcinumberlist(1.5, 2.5, 1.7),
                                               sys.odcivarchar2list('kg/ha', 'kg/ha', 'l/ha'));

    EXCEPTION
        WHEN OTHERS THEN
            v_error_message := SQLERRM;
    END;

    IF v_error_message IS NOT NULL AND INSTR(v_error_message, 'ERRO: O ID que definiu para a receita de fertirrega já existe na base de dados.') > 0 THEN
        DBMS_OUTPUT.PUT_LINE('O teste passou. A exceção idMixJaDefinidoNaBD foi lançada.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('O teste falhou. A exceção idMixJaDefinidoNaBD não foi lançada.');
    END IF;

END;
/
--------------------------------------------------------------------------
--TESTE 3-------------------------------------------------------------------
--Pelo menos uma das quantidadas definidas para os fatores de produçao da receita de fertirrega é inválida (igual ou inferior a 0).
DECLARE
    v_idMix NUMBER := 30;
    v_success NUMBER;
    v_error_message        VARCHAR2(200);

BEGIN

    BEGIN
        v_success := registarReceitaFertirrega(v_idMix, sys.odcivarchar2list('EPSO Top', 'soluSOP 52', 'Floracal Flow SL'),
                                               sys.odcivarchar2list('K+S', 'K+S', 'Plymag'),
                                               sys.odcinumberlist(1.5, 2.5, -1),
                                               sys.odcivarchar2list('kg/ha', 'kg/ha', 'l/ha'));

    EXCEPTION
        WHEN OTHERS THEN
            v_error_message := SQLERRM;
    END;

    IF v_error_message IS NOT NULL AND INSTR(v_error_message, 'ERRO: Pelo menos uma das quantidades indicadas é inválida (igual ou inferior a zero).') > 0 THEN
        DBMS_OUTPUT.PUT_LINE('O teste passou. A exceção quantidadeInvalida foi lançada.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('O teste falhou. A exceção quantidadeInvalida não foi lançada.');
    END IF;

END;
/
--------------------------------------------------------------------------
--TESTE 4-------------------------------------------------------------------
--Pelo menos uma das unidades definidas para os fatores de produçao da receita de fertirrega não se encontra presente na base de dados.
DECLARE
    v_idMix NUMBER := 30;
    v_success NUMBER;
    v_error_message        VARCHAR2(200);

BEGIN

    BEGIN
        v_success := registarReceitaFertirrega(v_idMix, sys.odcivarchar2list('EPSO Top', 'soluSOP 52', 'Floracal Flow SL'),
                                  sys.odcivarchar2list('K+S', 'K+S', 'Plymag'),
                                  sys.odcinumberlist(1.5, 2.5, 1.7),
                                  sys.odcivarchar2list('kg/ha', 'manga', 'l/ha'));

    EXCEPTION
        WHEN OTHERS THEN
            v_error_message := SQLERRM;
    END;

    IF v_error_message IS NOT NULL AND INSTR(v_error_message, 'ERRO: Pelo menos uma das unidades indicadas não está definida na base de dados.') > 0 THEN
        DBMS_OUTPUT.PUT_LINE('O teste passou. A exceção unidadeNaoDefinidaNaBD foi lançada.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('O teste falhou. A exceção unidadeNaoDefinidaNaBD não foi lançada.');
    END IF;

END;
/
--------------------------------------------------------------------------
--TESTE 5-------------------------------------------------------------------
--Pelo menos um dos fatores de produçao da receita de fertirrega não se encontra presente na base de dados.
DECLARE
    v_idMix NUMBER := 30;
    v_success NUMBER;
    v_error_message        VARCHAR2(200);

BEGIN

    BEGIN
        v_success := registarReceitaFertirrega(v_idMix, sys.odcivarchar2list('Matildinhas', 'soluSOP 52', 'Floracal Flow SL'),
                                  sys.odcivarchar2list('NoPorto', 'K+S', 'Plymag'),
                                  sys.odcinumberlist(1.5, 2.5, 1.7),
                                  sys.odcivarchar2list('kg/ha', 'kg/ha', 'l/ha'));

    EXCEPTION
        WHEN OTHERS THEN
            v_error_message := SQLERRM;
    END;

    IF v_error_message IS NOT NULL AND INSTR(v_error_message, 'ERRO: Pelo menos um dos fatores de produção indicados não está definido na base de dados.') > 0 THEN
        DBMS_OUTPUT.PUT_LINE('O teste passou. A exceção fatorNaoDefinidoNaBD foi lançada.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('O teste falhou. A exceção fatorNaoDefinidoNaBD não foi lançada.');
    END IF;

END;
/
--------------------------------------------------------------------------
--TESTE 6-------------------------------------------------------------------
--A informação fornecida está incompleta. Para cada fator de produção devem ser referidos: o nome comercial, o fabricante, a quantidade, a unidade.
--Neste caso existe informação para 3 fatores, mas apenas constam o nome de dois.
DECLARE
    v_idMix NUMBER := 16;
    v_success NUMBER;
    v_error_message        VARCHAR2(200);

BEGIN

    BEGIN
        v_success := registarReceitaFertirrega(v_idMix, sys.odcivarchar2list('EPSO Top', 'soluSOP 52'),
                                  sys.odcivarchar2list('K+S', 'K+S', 'Plymag'),
                                  sys.odcinumberlist(1.5, 2.5, 1.7),
                                  sys.odcivarchar2list('kg/ha', 'kg/ha', 'l/ha'));

    EXCEPTION
        WHEN OTHERS THEN
            v_error_message := SQLERRM;
    END;

    IF v_error_message IS NOT NULL AND INSTR(v_error_message, 'ERRO: Os dados indicados estão incompletos. Cada fator deve ter o seu nome, fabricante, unidade e quantidade definidas.') > 0 THEN
        DBMS_OUTPUT.PUT_LINE('O teste passou. A exceção informacaoIncompleta foi lançada.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('O teste falhou. A exceção informacaoIncompleta não foi lançada.');
    END IF;

END;
/