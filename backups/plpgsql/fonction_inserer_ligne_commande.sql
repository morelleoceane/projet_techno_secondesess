CREATE OR REPLACE FUNCTION inserer_ligne_commande(
    p_qte      INTEGER,
    p_prix     NUMERIC,
    p_taille   TEXT,
    p_couleur  TEXT,
    p_commande INTEGER,
    p_article  INTEGER
) RETURNS VOID AS $$
DECLARE v_stock INTEGER;
BEGIN
    -- Verification : stock suffisant
    SELECT stock INTO v_stock FROM article WHERE id_article = p_article;
 
    IF v_stock < p_qte THEN
        RAISE EXCEPTION 'Stock insuffisant pour l''article % (stock : %, demande : %)',
            p_article, v_stock, p_qte;
    END IF;
 
    INSERT INTO ligne_commande(quantite, prix_unitaire_achat, taille, couleur, id_commande, id_article)
    VALUES(p_qte, p_prix, p_taille, p_couleur, p_commande, p_article);
 
    -- Decrement du stock automatique
    UPDATE article SET stock = stock - p_qte WHERE id_article = p_article;
END;
$$ LANGUAGE plpgsql;
 
 