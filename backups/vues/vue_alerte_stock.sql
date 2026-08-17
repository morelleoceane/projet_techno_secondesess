CREATE OR REPLACE VIEW vue_stock_faible AS
SELECT
    id_article,
    code_article,
    libelle,
    stock
FROM article
WHERE stock < 5
  AND est_actif = TRUE
ORDER BY stock ASC;
 