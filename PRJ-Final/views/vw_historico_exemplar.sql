-- View para exibir o histórico de exemplares

CREATE OR REPLACE VIEW public.vw_historico_exemplar
AS SELECT l.titulo,
    e.codigo AS codigo_exemplar,
    e.status AS status_atual,
    e.data_aquisicao,
    count(emp.id) AS total_emprestimos,
    max(emp.data_emprestimo) AS ultimo_emprestimo,
    count(DISTINCT emp.cpf_usuario) AS usuarios_diferentes,
    count(m.id) AS total_multas_geradas
   FROM exemplar e
     JOIN livro l ON e.isbn::text = l.isbn::text
     LEFT JOIN emprestimo emp ON e.codigo = emp.codigo_exemplar
     LEFT JOIN multa m ON emp.id = m.id_emprestimo
  GROUP BY l.titulo, e.codigo, e.status, e.data_aquisicao;