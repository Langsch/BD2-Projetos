-- Vendas mensais
CREATE VIEW Vendas_mensais AS
	SELECT 
		DATE_PART('Month', data_venda) AS mes,
		SUM(total_venda) AS "Total de vendas"
	FROM Vendas
	GROUP BY mes;


-- Funcionarios TI
CREATE VIEW Funcionarios_TI AS
	SELECT 
		id_funcionario,
		nome,
		salario
	FROM Funcionarios 
	WHERE departamento LIKE 'Tecnologia da Informação (TI)' AND salario > 5000;


-- Pedidos Clientes
CREATE VIEW Pedidos_Clientes AS
	SELECT 
		id_pedido,
		data_pedido,
		nome_cliente
	FROM 
		Clientes c,
		Pedidos p
	WHERE c.id_cliente = p.id_cliente
	GROUP BY 1, 3
	ORDER BY 3;


-- Preco medio categorias
CREATE VIEW Preco_Medio_Cateogira AS
	SELECT
		categoria,
		ROUND(AVG(preco), 2)
	FROM Produtos
	GROUP BY 1;

-- Ranking Vendas
CREATE VIEW Ranking_Vendas AS
WITH totais AS ( -- Calcula o total de vendas
    SELECT 
        SUM(quantidade) as qtde_total,
        SUM(preco_total) as valor_total
    FROM VENDAS
)
SELECT  -- Calcula o percentual de vendas por produto
    id_produto,
    SUM(quantidade) as quantidade_total,
    SUM(preco_total) as soma_preco,
    ROUND((SUM(quantidade) * 100.0 / (SELECT qtde_total FROM totais)), 2) as percentual_qtde,
    ROUND((SUM(preco_total) * 100.0 / (SELECT valor_total FROM totais)), 2) as percentual_valor
FROM VENDAS
GROUP BY id_produto
ORDER BY soma_preco DESC;