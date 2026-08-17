CREATE OR REPLACE VIEW vue_articles_complet AS
SELECT
    a.id_article,
    a.code_article,
    a.libelle,
    a.description,
    a.photo_principale,
    a.prix_unitaire,
    a.stock,
    a.est_actif,
    a.id_categorie,
    c.nom_categorie
FROM article a
JOIN categorie_article c ON a.id_categorie = c.id_categorie
ORDER BY a.id_article;