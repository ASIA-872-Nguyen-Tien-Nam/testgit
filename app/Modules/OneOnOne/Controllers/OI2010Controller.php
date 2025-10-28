<?php

namespace App\Modules\OneOnOne\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Dao;
use Validator;
use App\Helpers\Service;
use App\Services\AdequacyService;
use App\Services\YearTargetService;
use App\Services\SheetService;
use Crypt;
use Illuminate\Validation\Rule;

class OI2010Controller extends Controller
{
    protected $adequacyService;
    protected $yearTargetService;
    protected $sheetService;
    public function __construct(AdequacyService $adequacyService, YearTargetService $yearTargetService, SheetService $sheetService)
    {
        parent::__construct();
        $this->adequacyService = $adequacyService;
        $this->yearTargetService = $yearTargetService;
        $this->sheetService       = $sheetService;
    }
    /**
     * Show the application index.
     * @author mail@ans-asia.com
     * @created at 2020-09-04 08:31:50
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        $company_cd = session_data()->company_cd;
        $user_id                    = session_data()->user_id;
        $screen_from                = $request->from;
        $redirect_param = $request->redirect_param ?? '';
        if ($redirect_param != '') {
            try {
                $redirect_param = json_decode(Crypt::decryptString($redirect_param));
            } catch (DecryptException $e) {
                return response()->view('errors.403');
            }
        }
        $params = [];
        //FAKE DATA
        $params['company_cd']           = $company_cd;
        $params['fiscal_year']          = $redirect_param->fiscal_year_1on1 ?? 0;
        $params['member_cd']            = $redirect_param->member_cd ?? '';
        $params['login_employee_cd']    = $user_id;
        $params['times']                = $redirect_param->times ?? 0;
        $data = $params;
        $data['screen_from']    = $screen_from;
        //validate redirect_param
        $validator = Validator::make($data, [
            'fiscal_year'                        => 'integer',
            'times'                              => 'integer',
            'screen_from'  => [
                'string',
                Rule::in(['oq2020', 'odashboardmember', 'odashboard', 'odashboardadmin']),
            ],
        ]);
        if ($validator->fails()) {
            return response()->view('errors.query', [], 501);
        }
        $data_adequacy_service = $this->adequacyService->getRemarkCombo($company_cd);
        $year_target_service   = $this->yearTargetService->getYearTargetPerson($company_cd, $params['fiscal_year'], $params['member_cd']);
        if ((isset($data_adequacy_service[0][0]['error_typ']) && $data_adequacy_service[0][0]['error_typ'] == '999') ||
            (isset($year_target_service[0][0]['error_typ']) && $year_target_service[0][0]['error_typ'] == '999')
        ) {
            return response()->view('errors.query', [], 501);
        }
        $data['combo_remark']           = $data_adequacy_service ?? [];
        $data['year_target_service']    = $year_target_service[0][0] ?? [];
        //
        $screen_check      = Dao::executeSql('SPC_oI2010_CHK1', $params);
        //2022/08/23
        $language = session_data()->language;
        array_unshift($params,$language);
        $interview_data    = Dao::executeSql('SPC_oI2010_INQ1', $params);
        if (
            isset($screen_check[0][0]['error_typ']) && $screen_check[0][0]['error_typ'] == '999'
            || isset($interview_data[0][0]['error_typ']) && $interview_data[0][0]['error_typ'] == '999'
        ) {
            return response()->view('errors.query', [], 501);
        }
        $data['over_30_day'] = 0;
        if (($interview_data[3][0]['year_end_30day'] ?? '1900/01/01') < date("Y/m/d")) {
            $data['over_30_day'] = 1;
        }
        $data['screen_mode']            = $screen_check[0][0]['screen_mode'] ?? 0;
        $data['coach_comment2_typ']     = $screen_check[0][0]['coach_comment2_typ'] ?? 0;
        $data['permission']             = $screen_check[0][0]['permission'] ?? 0;
        $data['login_employee_cd']      = session_data()->employee_cd ?? '';
        // check permission oi2010
        if ($data['permission'] == 0) {
            return view('errors.403');
        }
        //
        $interview_cd   = $interview_data[0][0]['interview_cd'] ?? 0;
        $adaption_date  = $interview_data[0][0]['adaption_date'] ?? NULL;
        $data_sheet_service     = $this->sheetService->getSheet($company_cd, $interview_cd, $adaption_date);
        if (isset($data_sheet_service[0][0]['error_typ']) && $data_sheet_service[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        $data['data_header']    =    $data_sheet_service[0][0] ?? [];
        $data['combo_coach_comment2']    = getCombobox('28', 0) ?? [];
        $data['data_refer']     = $interview_data[0][0] ?? [];
        $data['table_question'] = $interview_data[1] ?? [];
        $data['w_1on1_authority_typ'] = session_data()->w_1on1_authority_typ ?? 0;
        $data['category']       = trans('messages.implement');
        $data['category_icon']  = 'fa fa-users';
        $data['image']          = 'template/image/icon/icon_2_write.png';
        $data['title']          = trans('messages.1on1_sheet_input');
        return view('OneOnOne::oi2010.index', $data);
    }

    /**
     * postSave
     * @author mail@ans-asia.com
     * @created at 2020-09-04 08:31:50
     * @return void
     */
    public function postSave(Request $request)
    {
        if ($request->ajax()) {
            $this->respon['status'] = OK;
            $this->respon['errors'] = [];
            $data_request = $request->json()->all()['data_sql'];
            $validator = Validator::make($data_request, [
                'interview_cd'                       => 'integer',
                'fiscal_year'                        => 'integer',
                'times'                              => 'integer',
                'oneonone_schedule_date'             => 'date',
                'fullfillment_type'                  => 'integer',
                'list_question.*.interview_gyocd'    =>  'integer',
            ]);
            if ($validator->fails()) {
                return response()->view('errors.query', [], 501);
            }
            $params['company_cd']       = session_data()->company_cd;
            $params['json']             = json_encode($data_request, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
            $params['cre_user']         = session_data()->user_id;
            $params['cre_ip']           = $_SERVER['REMOTE_ADDR'];
            $res = Dao::executeSql('SPC_oI2010_ACT1', $params);
            if (isset($res[0][0]) && $res[0][0]['error_typ'] == '999') {
                return response()->view('errors.query', [], 501);
            }
            if (isset($res[0]) && !empty($res[0])) {
                $this->respon['status'] = NG;
                foreach ($res[0] as $temp) {
                    array_push($this->respon['errors'], $temp);
                }
            }
            $this->respon['data_oi3010'] = $res[1][0] ?? [];
            return response()->json($this->respon);
        }
        // return http request
    }
    /**
     * listExcel
     * @author mail@ans-asia.com
     * @created at 2020-09-04 08:31:50
     * @return void
     */
    public function listExcel(Request $request)
    {
        if ($request->ajax()) {
            $this->respon['status'] = OK;
            $this->respon['errors'] = [];
            $data_request = $request->json()->all() ?? [];
            $validator = Validator::make($data_request, [
                'fiscal_year'                        => 'integer',
                'times'                              => 'integer',
            ]);
            if ($validator->fails()) {
                return response()->view('errors.query', [], 501);
            }
            $store_name = 'SPC_oI2010_INQ1';
            $typeReport = 'FNC_OUT_EXL';
            $screen = 'OI2010';
            $file_name = 'oI2010' . time() . '.xlsx';
            $service = new Service();
            date_default_timezone_set('Asia/Tokyo');
            $time = date('YmdHis');
            $params = array(
                session_data()->company_cd,
                $data_request['fiscal_year'] ?? '',
                $data_request['member_cd'] ?? '',
                session_data()->user_id,
                $data_request['times'] ?? ''
            );
            $result = $service->execute($typeReport, $store_name, $params, $screen, $file_name);
            if (isset($result['filename'])) {
                $result['path_file'] =  '/download/' . $result['filename'];
            }
            $name = '1on1シート入力_';
            if (session_data()->language == 'en') {
                $name = '1on1SheetInput_';
            }
            $result['fileNameSave'] =   $name . time() . '.xlsx';
            $this->respon = $result;
            return response()->json($this->respon);
        }
        // return http request
    }

    /**
     * saveTemporary
     * @author vietdt@ans-asia.com
     * @created at 2021-11-03
     * @return void
     */
    public function saveTemporary(Request $request)
    {
        if ($request->ajax()) {
            $this->respon['status'] = OK;
            $this->respon['errors'] = [];
            $data_request = $request->json()->all()['data_sql'];
            $validator = Validator::make($data_request, [
                'interview_cd'                       => 'integer',
                'fiscal_year'                        => 'integer',
                'times'                              => 'integer',
                'oneonone_schedule_date'             => 'date',
                'fullfillment_type'                  => 'integer',
                'list_question.*.interview_gyocd'    =>  'integer',
            ]);
            if ($validator->fails()) {
                return response()->view('errors.query', [], 501);
            }
            $params['company_cd']       = session_data()->company_cd;
            $params['json']             = json_encode($data_request, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
            $params['cre_user']         = session_data()->user_id;
            $params['cre_ip']           = $_SERVER['REMOTE_ADDR'];
            $res = Dao::executeSql('SPC_oI2010_ACT2', $params);
            if (isset($res[0][0]) && $res[0][0]['error_typ'] == '999') {
                return response()->view('errors.query', [], 501);
            }
            if (isset($res[0]) && !empty($res[0])) {
                $this->respon['status'] = NG;
                foreach ($res[0] as $temp) {
                    array_push($this->respon['errors'], $temp);
                }
            }
            return response()->json($this->respon);
        }
        // return http request
    }
}
