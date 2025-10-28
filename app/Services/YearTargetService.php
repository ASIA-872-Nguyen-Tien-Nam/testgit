<?php
namespace App\Services;

use Dao;

class YearTargetService
{
    public function __construct()
    {

    }

    /**
     *  getYearTarget
     * 
     *  @param  integer $company_cd
     *  @param  integer $fiscal_year
     *
     *  @return array
    */
    public function getYearTarget($company_cd = 0,$fiscal_year = 0)
    {
        $params['company_cd']   =   $company_cd;
        $params['fiscal_year']  =   $fiscal_year;
        return Dao::executeSql('SPC_OM0100_INQ1',$params);
    }
    /**
     *  save YearTarget
     * 
     *  @param  integer $company_cd
     *  @param  json    $params
     *
     *  @return array
    */
    public function saveYearTarget($company_cd = 0,$params = '')
    {
        return Dao::executeSql('SPC_OM0100_ACT1',$params);
    }

    /**
     *  delete YearTarget
     * 
     *  @param  integer $company_cd
     *  @param  integer $fiscal_year
     *
     *  @return array
    */
    public function deleteYearTarget($company_cd = 0,$fiscal_year = 0)
    {
        $params['fiscal_year']  =   $fiscal_year;
        $params['cre_user']      =   session_data()->user_id;
        $params['cre_ip']        =   $_SERVER['REMOTE_ADDR'];
        $params['company_cd']   =   $company_cd;
        return Dao::executeSql('SPC_OM0100_ACT2',$params);
    }    
    /**
     * getYearTargetPerson
     *
     * @param  int $company_cd
     * @param  int $fiscal_year
     * @param  string $empployee_cd
     * @return array
     */
    public function getYearTargetPerson($company_cd = 0,$fiscal_year = 0, $employee_cd = '')
    {
        $params['company_cd']   =   $company_cd;
        $params['fiscal_year']  =   $fiscal_year;
        $params['employee_cd']  =   $employee_cd;
        return Dao::executeSql('SPC_OM0100_INQ2',$params);
    }
}