-- Criação do banco de dados e das tabelas
CREATE TABLE livro (
    id SERIAL PRIMARY KEY,
    isbn VARCHAR(255) NOT NULL,
    titulo VARCHAR(255) NOT NULL,
    ano_publicacao DATE,
    edicao VARCHAR(255),
    idioma VARCHAR(255),
    num_paginas INTEGER,
    formato VARCHAR(255),
    sinopse TEXT,
    capa_url VARCHAR(255)
);

CREATE TABLE acervo_digital (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    formato VARCHAR(255),
    url VARCHAR(255),
    tamanho INTEGER,
    licenca VARCHAR(255),
    requisitos TEXT,
    livro_id INTEGER REFERENCES livro(id)
);

CREATE TABLE exemplar (
    id SERIAL PRIMARY KEY,
    codigo VARCHAR(255) NOT NULL,
    status VARCHAR(255),
    data_aquisicao DATE,
    condicao VARCHAR(255),
    localizacao VARCHAR(255),
    tipo_aquisicao VARCHAR(255),
    livro_id INTEGER REFERENCES livro(id)
);

CREATE TABLE autor (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    biografia TEXT,
    data_nascimento DATE,
    nacionalidade VARCHAR(255),
    pseudonimo VARCHAR(255)
);

CREATE TABLE editora (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    cnpj VARCHAR(255),
    endereco VARCHAR(255),
    telefone VARCHAR(255),
    email VARCHAR(255),
    website VARCHAR(255)
);

CREATE TABLE categoria (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    descricao TEXT,
    categoria_pai INTEGER
);

CREATE TABLE usuario (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    cpf VARCHAR(255),
    email VARCHAR(255),
    telefone VARCHAR(255),
    endereco VARCHAR(255),
    data_nascimento DATE,
    tipo_usuario VARCHAR(255),
    status VARCHAR(255)
);

CREATE TABLE funcionario (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    cpf VARCHAR(255),
    email VARCHAR(255),
    telefone VARCHAR(255),
    cargo VARCHAR(255),
    data_contratacao DATE,
    status VARCHAR(255)
);

CREATE TABLE emprestimo (
    id SERIAL PRIMARY KEY,
    data_emprestimo DATE,
    data_devolucao_prevista DATE,
    data_devolucao_efetiva DATE,
    status VARCHAR(255),
    observacoes TEXT,
    exemplar_id INTEGER REFERENCES exemplar(id),
    usuario_id INTEGER REFERENCES usuario(id),
    funcionario_id INTEGER REFERENCES funcionario(id)
);

CREATE TABLE reserva (
    id SERIAL PRIMARY KEY,
    data_reserva DATE,
    data_limite DATE,
    status VARCHAR(255),
    prioridade INTEGER,
    usuario_id INTEGER REFERENCES usuario(id),
    livro_id INTEGER REFERENCES livro(id)
);

CREATE TABLE multa (
    id SERIAL PRIMARY KEY,
    valor DECIMAL,
    data_geracao DATE,
    status VARCHAR(255),
    motivo VARCHAR(255),
    usuario_id INTEGER REFERENCES usuario(id)
);

CREATE TABLE pagamento (
    id SERIAL PRIMARY KEY,
    valor DECIMAL,
    data_pagamento DATE,
    forma_pagamento VARCHAR(255),
    comprovante VARCHAR(255),
    multa_id INTEGER REFERENCES multa(id)
);

CREATE TABLE evento (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    descricao TEXT,
    data_inicio DATE,
    data_fim DATE,
    capacidade INTEGER,
    tipo_evento VARCHAR(255),
    status VARCHAR(255),
    funcionario_id INTEGER REFERENCES funcionario(id)
);

CREATE TABLE sala (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    capacidade INTEGER,
    tipo VARCHAR(255),
    status VARCHAR(255),
    equipamentos TEXT
);

CREATE TABLE reserva_sala (
    id SERIAL PRIMARY KEY,
    data_inicio DATE,
    data_fim DATE,
    finalidade VARCHAR(255),
    status VARCHAR(255),
    sala_id INTEGER REFERENCES sala(id),
    usuario_id INTEGER REFERENCES usuario(id)
);

CREATE TABLE fornecedor (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    cnpj VARCHAR(255),
    endereco VARCHAR(255),
    telefone VARCHAR(255),
    email VARCHAR(255),
    tipo_fornecedor VARCHAR(255)
);

CREATE TABLE aquisicao (
    id SERIAL PRIMARY KEY,
    data_pedido DATE,
    data_chegada DATE,
    valor_total DECIMAL,
    status VARCHAR(255),
    nota_fiscal VARCHAR(255),
    fornecedor_id INTEGER REFERENCES fornecedor(id)
);

-- Tabelas de relacionamentos many-to-many
CREATE TABLE livro_autor (
    livro_id INTEGER REFERENCES livro(id),
    autor_id INTEGER REFERENCES autor(id),
    PRIMARY KEY (livro_id, autor_id)
);

CREATE TABLE livro_categoria (
    livro_id INTEGER REFERENCES livro(id),
    categoria_id INTEGER REFERENCES categoria(id),
    PRIMARY KEY (livro_id, categoria_id)
);



-- Índices para otimização
CREATE INDEX idx_livro_isbn ON livro(isbn);
CREATE INDEX idx_exemplar_codigo ON exemplar(codigo);
CREATE INDEX idx_usuario_cpf ON usuario(cpf);
CREATE INDEX idx_funcionario_cpf ON funcionario(cpf);