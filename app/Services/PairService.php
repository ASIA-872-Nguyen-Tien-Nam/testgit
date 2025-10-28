<?php
namespace App\Services;

use Dao;

class PairService
{
    public function __construct()
    {

    }

    /**
     *  findPairs
     *  @param  integer $company_cd
     *  @param  string  $json
     *
     *  @return array
    */
    public function findPairs($company_cd = 0,$json = '')
    {
        $params = [
            'company_cd'    => $company_cd,
            'user_id'       => session_data()->user_id,
            'json'          => $json
        ];
        return Dao::executeSql('SPC_oI1020_FND1',$params);
    }
    /**
     *  save item
     *  @param  integer $company_cd
     *  @param  json    $params
     *
     *  @return array
    */
    public function savePairs($company_cd = 0,$json = '')
    {
        $params = array(
            'company_cd' => $company_cd,
            'cre_user'      =>   session_data()->user_id,
            'cre_ip'        =>   $_SERVER['REMOTE_ADDR'],
            'json'          => $json,
            'language'      =>   session_data()->language
        );
        return Dao::executeSql('SPC_oI1020_ACT1',$params);
    }

    /**
     *  delete item
     *  @param  integer $company_cd
     *  @param  string $json
     *
     *  @return array
    */
    public function deletePairs($company_cd = 0,$json = '')
    {
        $params = array(
            'company_cd' => $company_cd,
            'cre_user'      =>   session_data()->user_id,
            'cre_ip'        =>   $_SERVER['REMOTE_ADDR'],
            'json'          => $json

        );
        return Dao::executeSql('SPC_oI1020_ACT2',$params);
    }


}