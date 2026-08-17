CREATE OR REPLACE VIEW vue_clients_stats AS
SELECT
    cl.id_client,
    cl.nom_client || ' ' || cl.prenom_client AS client_complet,
    cl.adresse_email,
    cl.est_banni,
    COUNT(co.id_commande)              AS nb_commandes,
    COALESCE(SUM(co.montant_total), 0) AS total_depense
FROM client cl
LEFT JOIN commande co ON co.id_client = cl.id_client
    AND co.statut NOT IN ('Annulée', 'Remboursée')
GROUP BY
    cl.id_client, cl.nom_client, cl.prenom_client,
    cl.adresse_email, cl.est_banni
ORDER BY total_depense DESC;