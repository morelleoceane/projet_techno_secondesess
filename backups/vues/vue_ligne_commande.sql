CREATE OR REPLACE VIEW vue_lignes_commande AS
SELECT
    lc.id_ligne,
    lc.id_commande,
    lc.quantite,
    lc.prix_unitaire_achat,
    lc.quantite * lc.prix_unitaire_achat AS sous_total,
    lc.taille,
    lc.couleur,
    a.code_article,
    a.libelle AS article_libelle
FROM ligne_commande lc
JOIN article a ON lc.id_article = a.id_article
ORDER BY lc.id_commande, lc.id_ligne;
 