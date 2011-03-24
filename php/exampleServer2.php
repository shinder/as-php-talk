<?php
/**
 * User: shinder
 * Date: 2011/3/22
 * Time: AM 11:03
 */

require_once "AsPhpTalk/Server.php";

function getDBData() {
    $hostname_conn = "localhost";
    $database_conn = "shinder_test";
    $username_conn = "root";
    $password_conn = "";
    $conn = mysql_pconnect($hostname_conn, $username_conn, $password_conn) or trigger_error(mysql_error(),E_USER_ERROR);
    mysql_query("SET NAMES utf8");

    mysql_select_db($database_conn);
    $rs = mysql_query("select * from info_from");

    /* You can return a mysql record set in an one-dimension array */
    return array('first'=>$rs, 'second'=>$rs);
}

$server = new Asphptalk_Server(FALSE);
$server->addFunction( 'getDBData' );
echo $server->handle();