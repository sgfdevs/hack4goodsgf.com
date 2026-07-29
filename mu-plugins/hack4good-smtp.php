<?php
/**
 * Plugin Name: Hack4Good SMTP
 * Description: Routes WordPress mail through the configured SMTP service.
 */

add_action('phpmailer_init', static function ($phpmailer): void {
    $host = getenv('WORDPRESS_SMTP_HOST');
    $username = getenv('WORDPRESS_SMTP_USERNAME');
    $password = getenv('WORDPRESS_SMTP_PASSWORD');
    $fromEmail = getenv('WORDPRESS_SMTP_FROM_EMAIL');

    if (!$host || !$username || !$password || !$fromEmail) {
        return;
    }

    $phpmailer->isSMTP();
    $phpmailer->Host = $host;
    $phpmailer->Port = (int) (getenv('WORDPRESS_SMTP_PORT') ?: 587);
    $phpmailer->SMTPSecure = getenv('WORDPRESS_SMTP_ENCRYPTION') ?: 'tls';
    $phpmailer->SMTPAuth = true;
    $phpmailer->Username = $username;
    $phpmailer->Password = $password;
    $phpmailer->setFrom($fromEmail, getenv('WORDPRESS_SMTP_FROM_NAME') ?: 'Hack4Good SGF', false);
});
