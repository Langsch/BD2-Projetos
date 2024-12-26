-- Vendas mensais
CREATE VIEW Vendas_Mensais AS
SELECT 
    DATE_TRUNC('month', data_venda) AS mes,
    SUM(total_venda) AS total_mensal
FROM Vendas
GROUP BY DATE_TRUNC('month', data_venda)
ORDER BY mes;


-- Funcionarios TI
CREATE VIEW Funcionarios_TI AS
SELECT 
    id_funcionario,
    nome,
    salario
FROM Funcionarios
WHERE departamento = 'TI' 
AND salario > 5000
ORDER BY salario DESC;


-- Pedidos Clientes
CREATE VIEW Pedidos_Clientes AS
SELECT 
    p.id_pedido,
    p.data_pedido,
    c.nome_cliente
FROM Pedidos p
INNER JOIN Clientes c ON p.id_cliente = c.id_cliente
ORDER BY p.data_pedido DESC;


-- Preco medio categorias
CREATE VIEW Preco_Medio_Categorias AS
SELECT 
    categoria,
    ROUND(AVG(preco), 2) AS media_preco
FROM Produtos
GROUP BY categoria
ORDER BY media_preco DESC;


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