<?php
$overwriteDefaultSettings = [

	'thumbnails_imagemagick' => '1',
	'thumbnails_imagemagick_imagick' => '1',

	'thumbnails_ffmpeg' => '1',
	'thumbnails_ffmpeg_path' => 'ffmpeg',

	'thumbnails_libreoffice' => '1',
	'thumbnails_libreoffice_path' => 'soffice',

	'ui_logo_url' => '?page=logo&version=2021.12.07'
];
$queries[] = "UPDATE `df_file_handlers` SET `handler`='libreoffice_viewer', `weblink_handler`='libreoffice_viewer' WHERE `type` in ('office', 'ooffice')";
$queries[] = "UPDATE `df_users_permissions` SET `homefolder` = '/app/data/user-files' WHERE uid='1'";
