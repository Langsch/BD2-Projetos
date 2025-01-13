CREATE OR REPLACE FUNCTION random_string(length INTEGER) RETURNS TEXT AS $$
DECLARE
  chars TEXT := 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  result TEXT := '';
  i INTEGER;
BEGIN
  FOR i IN 1..length LOOP
    result := result || substr(chars, (floor(random() * length(chars) + 1))::INTEGER, 1);
  END LOOP;
  RETURN result;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION random_between(min INTEGER, max INTEGER) RETURNS INTEGER AS $$
BEGIN
    RETURN floor(random() * (max - min + 1)) + min;
END;
$$ LANGUAGE plpgsql;

-- Inserindo dados na tabela editora
DO $$
DECLARE
    i INTEGER;
BEGIN
    FOR i IN 1..10 LOOP  -- Inserir 10 editoras
        INSERT INTO editora (nome, cnpj, endereco, telefone, email, website)
        VALUES (
            'Editora ' || random_string(10),  -- Nome aleatório
            random_string(14),  -- CNPJ aleatório
            'Rua ' || random_string(10) || ', ' || random_between(100, 999), -- Endereço aleatório
            '(' || random_between(11, 99) || ') ' || random_string(8), -- Telefone aleatório
            random_string(10) || '@' || random_string(5) || '.com',  -- Email aleatório
            'www.' || random_string(10) || '.com'  -- Website aleatório
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;


-- Inserindo dados na tabela autor
DO $$
DECLARE
    i INTEGER;
BEGIN
    FOR i IN 1..20 LOOP  -- Inserir 20 autores
        INSERT INTO autor (nome, biografia, data_nascimento, nacionalidade, pseudonimo)
        VALUES (
            'Autor ' || random_string(10),  -- Nome aleatório
            'Biografia do autor ' || random_string(10),  -- Biografia aleatória
            DATE('1950-01-01') + (random_between(0, 60*365) * INTERVAL '1 day'),  -- Data de nascimento aleatória
            CASE WHEN random() < 0.7 THEN 'Brasileiro(a)' ELSE 'Estrangeiro(a)' END,  -- Nacionalidade aleatória
            CASE WHEN random() < 0.3 THEN 'Pseudônimo ' || random_string(8) ELSE NULL END  -- Pseudônimo aleatório
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Inserindo dados na tabela categoria
DO $$
DECLARE
    i INTEGER;
BEGIN
    FOR i IN 1..5 LOOP  -- Inserir 5 categorias
        INSERT INTO categoria (nome, descricao)
        VALUES (
            'Categoria ' || random_string(10),  -- Nome aleatório
            'Descrição da categoria ' || random_string(10)  -- Descrição aleatória
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Inserindo dados na tabela usuario
DO $$
DECLARE
    i INTEGER;
BEGIN
    FOR i IN 1..50 LOOP  -- Inserir 50 usuários
        INSERT INTO usuario (cpf, nome, email, telefone, endereco, data_nascimento, tipo_usuario, status)
        VALUES (
            random_string(11),  -- CPF aleatório (apenas para exemplo, idealmente deve ser um CPF válido)
            'Usuário ' || random_string(10),  -- Nome aleatório
            random_string(10) || '@' || random_string(5) || '.com',  -- Email aleatório
            '(' || random_between(11, 99) || ') ' || random_string(8), -- Telefone aleatório
            'Rua ' || random_string(10) || ', ' || random_between(100, 999), -- Endereço aleatório
            DATE('1980-01-01') + (random_between(0, 40*365) * INTERVAL '1 day'),  -- Data de nascimento aleatória
            'novo_usuario',  -- Tipo de usuário inicial
            CASE WHEN random() < 0.9 THEN 'ATIVO' ELSE 'INATIVO' END  -- Status aleatório
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Inserindo dados na tabela funcionario
DO $$
DECLARE
    i INTEGER;
BEGIN
    FOR i IN 1..5 LOOP  -- Inserir 5 funcionários
        INSERT INTO funcionario (nome, cpf, email, telefone, cargo, data_contratacao, status)
        VALUES (
            'Funcionário ' || random_string(10),  -- Nome aleatório
            random_string(11),  -- CPF aleatório (apenas para exemplo, idealmente deve ser um CPF válido)
            random_string(10) || '@' || random_string(5) || '.com',  -- Email aleatório
            '(' || random_between(11, 99) || ') ' || random_string(8), -- Telefone aleatório
            CASE
                WHEN i = 1 THEN 'Bibliotecário'
                WHEN i = 2 THEN 'Auxiliar de Biblioteca'
                ELSE 'Estagiário'
            END,  -- Cargo aleatório
            DATE('2020-01-01') + (random_between(0, 1095) * INTERVAL '1 day'),  -- Data de contratação aleatória
            'ATIVO'  -- Status
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Inserindo dados na tabela fornecedor
DO $$
DECLARE
    i INTEGER;
BEGIN
    FOR i IN 1..5 LOOP  -- Inserir 5 fornecedores
        INSERT INTO fornecedor (cnpj, nome, endereco, telefone, email, tipo_fornecedor)
        VALUES (
            random_string(14),  -- CNPJ aleatório
            'Fornecedor ' || random_string(10),  -- Nome aleatório
            'Rua ' || random_string(10) || ', ' || random_between(100, 999), -- Endereço aleatório
            '(' || random_between(11, 99) || ') ' || random_string(8), -- Telefone aleatório
            random_string(10) || '@' || random_string(5) || '.com',  -- Email aleatório
            CASE
                WHEN i = 1 THEN 'Livraria'
                WHEN i = 2 THEN 'Editora'
                ELSE 'Distribuidora'
            END  -- Tipo de fornecedor aleatório
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Inserindo dados na tabela sala
DO $$
DECLARE
    i INTEGER;
BEGIN
    FOR i IN 1..3 LOOP  -- Inserir 3 salas
        INSERT INTO sala (nome, capacidade, tipo, status, equipamentos)
        VALUES (
            'Sala ' || i,  -- Nome da sala
            random_between(10, 50),  -- Capacidade aleatória
            CASE
                WHEN i = 1 THEN 'Estudo Individual'
                WHEN i = 2 THEN 'Grupo de Estudo'
                ELSE 'Multiuso'
            END,  -- Tipo de sala aleatório
            'DISPONÍVEL',  -- Status
            'Mesas, cadeiras, quadro branco'  -- Equipamentos
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;


-- Inserindo dados na tabela livro
DO $$
DECLARE
    i INTEGER;
    editora_id INTEGER;
BEGIN
    FOR i IN 1..100 LOOP  -- Inserir 100 livros
        -- Selecionar uma editora aleatória
        SELECT id INTO editora_id FROM editora ORDER BY random() LIMIT 1;

        INSERT INTO livro (isbn, titulo, editora_id, ano_publicacao, edicao, idioma, num_paginas, formato, sinopse, capa_url)
        VALUES (
            random_string(13),  -- ISBN aleatório
            'Livro ' || random_string(10),  -- Título aleatório
            editora_id,  -- Editora aleatória
            DATE('2000-01-01') + (random_between(0, 24*365) * INTERVAL '1 day'),  -- Ano de publicação aleatório
            random_between(1, 10) || 'ª edição',  -- Edição aleatória
            CASE WHEN random() < 0.8 THEN 'Português' ELSE 'Inglês' END,  -- Idioma aleatório
            random_between(100, 500),  -- Número de páginas aleatório
            CASE WHEN random() < 0.7 THEN 'Físico' ELSE 'Digital' END,  -- Formato aleatório
            'Sinopse do livro ' || random_string(10),  -- Sinopse aleatória
            'https://example.com/capa_' || random_string(5) || '.jpg'  -- URL da capa aleatória
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Inserindo dados na tabela exemplar
DO $$
DECLARE
    i INTEGER;
    livro_isbn VARCHAR;
BEGIN
    FOR i IN 1..200 LOOP  -- Inserir 200 exemplares
        -- Selecionar um livro aleatório
        SELECT isbn INTO livro_isbn FROM livro ORDER BY random() LIMIT 1;

        INSERT INTO exemplar (codigo, status, data_aquisicao, condicao, localizacao, tipo_aquisicao, isbn)
        VALUES (
            gen_random_uuid(),  -- Código UUID aleatório
            CASE
                WHEN random() < 0.6 THEN 'DISPONÍVEL'
                WHEN random() < 0.8 THEN 'EMPRESTADO'
                WHEN random() < 0.9 THEN 'EM_MANUTENÇÃO'
                ELSE 'EXTRAVIADO'
            END,  -- Status aleatório
            DATE('2020-01-01') + (random_between(0, 1095) * INTERVAL '1 day'),  -- Data de aquisição aleatória
            CASE WHEN random() < 0.9 THEN 'Bom' ELSE 'Regular' END,  -- Condição aleatória
            'Estuante ' || random_between(1, 10),  -- Localização aleatória
            CASE WHEN random() < 0.7 THEN 'Compra' ELSE 'Doação' END,  -- Tipo de aquisição aleatório
            livro_isbn  -- ISBN do livro
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Inserindo dados na tabela emprestimo
DO $$
DECLARE
    i INTEGER;
    exemplar_codigo UUID;
    usuario_cpf VARCHAR;
BEGIN
    FOR i IN 1..150 LOOP  -- Inserir 150 empréstimos
        -- Selecionar um exemplar aleatório com status 'DISPONÍVEL'
        SELECT codigo INTO exemplar_codigo FROM exemplar WHERE status = 'DISPONÍVEL' ORDER BY random() LIMIT 1;

        -- Selecionar um usuário aleatório
        SELECT cpf INTO usuario_cpf FROM usuario ORDER BY random() LIMIT 1;

        INSERT INTO emprestimo (data_emprestimo, data_devolucao_prevista, data_devolucao_efetiva, status, observacoes, codigo_exemplar, cpf_usuario)
        VALUES (
            DATE('2023-01-01') + (random_between(0, 365) * INTERVAL '1 day'),  -- Data de empréstimo aleatória
            DATE('2023-01-01') + (random_between(7, 14) * INTERVAL '1 day'),  -- Data de devolução prevista aleatória
            CASE WHEN random() < 0.8 THEN DATE('2023-01-01') + (random_between(1, 21) * INTERVAL '1 day') ELSE NULL END,  -- Data de devolução efetiva aleatória
            CASE WHEN random() < 0.8 THEN 'FINALIZADO' ELSE 'ATIVO' END,  -- Status aleatório
            CASE WHEN random() < 0.2 THEN 'Observação do empréstimo' ELSE NULL END,  -- Observações aleatórias
            exemplar_codigo,  -- Código do exemplar
            usuario_cpf  -- CPF do usuário
        );

        -- Atualizar o status do exemplar para 'EMPRESTADO' se o empréstimo estiver ativo
        IF random() < 0.8 THEN
            UPDATE exemplar SET status = 'EMPRESTADO' WHERE codigo = exemplar_codigo;
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Inserindo dados na tabela reserva
DO $$
DECLARE
    i INTEGER;
    exemplar_codigo UUID;
    usuario_cpf VARCHAR;
BEGIN
    FOR i IN 1..50 LOOP  -- Inserir 50 reservas
        -- Selecionar um exemplar aleatório
        SELECT codigo INTO exemplar_codigo FROM exemplar ORDER BY random() LIMIT 1;

        -- Selecionar um usuário aleatório
        SELECT cpf INTO usuario_cpf FROM usuario ORDER BY random() LIMIT 1;

        INSERT INTO reserva (data_reserva, data_limite, status, prioridade, cpf_usuario, codigo_exemplar)
        VALUES (
            DATE('2023-01-01') + (random_between(0, 365) * INTERVAL '1 day'),  -- Data da reserva aleatória
            DATE('2023-01-01') + (random_between(3, 7) * INTERVAL '1 day'),  -- Data limite aleatória
            CASE WHEN random() < 0.7 THEN 'FINALIZADA' ELSE 'ATIVA' END,  -- Status aleatório
            random_between(1, 3),  -- Prioridade aleatória
            usuario_cpf,  -- CPF do usuário
            exemplar_codigo  -- Código do exemplar
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Inserindo dados na tabela multa
DO $$
DECLARE
    i INTEGER;
    emprestimo_id INTEGER;
    usuario_cpf VARCHAR;
BEGIN
    FOR i IN 1..30 LOOP  -- Inserir 30 multas
        -- Selecionar um empréstimo aleatório com status 'FINALIZADO'
        SELECT id INTO emprestimo_id FROM emprestimo WHERE status = 'FINALIZADO' ORDER BY random() LIMIT 1;

        -- Obter o CPF do usuário do empréstimo selecionado
        SELECT cpf_usuario INTO usuario_cpf FROM emprestimo WHERE id = emprestimo_id;

        INSERT INTO multa (valor, data_geracao, status, motivo, cpf_usuario, id_emprestimo)
        VALUES (
            random_between(5, 20)::DECIMAL(10,2),  -- Valor da multa aleatório
            DATE('2023-01-01') + (random_between(0, 365) * INTERVAL '1 day'),  -- Data de geração aleatória
            CASE WHEN random() < 0.7 THEN 'PAGA' ELSE 'PENDENTE' END,  -- Status aleatório
            CASE
                WHEN random() < 0.5 THEN 'Atraso na devolução'
                ELSE 'Danos ao exemplar'
            END,  -- Motivo aleatório
            usuario_cpf,  -- CPF do usuário
            emprestimo_id  -- ID do empréstimo
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Inserindo dados na tabela pagamento
DO $$
DECLARE
    i INTEGER;
    multa_id INTEGER;
BEGIN
    FOR i IN 1..20 LOOP  -- Inserir 20 pagamentos
        -- Selecionar uma multa aleatória com status 'PAGA'
        SELECT id INTO multa_id FROM multa WHERE status = 'PAGA' ORDER BY random() LIMIT 1;

        INSERT INTO pagamento (valor, data_pagamento, forma_pagamento, comprovante, id_multa)
        VALUES (
            (SELECT valor FROM multa WHERE id = multa_id),  -- Valor da multa
            DATE('2023-01-01') + (random_between(0, 365) * INTERVAL '1 day'),  -- Data de pagamento aleatória
            CASE WHEN random() < 0.5 THEN 'Dinheiro' ELSE 'Cartão' END,  -- Forma de pagamento aleatória
            CASE WHEN random() < 0.3 THEN 'Comprovante_' || random_string(5) ELSE NULL END,  -- Comprovante aleatório
            multa_id  -- ID da multa
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Inserindo dados na tabela evento
DO $$
DECLARE
    i INTEGER;
    funcionario_id INTEGER;
BEGIN
    FOR i IN 1..10 LOOP  -- Inserir 10 eventos
        -- Selecionar um funcionário aleatório
        SELECT id INTO funcionario_id FROM funcionario ORDER BY random() LIMIT 1;

        INSERT INTO evento (nome, descricao, data_inicio, data_fim, capacidade, tipo_evento, status, id_funcionario)
        VALUES (
            'Evento ' || random_string(10),  -- Nome aleatório
            'Descrição do evento ' || random_string(10),  -- Descrição aleatória
            DATE('2023-01-01') + (random_between(0, 365) * INTERVAL '1 day'),  -- Data de início aleatória
            DATE('2023-01-01') + (random_between(1, 7) * INTERVAL '1 day'),  -- Data de fim aleatória
            random_between(20, 100),  -- Capacidade aleatória
            CASE WHEN random() < 0.5 THEN 'Palestra' ELSE 'Workshop' END,  -- Tipo de evento aleatório
            CASE WHEN random() < 0.8 THEN 'REALIZADO' ELSE 'CANCELADO' END,  -- Status aleatório
            funcionario_id  -- ID do funcionário
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Inserindo dados na tabela reserva_sala
DO $$
DECLARE
    i INTEGER;
    usuario_cpf VARCHAR;
    sala_id INTEGER;
BEGIN
    FOR i IN 1..20 LOOP  -- Inserir 20 reservas de sala
        -- Selecionar um usuário aleatório
        SELECT cpf INTO usuario_cpf FROM usuario ORDER BY random() LIMIT 1;

        -- Selecionar uma sala aleatória
        SELECT id INTO sala_id FROM sala ORDER BY random() LIMIT 1;

        INSERT INTO reserva_sala (data_inicio, data_fim, finalidade, status, cpf_usuario, id_sala)
        VALUES (
            DATE('2023-01-01') + (random_between(0, 365) * INTERVAL '1 day'),  -- Data de início aleatória
            DATE('2023-01-01') + (random_between(1, 3) * INTERVAL '1 day'),  -- Data de fim aleatória
            'Estudo em grupo',  -- Finalidade
            CASE WHEN random() < 0.8 THEN 'UTILIZADA' ELSE 'CANCELADA' END,  -- Status aleatório
            usuario_cpf,  -- CPF do usuário
            sala_id  -- ID da sala
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Inserindo dados na tabela acervo_digital
DO $$
DECLARE
    i INTEGER;
    livro_isbn VARCHAR;
BEGIN
    FOR i IN 1..50 LOOP  -- Inserir 50 itens no acervo digital
        -- Selecionar um livro aleatório
        SELECT isbn INTO livro_isbn FROM livro ORDER BY random() LIMIT 1;

        INSERT INTO acervo_digital (isbn, titulo, formato, url, tamanho)
        VALUES (
            livro_isbn,  -- ISBN do livro
            'Livro Digital ' || random_string(10),  -- Título aleatório
            CASE WHEN random() < 0.5 THEN 'PDF' ELSE 'EPUB' END,  -- Formato aleatório
            'https://example.com/livro_' || random_string(5) || '.pdf',  -- URL aleatória
            random_between(1, 10) * 1000000  -- Tamanho aleatório em bytes
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Inserindo dados na tabela aquisicao
DO $$
DECLARE
    i INTEGER;
    fornecedor_cnpj VARCHAR;
BEGIN
    FOR i IN 1..20 LOOP  -- Inserir 20 aquisições
        -- Selecionar um fornecedor aleatório
        SELECT cnpj INTO fornecedor_cnpj FROM fornecedor ORDER BY random() LIMIT 1;

        INSERT INTO aquisicao (data_pedido, data_chegada, valor_total, status, nota_fiscal, cnpj_fornecedor)
        VALUES (
            DATE('2023-01-01') + (random_between(0, 365) * INTERVAL '1 day'),  -- Data do pedido aleatória
            DATE('2023-01-01') + (random_between(7, 30) * INTERVAL '1 day'),  -- Data de chegada aleatória
            random_between(100, 1000)::DECIMAL(10,2),  -- Valor total aleatório
            CASE
                WHEN random() < 0.6 THEN 'ENTREGUE'
                WHEN random() < 0.8 THEN 'EM_PROCESSAMENTO'
                ELSE 'CANCELADO'
            END,  -- Status aleatório
            'NF_' || random_string(10),  -- Nota fiscal aleatória
            fornecedor_cnpj  -- CNPJ do fornecedor
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Inserindo dados na tabela livro_autor
DO $$
DECLARE
    i INTEGER;
    livro_isbn VARCHAR;
    autor_id INTEGER;
BEGIN
    FOR i IN 1..150 LOOP  -- Criar 150 relações livro-autor
        -- Selecionar um livro aleatório
        SELECT isbn INTO livro_isbn FROM livro ORDER BY random() LIMIT 1;

        -- Selecionar um autor aleatório
        SELECT id INTO autor_id FROM autor ORDER BY random() LIMIT 1;

        -- Verificar se a relação já existe
        IF NOT EXISTS (SELECT 1 FROM livro_autor WHERE isbn_livro = livro_isbn AND id_autor = autor_id) THEN
            INSERT INTO livro_autor (isbn_livro, id_autor)
            VALUES (livro_isbn, autor_id);
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Inserindo dados na tabela livro_categoria
DO $$
DECLARE
    i INTEGER;
    livro_isbn VARCHAR;
    categoria_id INTEGER;
BEGIN
    FOR i IN 1..200 LOOP  -- Criar 200 relações livro-categoria
        -- Selecionar um livro aleatório
        SELECT isbn INTO livro_isbn FROM livro ORDER BY random() LIMIT 1;

        -- Selecionar uma categoria aleatória
        SELECT id INTO categoria_id FROM categoria ORDER BY random() LIMIT 1;

        -- Verificar se a relação já existe
        IF NOT EXISTS (SELECT 1 FROM livro_categoria WHERE isbn_livro = livro_isbn AND id_categoria = categoria_id) THEN
            INSERT INTO livro_categoria (isbn_livro, id_categoria)
            VALUES (livro_isbn, categoria_id);
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;