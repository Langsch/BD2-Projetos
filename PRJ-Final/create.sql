-- Criação do banco de dados para o sistema de biblioteca
-- Ordem das tabelas respeita as dependências de foreign keys

-- =====================================================
-- Primeiro criamos as tabelas independentes (sem foreign keys)
-- =====================================================

-- Tabela de editoras que publicam os livros
CREATE TABLE editora (
    id SERIAL PRIMARY KEY,
    nome VARCHAR NOT NULL,
    cnpj VARCHAR NOT NULL,
    endereco VARCHAR,
    telefone VARCHAR,
    email VARCHAR,
    website VARCHAR
);

-- Tabela de autores dos livros
CREATE TABLE autor (
    id SERIAL PRIMARY KEY,
    nome VARCHAR NOT NULL,
    biografia TEXT,
    data_nascimento DATE,
    nacionalidade VARCHAR,
    pseudonimo VARCHAR
);

-- Tabela de categorias/gêneros dos livros
CREATE TABLE categoria (
    id SERIAL PRIMARY KEY,
    nome VARCHAR NOT NULL,
    descricao TEXT
);

-- Tabela de usuários da biblioteca
CREATE TABLE usuario (
    cpf VARCHAR PRIMARY KEY NOT NULL,
    nome VARCHAR NOT NULL,
    email VARCHAR,
    telefone VARCHAR,
    endereco VARCHAR,
    data_nascimento DATE,
    tipo_usuario VARCHAR,
    status VARCHAR
);

-- Tabela de funcionários da biblioteca
CREATE TABLE funcionario (
    id SERIAL PRIMARY KEY,
    nome VARCHAR NOT NULL,
    cpf VARCHAR NOT NULL,
    email VARCHAR,
    telefone VARCHAR,
    cargo VARCHAR,
    data_contratacao DATE,
    status VARCHAR
);

-- Tabela de fornecedores de livros
CREATE TABLE fornecedor (
    cnpj VARCHAR PRIMARY KEY NOT NULL,
    nome VARCHAR NOT NULL,
    endereco VARCHAR,
    telefone VARCHAR,
    email VARCHAR,
    tipo_fornecedor VARCHAR
);

-- Tabela de salas disponíveis na biblioteca
CREATE TABLE sala (
    id SERIAL PRIMARY KEY,
    nome VARCHAR NOT NULL,
    capacidade INTEGER,
    tipo VARCHAR,
    status VARCHAR,
    equipamentos TEXT
);

-- =====================================================
-- Agora as tabelas que possuem foreign keys
-- =====================================================

-- Tabela principal de livros
CREATE TABLE livro (
    isbn VARCHAR PRIMARY KEY NOT NULL,
    titulo VARCHAR NOT NULL,
    editora_id INTEGER,
    ano_publicacao DATE,
    edicao VARCHAR,
    idioma VARCHAR,
    num_paginas INTEGER,
    formato VARCHAR,
    sinopse TEXT,
    capa_url VARCHAR,
    FOREIGN KEY (editora_id) REFERENCES editora(id)
);

-- Tabela de exemplares físicos dos livros
CREATE TABLE exemplar (
    codigo UUID PRIMARY KEY NOT NULL,
    status VARCHAR NOT NULL CHECK (status IN ('DISPONÍVEL', 'EMPRESTADO', 'EM_MANUTENÇÃO', 'EXTRAVIADO')),
    data_aquisicao DATE,
    condicao VARCHAR,
    localizacao VARCHAR,
    tipo_aquisicao VARCHAR,
    isbn VARCHAR,
    FOREIGN KEY (isbn) REFERENCES livro(isbn)
);

-- Tabela de empréstimos de exemplares
CREATE TABLE emprestimo (
    id SERIAL PRIMARY KEY,
    data_emprestimo DATE NOT NULL,
    data_devolucao_prevista DATE,
    data_devolucao_efetiva DATE,
    status VARCHAR NOT NULL,
    observacoes TEXT,
    codigo_exemplar UUID,
    cpf_usuario VARCHAR,
    id_funcionario INTEGER,
    FOREIGN KEY (codigo_exemplar) REFERENCES exemplar(codigo),
    FOREIGN KEY (cpf_usuario) REFERENCES usuario(cpf),
    FOREIGN KEY (id_funcionario) REFERENCES funcionario(id)
);

