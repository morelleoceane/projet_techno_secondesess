<?php
/**
 * Classe SecuriteAccess - Contrôles d'accès (client / admin)
 * Fichier : SecuriteAccess.class.php
 *
 * CORRECTION : ces deux contrôles existaient auparavant sous forme de
 * fonctions procédurales (check_connection.php), en dehors de toute classe.
 * Le PHP objet pur exige qu'aucune fonction n'existe hors d'une classe :
 * elles sont donc regroupées ici en méthodes statiques et autochargées
 * comme toutes les autres classes.
 */
class SecuriteAccess {

    public static function checkClientConnecte(): void {
        if (!isset($_SESSION['client_id'])) {
            header('Location: /ProjetMYTechno/index_.php?page=connexion');
            exit();
        }
    }

    public static function checkAdminConnecte(): void {
        if (!isset($_SESSION['admin_id'])) {
            header('Location: /ProjetMYTechno/admin/index_.php?page=connexion_admin');
            exit();
        }
    }
}
