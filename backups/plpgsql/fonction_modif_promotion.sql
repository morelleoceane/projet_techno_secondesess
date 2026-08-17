CREATE OR REPLACE FUNCTION modifier_promotion(
    p_id    INTEGER,
    p_taux  NUMERIC,
    p_debut DATE,
    p_fin   DATE,
    p_actif BOOLEAN
) RETURNS VOID AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM promotion WHERE id_promotion = p_id) THEN
        RAISE EXCEPTION 'Promotion % introuvable', p_id;
    END IF;
 
    UPDATE promotion
    SET taux_remise = p_taux,
        date_debut  = p_debut,
        date_fin    = p_fin,
        est_actif   = p_actif
    WHERE id_promotion = p_id;
END;
$$ LANGUAGE plpgsql;