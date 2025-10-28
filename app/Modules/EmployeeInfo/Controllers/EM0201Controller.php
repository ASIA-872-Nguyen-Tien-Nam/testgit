<?php
/**
 ****************************************************************************
 * MIRAI
 * EM0201Controller
 *
 * 処理概要/process overview   : EM0201Controller
 * 作成日/create date          : 2024/04
 * 作成者/creater              : matsumoto
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
use App\Services\EmployeeInformation\Communicationfield;
use Validator;

class EM0201Controller extends Controller
{
    protected $Communicationfield_service;

    public function __construct(Communicationfield $Communicationfield_service)
    {
        parent::__construct();
        $this->Communicationfield_service = $Communicationfield_service;
    }
    /**
     * Show the application index.
     * @author matsumoto
     * @created at 2024/04
     * @return View
     */
    public function index(Request $request)
    {
        $data['category'] = trans('messages.home');
        $data['category_icon'] = 'fa fa-home';
        $data['title'] = trans('messages.function_nm7');
        // render view
        $left = $this->getLeftContent($request);
        if (isset($left['error_typ']) && $left['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        $data['button'] = [];
        return view('EmployeeInfo::em0201.index', array_merge($data, $left));
    }

    /**
     * get left content
     * @author matsumoto
     * @created at 2014-04
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
        if (!validateCommandOS($request->search_key ?? '')) {
            $this->respon['status']     = 164;
			return response()->json($this->respon);
        }
        $params = [
            'search_key' => SQLEscape($request->search_key ?? ''),
            'current_page' => $request->current_page ?? 1,
            'page_size' => 10,
            'company_cd' => session_data()->company_cd, // set for demo
        ];
        // $data = $params;
        $data['search_key'] = htmlspecialchars($request->search_key) ?? '';

        // call service
        $result = $this->Communicationfield_service->getCommunicationfield($params);
        if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        $data['list'] = $result[0] ?? [];
        $data['paging'] = $result[1][0] ?? [];
        
        // render view
        if ($request->ajax()) {
            return view('EmployeeInfo::em0201.leftcontent', $data);
        } else {
            return $data;
        }
    }

    /**
     * get right content
     * @author matsumoto
     * @created at 2014-04
     * @return \Illuminate\Http\Response
     */
    public function getRightContent(Request $request)
    {
        if ($request->ajax()) {
            $validator = Validator::make($request->all(), [
                'field_cd' => 'integer',
            ]);
            if ($validator->passes()) {
                $params = [
                    'field_cd' => $request->field_cd ?? 0,
                    'company_cd' => session_data()->company_cd, // set for demo
                ];
                $result = $this->Communicationfield_service->findCommunicationfield($params);
                if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
                    return response()->view('errors.query', [], 501);
                }
                return $result[0][0] ?? [];
            } else {
                return response()->view('errors.query', [], 501);
            }
        }
    }

     /**
     * Save data
     * @author matsumoto
     * @created at 2014-04
     * @return \Illuminate\Http\Response
     */
    public function postSave(Request $request)
    {
        if ($request->ajax()) {
            try {
                $this->valid($request);
                if ($this->respon['status'] == OK) {
                    $params['json']         =   $this->respon['data_sql'];
                    $params['cre_user']     =   session_data()->user_id;
                    $params['cre_ip']       =   $_SERVER['REMOTE_ADDR'];
                    $params['company_cd']   =   session_data()->company_cd;
                    // call service
                    $result = $this->Communicationfield_service->saveCommunicationfield($params);
                    // check exception
                    if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                        return response()->view('errors.query', [], 501);
                    } else if (isset($result[0]) && !empty($result[0])) {
                        $this->respon['status'] = NG;
                        foreach ($result[0] as $temp) {
                            array_push($this->respon['errors'], $temp);
                        }
                    }
                    if (isset($result[1][0])) {
                        $this->respon['field_cd']     = $result[1][0]['field_cd'];
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
     * @author matsumoto
     * @created at 2014-04
     * @return \Illuminate\Http\Response
     */
    public function postDelete(Request $request)
    {
        if ($request->ajax()) {
            try {
                $this->valid($request);
                if ($this->respon['status'] == OK) {
                    $params['json']         =   $this->respon['data_sql'];
                    $params['cre_user']     =   session_data()->user_id;
                    $params['cre_ip']       =   $_SERVER['REMOTE_ADDR'];
                    $params['company_cd']   =   session_data()->company_cd;
                    // call service
                    $result = $this->Communicationfield_service->deleteCommunicationfield($params);
                    // check exception
                    if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                        return response()->view('errors.query', [], 501);
                    } else if (isset($result[0]) && !empty($result[0])) {
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