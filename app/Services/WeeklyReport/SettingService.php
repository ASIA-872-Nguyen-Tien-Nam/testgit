<?php
namespace App\Services\WeeklyReport;

use Dao;

class SettingService
{    
        
    /**
     * Using serice for（ rM0010 ）利用設定
     * 
     */
    public function __construct()
    {
        
    }
    /**
     * register a new record
     *
     * @param  Array $params
     * @return Array
     */
    public function register($params)
    {
        # code...
    }

    /**
     * Get records
     *
     * @param  Array $params
     * @return Array
     */
    public function get($params)
    {
        # code...
    }

    /**
     * Find a record
     *
     * @param  Array $params
     * @return Array
     */
    public function find($company_cd = 0)
    {
        $params['company_cd']   =   $company_cd;
        $result = Dao::executeSql('SPC_RM0010_INQ1',$params);
        if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        return $result[0][0] ?? [];
    }

}