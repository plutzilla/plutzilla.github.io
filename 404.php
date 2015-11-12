<?php

header('HTTP/1.1 301 Moved Permanently');
header('Location: http://old.lescinskas.lt'.$_SERVER['REQUEST_URI']);
exit;