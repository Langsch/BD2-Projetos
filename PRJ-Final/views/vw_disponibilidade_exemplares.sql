-- View para exibir a disponibilidade de exemplares

CREATE OR REPLACE VIEW public.vw_disponibilidade_exemplares
AS SELECT l.titulo,
    l.isbn,
    count(e.codigo) AS total_exemplares,
    count(e.codigo) FILTER (WHERE e.status::text = 'DISPONÍVEL'::text) AS exemplares_disponiveis,
    count(e.codigo) FILTER (WHERE e.status::text = 'EMPRESTADO'::text) AS exemplares_emprestados,
    count(e.codigo) FILTER (WHERE e.status::text = 'EM_MANUTENÇÃO'::text) AS exemplares_manutencao
   FROM livro l
     LEFT JOIN exemplar e ON l.isbn::text = e.isbn::text
  GROUP BY l.isbn, l.titulo
  ORDER BY l.titulo;