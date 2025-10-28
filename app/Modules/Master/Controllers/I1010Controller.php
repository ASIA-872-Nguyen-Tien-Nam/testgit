<?php 
/**
 ****************************************************************************
 * UNITE_MEDICAL
 * I1010Controller
 *
 * 処理概要/process overview   : I1010Controller
 * 作成日/create date   : 2018-06-25 03:01:47
 * 作成者/creater    : viettd
 * 
 * 更新日/update date    : 
 * 更新者/updater    : 
 * 更新内容 /update content  : 
 * 
 * 
 * @package         :  Master
 * @copyright       :  Copyright (c) ANS-ASIA
 * @version    :  1.0.0
 * **************************************************************************
 */
namespace App\Modules\Master\Controllers;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Validator;
use Carbon\Carbon;
use File;
use Dao;
class I1010Controller extends Controller
{
	/**
	 * Show the application index.
	 * @author viettd 
	 * @created at 2018-06-25 03:01:47
	 * @return \Illuminate\Http\Response
	 */
	public function getIndex(Request $request)
	{
		$data['category'] = trans('messages.process_fiscal_year');
		$data['category_icon'] = 'fa fa-refresh';
		$data['title'] = trans('messages.fiscal_year_master');
		$refer = $this->postRefer($request);
		if(isset($refer['error_typ']) && $refer['error_typ'] == '999'){
                return response()->view('errors.query',[],501);
            }
		return view('Master::i1010.index',array_merge($data,$refer));
	}
	 /**
	 * get right content;
	 * @author datnt
	 * @created at 2018-08-20
	 * @return \Illuminate\Http\Response
	 */
	public function postRefer(Request $request)
	{
		$validator = Validator::make($request->all(), [
			'fiscal_year' => 'integer', //Must be a number and length of value is 8
		]);
		// validate Laravel
		if ($validator->fails()) {
			return response()->view('errors.query', [], 501);
		}
		$now = Carbon::now();
		$params = [
			'company_cd'    	=> 	session_data()->company_cd,
			'fiscal_year' 		=>	$request->fiscal_year ?? 0,
			'user_id'			=>	session_data()->user_id,
		];
	    $res = Dao::executeSql('SPC_I1010_FND1', $params);
		$data['cur_year'] 		= $res[0][0]['cur_year'] ?? $now->year;
		$data['result'] 		= $res[1] ?? [];
		$data['library_data'] 	= getCombobox(9);
		$data['check_save'] 	= $res[2][0][0] ?? [];
		if(isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999'){
			return response()->view('errors.query',[],501);
		}
		// render view
		if ( $request->ajax() ){
			return view('Master::i1010.refer', $data);
		}
		// render data
		$request['fiscal_year'] = $data['cur_year'];
		$data['chk']	   	= $this->postCheck($request);
		return $data;		
	}
	 /**
	 * check save
	 * @author datnt
	 * @created at 2018-08-20
	 * @return \Illuminate\Http\Response
	 */
	public function postCheck(Request $request)
	{
		$validator = Validator::make($request->all(), [
			'fiscal_year' => 'integer', //Must be a number and length of value is 8
		]);
		// validate Laravel
		if ($validator->fails()) {
			return response()->view('errors.query', [], 501);
		}
		$params = [
			'company_cd'    	=> 	session_data()->company_cd,
			'fiscal_year' 		=>	$request->fiscal_year ?? 0,
			'user_id'			=>	session_data()->user_id,
		];
		$res = Dao::executeSql('SPC_I1010_CHK1', $params);
		if(isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999'){
			return response()->view('errors.query',[],501);
		}
		$data = $res[0][0]['chk'] ?? 2;
		// render view
		if ( $request->ajax() ){
			try{
				$this->respon['check_save'] = $data;
				return response()->json($this->respon); 
			} catch (\Exception $e) {
				$this->respon['status']     = EX;
				$this->respon['Exception']  = $e->getMessage();
			}
		}
		// render data
		return $data;	
	}
	/**
	 * Show the application index.
	 * @author datnt@ans-asia.com 
	 * @created at 2018-06-22 06:22:17
	 * @return void
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
                    $result = Dao::executeSql('SPC_I1010_ACT1',$params);
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
                        $this->respon['position_cd']     = $result[1][0]['position_cd'];
                    }
                }
            } catch (\Exception $e) {
                $this->respon['status']     = EX;
                $this->respon['Exception']  = $e->getMessage();
            }
            return response()->json($this->respon);
		}
		return 'Silent is golden.';
	}
}