-- Função pra gerar relatório dos empréstimos p/ período
CREATE OR REPLACE FUNCTION relatorio_emprestimos(
    p_data_inicio DATE,
    p_data_fim DATE
) RETURNS TABLE (
    total_emprestimos INTEGER,
    total_atrasos INTEGER,
    valor_multas DECIMAL,
    categoria_mais_emprestada VARCHAR,
    usuario_mais_ativo VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    WITH emprestimos_periodo AS (
        SELECT e.id, e.data_devolucao_prevista, e.data_devolucao_efetiva,
               u.nome as usuario_nome,
               c.nome as categoria_nome
        FROM emprestimo e
        JOIN usuario u ON e.usuario_id = u.id
        JOIN exemplar ex ON e.exemplar_id = ex.id
        JOIN livro l ON ex.livro_id = l.id
        JOIN livro_categoria lc ON l.id = lc.livro_id
        JOIN categoria c ON lc.categoria_id = c.id
        WHERE e.data_emprestimo BETWEEN p_data_inicio AND p_data_fim
    )
    SELECT 
        COUNT(*)::INTEGER as total_emprestimos,
        COUNT(*) FILTER (WHERE data_devolucao_efetiva > data_devolucao_prevista)::INTEGER as total_atrasos,
        COALESCE(SUM(m.valor), 0) as valor_multas,
        (SELECT categoria_nome 
         FROM emprestimos_periodo 
         GROUP BY categoria_nome 
         ORDER BY COUNT(*) DESC 
         LIMIT 1) as categoria_mais_emprestada,
        (SELECT usuario_nome 
         FROM emprestimos_periodo 
         GROUP BY usuario_nome 
         ORDER BY COUNT(*) DESC 
         LIMIT 1) as usuario_mais_ativo
    FROM emprestimos_periodo ep
    LEFT JOIN multa m ON m.data_geracao BETWEEN p_data_inicio AND p_data_fim;
END;
$$ LANGUAGE plpgsql;