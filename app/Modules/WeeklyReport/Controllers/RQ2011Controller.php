<?php

namespace App\Modules\WeeklyReport\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Services\MiraiService;
use Dao;
use Validator;

class RQ2011Controller extends Controller
{
    protected $weeklyReportService;
	protected $mirai_service;
	public function __construct(MiraiService $mirai_service)
	{
		parent::__construct();
		$this->mirai_service   = $mirai_service;
	}
    /**
     * Show index
     *
     * @param  Request $request
     * @return void
     */
    public function index(Request $request)
    {
        $data['category'] = trans('messages.home');
        $data['category_icon'] = 'fa fa-home';
        $data['title'] = trans('rq2011.title');
        $data['fiscal_year_today'] = $this->mirai_service->findFiscalYearFromDate(session_data()->company_cd ?? 0, 5) ?? 0;
        // render view
        $left = $this->getLeftContent($request);
        $right = $this->getRightContent($request);
        return view('WeeklyReport::rq2011.index',  array_merge($data, $left, $right));
    }

    /**
     * getLeftContent
     *
     * @param  mixed $request
     * @return void
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
        $params = [
            'search_key'    => SQLEscape($request->search_key) ?? '',
            'current_page'  => $request->current_page ?? 1,
            'page_size'     => 10,
            'company_cd'    => session_data()->company_cd,
            'employee_cd'   => session_data()->employee_cd,
        ];
        $data = [
            'search_key'    => htmlspecialchars($request->search_key) ?? '',
        ];
        $res = Dao::executeSql('SPC_rQ2011_LST1', $params);
        if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        //
        $data['list']       = $res[0] ?? [];
        $data['paging']     = $res[1][0] ?? [];
        // render view
        if ($request->ajax()) {
            return view('WeeklyReport::rq2011.leftcontent', $data);
        } else {
            return $data;
        }
    }
    /**
     * getLeftContent
     *
     * @param  mixed $request
     * @return void
     */
    public function getRightContent(Request $request)
    {
        if ($request->ajax()) {
            $data_request = $request->json()->all()['data_sql'];
            $validator = Validator::make($data_request, [
                'page_size'        => 'integer',
                'page'             => 'integer',
                'employee_typ'     => 'integer',
                'position_cd'      => 'integer',
                'grade'            => 'integer',
            ]);
            if ($validator->fails()) {
                return response()->view('errors.query', [], 501);
            }
            // success
            $params['json']               =  json_encode($data_request, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
            $params['user_id']            =  session_data()->user_id;
            $params['company_cd']         =  session_data()->company_cd;
            $params['employee_cd']        =  session_data()->employee_cd;
            $result = Dao::executeSql('SPC_rQ2011_FND1', $params);
            if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
                return response()->view('errors.query', [], 501);
            }
            
            $data['employees']                 =  $result[0] ?? [];
            $data['paging_right']              =  $result[1][0] ?? [];
            $data['mygroup'] = [
                'mygroup_cd'  => $data_request['mygroup_cd'] ?? -1,
                'mygroup_nm'  => $data_request['mygroup_nm'] ?? '',
            ];
            $data['combo_employee_type']   = getCombobox('M0060', 1, 5) ?? [];
            $data['combo_position']        = getCombobox('M0040', 1, 5) ?? [];
            $data['combo_grade']           = getCombobox('M0050', 1, 5) ?? [];
            $data['organization_group']    = getCombobox('M0022', 1, 5) ?? [];
            $data['combo_organization']    = getCombobox('M0020', 1, 5) ?? [];
            $data['mode']                  = 1;
            return view('WeeklyReport::rq2011.rightcontent', $data);
        } else {
            $data['combo_employee_type']   = getCombobox('M0060', 1, 5) ?? [];
            $data['combo_position']        = getCombobox('M0040', 1, 5) ?? [];
            $data['combo_grade']           = getCombobox('M0050', 1, 5) ?? [];
            $data['organization_group']    = getCombobox('M0022', 1, 5) ?? [];
            $data['combo_organization']    = getCombobox('M0020', 1, 5) ?? [];
            return $data;
        }
    }

