-- 1. 
explain SELECT * FROM cliente WHERE nome ILIKE '%Cliente 1%';
CREATE INDEX idx_cliente_nome ON cliente (nome) WHERE nome ILIKE '%Cliente 1%';;

-- 2. 
explain SELECT * FROM compra WHERE data > '2023-01-01';
CREATE INDEX idx_compra_data ON compra (data) where data > '2023-01-01';

-- 3.
explain SELECT * FROM produto WHERE preco_unitario > 100.00; 
CREATE INDEX idx_produto_preco_unitario ON produto (preco_unitario);

-- 4. 
explain SELECT * FROM devolucao WHERE data < '2023-06-01';
CREATE INDEX idx_devolucao_data ON devolucao (data) WHERE data < '2023-06-01';

-- 5. 
explain SELECT * FROM empresa_colaboradora WHERE endereco ILIKE '%Centro%';
CREATE INDEX idx_empresa_colaboradora_endereco ON empresa_colaboradora (endereco) WHERE endereco ILIKE '%Centro%';

-- 6. 
explain SELECT * FROM cliente WHERE telefone LIKE 'Telefone 21%';
CREATE INDEX idx_cliente_telefone ON cliente (telefone) WHERE telefone LIKE 'Telefone 21%';

-- 7. 
explain SELECT * FROM item_compra WHERE quantidade > 5;
CREATE INDEX idx_item_compra_quantidade ON item_compra (quantidade);

-- 8. 
explain SELECT DISTINCT ec.* FROM entrega e JOIN empresa_colaboradora ec ON e.id_entregador = ec.id WHERE e.data BETWEEN '2024-01-01' AND '2024-12-31';
CREATE INDEX idx_entrega_data_entregador ON entrega (data, id_entregador) WHERE data BETWEEN '2024-01-01' AND '2024-12-31';

-- 9. 
explain SELECT c.* FROM compra c JOIN pf p ON c.id_cliente = p.id WHERE p.salario > 5000.00;
CREATE INDEX idx_pf_salario ON pf (salario);

-- 10. 
explain SELECT p.* FROM produto p JOIN empresa_colaboradora ec ON p.id_fornecedor = ec.id WHERE ec.nome ILIKE '%Empresa 1%';
CREATE INDEX idx_produto_id_fornecedor ON produto (id_fornecedor);
CREATE INDEX idx_empresa_colaboradora_nome ON empresa_colaboradora (nome) WHERE nome ILIKE '%Empresa 1%';

-- 11. 
explain SELECT * FROM cliente WHERE endereco IS NULL;
CREATE INDEX idx_cliente_endereco ON cliente(endereco);

-- 12. 
explain SELECT d.* FROM devolucao d JOIN item_compra ic ON d.id_item_compra = ic.id JOIN produto p ON ic.id_produto = p.id WHERE p.preco_unitario > 200.00;
CREATE INDEX idx_devolucao_id_item_compra ON devolucao (id_item_compra);

-- 13. 
explain SELECT DISTINCT c.* FROM cliente c JOIN compra co ON c.id = co.id_cliente WHERE co.data BETWEEN '2023-02-01' AND '2023-02-28';
CREATE INDEX idx_compra_cliente_data ON compra (data, id_cliente) WHERE data BETWEEN '2023-02-01' AND '2023-02-28';

-- 14. 
explain SELECT * FROM entrega WHERE data > '2001-01-01';
CREATE INDEX idx_entrega_data ON entrega (data);

-- 15. 
explain SELECT * FROM pj WHERE lucro > 1000.00;
CREATE INDEX idx_pj_lucro ON pj (lucro);

