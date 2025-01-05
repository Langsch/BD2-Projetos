-- Trigger para proteger a exclusão de exemplares com empréstimos ativos

CREATE OR REPLACE FUNCTION public.tg_proteger_exemplar_emprestado()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    IF EXISTS (
        SELECT 1 FROM emprestimo 
        WHERE codigo_exemplar = OLD.codigo 
        AND status = 'ATIVO'
    ) THEN
        RAISE EXCEPTION 'Não é possível excluir exemplar com empréstimo ativo';
    END IF;
    RETURN OLD;
END;
$function$
;
