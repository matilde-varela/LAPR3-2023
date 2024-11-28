create or replace FUNCTION registarReceitaFertirrega(
    v_idMix NUMBER,
    v_nome_fatores_tabela sys.odcivarchar2list,
    v_nome_fabricantes_tabela sys.odcivarchar2list,
    v_quantidades_tabela sys.odcinumberlist,
    v_unidades_tabela sys.odcivarchar2list
) RETURN NUMBER IS
    v_success NUMBER := 0;
    idMixExiste NUMBER;
    fatorExiste NUMBER;
    unidadeExiste NUMBER;

    v_count_fatores   NUMBER;
    v_count_fabricantes NUMBER;
    v_count_quantidades NUMBER;
    v_count_unidades  NUMBER;

    idMixJaDefinidoNaBD  EXCEPTION;
    fatorNaoDefinidoNaBD EXCEPTION;
    unidadeNaoDefinidaNaBD EXCEPTION;
    quantidadeInvalida EXCEPTION;
    informacaoIncompleta EXCEPTION; --quando as listas nao têm todas o mesmo tamanho
BEGIN
    BEGIN

    v_count_fatores := v_nome_fatores_tabela.COUNT;
    v_count_fabricantes := v_nome_fabricantes_tabela.COUNT;
    v_count_quantidades := v_quantidades_tabela.COUNT;
    v_count_unidades := v_unidades_tabela.COUNT;


    IF v_count_fatores = v_count_fabricantes
        AND v_count_fatores = v_count_quantidades
        AND v_count_fatores = v_count_unidades THEN

        idMixExiste := checkIdMixFertirrega(v_idMix);

        IF idMixExiste = 0 THEN

            FOR i IN 1..v_nome_fatores_tabela.COUNT LOOP
                    fatorExiste := checkFatorProducaoExiste(v_nome_fatores_tabela(i),v_nome_fabricantes_tabela(i));

                    unidadeExiste := checkUnidadeExiste(v_unidades_tabela(i));

                    IF fatorExiste = 0 THEN
                        v_success := 0;
                        RAISE fatorNaoDefinidoNaBD;
                    END IF;

                    IF unidadeExiste = 0 THEN
                        v_success := 0;
                        RAISE unidadeNaoDefinidaNaBD;
                    END IF;

                    IF v_quantidades_tabela(i) <= 0 THEN
                        v_success := 0;
                        RAISE quantidadeInvalida;
                    END IF;

                END LOOP;

            --se loop foi concluido entao significa que a informacao foi toda validada
            INSERT INTO ReceitaFertirrega(idReceitaFertirrega) VALUES (v_idMix);

            FOR i IN 1..v_nome_fatores_tabela.COUNT LOOP
                    INSERT INTO CatalogoReceitaFertirrega(idReceitaFertirrega,nomeComercial,designacaoUnidade,quantidade) VALUES (v_idMix,v_nome_fatores_tabela(i),v_unidades_tabela(i),v_quantidades_tabela(i));
                END LOOP;

            v_success := 1;

        ELSE
            v_success := 0;
            RAISE idMixJaDefinidoNaBD;
        END IF;

    ELSE
        v_success := 0;
        RAISE informacaoIncompleta;
    END IF;

EXCEPTION
    WHEN idMixJaDefinidoNaBD THEN
        RAISE_APPLICATION_ERROR(-20001, 'ERRO: O ID que definiu para a receita de fertirrega já existe na base de dados.');
    WHEN fatorNaoDefinidoNaBD THEN
        RAISE_APPLICATION_ERROR(-20002, 'ERRO: Pelo menos um dos fatores de produção indicados não está definido na base de dados.');
    WHEN unidadeNaoDefinidaNaBD THEN
        RAISE_APPLICATION_ERROR(-20003, 'ERRO: Pelo menos uma das unidades indicadas não está definida na base de dados.');
    WHEN quantidadeInvalida THEN
        RAISE_APPLICATION_ERROR(-20004, 'ERRO: Pelo menos uma das quantidades indicadas é inválida (igual ou inferior a zero).');
    WHEN informacaoIncompleta THEN
        RAISE_APPLICATION_ERROR(-20005, 'ERRO: Os dados indicados estão incompletos. Cada fator deve ter o seu nome, fabricante, unidade e quantidade definidas.');

     END;

    RETURN v_success;

END;
/
-------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION checkIdMixFertirrega(
    v_idMix NUMBER
) RETURN NUMBER IS
    v_idMixExiste NUMBER;
BEGIN

    SELECT NVL(COUNT(*), 0) INTO v_idMixExiste
    FROM ReceitaFertirrega rf
    WHERE rf.idReceitaFertirrega = v_idMix;

    RETURN v_idMixExiste;
END;
/
-------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION checkFatorProducaoExiste(
    v_nome_fator VARCHAR2,
    v_nome_fabricante VARCHAR2
) RETURN NUMBER IS
    v_fatorExiste NUMBER;
BEGIN

    SELECT NVL(COUNT(*), 0) INTO v_fatorExiste
    FROM FatorProducao ft
    WHERE ft.nomeComercial = v_nome_fator
      AND ft.fabricante = v_nome_fabricante;

    RETURN v_fatorExiste;
END;
/
-------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION checkUnidadeExiste(
    v_unidade VARCHAR2
) RETURN NUMBER IS
    v_unidadeExiste NUMBER;
BEGIN

    SELECT NVL(COUNT(*), 0) INTO v_unidadeExiste
    FROM TipoUnidade tu
    WHERE tu.designacaoUnidade = v_unidade;

    RETURN v_unidadeExiste;
END;
/
------------------------------------------------
-------------------CONFIRMAÇÃO------------------
------------------------------------------------
SELECT crf.IDRECEITAFERTIRREGA "ID DA RECEITA",
       crf.NOMECOMERCIAL "FATOR DE PRODUÇÃO",
       fp.FABRICANTE,
       crf.QUANTIDADE,
       crf.DESIGNACAOUNIDADE UNIDADE
FROM CatalogoReceitaFertirrega crf
         INNER JOIN FatorProducao fp
             ON fp.nomecomercial = crf.nomecomercial;
--||----||----||----||----||----||----||----||--
SELECT IDRECEITAFERTIRREGA "ID DA RECEITA"
FROM ReceitaFertirrega;
--||----||----||----||----||----||----||----||--