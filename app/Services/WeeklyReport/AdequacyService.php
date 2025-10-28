<?php

namespace App\Services\WeeklyReport;

use Dao;

class AdequacyService
{

    /**
     * Using serice for（rM0110）充実度マスタ
     * 
     */
    public function __construct()
    {
    }

    /**
     *  getAdequacy
     *
     *  @param  integer $company_cd
     *
     *  @return array
     */
    public function getAdequacy($mark_kbn = 1, $mark_typ = 1, $mode = 1)
    {
        $params = [
            'company_cd'    => session_data()->company_cd,   
            'mark_kbn'      => $mark_kbn,   
            'mark_typ'      => $mark_typ,   
            'mode'          => $mode,   
            'language'      => session_data()->language
        ];
        return Dao::executeSql('SPC_rM0110_INQ1', $params);
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
    
    /**
     * get Adequacy By marl_kbn
     *
     * @param  Int $mark_kbn
     * @return Array
     */
    public function getAdequacyByMarkKbn($mark_kbn = 1)
    {
        $params['company_cd']   =   session_data()->company_cd; //session_data()->company_cd;
        $params['mark_kbn']     =   $mark_kbn;
        $adequacy = Dao::executeSql('SPC_RM0110_LST1', $params); 
        if (isset($adequacy[0][0]['error_typ']) && $adequacy[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        return $adequacy[0] ?? [];
    }
}
