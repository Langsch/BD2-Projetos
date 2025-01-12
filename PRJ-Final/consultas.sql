-- 1) Consulta o número de aquisições e o custo por mês: 
SELECT 
	DATE_PART('Month', data_pedido) AS mes,
	COUNT(id) AS qtd_pedidos,
	SUM(valor_total) AS total_mes  
FROM aquisicao
GROUP BY mes;
	
-- 2) Consulta todos os livros escritos por autores estrangeiros:
SELECT 
	li.isbn,
	li.titulo,
	li.edicao,
	li.idioma,
	li.sinopse
FROM livro li,
WHERE isbn NOT IN (
	SELECT l.isbn 
	FROM livro l, livro_autor la, autor a
	WHERE l.isbn = la.isbn_livro AND a.id = la.id_autor AND a.nacionalidade LIKE 'Brasileiro(a)';
);

-- 3) Consulta os 10 livros mais emprestados de 2024:
SELECT 
	l.titulo, 
	l.sinopse, 
	COUNT(l.isbn) AS qtd_emprestimo
FROM livro l, exemplar e, emprestimo emp
WHERE l.isbn = e.isbn AND e.codigo = emp.codigo_exemplar AND DATA_PART('Year', emp.data_emprestimo) = 2024 
ORDER BY(qtd_emprestimo) DESC
LIMIT 10; 

-- 4) Consulta todos os livros registrados de um determinado autor: 
SELECT 
	l.isbn,
	l.titulo,
	l.sinopse 
FROM livro l, livro_autor la, autor a 
WHERE l.isbn = la.isbn_livro AND la.id_autor = a.id AND a.nome LIKE 'Machado de Assis';

-- 5) Consulta os livros nunca emprestados: 
SELECT 
	isbn,
	titulo
FROM livro 
WHERE isbn NOT IN (
	SELECT 
		l.isbn
	FROM livro l, exemplar e, emprestimo emp
	WHERE l.isbn = e.isbn AND e.codigo = emp.codigo_exemplar
);

-- 6) Consulta os usuários com multa ativa: 
SELECT 
	u.nome,
	u.email,
	m.valor 
FROM usuario u, multa m
WHERE u.cpf = m.cpf_usuario AND m.status LIKE 'PENDENTE';

-- 7) Consulta o valor total de multas do ano, agrupadas pelo mês : 
SELECT 
	DATE_PART('Month', data_pagamento) AS mes,
	SUM(valor) AS total,
	COUNT(id_multa) AS qtd_multas 
FROM pagamento
WHERE DATE_PART('Year', data_pagamento) = 2024
GROUP BY mes
ORDER BY total DESC;

-- 8) Consulta os detalhes dos exemplares reservados:
SELECT
	l.isbn,
	l.titulo,
	r.data_reserva,
	r.status,
	u.nome
FROM livro l, exemplar e, reserva r, usuario u 
WHERE l.isbn = e.isbn AND e.codigo = r.codigo_exemplar AND r.cpf_usuario = u.cpf;

-- 9) Consulta as informações de eventos ativos e o contato do funcionario organizador:
SELECT 
	e.nome,
	e.descricao,
	e.data_inicio,
	e.data_fim,
	f.nome AS organizador,
	f.email,
	f.telefone
FROM evento e
JOIN funcionario f
	ON e.id_funcionario = f.id 
WHERE e.data_fim >= CURRENT_DATE;

-- 10) Consulta a porcentagem de emprestimos que se convertem em multa por usuário: 
SELECT 
	u.nome,
	u.email,
	u.telefone,
	COUNT(e.id) AS qtd_emprestimo,
	COUNT(m.id) AS qtd_multas, 
	ROUND(COUNT(m.id) * 100/ COUNT(e.id)::DECIMAL, 2) AS porcentagem_multas
FROM usuario u, emprestimo e, multa m
WHERE u.cpf = e.cpf_usuario AND e.id = m.id_emprestimo
GROUP BY 1, 2, 3;