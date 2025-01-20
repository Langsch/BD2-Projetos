-- Função para realizar devolução
CREATE OR REPLACE FUNCTION public.fn_realizar_devolucao(p_codigo_exemplar uuid, p_cpf_usuario character varying)
 RETURNS TABLE(mensagem character varying, valor_multa numeric)
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_emprestimo_id INTEGER;
    v_data_prevista DATE;
    v_dias_atraso INTEGER;
    v_valor_multa DECIMAL(10,2) := 0;
BEGIN
    -- Buscar o empréstimo
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

    -- Atualizar status
    UPDATE exemplar SET status = 'DISPONÍVEL'
    WHERE codigo = p_codigo_exemplar;

    UPDATE emprestimo 
    SET status = 'FINALIZADO',
        data_devolucao_efetiva = CURRENT_DATE
    WHERE id = v_emprestimo_id;

    RETURN QUERY SELECT 'Devolução realizada com sucesso'::VARCHAR, 0::DECIMAL;
END;
$function$
;