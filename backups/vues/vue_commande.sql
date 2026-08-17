CREATE OR REPLACE VIEW vue_commandes_detail AS
SELECT
    co.id_commande,
    co.date_commande,
    co.statut,
    co.type_livraison,
    co.montant_total,
    cl.id_client,
    cl.nom_client || ' ' || cl.prenom_client AS client_complet,
    cl.adresse_email
FROM commande co
JOIN client cl ON co.id_client = cl.id_client
ORDER BY co.date_commande DESC;