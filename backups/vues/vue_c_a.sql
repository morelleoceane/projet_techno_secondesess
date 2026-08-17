CREATE OR REPLACE VIEW vue_ca_par_mois AS
SELECT
    TO_CHAR(date_commande, 'YYYY-MM') AS mois,
    COUNT(id_commande)                AS nb_commandes,
    SUM(montant_total)                AS chiffre_affaires
FROM commande
WHERE statut NOT IN ('Annulée', 'Remboursée')
GROUP BY TO_CHAR(date_commande, 'YYYY-MM')
ORDER BY mois DESC;