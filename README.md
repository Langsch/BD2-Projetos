# Repositório de Projetos de Banco de Dados II

Este repositório é utilizado para armazenar e compartilhar projetos e atividades de banco de dados desenvolvidos durante a disciplina de Banco de Dados II.

## Conteúdo

* Projetos de banco de dados desenvolvidos em PostgreSQL.
* Documentação e relatórios de cada projeto
* Códigos-fonte e scripts de banco de dados

## Objetivo

O objetivo deste repositório é fornecer um local centralizado para armazenar e compartilhar projetos de banco de dados, permitindo que os integrantes dos grupo possam compartilhar e armazenar as atividades

## Contribuição

Se você é um integrante do grupo de Banco de Dados II e deseja contribuir com projetos ou melhorar os existentes, por favor, sinta-se à vontade para fazer um pull request ou abrir uma issue.

<hr>

<h1 align="center">Documentação do Projeto Final<h1/>

## Sobre o projeto
Esse projeto consiste da implementação de um banco de dados voltado para a administração de bibliotecas públicas.  

O banco de dados conta com 18 tabelas, 6 funções, 4 triggers, 3 views e 5 índices.

<hr>

## Tabelas e Finalidades

### 1. Livro
- **Finalidade**: Representa o conceito de um livro no acervo da biblioteca.  
- **Atributos principais**:
  - `ISBN`: Identificação única.  
  - `titulo`, `ano_publicacao`, `edicao`, `idioma`, `sinopse`: Detalhes sobre o conteúdo.  
  - `editora_id`: Relaciona com a editora responsável pelo livro.  
- **Relacionamentos**:  
  - Relaciona-se com `Exemplar`, `AcervoDigital`, `Autor` (via `LivroAutor`), `Categoria` (via `LivroCategoria`), `Reserva`.

### 2. Exemplar
- **Finalidade**: Representa cada cópia física de um livro disponível na biblioteca.  
- **Atributos principais**:
  - `codigo`: Identificador único de cada exemplar.  
  - `status`: Disponibilidade do exemplar (e.g., disponível, emprestado).  
  - `data_aquisicao`, `condicao`: Informações de aquisição e estado físico.  
- **Relacionamentos**:  
  - Relaciona-se com `Emprestimo` e `AquisicaoExemplar`.

### 3. AcervoDigital
- **Finalidade**: Representa os materiais digitais relacionados a um livro.  
- **Atributos principais**:
  - `url`: Endereço para acesso ao material.  
  - `formato`, `tamanho`: Informações técnicas do arquivo.

### 4. Autor
- **Finalidade**: Armazena dados sobre os autores dos livros.  
- **Atributos principais**:
  - `nome`, `biografia`, `data_nascimento`: Informações pessoais.  
- **Relacionamentos**:
  - Associado a livros por meio da tabela `LivroAutor`.

### 5. Editora
- **Finalidade**: Representa editoras responsáveis pela publicação dos livros.  
- **Atributos principais**:
  - `nome`, `cnpj`, `endereco`: Identificação da editora.  
- **Relacionamentos**:
  - Cada livro está associado a uma editora.

### 6. Categoria
- **Finalidade**: Classifica os livros em temas ou gêneros.  
- **Atributos principais**:
  - `nome`, `descricao`: Nome e descrição da categoria.  
- **Relacionamentos**:
  - Relaciona-se com livros por meio da tabela `LivroCategoria`.

### 7. Usuario
- **Finalidade**: Representa os usuários da biblioteca (leitores).  
- **Atributos principais**:
  - `cpf`, `nome`, `tipo_usuario`: Identificação e tipo (heavy/light user).  
  - `status`: Atividade do usuário.  
- **Relacionamentos**:
  - Relaciona-se com `Emprestimo`, `Reserva`, `Multa` e `ReservaSala`.

### 8. Funcionario
- **Finalidade**: Representa os funcionários da biblioteca.  
- **Atributos principais**:
  - `cargo`, `data_contratacao`, `status`: Informações profissionais.  
- **Relacionamentos**:
  - Relaciona-se com `Aquisicao`, `ReservaSala`, `Emprestimo` e `Reserva`.

