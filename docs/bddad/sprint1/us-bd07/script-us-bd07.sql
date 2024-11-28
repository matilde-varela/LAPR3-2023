WITH Operacoes AS (
    SELECT DISTINCT idParcela,
                    idOperacao
    FROM (
             SELECT idParcela, idOperacao
             FROM OperacaoCultura
             UNION ALL
             SELECT idParcela, idOperacao
             FROM OperacaoParcela
         )
),TipoOperacoes AS(
    SELECT op.idParcela, o.idOperacao, toa.designacaoOperacaoAgricola
    FROM Operacoes op
             INNER JOIN Operacao o ON op.idOperacao = o.idOperacao
             INNER JOIN TipoOperacaoAgricola toa ON o.designacaoOperacaoAgricola = toa.designacaoOperacaoAgricola
    WHERE o.dataOperacao BETWEEN TO_DATE('01/01/2016', 'DD/MM/YYYY') AND TO_DATE('31/12/2024', 'DD/MM/YYYY')
)
SELECT idParcela AS ID_PARCELA,
       designacaoOperacaoAgricola AS TIPO_OPERACAO,
       COUNT(distinct idOperacao) AS NUMERO_OPERACOES
FROM TipoOperacoes
GROUP BY idParcela, designacaoOperacaoAgricola
ORDER BY idParcela, designacaoOperacaoAgricola;