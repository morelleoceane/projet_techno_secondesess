CREATE OR REPLACE FUNCTION modifier_article(
    p_id        INTEGER,
    p_libelle   TEXT,
    p_desc      TEXT,
    p_prix      NUMERIC,
    p_stock     INTEGER,
    p_photo     TEXT,
    p_categorie INTEGER,
    p_actif     BOOLEAN
) RETURNS VOID AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM article WHERE id_article = p_id) THEN
        RAISE EXCEPTION 'Article % introuvable', p_id;
    END IF;
 
    IF p_prix < 0 THEN
        RAISE EXCEPTION 'Le prix ne peut pas etre negatif';
    END IF;
 
    IF p_stock < 0 THEN
        RAISE EXCEPTION 'Le stock ne peut pas etre negatif';
    END IF;
 
    UPDATE article
    SET libelle          = p_libelle,
        description      = p_desc,
        prix_unitaire    = p_prix,
		id_article       = p_article,
		code_article     = p_code,
        stock            = p_stock,
        photo_principale = p_photo,
        id_categorie     = p_categorie,
        est_actif        = p_actif,
		taille           = p_taille,
		couleur          = p_couleur,
		marque           = p_marque
		
    WHERE id_article = p_id;
END;
$$ LANGUAGE plpgsql;
 
 