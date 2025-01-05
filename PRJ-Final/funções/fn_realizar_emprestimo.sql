-- Função para realizar um empréstimo
CREATE OR REPLACE FUNCTION public.fn_realizar_emprestimo(p_codigo_exemplar uuid, p_cpf_usuario character varying)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_disponivel BOOLEAN;
    v_tem_multa BOOLEAN;
    v_qtd_emprestimos INTEGER;
BEGIN
    -- Verificar se exemplar está disponível
    SELECT status = 'DISPONÍVEL' 
    INTO v_disponivel
    FROM exemplar 
    WHERE codigo = p_codigo_exemplar;

    IF NOT v_disponivel THEN
        RETURN 'Exemplar não está disponível para empréstimo.';
    END IF;

    -- Verificar se usuário tem multas pendentes
    SELECT EXISTS(
        SELECT 1 FROM multa 
        WHERE cpf_usuario = p_cpf_usuario 
        AND status = 'PENDENTE'
    ) INTO v_tem_multa;

    IF v_tem_multa THEN
        RETURN 'Usuário possui multas pendentes.';
    END IF;

    -- Verificar quantidade de empréstimos ativos do usuário
    SELECT COUNT(*) 
    INTO v_qtd_emprestimos
    FROM emprestimo 
    WHERE cpf_usuario = p_cpf_usuario 
    AND status = 'ATIVO';

    IF v_qtd_emprestimos >= 3 THEN
        RETURN 'Usuário já atingiu o limite de empréstimos simultâneos.';
    END IF;

    -- Realizar o empréstimo
    INSERT INTO emprestimo (
        data_emprestimo,
        data_devolucao_prevista,
        status,
        codigo_exemplar,
        cpf_usuario
    ) VALUES (
        CURRENT_DATE,
        CURRENT_DATE + 7,
        'ATIVO',
        p_codigo_exemplar,
        p_cpf_usuario
    );

    -- Atualizar status do exemplar
    UPDATE exemplar 
    SET status = 'EMPRESTADO'
    WHERE codigo = p_codigo_exemplar;

    RETURN 'Empréstimo realizado com sucesso.';
END;
$function$
;