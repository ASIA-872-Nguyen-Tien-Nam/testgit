<?php

/**
 ****************************************************************************
 * MIRAI
 * EM0020Controller
 *
 * 処理概要/process overview   : EM0020Controller
 *
 * 更新日/update date          :
 * 更新者/updater              :
 * 更新内容 /update content    :
 *
 *
 * @package         :  EmployeeInfo
 * @copyright       :  Copyright (c) ANS-ASIA
 * @version         :  1.0.0
 * **************************************************************************
 */

 namespace App\Modules\EmployeeInfo\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Carbon\Carbon;
use File;
use Dao;
use Validator;
use App\Services\EmployeeInformation\BusinessHistory;
use Illuminate\Http\UploadedFile;

class EM0020Controller extends Controller
{
    protected $businessHistoryService;

    public function __construct(BusinessHistory $businessHistoryService)
    {
       parent::__construct();
       $this->businessHistoryService = $businessHistoryService;
    }
    /**
     * Show the application index.
     * @author trinhdt
     * @created at 2024/04
     * @return \Illuminate\Http\Response
     */
    public function getIndex(Request $request)
    {
        $data['category'] = trans('messages.home');
        $data['category_icon'] = 'fa fa-home';
        $data['title'] = trans('messages.function_nm2');
        $left = $this->getLeftContent($request);
        if (isset($left['error_typ']) && $left['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        return view('EmployeeInfo::em0020.index', array_merge($data,$left));
    }
    /**
     * get left content
     * @author trinhdt
     * @created at 2024/04
     * @return \Illuminate\Http\Response
     */
    public function getLeftContent(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'current_page' => 'integer',
			'search_key' => 'max:50'
        ]);
		// validate Laravel
		if ($validator->fails()) {
			return response()->view('errors.query', [], 501);
		}
		//  validateCommandOS
		if (!validateCommandOS($request->search_key??'')) {
			$this->respon['status']     = 164;
			return response()->json($this->respon);
		}
		if ($validator->passes()) {
            //
            $params = [
                'search_key' => SQLEscape($request->search_key) ?? '',
                'current_page' => $request->current_page??1,
                'page_size' => 10,
                'company_cd' => session_data()->company_cd, // set for demo
                'language'	=> session_data()->language ?? ''
            ];
            // $data = $params;
            $data['search_key'] = htmlspecialchars($request->search_key) ?? '';
            // $res = Dao::executeSql('SPC_M0030_LST1', $params);
            $res = $this->businessHistoryService->findBusinessHistory($params);
            $data['list'] = $res[0] ?? [];
            $data['paging'] = $res[1][0] ?? [];
            // render view
            if ( $request->ajax() ){
                if(isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999'){
                    return response()->view('errors.query',[],501);
                }
                return view('EmployeeInfo::em0020.leftcontent', $data);
            }
            else{
                if(isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999'){
                    return array('error_typ'=>'999');
                } 
                return $data;
            }
        }else{
            if ( $request->ajax() ){
				return response()->view('errors.query',[],501);
			}else{
				return array('error_typ'=>'999');
			}
        }                                         
    }

    /**
     * get right content
     * @author trinhdt
     * @created at 2024/04
     * @return \Illuminate\Http\Response
     */
    public function getRightContent(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'work_history_kbn' => 'integer',
        ]);
        if ($validator->passes()) {
            $params = [
                'work_history_kbn'   => $request->work_history_kbn ?? 0,
                'company_cd'         => session_data()->company_cd, // set for demo
            ];
            $res = $this->businessHistoryService->getBusinessHistorys($params);
            if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
                if ($request->ajax()) {
                    return response()->view('errors.query', [], 501);
                } else {
                    return array('error_typ' => '999');
                }
            }
            // render view
            return view('EmployeeInfo::em0020.rightcontent')
                ->with('work_history_kbn', $res[0][0]['work_history_kbn'] ?? '')
                ->with('list_item', $res[0] ?? []);
        } else {
            if ($request->ajax()) {
                return response()->view('errors.query', [], 501);
            } else {
                return array('error_typ' => '999');
            }
        }
    }
    /**
     * save data
     * @author trinhdt
     * @created at 2024/04
     * @return void
     */
    public function postSave(Request $request)
    {
        try {
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
                        $result = $this->businessHistoryService->saveBusinessHistory($params);
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
        } catch (\Exception $e) {
            $this->respon['status']     = EX;
            $this->respon['Exception']  = $e->getMessage();
        }
        return response()->json($this->respon);
    }
    /**
     * Delete data
     * @author trinhdt
     * @created at 2024/04
     * @return \Illuminate\Http\Response
     */
    public function postDelete(Request $request)
    {
        if ($request->ajax()) {
            try {
                $validator = Validator::make($request->all(), [
                    'work_history_kbn' => 'integer',
                ]);
                if ($validator->passes()) {
                    $params['work_history_kbn']     =   $request->work_history_kbn;
                    $params['cre_user']             =   session_data()->user_id;
                    $params['cre_ip']               =   $_SERVER['REMOTE_ADDR'];
                    $params['company_cd']           =   session_data()->company_cd;
                    //
                    $result = $this->businessHistoryService->deleteBusinessHistory($params);
                    // check exception
                    if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                        return response()->view('errors.query', [], 501);
                    } else if (isset($result[0]) && !empty($result[0])) {
                        $this->respon['status'] = NG;
                        foreach ($result[0] as $temp) {
                            array_push($this->respon['errors'], $temp);
                        }
                    }
                } else {
                    return response()->view('errors.query', [], 501);
                }
            } catch (\Exception $e) {
                $this->respon['status']     = EX;
                $this->respon['Exception']  = $e->getMessage();
            }
            return response()->json($this->respon);
        }
    }
    /**
	 * show selection and save
	 * @author trinhdt
	 * @created at 2024/03
	 * @return void
	 */
	public function selection(Request $request)
	{
        // when method is POST
        if ($request->isMethod('post')) {
            $this->valid($request);
            if($this->respon['status'] == OK)
            {
                $params['json']         =   $this->respon['data_sql'];
                $params['cre_user']     =   session_data()->user_id;
                $params['cre_ip']       =   $_SERVER['REMOTE_ADDR'];
                $params['company_cd']   =   session_data()->company_cd;
                //
                $result = $this->businessHistoryService->savePopupSelection($params);
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
            return response()->json($this->respon);
        } else {
            $validator = Validator::make($request->all(), [
                'id' => 'integer',
                'work_history_kbn' => 'integer',
            ]);
            if ($validator->passes()) {
                $params['id']       		= $request->id ?? 0;
                $params['work_history_kbn'] = $request->work_history_kbn ?? 0;
                $params['company_cd']       = session_data()->company_cd;
                $data_list = $this->businessHistoryService->getPopupSelection($params);
                $data['list'] = $data_list[0] ?? [];
                $data['title'] = $data_list[1][0]['item_title'] ?? '';
                return view('EmployeeInfo::em0020.popup_em0020', array_merge($data, $params));
            } else {
                if ($request->ajax()) {
                    return response()->view('errors.query', [], 501);
                } else {
                    return array('error_typ' => '999');
                }
            }
        }
	}

	/**
     * Delete selection
     * @author trinhdt 
     * @created at 2024/03
     * @return \Illuminate\Http\Response
     */
    public function deleteSelection(Request $request)
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
                    $result = $this->businessHistoryService->deletePopupSelection($params);
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
