<?php
namespace App\Services;
use App\Http\Controllers\Controller;
use Dao;

class AdequacyService extends Controller
{
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
    public function getAdequacy($company_cd = 0,$mark_typ = 1,$mode=1)
    {
        $params = [
            'company_cd'    => $company_cd
        ,    'mark_typ'      => $mark_typ
        ,   'mode'=>$mode
        ];
        return Dao::executeSql('SPC_OM0120_INQ1',$params);
    }
    /**
     *  getAdequacy
     *
     *  @param  integer $company_cd
     *
     *  @return array
    */
    public function getRemarkCombo($company_cd = 0)
    {
        $params = [
            'company_cd'    => $company_cd
        ,   'mark_typ'      => 1
        ,   'mode'=>2
        ];
        $sql = Dao::executeSql('SPC_OM0120_INQ1',$params);
        $temp = [];
        $item = 0;
        $result = [];
        $temp[0] = [];
        foreach($sql[1] as  $data){
            if($data['mark_cd'] == $item){
                $temp[$item] = $data??[];
            }else{
                $item = $data['mark_cd'] ;
                $temp[$item] = [];
                $temp[$item]= $data??[];
            }
        }
        $result =  $temp;
        unset($result[0]);
        return $result;
    }
    /**
     *  save Adequacy
     *
     *  @param  Request    $request
     *
     *  @return array
    */
    public function saveAdequacy($request)
    {
        try {
            $this->respon['status'] = OK;
            $this->respon['errors'] = [];
            $param = $request->json()->all()['data_sql'];
            $rules=[
             'remark_typ' =>'int',
             'tr.item_no' => 'int',
             'tr.point' => 'numeric',
             'tr.remark' => 'int',
            ];
           $validator =\Validator::make($param,$rules,$this->messages);
           if($validator->fails())
            {
                $this->respon['status']     = 999;
            }else{
                $params['json']         =   json_encode($param,JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
                $params['cre_user']     =   session_data()->user_id;
                $params['cre_ip']       =   $_SERVER['REMOTE_ADDR'];
                $params['company_cd']   =   session_data()->company_cd;
                $res = Dao::executeSql('SPC_OM0120_ACT1',$params);
                // check exception
                if(isset($res[0][0]) && $res[0][0]['error_typ'] == '999'){
                    $this->respon['status']     = 999;
                }else if(isset($res[0]) && !empty($res[0])){
                    $this->respon['status'] = NG;
                    foreach ($res[0] as $temp) {
                        array_push($this->respon['errors'], $temp);
                    }
                }


            }

       } catch (\Exception $e) {
           $this->respon['status']     = EX;
           $this->respon['Exception']  = $e->getMessage();
       }
       return $this->respon;
    }

    /**
     *  delete Adequacy
     *
     *
     *  @return array
    */
    public function deleteAdequacy($mark_typ = 1)
    {
        try {
            $this->respon['status'] = OK;
            $this->respon['errors'] = [];
            $params['company_cd']   =   session_data()->company_cd; //session_data()->company_cd;
            $params['mark_typ']     =  $mark_typ; //session_data()->company_cd;
            $params['cre_user']     =   session_data()->user_id;;//session_data()->user_id;
            $params['cre_ip']       =   $_SERVER['REMOTE_ADDR'];
            //
            $result = Dao::executeSql('SPC_OM0120_ACT2',$params);
            // check exception
            if(isset($result[0][0]) && $result[0][0]['error_typ'] == '999'){
                $this->respon['status'] = 999;
            }else if(isset($result[0]) && !empty($result[0])){
                 $this->respon['status'] = NG;
                 foreach ($result[0] as $temp) {
                      array_push($this->respon['errors'], $temp);
                 }
            }
       } catch (\Exception $e) {
            $this->respon['status']     = EX;
            $this->respon['Exception']  = $e->getMessage();
       }
       return $this->respon;
    }
}