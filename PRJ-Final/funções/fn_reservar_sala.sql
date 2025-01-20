-- Função para reservar uma sala
CREATE OR REPLACE FUNCTION public.fn_reservar_sala(p_cpf_usuario character varying, p_id_sala integer, p_data_inicio timestamp without time zone, p_data_fim timestamp without time zone)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_usuario_status VARCHAR;
    v_sala_status VARCHAR;
BEGIN
    -- Verificar se usuário existe e está ativo
    SELECT status INTO v_usuario_status
    FROM usuario
    WHERE cpf = p_cpf_usuario;

    IF NOT FOUND THEN
        RETURN 'Usuário não encontrado';
    END IF;

    IF v_usuario_status != 'ATIVO' THEN
        RETURN 'Usuário não está ativo';
    END IF;

    -- Verificar se sala existe e está disponível
    SELECT status INTO v_sala_status
    FROM sala
    WHERE id = p_id_sala;

    IF NOT FOUND THEN
        RETURN 'Sala não encontrada';
    END IF;

    IF v_sala_status != 'DISPONÍVEL' THEN
        RETURN 'Sala não está disponível';
    END IF;

    -- Verificar datas
    IF p_data_inicio >= p_data_fim THEN
        RETURN 'Data de início deve ser anterior à data de fim';
    END IF;

    -- Inserir reserva
    INSERT INTO reserva_sala (
        data_inicio,
        data_fim,
        status,
        cpf_usuario,
        id_sala
    ) VALUES (
        p_data_inicio,
        p_data_fim,
        'ATIVO',
        p_cpf_usuario,
        p_id_sala
    );

    RETURN 'Reserva realizada com sucesso';
END;
$function$
;
