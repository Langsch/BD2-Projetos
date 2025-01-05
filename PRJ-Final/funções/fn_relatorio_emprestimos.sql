-- Função pra gerar relatório dos empréstimos p/ período
CREATE OR REPLACE FUNCTION public.fn_relatorio_emprestimos(p_data_inicio date, p_data_fim date)
 RETURNS TABLE(total_emprestimos integer, media_diaria numeric, total_atrasos integer, valor_multas numeric)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    WITH emprestimos_periodo AS (
        SELECT *
        FROM emprestimo
        WHERE data_emprestimo BETWEEN p_data_inicio AND p_data_fim
    )
    SELECT 
        COUNT(*)::INTEGER as total_emprestimos,
        COUNT(*)::DECIMAL / (p_data_fim - p_data_inicio)::DECIMAL as media_diaria,
        COUNT(*) FILTER (WHERE data_devolucao_efetiva > data_devolucao_prevista)::INTEGER as total_atrasos,
        COALESCE(SUM(m.valor), 0) as valor_multas
    FROM emprestimos_periodo e
    LEFT JOIN multa m ON e.id = m.id_emprestimo;
END;
$function$
;
