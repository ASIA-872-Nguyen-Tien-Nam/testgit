<?php

namespace App\Services;

use Dao;

class ScheduleService
{
    /**
     * findSchedule
     * get data of group
     *  @param  company_cd  int
     *  @param  fiscal_year int
     *  @param  oneonone_group_list json
     *
     * @return array
     */
    public function findSchedule($company_cd, $fiscal_year, $oneonone_group_list)
    {
        $params = array(
            'company_cd'             =>  $company_cd,
            'fiscal_year'            =>  $fiscal_year,
            'oneonone_group_list'    =>  $oneonone_group_list,
            'language'               => session_data()->language,
        );
        return Dao::executeSql('SPC_oI1010_FND1', $params);
    }
    /**
     * getOption
     * get data for select box
     *
     * @return array
     */
    public function getOption()
    {
        $params = ['company_cd' => session_data()->company_cd];
        return Dao::executeSql('SPC_oI1010_INQ1', $params);
    }
    /**
     * saveSchedule
     * save data on screen
     *  @param  company_cd  int
     *  @param  fiscal_year int
     *  @param  json json
     *
     * @return array
     */
    public function saveSchedule($company_cd, $fiscal_year, $json)
    {
        $params = array(
            'json'          =>   $json,
            'fiscal_year'   =>   $fiscal_year,
            'company_cd'    =>   $company_cd,
            'cre_user'      =>   session_data()->user_id,
            'cre_ip'        =>   $_SERVER['REMOTE_ADDR']
        );
        return Dao::executeSql('SPC_oI1010_ACT1', $params);
    }
    /**
     * deleteSchedule
     * delete data of Schedule master
     *  @param  company_cd  int
     *  @param  fiscal_year int
     *  @param  oneonone_group_list json
     *
     * @return array
     */
    public function deleteSchedule($company_cd, $fiscal_year, $oneonone_group_list)
    {
        $params = array(
            'company_cd'            =>  $company_cd,
            'fiscal_year'           =>  $fiscal_year,
            'oneonone_group_list'   =>  $oneonone_group_list,
            'cre_user'              =>  session_data()->user_id,
            'cre_ip'                =>  $_SERVER['REMOTE_ADDR']
        );
        return Dao::executeSql('SPC_oI1010_ACT2', $params);
    }
}
