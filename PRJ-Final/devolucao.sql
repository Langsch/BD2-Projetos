-- Função pra devolução
CREATE OR REPLACE FUNCTION realizar_devolucao(
    p_exemplar_codigo VARCHAR,
    p_usuario_cpf VARCHAR
) RETURNS DECIMAL AS $$
DECLARE
    v_exemplar_id INTEGER;
    v_emprestimo_id INTEGER;
    v_dias_atraso INTEGER;
    v_valor_multa DECIMAL;
BEGIN
    -- Localizar o empréstimo ativo
    SELECT e.id, e.exemplar_id INTO v_emprestimo_id, v_exemplar_id
    FROM emprestimo e
    JOIN exemplar ex ON e.exemplar_id = ex.id
    JOIN usuario u ON e.usuario_id = u.id
    WHERE ex.codigo = p_exemplar_codigo 
    AND u.cpf = p_usuario_cpf 
    AND e.status = 'ATIVO';
    
    IF v_emprestimo_id IS NULL THEN
        RAISE EXCEPTION 'Empréstimo não encontrado';
    END IF;
    
    -- Calcular os dias de atraso
    SELECT GREATEST(0, CURRENT_DATE - data_devolucao_prevista) INTO v_dias_atraso
    FROM emprestimo
    WHERE id = v_emprestimo_id;
    
    -- Registrar devolução
    UPDATE emprestimo SET
        data_devolucao_efetiva = CURRENT_DATE,
        status = 'DEVOLVIDO'
    WHERE id = v_emprestimo_id;
    
    -- Atualizar o status do exemplar
    UPDATE exemplar SET status = 'DISPONÍVEL' WHERE id = v_exemplar_id;
    
    -- Gerar multa caso necessário
    IF v_dias_atraso > 0 THEN
        v_valor_multa := v_dias_atraso * 2.00; -- R$ 2,00 por dia de atraso
        
        INSERT INTO multa (
            usuario_id,
            valor,
            data_geracao,
            status,
            motivo
        ) VALUES (
            (SELECT usuario_id FROM emprestimo WHERE id = v_emprestimo_id),
            v_valor_multa,
            CURRENT_DATE,
            'PENDENTE',
            'Atraso na devolução - ' || v_dias_atraso || ' dias'
        );
        
        RETURN v_valor_multa;
    END IF;
    
    RETURN 0;
END;
$$ LANGUAGE plpgsql;