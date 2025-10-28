<?php

namespace App\Services\WeeklyReport;

use Dao;

class ReactionService
{

    /**
     * Using serice for（rM0120）リアクションマスタ
     * 
     */
    public function __construct()
    {
    }
    /**
     *  getReaction
     *
     *  @param  integer $company_cd
     *
     *  @return array
     */
    public function getReaction($mark_kbn = 2)
    {
        $params = [
            'company_cd'    => session_data()->company_cd,
            'mark_kbn'      => $mark_kbn,
        ];
        return Dao::executeSql('SPC_rM0120_INQ1', $params);
    }

    /**
     * search list master for leftcontent
     *  @param  array $params = [search_key,current_page,page_size,company_cd,language]
     *  @param  array 
     *
     * @return array
     */
    public function getLeftContent($params = [])
    {
        return Dao::executeSql('SPC_rM0120_LST1', $params);
    }

    /**
     * saveReaction
     *
     * @param  Array $params
     * @return Array
     */
    public function saveReaction($params = [])
    {
        return Dao::executeSql('SPC_RM0120_ACT1', $params);
    }
    /**
     *  deleteReaction
     *
     *
     *  @return array
     */
    public function deleteReaction($mark_kbn = 0)
    {
        $params['company_cd']   =   session_data()->company_cd; //session_data()->company_cd;
        $params['mark_kbn']     =   $mark_kbn;
        $params['cre_user']     =   session_data()->user_id;; //session_data()->user_id;
        $params['cre_ip']       =   $_SERVER['REMOTE_ADDR'];
        return Dao::executeSql('SPC_RM0120_ACT2', $params);
    }

    /**
     * get Reaction By mark_kbn
     *
     * @param  Int $mark_kbn
     * @return Array
     */
    public function getReactionByMarkKbn($mark_kbn = 1)
    {
        $params['company_cd']   =   session_data()->company_cd; //session_data()->company_cd;
        $params['mark_kbn']     =   $mark_kbn;
        $params['cre_user']     =   session_data()->user_id;; //session_data()->user_id;
        $adequacy = Dao::executeSql('SPC_rM0120_LST2', $params);
        return $adequacy[0] ?? [];
    }
}
