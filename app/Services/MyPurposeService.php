<?php

namespace App\Services;

use Dao;

class MyPurposeService
{
    /**
     * Create or Update a my purpose
     *
     * @param  Array $my_purposes
     * @return Array
     */
    public function register($my_purposes = [])
    {
        return Dao::executeSql('SPC_MY_PURPOSE_ACT1', $my_purposes);
    }

    /**
     * get
     *
     * @param  Int $company_cd
     * @param  String $employee_cd
     * @return Array
     */
    public function get($company_cd = 0, $employee_cd = '')
    {
        $params['employee_cd'] = $employee_cd;
        $params['company_cd'] = $company_cd;
        return Dao::executeSql('SPC_MY_PURPOSE_INQ1', $params);
    }

    /**
     * Find my purpose for page
     *
     * @param  String $json
     * @param  String $user_id
     * @param  Int $company_cd
     * @param  Int $mode          
     * @param  Int $system
     * @return Array
     */
    public function find($json, $user_id, $company_cd, $mode = 1, $system = 1)
    {
        $params['language']     =   session_data()->language;
        $params['json']         =   $json;
        $params['cre_user']     =   $user_id;
        $params['company_cd']   =   $company_cd;
        $params['mode']         =   $mode;
        $params['system']       =   $system; // 1.人事評価 2.1on1 3.マルチレビュー 4.共通設定 5.週報
        return Dao::executeSql('SPC_Q9001_FND1', $params);
    }
}
