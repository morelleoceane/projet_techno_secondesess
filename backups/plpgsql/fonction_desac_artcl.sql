CREATE OR REPLACE FUNCTION desactiver_article(p_id INTEGER) RETURNS VOID AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM article WHERE id_article = p_id) THEN
        RAISE EXCEPTION 'Article % introuvable', p_id;
    END IF;
 
    UPDATE article SET est_actif = FALSE WHERE id_article = p_id;
END;
$$ LANGUAGE plpgsql;
 
 