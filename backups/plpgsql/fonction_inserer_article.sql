
CREATE OR REPLACE FUNCTION inserer_article(
    p_code TEXT, p_libelle TEXT, p_desc TEXT, p_prix NUMERIC,
    p_stock INTEGER, p_photo TEXT, p_categorie INTEGER
) RETURNS INTEGER AS $$
DECLARE v_id INTEGER;
BEGIN
    INSERT INTO article(
        code_article, libelle, description, prix_unitaire,
        stock, photo_principale, id_categorie
    )
    VALUES(p_code, p_libelle, p_desc, p_prix, p_stock, p_photo, p_categorie)
    ON CONFLICT (code_article) DO UPDATE
        SET libelle          = EXCLUDED.libelle,
            description      = EXCLUDED.description,
            prix_unitaire    = EXCLUDED.prix_unitaire,
            stock            = EXCLUDED.stock,
            photo_principale = EXCLUDED.photo_principale,
            id_categorie     = EXCLUDED.id_categorie
    RETURNING id_article INTO v_id;
    RETURN v_id;
END;
$$ LANGUAGE plpgsql;
