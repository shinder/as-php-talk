<?php
/**
 * User: shinder
 * Date: 2011/3/22
 * Time: PM 3:35
 */
 
class Asphptalk_Recordset2Json {

    public static function get( $rs ) {
        return self::rs2json( $rs );
    }

    public static function rs2array($rs) {
        mysql_data_seek($rs, 0);
        $ar = array();
        if(mysql_num_rows($rs)) {
            while($row = mysql_fetch_assoc($rs)) {
                $obj = array();
                foreach($row as $key => $value) {
                    $obj[ $key ] = $value;
                }
                array_push($ar, $obj);
            }
            mysql_data_seek($rs, 0);
        }
        return $ar;
    }

    public static function rs2json($rs) {
        $ar = self::rs2array( $rs );
        return json_encode( $ar );
    }
}
