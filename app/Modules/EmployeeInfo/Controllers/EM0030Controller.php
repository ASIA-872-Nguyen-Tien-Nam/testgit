<?php 
/**
 ****************************************************************************
 * MIRAI
 * EM0030Controller
 *
 * 処理概要/process overview   : EM0030Controller
 * 作成日/create date          : 
 * 作成者/creater              : trinhdt
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
use App\Services\EmployeeInformation\Training;
use Validator;
class EM0030Controller extends Controller
{
    protected $trainingService;

    public function __construct(Training $trainingService)
    {
       parent::__construct();
       $this->trainingService = $trainingService;
    }

    /**
     * Show the application index.
     * @author trinhdt 
     * @return \Illuminate\Http\Response
     */
    public function getIndex(Request $request)
    {
        $data['category'] = trans('messages.home');
        $data['category_icon'] = 'fa fa-home';
        $data['title'] = trans('messages.training_settings');
        // render view
        $left = $this->getLeftContent($request);
         if(isset($left ['error_typ']) && $left['error_typ'] == '999'){
                return response()->view('errors.query',[],501);
        }
        $data['M5031'] = getCombobox('M5031', 1, 6) ?? [];
        $data['M5032'] = getCombobox('M5032', 1, 6) ?? [];
        return view('EmployeeInfo::em0030.index', array_merge($data, $left));
    }

  
  
  /**
     * get left content
     * @author trinhdt
     * @created at 2024/03
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
            ];
            // $data = $params;
            $data['search_key'] = htmlspecialchars($request->search_key) ?? '';
            // $res = Dao::executeSql('SPC_M0030_LST1', $params);
            $res = $this->trainingService->findTraining($params);
            $data['list'] = $res[0] ?? [];
            $data['paging'] = $res[1][0] ?? [];
            // render view
            if ( $request->ajax() ){
                if(isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999'){
                    return response()->view('errors.query',[],501);
                }
                return view('EmployeeInfo::em0030.leftcontent', $data);
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
     * @created at 2024/03
     * @return \Illuminate\Http\Response
     */
    public function getRightContent(Request $request)
    {
        if ( $request->ajax() )
        {
            $params = [
                'training_cd' => $request->training_cd ?? 0,
                'company_cd' => session_data()->company_cd, // set for demo
            ];
            $res = $this->trainingService->getTrainings($params);
            if(isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999'){
                return response()->view('errors.query',[],501);
            }
            return $res[0][0] ?? [];
        }
    }
    /**
     * Save data
     * @author trinhdt
     * @created at 2024/03
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
                    $result = $this->trainingService->saveTraining($params);
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
                        $this->respon['training_cd']     = $result[1][0]['training_cd'];
                    }
                }
            } catch (\Exception $e) {
                $this->respon['status']     = EX;
                $this->respon['Exception']  = $e->getMessage();
            }
            return response()->json($this->respon);
        }
    }

    /**
     * Delete data
     * @author trinhdt
     * @created at 2024/03
     * @return \Illuminate\Http\Response
     */
    public function postDelete(Request $request)
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
                    $result = $this->trainingService->deleteTraining($params);
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

    /**
	 * show training and save
	 * @author trinhdt
	 * @created at 2024/03
	 * @return void
	 */
	public function training(Request $request)
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
                $result = $this->trainingService->savePopupTraining($params);
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
                    $this->respon['training_cd']     = $result[1][0]['training_cd'];
                }
            }
            return response()->json($this->respon);
        } else {
            $data['mode']	= $request->mode ?? 0;
            if ($data['mode'] == 1) {
                $data['title'] 			= trans('messages.create_training_category');
            } else {
                $data['title'] 			= trans('messages.create_course_format');
            }
            $params['mode']       		= $data['mode'];
            $params['company_cd']       = session_data()->company_cd;
            $data['list'] = $this->trainingService->getPopupTraining($params);
            return view('EmployeeInfo::em0030.popup_em0030', $data);
        }
	}

	/**
     * refer list training
     * @author trinhdt
     * @created at 2024/03
     * @return \Illuminate\Http\Response
     */
    public function referTraining(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'mode' => 'integer',
        ]);
        if ($validator->passes()) {
            $params['mode']       = $request->mode ?? 0;
            $params['company_cd'] = session_data()->company_cd;
            $data['list'] = $this->trainingService->getPopupTraining($params);
            return view('EmployeeInfo::em0030.popup_em0030_search', $data);
        }
    }

	/**
     * Delete training
     * @author trinhdt 
     * @created at 2024/03
     * @return \Illuminate\Http\Response
     */
    public function deleteTraining(Request $request)
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
                    $result = $this->trainingService->deletePopupTraining($params);
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