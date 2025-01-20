-- Trigger para verificar se já existe uma reserva ativa para a sala no mesmo período

CREATE OR REPLACE FUNCTION public.fn_verificar_sobreposicao_reserva()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    -- Verificar se existe alguma reserva que se sobrepõe
    IF EXISTS (
        SELECT 1 
        FROM reserva_sala
        WHERE id_sala = NEW.id_sala
        AND status = 'ATIVO'
        AND id != COALESCE(NEW.id, -1)  -- Ignorar a própria reserva em caso de UPDATE
        AND (
            (NEW.data_inicio BETWEEN data_inicio AND data_fim)
            OR
            (NEW.data_fim BETWEEN data_inicio AND data_fim)
            OR
            (data_inicio BETWEEN NEW.data_inicio AND NEW.data_fim)
        )
    ) THEN
        RAISE EXCEPTION 'Já existe uma reserva ativa para esta sala neste período';
    END IF;
    
    RETURN NEW;
END;
$function$
;

CREATE TRIGGER tg_verificar_sobreposicao_reserva
    BEFORE INSERT OR UPDATE ON reserva_sala
    FOR EACH ROW
    EXECUTE FUNCTION fn_verificar_sobreposicao_reserva();