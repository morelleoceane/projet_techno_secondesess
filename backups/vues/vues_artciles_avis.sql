CREATE OR REPLACE VIEW vue_articles_avec_avis AS
SELECT
    a.id_article,
    a.code_article,
    a.libelle,
    a.prix_unitaire,
    a.photo_principale,
    c.nom_categorie,
    COUNT(av.id_avis)               AS nb_avis,
    ROUND(AVG(av.note)::NUMERIC, 1) AS note_moyenne
FROM article a
JOIN categorie_article c  ON a.id_categorie  = c.id_categorie
LEFT JOIN avis_client av  ON av.id_article   = a.id_article
                         AND av.est_visible  = TRUE
WHERE a.est_actif = TRUE
GROUP BY
    a.id_article, a.code_article, a.libelle,
    a.prix_unitaire, a.photo_principale, c.nom_categorie
ORDER BY note_moyenne DESC NULLS LAST;