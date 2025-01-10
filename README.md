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

O banco de dados conta com 19 tabelas, 6 funções, 4 triggers, 3 views e 5 índices.

<hr>

## Tabelas e Finalidades

### 1. Livro
- **Finalidade**: Representa as informações bibliográficas de um livro.  
- **Atributos principais**:
  - `ISBN`: Identificação única.  
  - `titulo`, `ano_publicacao`, `edicao`, `idioma`, `sinopse`: Detalhes sobre o conteúdo.  
  - `editora_id`: Relaciona com a editora responsável pelo livro.  
- **Relacionamentos**:  
  - Relaciona-se com `Exemplar`, `AcervoDigital`, `Autor` (via `LivroAutor`), `Categoria` (via `LivroCategoria`).

### 2. Exemplar
- **Finalidade**: Representa cada cópia física de um livro disponível na biblioteca.  
- **Atributos principais**:
  - `codigo`: Identificador único de cada exemplar.  
  - `status`: Disponibilidade do exemplar (e.g., disponível, emprestado).  
  - `data_aquisicao`, `condicao`: Informações de aquisição e estado físico.  
- **Relacionamentos**:  
  - Relaciona-se com `Emprestimo` e `Reserva`.

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
  - `cpf`, `nome`, `tipo_usuario`: Identificação e tipo (e.g., estudante, professor).  
  - `status`: Atividade do usuário.  
- **Relacionamentos**:
  - Relaciona-se com `Emprestimo`, `Reserva`, `Multa` e `ReservaSala`.

### 8. Funcionario
- **Finalidade**: Representa os funcionários da biblioteca.  
- **Atributos principais**:
  - `cargo`, `data_contratacao`, `status`: Informações profissionais.  
- **Relacionamentos**:
  - Relaciona-se com `Aquisicao`, `ReservaSala` e `Evento`.

### 9. Emprestimo
- **Finalidade**: Controla os empréstimos de exemplares.  
- **Atributos principais**:
  - `data_emprestimo`, `data_devolucao_prevista`, `data_devolucao_efetiva`: Controle de prazos.  
  - `status`: Estado do empréstimo (e.g., pendente, concluído).  
- **Relacionamentos**:
  - Associado a `Usuario` e `Exemplar`.

### 10. Reserva
- **Finalidade**: Representa reservas de exemplares pelos usuários.  
- **Atributos principais**:
  - `data_reserva`, `data_limite`: Controle de disponibilidade.  
  - `prioridade`: Define ordem de atendimento.  

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

### 13. Evento
- **Finalidade**: Controla eventos promovidos pela biblioteca.  
- **Atributos principais**:
  - `nome`, `descricao`, `data_inicio`, `data_fim`: Informações do evento.  
- **Relacionamentos**:
  - Organizado por um `Funcionario`.

### 14. Sala
- **Finalidade**: Gerencia salas disponíveis para atividades ou eventos.  
- **Atributos principais**:
  - `nome`, `capacidade`, `equipamentos`: Características da sala.  
- **Relacionamentos**:
  - Associada a `ReservaSala`.

### 15. Fornecedor
- **Finalidade**: Representa fornecedores de materiais.  
- **Atributos principais**:
  - `cnpj`, `nome`, `tipo_fornecedor`: Identificação e classificação.  

### 16. Aquisicao
- **Finalidade**: Gerencia pedidos de aquisição de materiais.  
- **Atributos principais**:
  - `data_pedido`, `data_chegada`, `valor_total`: Informações financeiras e de logística.  

<hr>

## Regras de Negócio

### 1. Empréstimos
- Um usuário só pode realizar empréstimos se não houver multas pendentes ou exemplares atrasados.
- O prazo máximo de empréstimo é de 14 dias para usuários comuns, podendo ser maior para professores.

### 2. Reservas
- A prioridade de atendimento é definida com base na ordem de solicitação.
- Uma reserva expira após um prazo pré-definido (e.g., 3 dias úteis) sem retirada.

### 3. Multas
- Multas são geradas automaticamente para empréstimos atrasados ou exemplares danificados.
- O pagamento de multas pode ser feito diretamente na biblioteca ou por meios digitais.

### 4. Aquisição de Livros
- Apenas funcionários autorizados podem registrar aquisições.
- Cada aquisição deve ter um fornecedor associado com nota fiscal válida.

### 5. Eventos
- Os eventos devem ser aprovados por um funcionário responsável e registrados no sistema.
- Cada evento deve ter capacidade máxima definida.

### 6. Reservas de Salas
- Apenas usuários ativos podem reservar salas,     respeitando os horários de funcionamento.
- Equipamentos adicionais devem ser solicitados previamente.

<hr>

## Funções 
[`fn_gerar_relatorio_usuario`](PRJ-Final\funções\fn_gerar_relatorio_usuario.sql): A função fn_gerar_relatorio_usuario é usada para gerar um relatório consolidado com informações de um usuário específico, identificado pelo CPF, sobre empréstimos, multas e reservas. Ela retorna diversas estatísticas organizadas em colunas.

[`fn_realizar_devolução`](PRJ-Final\funções\fn_realizar_devolucao.sql): Localiza o empréstimo ativo, finaliza-o, atualiza o status do exemplar e retorna uma mensagem de sucesso.

[`fn_relatorio_emprestimos`](PRJ-Final\funções\fn_realizar_emprestimo.sql): A função fn_realizar_emprestimo é usada para registrar um novo empréstimo de um exemplar para um usuário, realizando as devidas verificações e atualizando os dados no banco.

[`fn_relatorio_emprestimos`](PRJ-Final\funções\fn_relatorio_emprestimos.sql): A função fn_relatorio_emprestimos gera um relatório detalhado sobre os empréstimos realizados em um período específico. Ela utiliza parâmetros de data de início e fim fornecidos pelo usuário para calcular métricas importantes relacionadas aos empréstimos e multas.

[`fn_renovar_emprestimo`](PRJ-Final\funções\fn_renovar_emprestimo.sql): A função fn_renovar_emprestimo permite que um empréstimo ativo seja renovado, estendendo o prazo de devolução.

[`fn_reservar_sala`](PRJ-Final\funções\fn_reservar_sala.sql): 
A função fn_reservar_sala permite que um usuário ativo realize a reserva de uma sala disponível, verificando as condições e inserindo o registro na tabela de reservas.

## Triggers

## Visões

## Índices