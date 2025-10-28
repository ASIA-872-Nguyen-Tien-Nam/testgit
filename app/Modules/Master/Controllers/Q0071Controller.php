<?php
/**
 ****************************************************************************
 * MIRAI
 * Q0071Controller
 *
 * 処理概要/process overview   : Q0071Controller
 * 作成日/create date          : 2018-06-15 15:30:26
 * 作成者/creater              : TOINV
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

use Crypt;
use Illuminate\Contracts\Encryption\DecryptException;

class Q0071Controller extends Controller
{
	/**
     * Show the application index.
     * @author TOINV
     * @created at 2018-06-15 15:30:26
     * @return \Illuminate\Http\Response
     */
	public function getIndex(Request $request)
	{
		$data['category'] = trans('messages.employee_info_management');
		$data['category_icon'] = 'fa fa-database';
		$data['title'] = trans('messages.employee_history_inquiry');
		if($request->feedback ?? 0 == 1){
			$data['title'] = trans('messages.feedback');
		}
        // get data from url query
		$redirect_param = $request->redirect_param ?? '';
		if($redirect_param != ''){
			try{
				$redirect_param = json_decode(Crypt::decryptString($redirect_param));
			}catch(DecryptException $e){
				return response()->view('errors.403');
			}
		}
		//
		$reqs = [
			'employee_cd'   => $redirect_param->employee_cd ?? '',
			'from'  => $redirect_param->from ?? '',
			'from_source'  => $redirect_param->from_source ?? '',
        ];
        $validator = Validator::make($reqs, [
            'from'  => [
                'string',
                Rule::in(['i2010', 'i2020', 'i2040','i2050','q2010','q0070','m0070']),
            ],
        ]);
        if ($validator->fails()) {
            return response()->view('errors.query', [], 501);
		}

		if(isset($reqs['employee_cd']) && $reqs['employee_cd'] != ''){
			$request->employee_cd = htmlspecialchars($reqs['employee_cd']);
		}else{
			$request->employee_cd = session_data()->m0070->employee_cd ?? '';
		}
		$data['from']	=	htmlspecialchars($reqs['from']);
		$data['from_source']	=	htmlspecialchars($reqs['from_source']);
		$data['organization_group'] = getCombobox('M0022',1);
		$data['combo_organization'] = getCombobox('M0020',1);
		$info = $this->getInfo($request);
		if(isset($info['error_typ']) && $info['error_typ'] == '999'){
			return response()->view('errors.query',[],501);
		}
		$data['data'] = array_merge($info ,$data);
	
		return view('Master::q0071.index',$data);
	}

	public function getInfo(Request $request)
	{
		$params= [];
		$params = [
			'company_cd' => session_data()->company_cd,
			'employee_cd' => $request->employee_cd,
			'user_id'     =>   session_data()->user_id
		];
		$res = Dao::executeSql('SPC_Q0071_INQ1', $params);
		if(isset($data[0][0]['error_typ']) && $data[0][0]['error_typ'] == '999'){
			return ['error_typ'=>'999'];
		}
		return $res;
	}

}