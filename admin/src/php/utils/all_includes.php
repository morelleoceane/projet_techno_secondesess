<?php
/**
 * all_includes.php – Point d'entrée unique pour :
 *  - Sécuriser et démarrer la session
 *  - Définir les constantes ROOT_PATH et BASE_URL
 *  - Autocharger toutes les classes du dossier classes/
 *  - Inclure la connexion à la base de données
 *
 * Ce fichier est inclus en TOUT PREMIER dans chaque index_.php
 * (public et admin) avant tout autre code.
 *
 * CORRECTION : ROOT_PATH pointe maintenant vers le dossier /admin
 *              (dirname(__DIR__, 3) depuis utils/ remonte bien jusqu'à /admin).
 *              Le fichier all_includes.php est partagé par les deux index_.php ;
 *              il doit donc toujours se trouver dans admin/src/php/utils/.
 */

// Sécurisation du cookie de session (pas d'accès JS, envoi limité same-site)
session_set_cookie_params([
    'httponly' => true,
    'samesite' => 'Lax',
]);
session_start();

// Racine du dossier /admin (commune aux deux index_.php)
define('ROOT_PATH', dirname(__DIR__, 3)); // admin/src/php/utils → admin/src/php → admin/src → admin

// URL de base du projet
define('BASE_URL', '/ProjetMYTechno/');

// ========================
// AUTOLOADING DES CLASSES
// ========================
// Aucune fonction ne doit exister en dehors d'une classe :
// l'autoload garantit que chaque nom de classe correspond au fichier
// NomClasse.class.php dans le dossier classes/.
spl_autoload_register(function (string $className): void {
    $file = ROOT_PATH . '/src/php/classes/' . $className . '.class.php';
    if (file_exists($file)) {
        require_once $file;
    }
});

// ========================
// CONNEXION BASE DE DONNÉES
// ========================
require_once ROOT_PATH . '/src/php/db/db_pg_connect.php';
