<?php
/**
 * Classe SecuriteAccess – Contrôles d'accès (client / admin)
 * Fichier : SecuriteAccess.class.php
 *
 * CORRECTION : les fonctions procédurales checkClientConnecte() et
 * checkAdminConnecte() de check_connection.php sont ici regroupées
 * en méthodes statiques d'une classe, conformément à la règle
 * "PHP objet pur – aucune fonction en dehors d'une classe".
 * La classe est autochargée comme toutes les autres.
 */
class SecuriteAccess
{
    /** Redirige vers la connexion client si non connecté */
    public static function checkClientConnecte(): void
    {
        if (!isset($_SESSION['client_id'])) {
            header('Location: /ProjetMYTechno/index_.php?page=connexion');
            exit();
        }
    }

    /** Redirige vers la connexion admin si non connecté */
    public static function checkAdminConnecte(): void
    {
        if (!isset($_SESSION['admin_id'])) {
            header('Location: /ProjetMYTechno/admin/index_.php?page=connexion_admin');
            exit();
        }
    }
}
