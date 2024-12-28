CREATE OR REPLACE FUNCTION verificar_faltas() RETURNS TRIGGER AS $$
DECLARE
    v_faltas_sem_justificativa INTEGER;
BEGIN
    -- Contar faltas sem justificativa
    SELECT COUNT(*)
    INTO v_faltas_sem_justificativa
    FROM controle_faltas
    WHERE cpf_funcionario = NEW.cpf_funcionario
    AND justificativa IS NULL
    AND data_justificativa IS NULL;

    -- Se atingiu 5 faltas, desativar funcionário
    IF v_faltas_sem_justificativa >= 5 THEN
        UPDATE funcionario
        SET ativo = 'N'
        WHERE cpf = NEW.cpf_funcionario;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trig_verificar_faltas
AFTER INSERT OR UPDATE ON controle_faltas
FOR EACH ROW
EXECUTE FUNCTION verificar_faltas();