-- Tabela de reservas de livros
CREATE TABLE reserva (
    id SERIAL PRIMARY KEY,
    data_reserva DATE NOT NULL,
    data_limite DATE,
    status VARCHAR NOT NULL,
    prioridade INTEGER,
    cpf_usuario VARCHAR,
    isbn_livro VARCHAR,
    id_funcionario INTEGER,
    FOREIGN KEY (isbn_livro) REFERENCES livro(isbn),
    FOREIGN KEY (cpf_usuario) REFERENCES usuario(cpf),
    FOREIGN KEY (id_funcionario) REFERENCES funcionario(id)
);

-- Tabela de multas por atraso ou danos
CREATE TABLE multa (
    id SERIAL PRIMARY KEY,
    valor DECIMAL(10, 2) NOT NULL,
    data_geracao DATE NOT NULL,
    status VARCHAR NOT NULL,
    motivo VARCHAR,
    cpf_usuario VARCHAR,
    id_emprestimo INTEGER,
    FOREIGN KEY (cpf_usuario) REFERENCES usuario(cpf),
    FOREIGN KEY (id_emprestimo) REFERENCES emprestimo(id)
);

-- Tabela de pagamentos de multas
CREATE TABLE pagamento (
    id SERIAL PRIMARY KEY,
    valor DECIMAL(10, 2) NOT NULL,
    data_pagamento DATE NOT NULL,
    forma_pagamento VARCHAR,
    comprovante VARCHAR,
    id_multa INTEGER,
    FOREIGN KEY (id_multa) REFERENCES multa(id)
);

-- Tabela de reservas de salas
CREATE TABLE reserva_sala (
    id SERIAL PRIMARY KEY,
    data_inicio DATE NOT NULL,
    data_fim DATE,
    finalidade VARCHAR,
    status VARCHAR,
    cpf_usuario VARCHAR,
    id_sala INTEGER,
    FOREIGN KEY (cpf_usuario) REFERENCES usuario(cpf),
    FOREIGN KEY (id_sala) REFERENCES sala(id)
);

-- Tabela de acervo digital (e-books)
CREATE TABLE acervo_digital (
    id SERIAL PRIMARY KEY,
    isbn VARCHAR,
    titulo VARCHAR NOT NULL,
    formato VARCHAR,
    url VARCHAR,
    tamanho INTEGER,
    FOREIGN KEY (isbn) REFERENCES livro(isbn)
);

-- Tabela de aquisições de livros
CREATE TABLE aquisicao (
    id SERIAL PRIMARY KEY,
    data_pedido DATE NOT NULL,
    data_chegada DATE,
    valor_total DECIMAL(10, 2) NOT NULL,
    status VARCHAR NOT NULL,
    nota_fiscal VARCHAR,
    cnpj_fornecedor VARCHAR,
    FOREIGN KEY (cnpj_fornecedor) REFERENCES fornecedor(cnpj)
);

-- Tabela que relaciona aquisição com exemplar
CREATE TABLE aquisicao_exemplar (
    id_aquisicao INTEGER REFERENCES aquisicao(id),
    codigo_exemplar UUID REFERENCES exemplar(codigo),
    PRIMARY KEY (id_aquisicao, codigo_exemplar)
);

-- =====================================================
-- Tabelas de relacionamentos many-to-many
-- =====================================================

-- Relacionamento entre livros e autores
CREATE TABLE livro_autor (
    isbn_livro VARCHAR REFERENCES livro(isbn),
    id_autor INTEGER REFERENCES autor(id),
    PRIMARY KEY (isbn_livro, id_autor)
);

-- Relacionamento entre livros e categorias
CREATE TABLE livro_categoria (
    isbn_livro VARCHAR REFERENCES livro(isbn),
    id_categoria INTEGER REFERENCES categoria(id),
    PRIMARY KEY (isbn_livro, id_categoria)
);

-- =====================================================
-- Criação de índices para otimização de consultas
-- =====================================================

CREATE INDEX idx_livro_isbn ON livro(isbn);
CREATE INDEX idx_exemplar_codigo ON exemplar(codigo);
CREATE INDEX idx_usuario_cpf ON usuario(cpf);
CREATE INDEX idx_funcionario ON funcionario(id);
CREATE INDEX idx_reserva_isbn ON reserva(isbn_livro);
CREATE INDEX idx_aquisicao_exemplar ON aquisicao_exemplar(id_aquisicao, codigo_exemplar);