### 9. Emprestimo
- **Finalidade**: Controla os empréstimos de exemplares.  
- **Atributos principais**:
  - `data_emprestimo`, `data_devolucao_prevista`, `data_devolucao_efetiva`: Controle de prazos.  
  - `status`: Estado do empréstimo (e.g., pendente, concluído).  
  - `id_funcionario`: Funcionário responsável pela operação.
- **Relacionamentos**:
  - Associado a `Usuario`, `Exemplar` e `Funcionario`.

### 10. Reserva
- **Finalidade**: Representa reservas de livros pelos usuários.  
- **Atributos principais**:
  - `data_reserva`, `data_limite`: Controle de disponibilidade.  
  - `prioridade`: Define ordem de atendimento.  
  - `isbn_livro`: Livro que está sendo reservado.
  - `id_funcionario`: Funcionário responsável pela operação.
- **Relacionamentos**:
  - Relaciona-se com `Usuario`, `Livro` e `Funcionario`.

### 11. Multa
- **Finalidade**: Gerencia penalidades aplicadas a usuários por atrasos ou danos.  
- **Atributos principais**:
  - `valor`, `motivo`: Descrição e valor da penalidade.  
- **Relacionamentos**:
  - Relaciona-se com `Emprestimo` e `Pagamento`.

### 12. Pagamento
- **Finalidade**: Registra pagamentos de multas.  
- **Atributos principais**:
  - `forma_pagamento`, `comprovante`: Detalhes financeiros.  

### 13. Sala
- **Finalidade**: Gerencia salas disponíveis para atividades.  
- **Atributos principais**:
  - `nome`, `capacidade`, `equipamentos`: Características da sala.  
- **Relacionamentos**:
  - Associada a `ReservaSala`.

### 14. ReservaSala
- **Finalidade**: Controla as reservas de salas.  
- **Atributos principais**:
  - `data_inicio`, `data_fim`: Período da reserva.
  - `finalidade`: Propósito do uso da sala.
- **Relacionamentos**:
  - Associada a `Usuario` e `Sala`.

### 15. Fornecedor
- **Finalidade**: Representa fornecedores de materiais.  
- **Atributos principais**:
  - `cnpj`, `nome`, `tipo_fornecedor`: Identificação e classificação.  
- **Relacionamentos**:
  - Relaciona-se com `Aquisicao`.

### 16. Aquisicao
- **Finalidade**: Gerencia pedidos de aquisição de materiais.  
- **Atributos principais**:
  - `data_pedido`, `data_chegada`, `valor_total`: Informações financeiras e de logística.  
- **Relacionamentos**:
  - Relaciona-se com `Fornecedor` e `AquisicaoExemplar`.

### 17. AquisicaoExemplar
- **Finalidade**: Relaciona os exemplares adquiridos com sua aquisição de origem.
- **Atributos principais**:
  - `id_aquisicao`: Identificador da aquisição.
  - `codigo_exemplar`: Identificador do exemplar.
- **Relacionamentos**:
  - Conecta `Aquisicao` com `Exemplar`.


## Índices
- `idx_livro_isbn`: Otimiza buscas por ISBN do livro
- `idx_exemplar_codigo`: Melhora consultas por código do exemplar
- `idx_usuario_cpf`: Acelera buscas por CPF do usuário
- `idx_funcionario`: Otimiza consultas envolvendo funcionários
- `idx_reserva_isbn`: Melhora performance em consultas de reservas por livro
- `idx_aquisicao_exemplar`: Otimiza buscas de exemplares por aquisição

## Views

[`vw_disponibilidade_exemplares`](PRJ-Final\views\vw_disponibilidade_exemplares.sql): A view vw_disponibilidade_exemplares é uma estrutura que fornece uma visão consolidada sobre a disponibilidade dos exemplares de livros, agrupando e organizando informações úteis para gestão de acervo. 

[`vw_historico_exemplar`](PRJ-Final\views\vw_historico_exemplar.sql): Exibe um histórico consolidado dos exemplares, com informações relacionadas ao livro, status atual, datas de aquisição, empréstimos, usuários distintos que o utilizaram e multas geradas.

[`vw_ocupacao_salas`](PRJ-Final\views\vw_ocupacao_salas.sql): A view vw_ocupacao_salas fornece uma visão detalhada sobre a ocupação das salas, incluindo informações sobre a sala, reservas ativas e os usuários que realizaram essas reservas.