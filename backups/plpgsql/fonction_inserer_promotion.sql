CREATE OR REPLACE FUNCTION inserer_promotion(
    p_code  TEXT,
    p_taux  NUMERIC,
    p_debut DATE,
    p_fin   DATE,
    p_admin INTEGER
) RETURNS VOID AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM promotion WHERE code_promo = p_code) THEN
        RAISE EXCEPTION 'Le code promo % existe deja', p_code;
    END IF;
 
    IF p_debut > p_fin THEN
        RAISE EXCEPTION 'La date de debut doit etre anterieure a la date de fin';
    END IF;
 
    INSERT INTO promotion(code_promo, taux_remise, date_debut, date_fin, id_admin)
    VALUES(p_code, p_taux, p_debut, p_fin, p_admin);
END;
$$ LANGUAGE plpgsql;