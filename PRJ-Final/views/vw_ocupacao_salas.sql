-- View para exibir a ocupação das salas

CREATE OR REPLACE VIEW public.vw_ocupacao_salas
AS SELECT s.nome AS nome_sala,
    s.capacidade,
    rs.data_inicio,
    rs.data_fim,
    rs.finalidade,
    u.nome AS nome_usuario
   FROM sala s
     LEFT JOIN reserva_sala rs ON s.id = rs.id_sala
     LEFT JOIN usuario u ON rs.cpf_usuario::text = u.cpf::text
  WHERE rs.data_fim >= CURRENT_DATE
  ORDER BY rs.data_inicio;