-- 3. Função pra verificar disponibilidade dos exemplares
CREATE OR REPLACE FUNCTION verificar_disponibilidade(
    p_isbn VARCHAR
) RETURNS TABLE (
    exemplares_total INTEGER,
    exemplares_disponiveis INTEGER,
    proxima_devolucao DATE
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(e.id)::INTEGER as exemplares_total,
        COUNT(e.id) FILTER (WHERE e.status = 'DISPONÍVEL')::INTEGER as exemplares_disponiveis,
        MIN(emp.data_devolucao_prevista) as proxima_devolucao
    FROM livro l
    LEFT JOIN exemplar e ON l.id = e.livro_id
    LEFT JOIN emprestimo emp ON e.id = emp.exemplar_id AND emp.status = 'ATIVO'
    WHERE l.isbn = p_isbn
    GROUP BY l.id;
END;
$$ LANGUAGE plpgsql;