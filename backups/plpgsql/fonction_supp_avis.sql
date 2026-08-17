CREATE OR REPLACE FUNCTION supprimer_avis(p_id INTEGER) RETURNS VOID AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM avis_client WHERE id_avis = p_id) THEN
        RAISE EXCEPTION 'Avis % introuvable', p_id;
    END IF;
 
    UPDATE avis_client SET est_visible = FALSE WHERE id_avis = p_id;
END;
$$ LANGUAGE plpgsql;