<?php
/**
*-------------------------------------------------------------------------*
* Monitas
* Helpers call procedue sql server
*
* 処理概要/process overview :
* 作成日/create date           :   2016/01/05
* 作成者/creater               :   Vulq - ANS793 - vulq@ans-asia.com
*
* @package                  :   Helpers
* @copyright                :   Copyright (c) ANS-ASIA
* @version                  :   1.0.0
*-------------------------------------------------------------------------*
*/
namespace App\Helpers;
use Illuminate\Http\File;
use Illuminate\Support\Facades\Storage;
use PDO,DB;
class Dao{
    const FROM_ENCODING = 'SJIS';
    const TO_ENCODING = 'UTF-8';
    const EXCEPTION = 'EXCEPTION';

    public function __construct() {

    }
    /**
     * runs a stored procedure and returns results if any
     *--------------------------------------------
     * @author      :   vulq    - 2016/02/22 - create
     * @author      :   Kyvd    - 2016/11/23 - update option endcode html
     * @param string    $sProcedure : SQL string
     * @param array     $aParams    : params
     * @param boolean   $option     : true: format html (default) / false: don't format html
     * @param boolean   $debug      : true: debug / false: don't debug
     *
     * @updated by  :   quyentb - 2018/02/22 - update delete file log
     */
    public static function executeSql($sProcedure, $aParams = array(), $option = false, $debug = false)
    {
        try{
            // var_dump($sProcedur);
            $this_ = new Dao;
            // create database connection
            $db = DB::connection()->getPdo();
            $db->setAttribute(constant('PDO::SQLSRV_ATTR_DIRECT_QUERY'), true);
            $db->query("SET NOCOUNT ON");
            // if any params are present, add them
            $sParamsIn = '';
            if(isset($aParams) && is_array($aParams) && count($aParams)>0) {
                // loop through params and set
                foreach($aParams as $sParam) {
                    $sParamsIn .= '?,';
                }
                // trim the last comma from the params in string
                $sParamsIn = substr($sParamsIn, 0, strlen($sParamsIn)-1);
            }
            if($debug){
                echo $this_->debugQuery($sProcedure, $aParams);
                die;
            }

            //    Logging
            $debug_sql = $this_->interpolateQuery($sProcedure, $aParams);
            $time = date("Y-m-d H:i:s");
            $logFile = fopen(
                storage_path('logs' . DIRECTORY_SEPARATOR . date('Y-m-d') . '_query.log'),
                'a+'
            );

            // Delete all log file except newest 10 files
            $path = storage_path('logs');
            $files = \Illuminate\Support\Facades\File::files($path);
            if(count($files) > 11) {
                $index = count($files) - 11;
                for ($i = 0; $i < count($files); $i++) {
                    if ($i < $index) {
                        \Illuminate\Support\Facades\File::delete($files[$i]);
                    }
                }
            }

            fwrite($logFile, $time . ': ' . $debug_sql . PHP_EOL);
            fclose($logFile);

            // create initial stored procedure call
            $stmt = $db->prepare("{CALL $sProcedure($sParamsIn)}");
            // if any params are present, add them
            if(isset($aParams) && is_array($aParams) && count($aParams)>0) {
                $iParamCount = 1;
                // loop through params and bind value to the prepare statement
                foreach ($aParams as &$value) {
                    // if (strpos($sProcedure,'FND') !== false 
                    //     || strpos($sProcedure,'LST') !== false
                    //     || strpos($sProcedure,'INQ') !== false) {
                    //         $value = $this_->sqlServerEscapeString($value);//vulq comment 20160804
                    // }
                    $stmt->bindParam($iParamCount, $value);
                    $iParamCount++;
                }
            }
            // execute the stored procedure
            $stmt->execute();
            $stmt->setFetchMode(PDO::FETCH_ASSOC);
            //    START: Updated by HaTT 20160719
            
            // START: Updated by HaTT 20160719
            $result = array();
            $i = 0;
            // START: Updated by HaTT 20160704
            do {
                while($respon = $stmt->fetch(PDO::FETCH_ASSOC)) {
                    foreach ($respon as $key_from_encoding => $res_from_encoding) {
                        $key_to_encoding = mb_convert_encoding($key_from_encoding, self::TO_ENCODING, self::FROM_ENCODING);
                        $res_from_encoding = $option == true ? htmlspecialchars_decode($res_from_encoding) : htmlspecialchars($res_from_encoding);
                        unset ($respon[$key_from_encoding]);
                        $respon[$key_to_encoding] = $res_from_encoding;
                    }
                    $result[$i][] = $respon;
                }
                //Comment by kyvd 20160711
                if(!isset($result[$i])) {
                    $result[$i] = $this_->getColumns($stmt, $option);
                }
                $i++;
            } while ($stmt->nextRowset());
            // END: Updated by HaTT 20160704

         }catch (\Exception $e) {
            $result[0][0]['Id']         = $e->getCode();
            $result[0][0]['error_typ']  = '999';
            $result[0][0]['Data']       = 'Exception';
            $result[0][0]['remark']     = $e->getMessage();
            // Write log error
            $this_ = new Dao;
            $sParamsIn = '';
            if(isset($aParams) && is_array($aParams) && count($aParams)>0) {
                // loop through params and set
                foreach($aParams as $sParam) {
                    $sParamsIn .= '?,';
                }
                // trim the last comma from the params in string
                $sParamsIn = substr($sParamsIn, 0, strlen($sParamsIn)-1);
            }
            $debug_sql  =   $this_->interpolateQuery($sProcedure, $aParams);
            $time = date("Y-m-d H:i:s");
            $logFile = fopen(
                storage_path('logs' . DIRECTORY_SEPARATOR . date('Y-m-d') . '_query.log'),
                'a+'
            );
            fwrite($logFile, $time . ': ' . $debug_sql . PHP_EOL);
            fclose($logFile);
        }
        return $result;
    }
    /**
     * interpolateQuery
     *
     * @author      :   hatt     - 2016/07/19 - create
     * @author      :
     * @param       :   $query,$params
     * @return      :
     * @access      :   protected
     * @see         :   get _db
     */
    protected function interpolateQuery($query, $params) {
        $keys = array();
        $values = $params;
        $arr = array_fill(0, sizeof($params), '?');
        $params_str = implode("','", $params);
        $query = "EXEC " . $query;
        $query .= " '" . $params_str . "';";
        return $query;
    }
    /**
     * debugQuery
     *
     * @author      :   hatt     - 2016/07/19 - create
     * @author      :
     * @param       :   $query,$params
     * @return      :
     * @access      :   protected
     * @see         :   get _db
     */
    protected function debugQuery($query, $params) {
        $keys = array();
        $values = $params;
        $arr = array_fill(0, sizeof($params), '?');
        $quote_css = '<span style="color:#FF0000;">' . "'" . '</span>';
        $comma_css = '<span style="color:#808080;">,</span>';
        $semicolon_css = '<span style="color:#808080;">;</span>';
        $str_css  = '</span>' . $quote_css;
        $str_css .= $comma_css;
        $str_css .= $quote_css . '<span style="color:#FF0000;">';
        $params_str = implode($str_css, $params);
        $query = '<span style="color:#0000FF;">EXEC</span>' . "<span> $query </span>";
        $query .= $quote_css.'<span style="color:#FF0000;">' . $params_str . '</span>'.$quote_css . $semicolon_css;
        return     '<div><span>SQL Debug:<span><br>
                <pre style="display: block;color: #000;font-size: 16px;background-color: #eff0f1;"><code>'.$query.'</code></pre></div><br>';
    }
    /**
     * getColumns
     *
     * @author      :   vulq     - 2016/05/08 - create
     * @author      :
     * @param       :   $statement,$option
     * @return      :
     * @access      :   protected
     * @see         :
     */
    protected function getColumns($statement, $option) {
        $columns = array();
        if($option == 'default'){
            for ($i = 0; $i < $statement->columnCount(); $i++) {
                $col = $statement->getColumnMeta($i);
                $columns[0][$col['name']] = $this->setDefaultByType($col['sqlsrv:decl_type']);
            }
        }
        return $columns;
    }

