CREATE OR REPLACE VIEW vue_promotions_actives AS
SELECT
    id_promotion,
    code_promo,
    taux_remise,
    date_debut,
    date_fin
FROM promotion
WHERE est_actif = TRUE
  AND CURRENT_DATE BETWEEN date_debut AND date_fin
ORDER BY taux_remise DESC;
 