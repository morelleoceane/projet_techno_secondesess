<?php
/**
 * db_pg_connect.php – Chargement des paramètres de connexion
 * CORRECTION : les credentials ne sont plus écrits en clair ici.
 *              Ils proviennent de db_config.php (à exclure du dépôt Git).
 */
$config = require __DIR__ . '/db_config.php';
$dsn  = $config['dsn'];
$user = $config['user'];
$pass = $config['pass'];
