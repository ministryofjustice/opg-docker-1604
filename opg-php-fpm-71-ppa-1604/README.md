php-fpm
=======

Container with one php-fpm pool running (4 static workers).

env variables
-------------
OPG_PHP_XDEBUG_ENABLE: If pass with any value it will enable XDebug extension for both CLI and Remote 
OPG_PHP_POOL_CHILDREN_MAX: default 4
OPG_PHP_POOL_REQUESTS_MAX: default 0
