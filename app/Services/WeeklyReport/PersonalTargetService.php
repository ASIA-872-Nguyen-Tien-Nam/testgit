<?php

namespace App\Services\WeeklyReport;

use Dao;

class PersonalTargetService
{

    /**
     * Using serice for （rM0020）個人マスタ
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
    public function register($params = '')
    {
        return Dao::executeSql('SPC_RM0020_ACT1', $params);
    }

    /**
     * Get a record
     *
     * @param  Array $params
     * @return Array
     */
    public function get($company_cd = 0, $fiscal_year = 0)
    {
        $params['company_cd']   =   $company_cd;
        $params['fiscal_year']  =   $fiscal_year;
        return Dao::executeSql('SPC_RM0020_INQ1', $params);
    }

    /**
     *  delete 
     * 
     *  @param  integer $company_cd
     *  @param  integer $fiscal_year
     *
     *  @return array
     */
    public function delete($company_cd = 0, $fiscal_year = 0)
    {
        $params['fiscal_year']  =   $fiscal_year;
        $params['cre_user']     =   session_data()->user_id;
        $params['cre_ip']       =   $_SERVER['REMOTE_ADDR'];
        $params['company_cd']   =   $company_cd;
        return Dao::executeSql('SPC_RM0020_ACT2', $params);
    }

    /**
     * find target of employee_cd
     *
     * @param  Int $company_cd
     * @param  Int $fiscal_year
     * @param  String $employee_cd
     * @param  Int $get_default
     * @return Array
     */
    public function find($company_cd = 0, $fiscal_year = 0, $employee_cd = '', $get_default = 0)
    {
        $params['company_cd']   =   $company_cd;
        $params['fiscal_year']  =   $fiscal_year;
        $params['employee_cd']  =   $employee_cd;
        $params['get_default']  =   $get_default;
        $result = Dao::executeSql('SPC_RI0020_INQ1', $params);
        return $result[0][0] ?? [];
    }

    /**
     * save a target with employee_cd
     *
     * @param  Int $fiscal_year
     * @param  String $target1
     * @param  String $target2
     * @param  String $target3
     * @param  String $target4
     * @param  String $target5
     * @return Array
     */
    public function save($params = [])
    {
        $params['employee_cd'] = session_data()->employee_cd;
        $params['cre_user'] = session_data()->user_id;
        $params['cre_ip'] = $_SERVER['REMOTE_ADDR'];
        $params['company_cd'] = session_data()->company_cd;
        return Dao::executeSql('SPC_RI0020_ACT1', $params);
    }
}
