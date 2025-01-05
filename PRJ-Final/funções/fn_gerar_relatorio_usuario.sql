-- 3. Função para gerar relatório de usuário
CREATE OR REPLACE FUNCTION public.fn_gerar_relatorio_usuario(p_cpf character varying)
 RETURNS TABLE(nome character varying, email character varying, tipo_usuario character varying, status_usuario character varying, total_emprestimos_realizados bigint, emprestimos_ativos bigint, livros_em_atraso bigint, total_multas numeric, multas_pendentes numeric, reservas_ativas bigint, salas_reservadas bigint)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        u.nome,
        u.email,
        u.tipo_usuario,
        u.status,
        
        -- Estatísticas de empréstimos
        COUNT(DISTINCT e.id),
        COUNT(DISTINCT CASE WHEN e.status = 'ATIVO' THEN e.id END),
        COUNT(DISTINCT CASE 
            WHEN e.status = 'ATIVO' 
            AND e.data_devolucao_prevista < CURRENT_DATE 
            THEN e.id END),
        
        -- Estatísticas de multas
        COALESCE(SUM(m.valor), 0),
        COALESCE(SUM(CASE WHEN m.status = 'PENDENTE' THEN m.valor ELSE 0 END), 0),
        
        -- Reservas
        COUNT(DISTINCT CASE WHEN r.status = 'ATIVO' THEN r.id END),
        COUNT(DISTINCT CASE WHEN rs.status = 'ATIVO' THEN rs.id END)
        
    FROM usuario u
    LEFT JOIN emprestimo e ON u.cpf = e.cpf_usuario
    LEFT JOIN multa m ON e.id = m.id_emprestimo
    LEFT JOIN reserva r ON u.cpf = r.cpf_usuario
    LEFT JOIN reserva_sala rs ON u.cpf = rs.cpf_usuario
    WHERE u.cpf = p_cpf
    GROUP BY u.cpf, u.nome, u.email, u.tipo_usuario, u.status;
END;
$function$
;