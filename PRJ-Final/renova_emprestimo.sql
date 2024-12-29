-- Função praa renovar o empréstimo
CREATE OR REPLACE FUNCTION renovar_emprestimo(
    p_exemplar_codigo VARCHAR,
    p_usuario_cpf VARCHAR,
    p_dias_renovacao INTEGER
) RETURNS DATE AS $$
DECLARE
    v_emprestimo_id INTEGER;
    v_nova_data_devolucao DATE;
    v_tem_reserva BOOLEAN;
BEGIN
    -- Verifica se existe algum empréstimo ativo
    SELECT e.id INTO v_emprestimo_id
    FROM emprestimo e
    JOIN exemplar ex ON e.exemplar_id = ex.id
    JOIN usuario u ON e.usuario_id = u.id
    WHERE ex.codigo = p_exemplar_codigo 
    AND u.cpf = p_usuario_cpf 
    AND e.status = 'ATIVO';
    
    IF v_emprestimo_id IS NULL THEN
        RAISE EXCEPTION 'Empréstimo não encontrado';
    END IF;
    
    -- Verifica se existe reserva pro livro
    SELECT EXISTS (
        SELECT 1
        FROM reserva r
        JOIN exemplar ex ON ex.livro_id = r.livro_id
        WHERE ex.codigo = p_exemplar_codigo
        AND r.status = 'ATIVA'
    ) INTO v_tem_reserva;
    
    IF v_tem_reserva THEN
        RAISE EXCEPTION 'Não é possível renovar. Existe uma reserva para este livro.';
    END IF;
    
    -- Atualizar data de devolução
    v_nova_data_devolucao := CURRENT_DATE + p_dias_renovacao;
    
    UPDATE emprestimo SET
        data_devolucao_prevista = v_nova_data_devolucao
    WHERE id = v_emprestimo_id;