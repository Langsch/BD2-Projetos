-- Função praa realizar devolução e gerar multa se necessário
CREATE OR REPLACE FUNCTION realizar_devolucao(
    p_codigo_exemplar UUID,
    p_cpf_usuario VARCHAR
) RETURNS TABLE (
    mensagem VARCHAR,
    valor_multa DECIMAL(10,2)
) AS $$
DECLARE
    v_emprestimo_id INTEGER;
    v_data_prevista DATE;
    v_dias_atraso INTEGER;
    v_valor_multa DECIMAL(10,2) := 0;
    v_multa_id INTEGER;
BEGIN
    -- Buscar o empréstimo ativo
    SELECT id, data_devolucao_prevista 
    INTO v_emprestimo_id, v_data_prevista
    FROM emprestimo 
    WHERE codigo_exemplar = p_codigo_exemplar 
    AND cpf_usuario = p_cpf_usuario 
    AND status = 'ATIVO';

    IF NOT FOUND THEN
        RETURN QUERY SELECT 'Empréstimo não encontrado'::VARCHAR, 0::DECIMAL;
        RETURN;
    END IF;

    -- Calcular dias de atraso
    IF CURRENT_DATE > v_data_prevista THEN
        v_dias_atraso := CURRENT_DATE - v_data_prevista;
        v_valor_multa := v_dias_atraso * 2.00; -- R$ 2,00 por dia de atraso

        -- Gerar multa
        INSERT INTO multa (valor, data_geracao, status, motivo, cpf_usuario, id_emprestimo)
        VALUES (v_valor_multa, CURRENT_DATE, 'PENDENTE', 'Atraso na devolução', p_cpf_usuario, v_emprestimo_id)
        RETURNING id INTO v_multa_id;
    END IF;

    -- Atualizar status do empréstimo e do exemplar
    UPDATE emprestimo 
    SET status = 'FINALIZADO',
        data_devolucao_efetiva = CURRENT_DATE
    WHERE id = v_emprestimo_id;

    UPDATE exemplar 
    SET status = 'DISPONÍVEL'
    WHERE codigo = p_codigo_exemplar;

    RETURN QUERY SELECT 
        CASE 
            WHEN v_valor_multa > 0 THEN 'Devolução realizada com multa'
            ELSE 'Devolução realizada com sucesso'
        END,
        v_valor_multa;
END;
$$ LANGUAGE plpgsql;