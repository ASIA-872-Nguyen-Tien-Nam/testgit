<?php
namespace App\Services;

use Dao;

class FileUploadService
{
    public function __construct()
    {

    }
    /**
     *  refer item for rightcontent
     *  @param  integer $company_cd
     *  @param  integer $item_cd
     *
     *  @return array
    */
    public function getFile($company_cd = 0,$employee_cd = '',$authority_typ = 0,$authority_cd = 0,$refer_kbn = 0)
    {
        $params = [
            'company_cd'    		=> $company_cd,
            'employee_cd'   		=> $employee_cd,
            '1on1_authority_typ'    => $authority_typ,
            '1on1_authority_cd'    	=> $authority_cd,
            'refer_kbn'    			=> $refer_kbn,
        ];
        return Dao::executeSql('SPC_oM0010_INQ1',$params);
    }

    /**
     *  save item
     *  @param  integer $company_cd
     *  @param  json    $params
     *
     *  @return array
    */
    public function saveFile($json = '',$mode = '',$upload_file_name = '')
    {
        $array= [
            'json'          =>   json_encode($json,JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE),
            'file_nm'       =>   $upload_file_name,
            'mode'          =>   $mode,
            'cre_user'      =>   session_data()->user_id,
            'cre_ip'        =>   $_SERVER['REMOTE_ADDR'],
            'company_cd'    =>   session_data()->company_cd,
        ];
        return Dao::executeSql('SPC_oM0010_ACT1',$array);
    }

    /**
     *  delete item
     *  @param  integer $company_cd
     *  @param  integer $item_cd
     *
     *  @return array
    */
    public function deleteFile($refer_kbn = 0,$file_cd = 0)
    {
        $array= [
            'company_cd'    =>   session_data()->company_cd,
            'refer_kbn'     =>   $refer_kbn,
            'file_cd'       =>   $file_cd,
            'cre_user'      =>   session_data()->user_id,
            'cre_ip'        =>   $_SERVER['REMOTE_ADDR'],
        ];
        return Dao::executeSql('SPC_oM0010_ACT2',$array);
    }

}