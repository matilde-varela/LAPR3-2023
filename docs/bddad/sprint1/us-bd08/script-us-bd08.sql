WITH operacoesAgricolasIDs AS (
    SELECT aplicacaofatorproducao.nomecomercial
    FROM aplicacaofatorproducao
    INNER JOIN operacao ON aplicacaofatorproducao.idoperacao = operacao.idoperacao
    WHERE operacao.dataoperacao BETWEEN TO_DATE('01/01/2013', 'DD/MM/YYYY') AND TO_DATE('07/04/2020', 'DD/MM/YYYY')
),
fatorMaisUsado AS (
    SELECT operacoesAgricolasIDs.nomecomercial
    FROM operacoesAgricolasIDs
    HAVING COUNT(operacoesAgricolasIDs.nomecomercial) = (SELECT MAX(COUNT(nomecomercial))
				                   						 FROM operacoesAgricolasIDs
				 			       						 GROUP BY operacoesAgricolasIDs.nomecomercial)
    GROUP BY operacoesAgricolasIDs.nomecomercial
)
SELECT fatorproducao.nomecomercial
FROM fatorproducao INNER JOIN fatorMaisUsado
ON fatorproducao.nomecomercial = fatorMaisUsado.nomecomercial;