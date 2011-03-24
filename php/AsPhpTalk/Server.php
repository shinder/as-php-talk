<?php
/**
 * User: shinder
 * Date: 2011/3/21
 * Time: AM 10:46
 */
session_start();
function __autoload($class_name) {
    $class_name = str_replace ('_', '/', $class_name );
    include $class_name . '.php';
}
 
class Asphptalk_Server {
    protected $regClasses = array();
    protected $regFunctions = array();
    private $_production;

    public function __construct($prod=true) {
        $this->_production = $prod;
    }

    public function addFunction($functionName) {
        if( is_string($functionName) ) {
            if(! function_exists($functionName) ) {
                throw new Exception("Cannot find '$functionName' function!");
            } else {
                $this->regFunctions[$functionName] = true;
            }

        } else if ( is_array($functionName) ) {
            foreach($functionName as $func) {
                if( is_string($func) ) {
                    if(! function_exists($func) ) {
                        throw new Exception("Cannot find '$func' function!");
                    } else {
                        $this->regFunctions[$func] = true;
                    }

                } else {
                    throw new Exception("'$func' is not a function name!");
                }
            }
        }
        return $this;
    }

    public function setClass($className) {
        if( is_string($className) ) {
            if(! class_exists($className) ) {
                throw new Exception("Cannot find '$className' class!");
            } else {
                $this->regClasses[$className] = true;
            }
        } else {
            throw new Exception("'$className' is not a class name!");
        }
        return $this;
    }

    public function isProduction() {
        return $this->_production;
    }

    public function handle() {
        if(! $this->_production) {
            $_SESSION['last_talk_post_data'] = $_POST;
            $_SESSION['last_talk_post_data']['time'] = date( 'H:i:s');
        } else {
            if( isset($_SESSION['last_talk_post_data']) )
            unset( $_SESSION['last_talk_post_data'] );
        }
        $command = $_POST['jsonTalk'];
        if(! $command) {
            echo 'There are no service commands!';
            exit();
        }
        $args = json_decode( $_POST['args']);
        $argsArr = array();
        if( is_array($args) ) {
            foreach( $args as $arg) {
               $argsArr[] = $arg;
            }
        } else {
            $argsArr[] = $args;
        }

        if(strpos($command, '.') === false) {
            // call function
            if( $this->regFunctions[$command] ) {
                $result = call_user_func_array($command, $argsArr);
            } else {
                throw new Exception("'$command' is not an allowed function!");
            }
        } else {
            // call method of an object
            $commands = explode('.', $command);
            $methodName = array_pop($commands);
            $className = implode('_', $commands);

            if( $this->regClasses[$className] ) {
                $result = call_user_func_array( array($className, $methodName), $argsArr);
            } else {
                 throw new Exception("'$command' is not an allowed class!");
            }
        }
        echo $this->handle_result($result);
    }

    public function handle_result($result) {
        if( is_resource($result) ) {
            if( get_resource_type( $result )=='mysql result') {
                return Asphptalk_Recordset2Json::get($result);
            } else {
                throw new Exception(" The resource is not supported to JSON export!");
            }

        } elseif ( is_array($result) ) {
            $rs_count = 1;
            $register_ar = array();
            $prefix_mark = 'ShinderLinMark';
            $new_ar = array();

            foreach( $result as $k=>$v) {
                if( is_resource($v) ) {
                     if( get_resource_type( $v )=='mysql result' ) {
                        $register_ar[ $prefix_mark . $rs_count ] = Asphptalk_Recordset2Json::get($v);
                        $new_ar[$k] = $prefix_mark . $rs_count;
                        $rs_count++;
                     } else {
                        throw new Exception(" The resource is not supported to JSON export!");
                     }
                } else{
                    $new_ar[$k] = $v;
                }
            }
            $result_str = json_encode( $new_ar );

            // replacement
            foreach( $register_ar as $k=>$v) {
               $result_str = str_replace ('"'. $k .'"', $v , $result_str );
            }
            return $result_str;
        } else {
            return json_encode($result);
        }
    }
}