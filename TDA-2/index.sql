-- Índice tabela Usuario, acelera a busca pelo Login
CREATE INDEX idx_usuario_login ON Usuario(Login);

-- Índice tabela Algoritmo, acelera a busca pelo Nome e Tipo
CREATE INDEX idx_algoritmo_nome ON Algoritmo(Nome);
CREATE INDEX idx_algoritmo_tipo ON Algoritmo(Tipo);

-- Índice tabela Treinamento, acelera a busca por Data e AlgId
CREATE INDEX idx_treinamento_data ON Treinamento(Data);
CREATE INDEX idx_treinamento_algid ON Treinamento(AlgId);

-- Índice tabela Modelo, acelera a busca por Path e Data
CREATE INDEX idx_modelo_path ON Modelo(Path);
CREATE INDEX idx_modelo_data ON Modelo(Data);
