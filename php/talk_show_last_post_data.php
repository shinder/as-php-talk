<?php
/**
 * User: shinder
 * Date: 2011/3/23
 * Time: PM 2:34
 */
session_start();
if( isset( $_SESSION['last_talk_post_data']) )
    print_r( $_SESSION['last_talk_post_data'] );
else
    echo 'No post data!';

