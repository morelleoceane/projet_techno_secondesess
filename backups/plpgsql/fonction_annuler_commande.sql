CREATE OR REPLACE FUNCTION annuler_commande(
    p_id     INTEGER,
    p_client INTEGER
) RETURNS BOOLEAN AS $$
DECLARE v_statut TEXT;
BEGIN
    SELECT statut INTO v_statut FROM commande
    WHERE id_commande = p_id AND id_client = p_client;

    IF v_statut IN ('en_attente', 'En attente', 'validee', 'Validée') THEN
        PERFORM modifier_statut_commande(p_id, 'Annulée');
        RETURN TRUE;
    END IF;
 
    RETURN FALSE;
END;
$$ LANGUAGE plpgsql;
 
 