-- Trigger para atualizar o tipo de usuário baseado no número de empréstimos e reservas de sala

CREATE OR REPLACE FUNCTION public.fn_atualizar_tipo_usuario()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_count_emprestimos INTEGER;
    v_count_reservas_sala INTEGER;
    v_threshold_heavy INTEGER := 10;
BEGIN
    -- Contar empréstimos
    SELECT COUNT(*)
    INTO v_count_emprestimos
    FROM emprestimo
    WHERE cpf_usuario = NEW.cpf_usuario;

    -- Contar reservas de sala
    SELECT COUNT(*)
    INTO v_count_reservas_sala
    FROM reserva_sala
    WHERE cpf_usuario = NEW.cpf_usuario;

    -- Atualizar tipo_usuario baseado nas contagens
    UPDATE usuario
    SET tipo_usuario = 
        CASE 
            WHEN v_count_emprestimos >= v_threshold_heavy AND v_count_reservas_sala >= v_threshold_heavy 
                THEN 'heavy_user_leitor_estudante'
            WHEN v_count_emprestimos >= v_threshold_heavy AND v_count_reservas_sala < v_threshold_heavy 
                THEN 'heavy_user_leitor'
            WHEN v_count_emprestimos < v_threshold_heavy AND v_count_reservas_sala >= v_threshold_heavy 
                THEN 'heavy_user_estudante'
            WHEN v_count_emprestimos > 0 AND v_count_reservas_sala > 0 
                THEN 'light_user_leitor_estudante'
            WHEN v_count_emprestimos > 0 
                THEN 'light_user_leitor'
            WHEN v_count_reservas_sala > 0 
                THEN 'light_user_estudante'
            ELSE 'novo_usuario'
        END
    WHERE cpf = NEW.cpf_usuario;

    RETURN NEW;
END;
$function$;

CREATE TRIGGER tg_atualizar_tipo_usuario_on_empretimos
    AFTER INSERT OR UPDATE ON emprestimo
    FOR EACH STATEMENT
    EXECUTE FUNCTION fn_atualizar_tipo_usuario;

CREATE TRIGGER tg_atualizar_tipo_usuario_on_reservas
    AFTER INSERT OR UPDATE ON reserva_sala
    FOR EACH STATEMENT
    EXECUTE FUNCTION fn_atualizar_tipo_usuario();