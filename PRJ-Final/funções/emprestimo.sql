-- Função para realizar um empréstimo
CREATE OR REPLACE FUNCTION realizar_emprestimo(
    p_exemplar_codigo VARCHAR,
    p_usuario_cpf VARCHAR,
    p_funcionario_cpf VARCHAR,
    p_dias_emprestimo INTEGER
) RETURNS INTEGER AS $$
DECLARE
    v_exemplar_id INTEGER;
    v_usuario_id INTEGER;
    v_funcionario_id INTEGER;
    v_emprestimo_id INTEGER;
BEGIN
    -- Verificar se o exemplar está disponível
    SELECT id INTO v_exemplar_id
    FROM exemplar
    WHERE codigo = p_exemplar_codigo AND status = 'DISPONÍVEL';
    
    IF v_exemplar_id IS NULL THEN
        RAISE EXCEPTION 'Exemplar não disponível ou não encontrado';
    END IF;
    
    -- Obter os ids
    SELECT id INTO v_usuario_id FROM usuario WHERE cpf = p_usuario_cpf;
    SELECT id INTO v_funcionario_id FROM funcionario WHERE cpf = p_funcionario_cpf;
    
    -- Inserir o empréstimo
    INSERT INTO emprestimo (
        exemplar_id,
        usuario_id,
        funcionario_id,
        data_emprestimo,
        data_devolucao_prevista,
        status
    ) VALUES (
        v_exemplar_id,
        v_usuario_id,
        v_funcionario_id,
        CURRENT_DATE,
        CURRENT_DATE + p_dias_emprestimo,
        'ATIVO'
    ) RETURNING id INTO v_emprestimo_id;
    
    -- Atualizar o status do exemplar
    UPDATE exemplar SET status = 'EMPRESTADO' WHERE id = v_exemplar_id;
    
    RETURN v_emprestimo_id;
END;
$$ LANGUAGE plpgsql;
