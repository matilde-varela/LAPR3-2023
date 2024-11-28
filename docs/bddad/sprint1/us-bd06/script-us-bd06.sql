WITH Operacoes AS (
    SELECT DISTINCT idParcela, idOperacao
    FROM (
        SELECT oc.idParcela, oc.idOperacao
        FROM OperacaoCultura oc
        UNION ALL
        SELECT opp.idParcela, opp.idOperacao
        FROM OperacaoParcela opp
    )
), Fatores AS (
    SELECT ops.idParcela as ID_PARCELA,
           f.classificacao as TIPO_FATOR_PRODUCAO
    FROM Operacoes ops
    INNER JOIN Operacao op ON ops.idOperacao = op.idOperacao
    INNER JOIN AplicacaoFatorProducao afp ON op.idOperacao = afp.idOperacao
    INNER JOIN FatorProducao f ON afp.nomeComercial = f.nomeComercial
    WHERE op.dataOperacao BETWEEN TO_DATE('01/01/2016', 'DD/MM/YYYY') AND TO_DATE('31/12/2024', 'DD/MM/YYYY')
)
SELECT fs.ID_PARCELA,
       fs.TIPO_FATOR_PRODUCAO,
       COUNT(fs.TIPO_FATOR_PRODUCAO) as NUMERO_FATORES_APLICADOS
FROM Fatores fs
GROUP BY fs.ID_PARCELA, fs.TIPO_FATOR_PRODUCAO
ORDER BY fs.ID_PARCELA;