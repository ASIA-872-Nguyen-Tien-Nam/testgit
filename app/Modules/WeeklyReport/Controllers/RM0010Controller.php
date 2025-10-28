<?php 

namespace App\Modules\WeeklyReport\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Carbon\Carbon;
use Dao;

class RM0010Controller extends Controller
{
    /**
     * 
     * @author namnt 
     * @created at 2023-02-08
     * @return \Illuminate\Http\Response
     */
    public function getIndex(Request $request)
    {
        $data['category'] = trans('messages.home');
        $data['mode'] = 0;
        $data['category_icon'] = 'fa fa-home';
        $data['title'] = trans('rm0010.usage_settings');
        $params['company_cd']   =   session_data()->company_cd;
        //
        $result = Dao::executeSql('SPC_RM0010_INQ1',$params);
        $data['result_original'] = $result[1];
        $data['sticky_default'] = $result[1];
        if(count($result[1])>2) {
        $result[1] = array_splice($result[1],3,2);
        $data['mode'] = 1;
        }
        $data['data'] = $result[0];
        $data['days'] = getCombobox(44);
        $data['days_end'] = getCombobox(45);
        $data['stickies_color'] = [['number_cd'=>'1','name'=>'#E57373'],['number_cd'=>'2','name'=>'#FFF176'],['number_cd'=>'3','name'=>'#42A5F5'],['number_cd'=>'4','name'=>'#BA68C8'],['number_cd'=>'5','name'=>'#81C784']];
        $data['label_stickies'] = getCombobox(46);
        for($i=1;$i<32;$i++) {
            if(session_data()->language == 'en') {
                $data['date'][] = ['number_cd'=>$i,'name'=>$i];
            } else {
                $data['date'][] = ['number_cd'=>$i,'name'=>$i.'日'];
            }
        }
        $data['stickies_approver'] = $result[1];
        $data['stickies_reporter'] = $result[2];
        $data['lang'] = session_data()->language;
        // render view
        return view('WeeklyReport::rm0010.index', array_merge($data));
    }
    /**
     * save data rm0010
     * @author namnt 
     * @created at 2023-04-04
     * @return \Illuminate\Http\Response
     */
    public function postSave(Request $request)
    {
        if ( $request->ajax() )
        {
            try {
                $this->valid($request);
                if($this->respon['status'] == OK)
                {
                    $params['json']         =   $this->respon['data_sql'];
                    $params['cre_user']     =   session_data()->user_id;
                    $params['cre_ip']       =   $_SERVER['REMOTE_ADDR'];
                    $params['company_cd']   =   session_data()->company_cd;
                    //
                    $result = Dao::executeSql('SPC_RM0010_ACT1',$params);
                    // check exception
                    if(isset($result[0][0]) && $result[0][0]['error_typ'] == '999'){
                        return response()->view('errors.query',[],501);
                    }else if(isset($result[0]) && !empty($result[0])){
                        $this->respon['status'] = NG;
                        foreach ($result[0] as $temp) {
                            array_push($this->respon['errors'], $temp);
                        }
                    }
                }
            } catch (\Exception $e) {
                $this->respon['status']     = EX;
                $this->respon['Exception']  = $e->getMessage();
            }
            return response()->json($this->respon);
        }
    }
}
  
  