# How To activate OMP logging
Logging of SQL statements executed for debugging, can be activated in the file config.inc.php.
Set "debug = True" in the [database] section.
But this leads to all SQL statements being printed interleaved with the HTML output,
and is not readable for longer sessions.

Another way to inspect the executed database queries is to enable general logging on the MYSQL server.
See the official [MySQL documentation](https://dev.mysql.com/doc/refman/5.5/en/query-log.html) for more information.

The query log for MySQL can be activated while the server is running with the following statement.
```sql
SET GLOBAL general_log = 'ON';
```

Even more detailed inspection of the OMP workflow can be done with debugging.
One way is using Xdebug in combination with Jetbrains PhpStorm, see the
[instructions from the JetBrains](https://confluence.jetbrains.com/display/PhpStorm/Zero-configuration+Web+Application+Debugging+with+Xdebug+and+PhpStorm) website for debugging with PhpStorm and Xdebug.

The Xdebug PHP module needs to be installed on the webserver running the code.
For Ubuntu and PHP 7 bundled packages are available http://packages.ubuntu.com/de/xenial/php-xdebug,
 which can be installed with apt-get.
```sh
sudo apt-get install php-xdebug
```

See the [Xdebug installation instructions](https://xdebug.org/docs/install) for other versions and platforms.
And the instructions on the JetBrains website.

## Recommendations


# Database Entry steps

