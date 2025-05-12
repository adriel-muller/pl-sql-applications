CREATE SEQUENCE seq_chamadossprints
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;


CREATE OR REPLACE TRIGGER trg_insere_sprint_automatizado
AFTER UPDATE ON chamados
FOR EACH ROW
DECLARE
    v_idsprint NUMBER;
    v_exists NUMBER;
    v_new_id NUMBER;
BEGIN
    IF (:NEW.idsituacaokanban IN (635, 640)) AND (:OLD.idsituacaokanban != :NEW.idsituacaokanban) THEN
       
        CASE :NEW.idsituacaokanban
            WHEN 635 THEN v_idsprint := 93; -- Homologação
            WHEN 640 THEN v_idsprint := 94; -- Implantação
        END CASE;
        
        SELECT COUNT(*)
        INTO v_exists
        FROM roman.chamadossprints
        WHERE idchamado = :NEW.idchamado
          AND idsprint = v_idsprint;
        
        IF v_exists = 0 THEN
            SELECT roman.seq_chamadossprints.NEXTVAL INTO v_new_id FROM dual;

            INSERT INTO roman.chamadossprints (idchamadosprint, idchamado, idsprint, datainclusao)
            VALUES (v_new_id, :NEW.idchamado, v_idsprint, SYSDATE);
        END IF;
    END IF;
END;
