CREATE TABLE Livro (
    ISBN VARCHAR PRIMARY KEY NOT NULL,
    titulo VARCHAR NOT NULL,
    ano_publicacao DATE,
    edicao VARCHAR,
    idioma VARCHAR,
    num_paginas INTEGER,
    formato VARCHAR,
    sinopse TEXT,
    capa_url VARCHAR
);

CREATE TABLE Exemplar (
    codigo VARCHAR PRIMARY KEY NOT NULL,
    status VARCHAR NOT NULL,
    data_aquisicao DATE,
    condicao VARCHAR,
    localizacao VARCHAR,
    tipo_aquisicao VARCHAR,
    ISBN VARCHAR,
    FOREIGN KEY (ISBN) REFERENCES Livro(ISBN)
);

CREATE TABLE Autor (
    id SERIAL PRIMARY KEY,
    nome VARCHAR NOT NULL,
    biografia TEXT,
    data_nascimento DATE,
    nacionalidade VARCHAR,
    pseudonimo VARCHAR
);

CREATE TABLE Editora (
    id SERIAL PRIMARY KEY,
    nome VARCHAR NOT NULL,
    cnpj VARCHAR NOT NULL,
    endereco VARCHAR,
    telefone VARCHAR,
    email VARCHAR,
    website VARCHAR
);

CREATE TABLE Categoria (
    id SERIAL PRIMARY KEY,
    nome VARCHAR NOT NULL,
    descricao TEXT,
    categoria_pai INTEGER
);

CREATE TABLE Usuario (
    id SERIAL PRIMARY KEY,
    nome VARCHAR NOT NULL,
    cpf VARCHAR NOT NULL,
    email VARCHAR,
    telefone VARCHAR,
    endereco VARCHAR,
    data_nascimento DATE,
    tipo_usuario VARCHAR,
    status VARCHAR
);

CREATE TABLE Funcionario (
    id SERIAL PRIMARY KEY,
    nome VARCHAR NOT NULL,
    cpf VARCHAR NOT NULL,
    email VARCHAR,
    telefone VARCHAR,
    cargo VARCHAR,
    data_contratacao DATE,
    status VARCHAR
);

CREATE TABLE Emprestimo (
    id SERIAL PRIMARY KEY,
    data_emprestimo DATE NOT NULL,
    data_devolucao_prevista DATE,
    data_devolucao_efetiva DATE,
    status VARCHAR NOT NULL,
    observacoes TEXT,
    codigo_exemplar VARCHAR,
    cpf_usuario VARCHAR,
    FOREIGN KEY (codigo_exemplar) REFERENCES Exemplar(codigo),
    FOREIGN KEY (cpf_usuario) REFERENCES Usuario(cpf)
);

CREATE TABLE Reserva (
    id SERIAL PRIMARY KEY,
    data_reserva DATE NOT NULL,
    data_limite DATE,
    status VARCHAR NOT NULL,
    prioridade INTEGER,
    cpf_usuario VARCHAR,
    FOREIGN KEY (cpf_usuario) REFERENCES Usuario(cpf)
);

CREATE TABLE Multa (
    id SERIAL PRIMARY KEY,
    valor DECIMAL(10, 2) NOT NULL,
    data_geracao DATE NOT NULL,
    status VARCHAR NOT NULL,
    motivo VARCHAR,
    id_reserva INTEGER,
    FOREIGN KEY (id_reserva) REFERENCES Reserva(id)
);

CREATE TABLE Pagamento (
    id SERIAL PRIMARY KEY,
    valor DECIMAL(10, 2) NOT NULL,
    data_pagamento DATE NOT NULL,
    forma_pagamento VARCHAR,
    comprovante VARCHAR,
    id_multa INTEGER,
    FOREIGN KEY (id_multa) REFERENCES Multa(id)
);

CREATE TABLE Evento (
    id SERIAL PRIMARY KEY,
    nome VARCHAR NOT NULL,
    descricao TEXT,
    data_inicio DATE NOT NULL,
    data_fim DATE,
    capacidade INTEGER,
    tipo_evento VARCHAR,
    status VARCHAR,
    cpf_funcionario VARCHAR,
    FOREIGN KEY (cpf_funcionario) REFERENCES Funcionario(cpf)
);

CREATE TABLE Sala (
    id SERIAL PRIMARY KEY,
    nome VARCHAR NOT NULL,
    capacidade INTEGER,
    tipo VARCHAR,
    status VARCHAR,
    equipamentos TEXT
);

CREATE TABLE ReservaSala (
    id SERIAL PRIMARY KEY,
    data_inicio DATE NOT NULL,
    data_fim DATE,
    finalidade VARCHAR,
    status VARCHAR,
    cpf_usuario VARCHAR,
    FOREIGN KEY (cpf_usuario) REFERENCES Usuario(cpf),
    id_sala INTEGER,
    FOREIGN KEY (id_sala) REFERENCES Sala(id)
);

CREATE TABLE AcervoDigital (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR NOT NULL,
    formato VARCHAR,
    url VARCHAR,
    tamanho INTEGER,
    licenca VARCHAR,
    requisitos TEXT,
    ISBN VARCHAR,
    FOREIGN KEY (ISBN) REFERENCES Livro(ISBN)
);

CREATE TABLE Fornecedor (
    id SERIAL PRIMARY KEY,
    nome VARCHAR NOT NULL,
    cnpj VARCHAR NOT NULL,
    endereco VARCHAR,
    telefone VARCHAR,
    email VARCHAR,
    tipo_fornecedor VARCHAR
);

CREATE TABLE Aquisicao (
    id SERIAL PRIMARY KEY,
    data_pedido DATE NOT NULL,
    data_chegada DATE,
    valor_total DECIMAL(10, 2) NOT NULL,
    status VARCHAR NOT NULL,
    nota_fiscal VARCHAR,
    cnpj_fornecedor VARCHAR,
    FOREIGN KEY (cnpj_fornecedor) REFERENCES Fornecedor(cnpj)
);
