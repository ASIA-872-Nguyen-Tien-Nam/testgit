<?php

namespace App\Modules\OneOnOne\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Services\SettingGroupService;
use App\Services\OneOnOneService;
use App\Helpers\Service;
use Dao;
use Validator;

class OQ3020Controller extends Controller
{
    protected $SettingGroupService;
    public function __construct(SettingGroupService $SettingGroupService, OneOnOneService $OneOnOneService)
    {
        parent::__construct();
        $this->SettingGroupService = $SettingGroupService;
        $this->one_on_one_service = $OneOnOneService;
    }
    /**
     * Show the application index.
     * @author mail@ans-asia.com
     * @created at 2020-09-04 08:33:02
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        $data['title'] = trans('messages.questionnaire_list');
        $data['category'] = trans('messages.questionnaire');
        $data['category_icon'] = 'fa fa-clipboard';
        //\
        $company_cd = session_data()->company_cd;
        $params = [
            'search_key' => '',
            'current_page' => $request->current_page ?? 0,
            'page_size' => 10,
            'company_cd' => session_data()->company_cd, // set for demo
        ];
        $validator = Validator::make($params, [
            'current_page'   => 'integer',
        ]);
        if ($validator->passes()) {
            $data['M0020']          = getCombobox('M0020', 1, 2);
            $data['F0010']          = getCombobox('F0010', 1, 2);
            $data['M0060']          = getCombobox('M0060', 1, 2);
            $data['M0040']          = getCombobox('M0040', 1, 2);
            $data['M0050']          = getCombobox('M0050', 1, 2);
            $data['M0022']          = getCombobox('M0022', 1, 2);
            $data_year     =  $this->one_on_one_service->getCurrentFiscalYear($company_cd);
            $setting_group = $this->SettingGroupService->findGroups(
                $company_cd,
                $params['search_key'],
                $params['current_page'],
                10
            );
            if (isset($setting_group[0][0]['error_typ']) && $setting_group[0][0]['error_typ'] == '999') {
                // return 501 error
                return response()->view('errors.query', [], 501);
            }
            $result = Dao::executeSql('SPC_OQ3020_INQ1', ['company_cd' => $company_cd]);
            if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
                // return 501 error
                return response()->view('errors.query', [], 501);
            }
            $data['year_time']      = $data_year['fiscal_year'] ?? date("Y");
            $data['list']       = $setting_group[0] ?? [];
            $data['list_m0040'] = $setting_group[2] ?? [];
            $data['list_m0030'] = $setting_group[3] ?? [];
            $data['list_m0050'] = $setting_group[4] ?? [];
            $data['list_m0060'] = $setting_group[5] ?? [];
            $data['list_times'] = $result[0] ?? [];
            return view('OneOnOne::oq3020.index', $data);
        } else {
            return response()->view('errors.query', [], 501);
        }
    }
    /**
     * Search
     * @author nghianm
     * @created at 2020-12-02 07:46:26
     * @return void
     */
    public function postSearch(Request $request)
    {
        $payload = $request->json()->all() ?? [];
        // validate
        $validator = Validator::make($payload, [
            'fiscal_year'        =>  'integer',
            'employee_role'      =>  'integer',
            'group_cd'           =>  'integer',
            'position_cd'        =>  'integer',
            'grade'              =>  'integer',
            'job_cd'             =>  'integer',
            'employee_typ'       =>  'integer',
            'page_size'          =>  'integer',
            'page'               =>  'integer',
        ]);
        //
        if ($validator->fails()) {
            return response()->view('errors.query', [], 501);
        } else {
            if (count($payload) == 0) {
                $payload['fiscal_year']                      = date('Y');
                $payload['employee_role']                    = -1;
                $payload['group_cd']                          = -1;
                $payload['rater_employee_nm']                = '';
                $payload['employee_cd']                      = '';
                $payload['coach_cd']                         = '';
                $payload['list_times']                        = [];
                $payload['position_cd']                      = -1;
                $payload['grade']                            = -1;
                $payload['job_cd']                           = -1;
                $payload['employee_typ']                     = -1;
                $payload['list_organization_step1']          = [];
                $payload['list_organization_step2']          = [];
                $payload['list_organization_step3']          = [];
                $payload['list_organization_step4']          = [];
                $payload['list_organization_step5']          = [];
                $payload['page_size']                        = 20;
                $payload['page']                             = 1;
            }
            $json = json_encode($payload, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
            if (!validateJsonFormat($json)) {
                // return 501 error
                return response()->view('errors.query', [], 501);
            }
            $params['language']     =   session_data()->language;
            $params['json']         =   preventOScommand($json);
            $params['employee_cd']  =   session_data()->employee_cd;
            $params['cre_user']     =   session_data()->user_id;
            $params['company_cd']   =   session_data()->company_cd;
            $params['mode']         =   0;   //mode search
            $result = Dao::executeSql('SPC_OQ3020_FND1', $params);
            if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
                // return 501 error
                return response()->view('errors.query', [], 501);
            } else {
                $data['views']  = $result[0] ?? [];
                $data['paging'] = $result[1][0] ?? [];
                $data['M0022']  = getCombobox('M0022', 1, 2);
                //return request ajax
                return view('OneOnOne::oq3020.search', $data);
            }
        }
    }
    /**
     * List Excel
     * @author nghianm
     * @created at 2020-12-02 07:46:26
     * @return void
     */
    public function postListExcel(Request $request)
    {
        $param_json = $request->json()->all() ?? [];
        $validator = Validator::make($param_json, [
            'fiscal_year'        =>  'integer',
            'employee_role'      =>  'integer',
            'group_cd'           =>  'integer',
            'position_cd'        =>  'integer',
            'grade'              =>  'integer',
            'job_cd'             =>  'integer',
            'employee_typ'       =>  'integer',
            'page_size'          =>  'integer',
            'page'               =>  'integer',
        ]);
        if ($validator->fails()) {
            return response()->view('errors.query', [], 501);
        }
        if (count($param_json) == 0) {
            $payload['fiscal_year']                      = date('Y');
            $payload['employee_role']                    = -1;
            $payload['group_cd']                         = -1;
            $payload['rater_employee_nm']                = '';
            $payload['employee_cd']                      = '';
            $payload['coach_cd']                         = '';
            $payload['list_times']                       = [];
            $payload['position_cd']                      = -1;
            $payload['grade']                            = -1;
            $payload['job_cd']                           = -1;
            $payload['employee_typ']                     = -1;
            $payload['list_organization_step1']          = [];
            $payload['list_organization_step2']          = [];
            $payload['list_organization_step3']          = [];
            $payload['list_organization_step4']          = [];
            $payload['list_organization_step5']          = [];
            $payload['page_size']                        = 20;
            $payload['page']                             = 1;
        }
        // $param_json['employee_cd'] = SQLEscape(preventOScommand($param_json['employee_cd']));
        $json = json_encode($param_json, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
        //
        if (!validateJsonFormat($json)) {
            return response()->view('errors.query', [], 501);
        }
        $params = array(
            preventOScommand($json),   session_data()->employee_cd,   session_data()->user_id,   session_data()->company_cd,   1           // mode excel
        );
        $store_name = 'SPC_OQ3020_FND1';
        $typeReport = 'FNC_OUT_EXL';
        $screen = 'OQ3020_LIST';
        $file_name = 'OQ3020_LIST' . time() . '.xlsx';
        $service = new Service();
        date_default_timezone_set('Asia/Tokyo');
        $time = date('YmdHis');
        $result = $service->execute($typeReport, $store_name, $params, $screen, $file_name);
        if (isset($result['filename'])) {
            $result['path_file'] =  '/download/' . $result['filename'];
        }
        $name = 'アンケート一覧_';
        if (session_data()->language == 'en') {
            $name = 'SurveyList_';
        }
        $result['fileNameSave'] =   $name . time() . '.xlsx';
        $this->respon = $result;

        // return http request
        return response()->json($this->respon);
    }
}
