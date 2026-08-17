CREATE OR REPLACE FUNCTION inserer_avis(
    p_note        INTEGER,
    p_commentaire TEXT,
    p_client      INTEGER,
    p_article     INTEGER
) RETURNS VOID AS $$
BEGIN
    IF p_note NOT BETWEEN 1 AND 5 THEN
        RAISE EXCEPTION 'La note doit etre comprise entre 1 et 5';
    END IF;
 
    INSERT INTO avis_client(note, commentaire, id_client, id_article)
    VALUES(p_note, p_commentaire, p_client, p_article);
END;
$$ LANGUAGE plpgsql;
 