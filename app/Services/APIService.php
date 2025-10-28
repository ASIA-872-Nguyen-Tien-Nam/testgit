<?php
namespace App\Services;

use Dao;

class APIService
{
    public function __construct()
    {

    }

    /**
     * call authorize king of time
     * @author namnt
     * @created at 2024-10-29
     * @return \Illuminate\Http\Response
     */
    public function getKotData($company_cd = '', $type)
    {
        $params['company_cd'] = $company_cd;
        $result = Dao::executeSql('SPC_A0005_INQ1',$params);
        if($type == 0) {
            return $result[1][0]['access_token']??'';
        } else {
            return $result[0];
        }
    }
    /**
     *  update statusUpload api
     *  @param  integer $company_cd
     *
     *  @return array
    */
    public function updateStatusUpload($params)
    {
        $result = Dao::executeSql('SPC_A0005_ACT1',$params);
        return $result[0];
    }
}