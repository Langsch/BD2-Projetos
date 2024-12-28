-- Diminuir salário em 10%
SELECT DiminuirSalario('12345678901', 10);

-- Registrar uma falta
INSERT INTO controle_faltas (cpf_funcionario, data_falta)
VALUES ('12345678901', CURRENT_DATE);

-- Promover funcionário
SELECT PromoverFuncionario('12345678901', 2);