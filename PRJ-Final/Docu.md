# Documentação do Sistema de Biblioteca

## 1. Visão Geral
O sistema de biblioteca foi projetado para gerenciar todos os aspectos de uma biblioteca moderna, incluindo acervo físico e digital, usuários, empréstimos, eventos e espaços físicos.

## 2. Modelo Conceitual

### 2.1 Principais Entidades

#### 2.1.1 Livro
- Representa a obra em si (conceito abstrato)
- Atributos principais:
  - ISBN (identificador único)
  - Título
  - Ano de publicação
  - Edição
  - Idioma
  - Número de páginas
  - Formato
  - Sinopse
  - URL da capa

#### 2.1.2 Exemplar
- Representa uma cópia física de um livro
- Atributos principais:
  - Código único
  - Status (Disponível/Emprestado/Manutenção/Extraviado)
  - Data de aquisição
  - Condição física
  - Localização na biblioteca
  - Tipo de aquisição

#### 2.1.3 Autor
- Dados dos autores das obras
- Atributos principais:
  - Nome
  - Biografia
  - Data de nascimento
  - Nacionalidade
  - Pseudônimo

#### 2.1.4 Usuário
- Representa os leitores cadastrados
- Atributos principais:
  - Nome
  - CPF
  - Email
  - Telefone
  - Endereço
  - Data de nascimento
  - Tipo de usuário
  - Status

#### 2.1.5 Funcionário
- Membros da equipe da biblioteca
- Atributos principais:
  - Nome
  - CPF
  - Email
  - Telefone
  - Cargo
  - Data de contratação
  - Status

### 2.2 Relacionamentos Principais

#### 2.2.1 Livro-Exemplar (1:N)
- Um livro pode ter múltiplos exemplares
- Cada exemplar pertence a um único livro

#### 2.2.2 Livro-Autor (N:M)
- Um livro pode ter vários autores
- Um autor pode ter escrito vários livros

#### 2.2.3 Empréstimo (Exemplar-Usuário) (N:M)
- Um usuário pode emprestar vários exemplares
- Um exemplar pode ser emprestado por vários usuários (em momentos diferentes)

#### 2.2.4 Reserva (Livro-Usuário) (N:M)
- Usuários podem reservar livros
- Livros podem ter múltiplas reservas

## 3. Modelo Relacional

### 3.1 Tabelas Principais

#### 3.1.1 livros
``` sql
CREATE TABLE livros (
    livro_id SERIAL PRIMARY KEY,
    isbn VARCHAR(13) UNIQUE NOT NULL,
    titulo VARCHAR(200) NOT NULL,
    editora_id INTEGER REFERENCES editoras(editora_id),
    ano_publicacao DATE,
    edicao VARCHAR(20),
    idioma VARCHAR(30),
    num_paginas INTEGER,
    formato VARCHAR(30),
    sinopse TEXT,
    capa_url VARCHAR(255)
);
```
- Chave primária: livro_id
- Chave estrangeira: editora_id → editoras(editora_id)
- Índices: isbn (UNIQUE), titulo (para busca)

---
#### 3.1.2 exemplares
``` sql
CREATE TABLE exemplares (
    exemplar_id SERIAL PRIMARY KEY,
    livro_id INTEGER REFERENCES livros(livro_id),
    codigo VARCHAR(50) UNIQUE NOT NULL,
    status VARCHAR(20) CHECK (status IN ('DISPONÍVEL', 'EMPRESTADO',
    'EM_MANUTENÇÃO', 'EXTRAVIADO')),
    data_aquisicao DATE,
    condicao VARCHAR(20),
    localizacao VARCHAR(50)
);
```
- Chave primária: exemplar_id
- Chave estrangeira: livro_id → livros(livro_id)
- Constraints: status (CHECK)
---

### 3.2 Tabelas de Relacionamento

#### 3.2.1 autor_livro

``` sql
CREATE TABLE autor_livro (
    autor_id INTEGER REFERENCES autores(autor_id),
    livro_id INTEGER REFERENCES livros(livro_id),
    tipo_autoria VARCHAR(30),
    PRIMARY KEY (autor_id, livro_id)
);
``` 
- Chave primária composta: (autor_id, livro_id)
- Chaves estrangeiras:
    - autor_id → autores(autor_id)
    - livro_id → livros(livro_id)

### 3.3 Tabelas de Controle

#### 3.3.1 emprestimos

```sql
CREATE TABLE emprestimos (
    emprestimo_id SERIAL PRIMARY KEY,
    exemplar_id INTEGER REFERENCES exemplares(exemplar_id),
    usuario_id INTEGER REFERENCES usuarios(usuario_id),
    funcionario_id INTEGER REFERENCES funcionarios(funcionario_id),
    data_emprestimo TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_devolucao_prevista DATE NOT NULL,
    data_devolucao_efetiva DATE,
    status VARCHAR(20) CHECK (status IN ('ATIVO', 'DEVOLVIDO', 'ATRASADO'))
);
```
- Controle temporal através de data_emprestimo e data_devolucao_prevista
- Status permite rastreamento do estado atual do empréstimo

### 3.4 Decisões de Design

#### Separação entre Livro e Exemplar
- Permite melhor controle do acervo físico
- Facilita gestão de múltiplas cópias
- Possibilita rastreamento individual de cada item

#### Uso de SERIAL para IDs
- Autoincremento automático
- Garante unicidade
- Melhor performance em índices

#### Timestamps de Controle
- created_at e updated_at em todas as tabelas
- Facilita auditoria e rastreamento de mudanças

#### Constraints de Validação
- CHECK constraints para status
- NOT NULL para campos obrigatórios
- UNIQUE para campos que não podem duplicar
