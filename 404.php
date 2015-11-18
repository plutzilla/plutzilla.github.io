<?php

$redirectUri = 'http://old.lescinskas.lt'.$_SERVER['REQUEST_URI'];

if($_SERVER['REQUEST_URI'] == '/lt/blog/rss' || $_SERVER['REQUEST_URI'] == '/index.php/lt/blog/rss') {
	$redirectUri = '/feed.xml';
}

header('HTTP/1.1 301 Moved Permanently');
header('Location: '.$redirectUri);
exit;