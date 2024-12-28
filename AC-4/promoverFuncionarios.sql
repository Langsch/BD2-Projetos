CREATE OR REPLACE FUNCTION PromoverFuncionario(
    p_cpf VARCHAR(11),
    p_novo_nivel INTEGER
) RETURNS BOOLEAN AS $$
DECLARE
    v_nivel_atual INTEGER;
    v_ultima_promocao DATE;
BEGIN
    -- Verificar se o funcionário existe e está ativo
    SELECT nivel INTO v_nivel_atual
    FROM funcionario
    WHERE cpf = p_cpf AND ativo = 'S';
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Funcionário não encontrado ou inativo';
    END IF;

    -- Verificar se o novo nível é válido (entre 1 e 7 e apenas um nível acima do atual)
    IF p_novo_nivel NOT BETWEEN 1 AND 7 OR p_novo_nivel != v_nivel_atual + 1 THEN
        RAISE EXCEPTION 'Nível de promoção inválido. Deve ser % (um nível acima do atual)', v_nivel_atual + 1;
    END IF;

    -- Verificar a data da última promoção
    SELECT MAX(data_promocao) INTO v_ultima_promocao
    FROM historico_promocoes
    WHERE cpf_funcionario = p_cpf;

    -- Verificar se passaram 3 anos desde a última promoção
    IF v_ultima_promocao IS NOT NULL AND 
       (CURRENT_DATE - v_ultima_promocao) < INTERVAL '3 years' THEN
        RAISE EXCEPTION 'Ainda não se passaram 3 anos desde a última promoção';
    END IF;

    -- Registrar a promoção
    INSERT INTO historico_promocoes (
        cpf_funcionario,
        cargo,
        nivel_anterior,
        nivel_novo,
        data_promocao
    ) VALUES (
        p_cpf,
        (SELECT cargo FROM funcionario WHERE cpf = p_cpf),
        v_nivel_atual,
        p_novo_nivel,
        CURRENT_DATE
    );

    -- Atualizar o nível do funcionário
    UPDATE funcionario
    SET nivel = p_novo_nivel
    WHERE cpf = p_cpf;

    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;