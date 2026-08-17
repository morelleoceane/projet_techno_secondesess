CREATE OR REPLACE FUNCTION modifier_statut_commande(
    p_id     INTEGER,
    p_statut TEXT
) RETURNS VOID AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM commande WHERE id_commande = p_id) THEN
        RAISE EXCEPTION 'Commande % introuvable', p_id;
    END IF;
 
    UPDATE commande SET statut = p_statut WHERE id_commande = p_id;
END;
$$ LANGUAGE plpgsql;