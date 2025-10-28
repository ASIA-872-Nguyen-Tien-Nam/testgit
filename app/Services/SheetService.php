<?php
namespace App\Services;

use Dao;

class SheetService
{
    public function __construct()
    {

    }

    /**
     *  search item for left content
     *  @param  integer $company_cd
     *  @param  string  $key_search
     *  @param  integer $page (= 0 find all)
     *  @param  integer $page_size
     *
     *  @return array
    */
    public function findSheets($company_cd = 0,$key_search = '',$page = 1,$page_size = 10)
    {
        $params = [
            'key_search'        => $key_search,
            'company_cd'        => $company_cd,
            'page'              => $page,
            'page_size'         => $page_size,
        ];
        $res =  Dao::executeSql('SPC_oM0200_INQ1',$params);
        $re_data = [];
        $interview_cd = -1;
        $count  =   0;
        if(isset($res[0]) && isset($res[0][0]['interview_cd'])){
            foreach($res[0] as $dt){
                if($interview_cd == $dt['interview_cd']){
                    array_push($re_data[$interview_cd],$dt);
                    // $re_data[$interview_cd] = $re_data[$interview_cd]+$dt;
                }else{
                    $interview_cd = $dt['interview_cd'];
                    $re_data[$dt['interview_cd']][0] = $dt;
                }
            }
        };
        $res[0] = $re_data;
        return $res;
    }

    /**
     *  getMark
     *
     *  @param  integer $company_cd
     *  @param  integer $interview_cd
     * *  @param  integer $adaption_date
     *
     *  @return array
    */
    public function getSheet($company_cd ,$interview_cd,$adaption_date)
    {
        $params = [
            'company_cd'        => $company_cd,
            'interview_cd'      => $interview_cd,
            'adaption_date'     => $adaption_date,
        ];
        return Dao::executeSql('SPC_oM0200_FND1',$params);
    }

     /**
     *  saveSheet
     *
     *  @param  integer $company_cd
     *  @param  integer $interview_cd
     * *  @param  integer $adaption_date
     *
     *  @return array
    */
    public function saveSheet($json)
    {
        $params['json']         =   $json;
        $params['cre_user']     =   session_data()->user_id;
        $params['cre_ip']       =   $_SERVER['REMOTE_ADDR'];
        $params['company_cd']   =   session_data()->company_cd;
        return Dao::executeSql('SPC_OM0200_ACT1',$params);
    }

     /**
     *  saveSheet
     *
     *  @param  integer $company_cd
     *  @param  integer $interview_cd
     * *  @param  integer $adaption_date
     *
     *  @return array
    */
    public function deleteSheet($interview_cd,$adaption_date)
    {
        $params['company_cd']   	=   session_data()->company_cd; //session_data()->company_cd;
        $params['interview_cd']   	=   $interview_cd; //session_data()->company_cd;
        $params['adaption_date']   	=   $adaption_date; //session_data()->company_cd;
        $params['cre_user']     	=   session_data()->user_id;//session_data()->user_id;
        $params['cre_ip']       	=   $_SERVER['REMOTE_ADDR'];
        //
        return  Dao::executeSql('SPC_OM0200_ACT2',$params);
    }
}