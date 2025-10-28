<?php
namespace App\Modules\EmployeeInfo\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Services\EmployeeInformation\Qualification;
use Validator;
class EM0010Controller extends Controller
{
    protected $qualification_service;

    public function __construct(Qualification $qualification_service)
    {
        parent::__construct();
        $this->qualification_service = $qualification_service;
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
        $data['title'] = trans('messages.function_nm1');
        $data['L0010_57'] = getCombobox(57);
        // render view
        $left = $this->getLeftContent($request);
        return view('EmployeeInfo::em0010.index', array_merge($data, $left));
    }

    /**
     * get left content
     * @author namnb
     * @created at 2018-08-20
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
        $result = $this->qualification_service->getQualifications($params);
        if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        $data['list'] = $result[0] ?? [];
        $data['paging'] = $result[1][0] ?? [];
        // render view
        if ($request->ajax()) {
            return view('EmployeeInfo::em0010.leftcontent', $data);
        } else {
            return $data;
        }
    }

    /**
     * get right content
     * @author namnb
     * @created at 2018-08-20
     * @return \Illuminate\Http\Response
     */
    public function getRightContent(Request $request)
    {
        if ($request->ajax()) {
            $validator = Validator::make($request->all(), [
                'qualification_cd' => 'integer',
            ]);
            if ($validator->passes()) {
                $params = [
                    'qualification_cd' => $request->qualification_cd ?? 0,
                    'company_cd' => session_data()->company_cd, // set for demo
                ];
                $result = $this->qualification_service->findQualification($params);
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
     * @author namnb 
     * @created at 2018-08-16
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
                    $result = $this->qualification_service->saveQualification($params);
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
                        $this->respon['qualification_cd']     = $result[1][0]['qualification_cd'];
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
     * @author namnb 
     * @created at 2018-08-16
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
                    $result = $this->qualification_service->deleteQualification($params);
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
