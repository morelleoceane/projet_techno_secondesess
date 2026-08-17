CREATE OR REPLACE FUNCTION modifier_client(
    p_id      INTEGER,
    p_nom     TEXT,
    p_prenom  TEXT,
    p_adresse TEXT
) RETURNS VOID AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM client WHERE id_client = p_id) THEN
        RAISE EXCEPTION 'Client % introuvable', p_id;
    END IF;
 
    UPDATE client
    SET nom_client=p_nom, prenom_client=p_prenom, adresse_livraison=p_adresse
    WHERE id_client = p_id;
END;
$$ LANGUAGE plpgsql;
 
 