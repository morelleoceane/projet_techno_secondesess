CREATE OR REPLACE FUNCTION bannir_client(p_id INTEGER) RETURNS VOID AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM client WHERE id_client = p_id) THEN
        RAISE EXCEPTION 'Client % introuvable', p_id;
    END IF;
 
    UPDATE client SET est_banni = TRUE WHERE id_client = p_id;
END;
$$ LANGUAGE plpgsql;