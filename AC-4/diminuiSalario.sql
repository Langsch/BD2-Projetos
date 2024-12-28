CREATE OR REPLACE FUNCTION DiminuirSalario(
    p_cpf VARCHAR(11),
    p_percentual INTEGER
) RETURNS NUMERIC AS $$
DECLARE
    v_salario_atual NUMERIC(10,2);
    v_novo_salario NUMERIC(10,2);
BEGIN
    -- Verificar se o funcionário existe
    IF NOT EXISTS (SELECT 1 FROM funcionario WHERE cpf = p_cpf) THEN
        RAISE EXCEPTION 'Funcionário com CPF % não encontrado', p_cpf;
    END IF;

    -- Verificar se o percentual é válido
    IF p_percentual <= 0 OR p_percentual >= 100 THEN
        RAISE EXCEPTION 'Percentual deve estar entre 1 e 99';
    END IF;

    -- Buscar salário atual
    SELECT salario INTO v_salario_atual
    FROM funcionario
    WHERE cpf = p_cpf;

    -- Calcular novo salário
    v_novo_salario := v_salario_atual * (1 - p_percentual::NUMERIC/100);

    -- Atualizar salário
    UPDATE funcionario
    SET salario = v_novo_salario
    WHERE cpf = p_cpf;

    RETURN v_novo_salario;
END;
$$ LANGUAGE plpgsql;