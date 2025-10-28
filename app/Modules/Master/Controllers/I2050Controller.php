<?php 
/**
 ****************************************************************************
 * MIRAI
 * I2050Controller
 *
 * 処理概要/process overview   : I2050Controller
 * 作成日/create date          : 2020-10-05
 * 作成者/creater              : nghianm
 * 
 * 更新日/update date          : 
 * 更新者/updater              : 
 * 更新内容 /update content    : 
 * 
 * 
 * @package         :  Master
 * @copyright       :  Copyright (c) ANS-ASIA
 * @version         :  1.0.0
 * **************************************************************************
 */
namespace App\Modules\Master\Controllers;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Validator;
use Illuminate\Validation\Rule;

use Dao;
class I2050Controller extends Controller
{
	/**
     * Show the application index.
     * @author nghianm 
     * @created at 2020-10-05
     * @return \Illuminate\Http\Response
     */
	public function getIndex(Request $request)
	{
        $data['category'] = trans('messages.personnel_assessment');
        $data['category_icon'] = 'fa fa-line-chart';
        $data['title'] = trans('messages.status_management');
        $reqs = [
            'from'  => $request->from ?? '',
        ];
        $validator = Validator::make($reqs, [
            'from'  => [
                'string',
                Rule::in(['i2010', 'i2020']),
            ],
        ]);
        if ($validator->fails()) {
            return response()->view('errors.query', [], 501);
        }
        //
        $data['M0020']          = getCombobox('M0020',1);
        $data['F0010']          = getCombobox('F0010',1);
        $data['M0060']          = getCombobox('M0060',1);
        $data['M0040']          = getCombobox('M0040',1);
        $data['M0050']          = getCombobox('M0050',1);
        $data['M0022']          = getCombobox('M0022',1);
        $data['libraryno7']     = getCombobox(7); 
        $data['library_14']     = getCombobox(14); 
        $data['views']          = [];
        //
        $user_id                = session_data()->user_id;
        $html                   = '';
        if ($reqs['from'] == 'i2010') {
            $cache              = getCache('i2050_i2010', $user_id);
            deleteCache('q2010_i2010',$user_id);
        } else if ($reqs['from'] == 'i2020') {
            $cache              = getCache('i2050_i2020', $user_id);
            deleteCache('q2010_i2020',$user_id);
        }
        // 
        if (isset($cache['html'])){
            $html               = htmlspecialchars_decode($cache['html'], ENT_QUOTES) ??  '';
        }
        // 
        $data['html']           =  $html;
        $data['authority_typ']  =  session_data()->authority_typ ?? 0;
        $data['employee_cd']    =   '';
        $data['employee_nm']    =   '';
        if (isset(session_data()->m0070->employee_cd)) {
            $data['employee_cd']    = session_data()->m0070->employee_cd;
        }
        if (isset(session_data()->m0070->employee_nm)) {
            $data['employee_nm']    = session_data()->m0070->employee_nm;
        }
        return view('Master::i2050.index',$data);
	}

	/**
     * Show the application index.
     * @author nghianm 
     * @created at 2020-10-05 07:46:26
     * @return void
     */
    public function postSearch(Request $request) 
    {
    	if($request->ajax()) 
    	{
            $param_json = $request->json()->all() ?? [];
            if(count($param_json) == 0){
                $param_json['fiscal_year']                      = date('Y');
                $param_json['employee_typ']                     = -1;
                $param_json['employee_nm']                      = '';
                $param_json['rater_employee_nm']                = '';
                $param_json['evaluation_step']                  = -1;
                $param_json['list_treatment_applications_no']   = [];
                $param_json['list_position_cd']                 = [];
                $param_json['list_grade']                       = [];
                //
                $param_json['list_organization_step1']          = [];
                $param_json['list_organization_step2']          = [];
                $param_json['list_organization_step3']          = [];
                $param_json['list_organization_step4']          = [];
                $param_json['list_organization_step5']          = [];
                //
                $param_json['page_size']                        = 20;
                $param_json['page']                             = 1;
            }
            // $param_json['employee_cd'] = SQLEscape(preventOScommand($param_json['employee_cd']));
            $json = json_encode($param_json,JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
            //
            if(!validateJsonFormat($json)){
                // return 501 error
                return response()->view('errors.query',[],501);
            }else{
                $params['json']         =   preventOScommand($json);
                $params['employee_cd']  =   session_data()->employee_cd;
                $params['cre_user']     =   session_data()->user_id;
                $params['company_cd']   =   session_data()->company_cd;
                $result = Dao::executeSql('SPC_I2050_FND1',$params);
                if(isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999'){
                    // return 501 error
                    return response()->view('errors.query',[],501);
                }else {
                    $data['views']  = $result[0] ?? [];
                    $data['paging'] = $result[1][0] ?? [];
                    //$data['router'] = $result[2][0] ?? [];
                    $data['max_sheetcd'] = $result[2][0]['max_sheet_cd_num'] ?? [];
                    $data['M0022']  = getCombobox('M0022',1);
                    //return request ajax        
                    return view('Master::i2050.search',$data);  
                }
            }    
    	}
    }
      /**
     * Show the application index.
     * @author datnt 
     * @created at 2020-10-06 07:46:26
     * @return void
     */
    public function postSave(Request $request) 
    {
        if ( $request->ajax() )
        {
            try {
                $param_json = $request->json()->all() ?? [];
                if(count($param_json) == 0){
                    $param_json['fiscal_year']                      = date('Y');
                    $param_json['evaluation_step']                  = -1;
                    $param_json['employee_nm']                      = '';
                    $param_json['rater_employee_nm']                = '';
                    $param_json['employee_typ']                     = -1;
                    $param_json['list_treatment_applications_no']   = [];
                    $param_json['list']                             = [];
                    $param_json['page_size']                        = 20;
                    $param_json['page']                             = 1;
                }
                $json = json_encode($param_json,JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
            //
                if(!validateJsonFormat($json)){
                    return response()->view('errors.query',[],501);
                }else{
                        $params['json']         =   $json;
                        $params['cre_user']     =   session_data()->user_id;
                        $params['cre_ip']       =   $_SERVER['REMOTE_ADDR'];
                        $params['company_cd']   =   session_data()->company_cd;
                        $result = Dao::executeSql('SPC_I2050_ACT1',$params);
                        // check exception
                        if(isset($result[0][0]) && $result[0][0]['error_typ'] == '999'){
                            return response()->view('errors.query',[],501);
                        }else if(isset($result[0]) && !empty($result[0])){
                            $this->respon['status'] = NG;
                            foreach ($result[0] as $temp) {
                                array_push($this->respon['errors'], $temp);
                            }
                        }
                        if(isset($result[1][0])){
                            $this->respon['authority_cd']     = $result[1][0]['authority_cd'];
                        }
                }
            } catch (\Exception $e) {
                $this->respon['status']     = EX;
                $this->respon['Exception']  = $e->getMessage();
            }
            return response()->json($this->respon);
        }
        return 'Silent is golden.';
        // return http request
    }
}