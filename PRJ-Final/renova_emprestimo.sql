-- Função praa renovar o empréstimo
CREATE OR REPLACE FUNCTION renovar_emprestimo(
    p_exemplar_codigo VARCHAR,
    p_usuario_cpf VARCHAR,
    p_dias_renovacao INTEGER
) RETURNS DATE AS $$
DECLARE
    v_emprestimo_id INTEGER;
    v_livro_id INTEGER;
    v_nova_data_devolucao DATE;
BEGIN
    -- Verificar se existe empréstimo ativo
    SELECT e.id, ex.livro_id INTO v_emprestimo_id, v_livro_id
    FROM emprestimo e
    JOIN exemplar ex ON e.exemplar_id = ex.id
    JOIN usuario u ON e.usuario_id = u.id
    WHERE ex.codigo = p_exemplar_codigo 
    AND u.cpf = p_usuario_cpf 
    AND e.status = 'ATIVO';
    
    IF v_emprestimo_id IS NULL THEN
        RAISE EXCEPTION 'Empréstimo não encontrado';
    END IF;
    
    -- Verificar se existe reserva para o livro
    IF EXISTS (
        SELECT 1
        FROM reserva r
        WHERE r.livro_id = v_livro_id
        AND r.status = 'ATIVA'
    ) THEN
        RAISE EXCEPTION 'Não é possível renovar. Existe uma reserva para este livro.';
    END IF;
    
    -- Atualizar data de devolução
    v_nova_data_devolucao := CURRENT_DATE + p_dias_renovacao;
    
    UPDATE emprestimo SET
        data_devolucao_prevista = v_nova_data_devolucao
    WHERE id = v_emprestimo_id;
    
    RETURN v_nova_data_devolucao;
END;
$$ LANGUAGE plpgsql;