-- Indice para consulta 1:
CREATE INDEX idx_aquisicao_data_pedido ON aquisicao (data_pedido); -- Acelera a busca por pedidos dentro de um mês específico e a agregação por mês

-- Indices para consulta 2:
CREATE INDEX idx_autor_nacionalidade ON autor (nacionalidade); -- Agiliza a busca por autores brasileiros
CREATE INDEX idx_livro_autor_isbn_id ON livro_autor (isbn_livro, id_autor); -- Otimiza a junção entre livros e autores.

-- Indice para consulta 3:
CREATE INDEX idx_emprestimo_data_emprestimo_codigo_exemplar ON emprestimo (data_emprestimo, codigo_exemplar); -- Acelera a filtragem por ano na tabela emprestimo e otimiza a junção entre emprestimo e exemplar.

-- Indice para consulta 4:
CREATE INDEX idx_autor_nome ON autor (nome); -- Agiliza a busca pelo nome do autor
CREATE INDEX idx_livro_autor_isbn_id ON livro_autor (id_autor,isbn_livro); -- Otimiza a junção entre livro e autor

--Indice para consulta 5:
CREATE INDEX idx_exemplar_codigo ON exemplar (codigo); -- Otimiza a junção entre exemplar e emprestimo na subconsulta.

--Indice para consulta 6:
CREATE INDEX idx_multa_status ON multa (status) where status = 'PENDENTE'; --Agiliza a busca por multas pendentes

--Indice para consulta 7:
CREATE INDEX idx_pagamento_data_pagamento ON pagamento (data_pagamento); --acelera a busca por pagamentos dentro de um ano específico, a agregação por mês e a ordenação.

--Indice para consulta 8:
CREATE INDEX idx_reserva_cpf_usuario ON reserva (cpf_usuario); -- Otimiza a junção entre reserva e usuario.

--Indice para cunsulta 9:
CREATE INDEX idx_evento_data_fim ON evento (data_fim); --Agiliza a busca por eventos ativos.

--Indice para consulta 10:

CREATE INDEX idx_emprestimo_cpf_usuario ON emprestimo (cpf_usuario); --Otimiza a junção com usuario e multa.
CREATE INDEX idx_multa_id_emprestimo ON multa (id_emprestimo); --Otimiza a junção com emprestimo.
