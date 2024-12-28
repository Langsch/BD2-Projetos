-- Ajustando a tabela de funcionários para incluir cargo e nível
ALTER TABLE funcionario
ADD COLUMN cargo VARCHAR(6) DEFAULT 'CARGO1',
ADD COLUMN nivel INTEGER DEFAULT 1,
ALTER COLUMN salario TYPE NUMERIC(10,2); -- Ajustando o tipo do salário para ser mais preciso

-- Criação da tabela de controle de faltas
CREATE TABLE controle_faltas (
    id SERIAL PRIMARY KEY,
    cpf_funcionario VARCHAR(11) NOT NULL,
    data_falta DATE NOT NULL,
    justificativa TEXT,
    data_justificativa DATE,
    FOREIGN KEY (cpf_funcionario) REFERENCES funcionario(cpf)
);

-- Criação da tabela de histórico de promoções
CREATE TABLE historico_promocoes (
    id SERIAL PRIMARY KEY,
    cpf_funcionario VARCHAR(11) NOT NULL,
    cargo VARCHAR(6) NOT NULL,
    nivel_anterior INTEGER NOT NULL,
    nivel_novo INTEGER NOT NULL,
    data_promocao DATE NOT NULL,
    FOREIGN KEY (cpf_funcionario) REFERENCES funcionario(cpf)
);