    /**
     * setDefaultByType
     *
     * @author      :   giangnt     - 2015/05/08 - create
     * @author      :
     * @param       :   $mssql_type
     * @return      :
     * @access      :   private
     * @see         :
     */
    private function setDefaultByType($mssql_type) {
        $default = null;
        switch(strtoupper($mssql_type)) {
            case 'BIT':
                $default = '';
                break;
            case 'TINYINT':
            case 'SMALLINT':
            case 'MEDIUMINT':
            case 'INT':
            case 'INTEGER':
            case 'BIGINT':
                $default = '';
                break;
            case 'FLOAT':
            case 'DOUBLE':
            case 'DECIMAL':
                $default = '';
                break;
            case 'CHAR':
            case 'ENUM':
            case 'SET':
            case 'VARCHAR':
            case 'NVARCHAR':
                $default = '';
                break;
            case 'TINYTEXT':
            case 'TEXT':
            case 'MEDIUMTEXT':
            case 'LONGTEXT':
                $default = '';
                break;
            case 'BINARY':
            case 'VARBINARY':
            case 'BLOB':
            case 'TINYBLOB':
            case 'MEDIUMBLOB':
            case 'LONGBLOB':
                $default = '';
                break;
            case 'DATE':
            case 'TIME':
            case 'DATETIME':
            case 'TIMESTAMP':
            case 'YEAR':
                $default = '';
                break;
            default:
                $default = '';
                break;
        }
        return $default;
    }

    /**
     * validate string
     *
     * @param string $input
     * @return string
     */
    public function sqlServerEscapeString($input){
        $input = str_replace('[', '[[]', $input);
        $input = str_replace('%', '[%]', $input);
        $input = str_replace('_', '[_]', $input);
        $input = str_replace('\\', '[\\]', $input);
        $input = str_replace('\'', '\'\'', $input);
        // START: Add by SangTK 20160726
        if ($input === NULL){
            $input = NULL;
        }
        // END: Add by SangTK 20160726
        //$input = rtrim($input);
        return $input;
    }

}
