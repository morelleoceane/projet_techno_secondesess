CREATE OR REPLACE FUNCTION inserer_client(
    p_nom     TEXT,
    p_prenom  TEXT,
    p_email   TEXT,
    p_mdp     TEXT,
    p_adresse TEXT
) RETURNS INTEGER AS $$
DECLARE v_id INTEGER;
BEGIN
    -- Verification : email unique
    IF EXISTS (SELECT 1 FROM client WHERE adresse_email = p_email) THEN
        RAISE EXCEPTION 'Un client avec l''email % existe deja', p_email;
    END IF;
 
    INSERT INTO client(nom_client, prenom_client, adresse_email, mot_de_passe, adresse_livraison)
    VALUES(p_nom, p_prenom, p_email, p_mdp, p_adresse)
    RETURNING id_client INTO v_id;
 
    RETURN v_id;
END;
$$ LANGUAGE plpgsql;
 