    /**
     * Search
     * @author mail@ans-asia.com
     * @created at 2020-09-04 08:29:12 
     * @return void
     */
    public function postSearch(Request $request)
    {
        $data_request = $request->json()->all()['data_sql'];
        $validator = Validator::make($data_request, [
            'page_size'        => 'integer',
            'page'             => 'integer',
            'employee_typ'     => 'integer',
            'position_cd'      => 'integer',
            'grade'            => 'integer',
        ]);
        if ($validator->fails()) {
            return response()->view('errors.query', [], 501);
        }
        // success
        $params['json']               =  json_encode($data_request, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
        $params['user_id']            =  session_data()->user_id;
        $params['company_cd']         =  session_data()->company_cd;
        $params['employee_cd']        =  session_data()->employee_cd;
        $result = Dao::executeSql('SPC_rQ2011_FND1', $params);
        if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        $data['employees']                 =  $result[0] ?? [];
        $data['paging_right']              =  $result[1][0] ?? [];
        $data['organization_group']        =  getCombobox('M0022', 1, 5) ?? [];
        // render view
        if ($request->ajax()) {
            return view('WeeklyReport::rq2011.search', $data);
        } else {
            return $data;
        }
    }
    /**
     * refer sheet group
     * @author tuantv
     * @created at 2018-09-26
     * @return \Illuminate\Http\Response
     */
    public function referEmployee(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'employee_cd'                => 'max:10',
            ]);
            if ($validator->fails()) {
                return response()->view('errors.query', [], 501);
            }
            $params['company_cd']   =  session_data()->company_cd;
            $params['employee_cd']  =  $request->employee_cd;
            $res = Dao::executeSql('SPC_rQ2011_INQ1', $params);
            if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
                return response()->view('errors.query', [], 501);
            }
            //
            $this->respon['status']           = 200;
            $this->respon['data']             = $res[0][0] ?? [];
        } catch (\Exception $e) {
            $this->respon['status']     = EX;
            $this->respon['Exception']  = $e->getMessage();
        }
        return response()->json($this->respon);
    }
    /**
     * save
     * @author quangnd
     * @created at 22023/04/25
     * @return \Illuminate\Http\Response
     */
    public function postSave(Request $request)
    {
        if ($request->ajax()) {
            try {
                $data_request = $request->json()->all();
                $validator = Validator::make($data_request, [
                    'mygroup_cd'                    => 'integer',
                    'cre_employee.*.employee_cd'    => 'max:10',
                    'del_employee.*.employee_cd'    => 'max:10',
                ]);
                if ($validator->fails()) {
                    return response()->view('errors.query', [], 501);
                }
                $params['json']          =   json_encode($data_request, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
                $params['cre_user']      =   session_data()->user_id;
                $params['cre_ip']        =   $_SERVER['REMOTE_ADDR'];
                $params['company_cd']    =   session_data()->company_cd;
                $params['employee_cd']   =  session_data()->employee_cd;
                $result =  Dao::executeSql('SPC_rQ2011_ACT1', $params);
                // check exception
                if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                    return response()->view('errors.query', [], 501);
                } else if (isset($result[0]) && !empty($result[0])) {
                    $this->respon['status'] = NG;
                    foreach ($result[0] as $temp) {
                        array_push($this->respon['errors'], $temp);
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
     * postDelete
     * @author quang
     * @created at 2023/04/25
     * @return \Illuminate\Http\Response
     */
    public function postDelete(Request $request)
    {
        if ($request->ajax()) {
            try {
                $validator = Validator::make($request->all(), [
                    'mygroup_cd'        => 'integer',
                ]);
                if ($validator->fails()) {
                    return response()->view('errors.query', [], 501);
                }
                $params['mygroup_cd']    =  $request->mygroup_cd ?? 0;
                $params['cre_user']      =   session_data()->user_id;
                $params['cre_ip']        =   $_SERVER['REMOTE_ADDR'];
                $params['company_cd']    =   session_data()->company_cd;
                $params['employee_cd']   =  session_data()->employee_cd;
                $result = Dao::executeSql('SPC_rQ2011_ACT2', $params);
                // check exception
                if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                    return response()->view('errors.query', [], 501);
                } else if (isset($result[0]) && !empty($result[0])) {
                    $this->respon['status'] = NG;
                    foreach ($result[0] as $temp) {
                        array_push($this->respon['errors'], $temp);
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
