-- Função para renovar o empréstimo
CREATE OR REPLACE FUNCTION public.fn_renovar_emprestimo(p_codigo_exemplar uuid, p_cpf_usuario character varying)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_tem_reserva BOOLEAN;
    v_tem_multa BOOLEAN;
    v_nova_data DATE;
BEGIN
    -- Verificar se há reservas para o exemplar
    SELECT EXISTS(
        SELECT 1 FROM reserva 
        WHERE codigo_exemplar = p_codigo_exemplar 
        AND status = 'ATIVA'
    ) INTO v_tem_reserva;

    -- Verificar se usuário tem multas pendentes
    SELECT EXISTS(
        SELECT 1 FROM multa 
        WHERE cpf_usuario = p_cpf_usuario 
        AND status = 'PENDENTE'
    ) INTO v_tem_multa;

    IF v_tem_reserva THEN
        RETURN 'Não é possível renovar. Exemplar possui reserva.';
    END IF;

    IF v_tem_multa THEN
        RETURN 'Não é possível renovar. Usuário possui multas pendentes.';
    END IF;

    -- Calcular nova data (mais 7 dias)
    SELECT data_devolucao_prevista + 7 
    INTO v_nova_data 
    FROM emprestimo 
    WHERE codigo_exemplar = p_codigo_exemplar 
    AND cpf_usuario = p_cpf_usuario 
    AND status = 'ATIVO';

    -- Atualizar data de devolução
    UPDATE emprestimo 
    SET data_devolucao_prevista = v_nova_data
    WHERE codigo_exemplar = p_codigo_exemplar 
    AND cpf_usuario = p_cpf_usuario 
    AND status = 'ATIVO';

    RETURN 'Empréstimo renovado com sucesso. Nova data de devolução: ' || v_nova_data::VARCHAR;
END;
$function$
;