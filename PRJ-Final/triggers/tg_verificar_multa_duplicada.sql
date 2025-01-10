-- Trigger para verificar se já existe uma multa pendente para um empréstimo

CREATE OR REPLACE FUNCTION public.fn_verificar_multa_duplicada()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    IF EXISTS (
        SELECT 1 FROM multa 
        WHERE id_emprestimo = NEW.id_emprestimo 
        AND status = 'PENDENTE'
    ) THEN
        RAISE EXCEPTION 'Já existe uma multa pendente para este empréstimo';
    END IF;
    RETURN NEW;
END;
$function$
;

CREATE TRIGGER tg_verificar_multa_duplicada
    BEFORE INSERT ON multa
    FOR EACH ROW
    EXECUTE FUNCTION fn_verificar_multa_duplicada();