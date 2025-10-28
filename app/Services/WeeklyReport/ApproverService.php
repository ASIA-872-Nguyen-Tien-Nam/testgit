<?php

namespace App\Services\WeeklyReport;

use Dao;

class ApproverService
{

    /**
     * Using serice for（ri1020）充実度マスタ
     * 
     */
    public function __construct()
    {
    }

    /**
     *  
     *
     *  @param  integer $company_cd
     *
     *  @return array
     */
    public function get($params)
    {
        return Dao::executeSql('SPC_rI1020_INQ1', $params);
    }

    /**
     *  save Adequacy
     *
     *  @param  Request    $request
     *
     *  @return array
     */
    public function saveAdequacy($params = [])
    {
        return Dao::executeSql('SPC_RM0110_ACT1', $params);
    }

    /**
     *  delete Adequacy
     *
     *
     *  @return array
     */
    public function deleteAdequacy($mark_kbn = 0)
    {
        $params['company_cd']   =   session_data()->company_cd; //session_data()->company_cd;
        $params['mark_kbn']     =   $mark_kbn;
        $params['cre_user']     =   session_data()->user_id;; //session_data()->user_id;
        $params['cre_ip']       =   $_SERVER['REMOTE_ADDR'];
        return Dao::executeSql('SPC_RM0110_ACT2', $params);
    }
}
