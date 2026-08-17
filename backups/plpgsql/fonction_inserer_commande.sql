CREATE OR REPLACE FUNCTION inserer_commande(
    p_type    TEXT,
    p_adresse TEXT,
    p_total   NUMERIC,
    p_cgv     BOOLEAN,
    p_client  INTEGER
) RETURNS INTEGER AS $$
DECLARE v_id INTEGER;
BEGIN
    IF NOT EXISTS (SELECT 1 FROM client WHERE id_client = p_client AND est_banni = FALSE) THEN
        RAISE EXCEPTION 'Client % introuvable ou banni', p_client;
    END IF;
 
    IF p_cgv = FALSE THEN
        RAISE EXCEPTION 'Les CGV doivent etre acceptees pour passer commande';
    END IF;
 
    INSERT INTO commande(type_livraison, adresse_livraison, montant_total, cgv_acceptees, id_client)
    VALUES(p_type, p_adresse, p_total, p_cgv, p_client)
    RETURNING id_commande INTO v_id;
 
    RETURN v_id;
END;
$$ LANGUAGE plpgsql;