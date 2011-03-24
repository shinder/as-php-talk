<?php
/**
 * User: shinder
 * Date: 2011/3/22
 * Time: AM 11:03
 */

require_once "AsPhpTalk/Server.php";

function sayHello( $who ) {
    return 'Hello~ ' . $who;
}

function multi( $a, $b, $c=1 ) {
    return 'multi: ' . ($a * $b * $c);
}

$server = new Asphptalk_Server(FALSE);  // No production status

/* You can allow serval function by an array */
// $server->addFunction( array('sayHello', 'multi') );


/* The classes you allowed will be autoloaded */
$server->addFunction( 'sayHello' )
        ->addFunction( 'multi' )
        ->setClass("examples_ExampleClass2")
        ->setClass("ExampleClass1");


echo $server->handle();