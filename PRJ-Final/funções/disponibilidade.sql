-- 3. Função pra verificar disponibilidade dos exemplares
CREATE OR REPLACE FUNCTION verificar_disponibilidade(
    p_isbn VARCHAR
) RETURNS TABLE (
    exemplares_disponiveis INTEGER,
    exemplares_total INTEGER,
    proxima_devolucao DATE
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(e.codigo) FILTER (WHERE e.status = 'DISPONÍVEL')::INTEGER as disponiveis,
        COUNT(e.codigo)::INTEGER as total,
        MIN(emp.data_devolucao_prevista) as proxima_devolucao
    FROM livro l
    LEFT JOIN exemplar e ON l.isbn = e.isbn
    LEFT JOIN emprestimo emp ON e.codigo = emp.codigo_exemplar 
        AND emp.status = 'ATIVO'
    WHERE l.isbn = p_isbn
    GROUP BY l.isbn;
END;
$$ LANGUAGE plpgsql;