<?php

/**
 ****************************************************************************
 * MIRAI
 * Q0070Controller
 *
 * 処理概要/process overview   : Q0070Controller
 * 作成日/create date          : 2018-06-15 14:15:26
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
use Dao;
use App\Services\ItemService;
use App\L0020;
use Illuminate\Validation\Rule;

class Q0070Controller extends Controller
{
    protected $itemService;

    public function __construct(ItemService $itemService)
    {
        parent::__construct();
        $this->itemService = $itemService;
    }
    /**
     * Show the application index.
     * @author Tuantv
     * @created at 2018-08-08
     * @return \Illuminate\Http\Response
     */
    public function getIndex(Request $request)
    {
        $data['category'] = trans('messages.employee_info_management');
        $data['category_icon'] = 'fa fa-database';
        $data['title'] = trans('messages.employee_info_management');
        //
        //dd($request->segment(2));
        $screen = $request->segment(2);
        $reqs = [
            'from'  => $request->from ?? '',
        ];
        $validator = Validator::make($reqs, [
            'from'  => [
                'string',
                Rule::in(['m0070', 'q0071']),
            ],
        ]);
        if ($validator->fails()) {
            return response()->view('errors.query', [], 501);
        }
        // check setting authority
        //

        // $data['screen_from']        =   htmlspecialchars($reqs['from']);
        // $from                       =Input::get('from', '');
        // $data['screen_from'] = $from;
        // $request->session()->forget('screen_from');
        // $from = SQLEscape(preventOScommand($from));
        if ($screen == 'sq0070') {
            $query = Dao::executeSql('SPC_Q0070_INQ1', [
                'company_cd' => session_data()->company_cd ?? 0,
                'user_id'    => session_data()->user_id ?? '',
                'system'        => 4,
            ]);
        }
        if ($screen == 'q0070') {
            $query = Dao::executeSql('SPC_Q0070_INQ1', [
                'company_cd' => session_data()->company_cd ?? 0,
                'user_id'    => session_data()->user_id ?? '',
                'system'        => 1,
            ]);
        }
        if (isset($query[0][0]['error_typ']) && $query[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        //
        $data['m0060'] = $query[0] ?? [];
        $data['m0050'] = $query[1] ?? [];
        $data['m0040'] = $query[2] ?? [];
        $data['m0150'] = $query[3] ?? [];
        $data['m0020'] = $query[4] ?? [];
        $data['f0010'] = $query[5] ?? [];
        $user_id                   = session_data()->user_id;
        $html                   = '';
        if ($reqs['from'] == 'm0070') {
            $cache              = getCache('sq0070_m0070', $user_id);
        } else if ($reqs['from'] == 'q0071') {
            $cache              = getCache('q0070_q0071', $user_id);
        }
        if (isset($cache['html'])) {
            $html               = htmlspecialchars_decode($cache['html'], ENT_QUOTES) ??  '';
        }
        $data['html']           =  $html;
        $arr_request            = $request->all();
        $arr_request['screen']  =   $screen;
        $data = array_merge($this->referData($arr_request), $data);
        if (isset($data['error_typ']) && $data['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        return view('Master::q0070.index', $data);
    }
    /**
     * outCSV
     * @author longvv
     * @created at 2018-09-05
     * @return \Illuminate\Http\Response
     */
    public function getSearch(Request $request)
    {
        $arr_request = $request->json()->all();
        $validator = Validator::make($arr_request, [
			'employee_name' => 'max:101',
        ]);
		// validate Laravel
		if ($validator->fails()) {
			return response()->view('errors.query', [], 501);
		}
        //  validateCommandOS
		if (!validateCommandOS($arr_request['employee_name'] ?? '')) {
			$this->respon['status']     = 164;
			return response()->json($this->respon);
		}
        $screen = $request->segment(2);
        // check setting authority
        $arr_request['screen']  = $screen;
        $data = $this->referData($arr_request);
        if (isset($data['error_typ']) && $data['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        $screen_from = $arr_request['screen_from'] ?? '';
        $data['screen_from']        = $screen_from;
        $data['screen']             = $screen;
        return view('Master::q0070.search', $data)->render();
    }

    /**
     * outCSV
     * @author longvv
     * @created at 2018-09-05
     * @return \Illuminate\Http\Response
     */
    public function referData($arr_request = [])
    {
        $authority_typ              = session_data()->authority_typ;
        $system     =   1;
        $validator = Validator::make($arr_request, [
            'employee_typ'                          => 'integer',
            'position_cd'                           => 'integer',
            'grade'                                 => 'integer',
            'organization_step1.*.*'                => 'max:20',
            'organization_step2.*.*'                => 'max:20',
            'organization_step3.*.*'                => 'max:20',
            'organization_step4.*.*'                => 'max:20',
            'organization_step5.*.*'                => 'max:20',
            'company_out_dt_flg'                    => 'integer',
            'fiscal_year'                           => 'integer',
            'group_cd'                              => 'integer',
            'ck_search'                             => 'integer',
            'page_size'                             => 'integer',
            'page'                                  => 'integer',
            'list_character.*.character_item'       => 'string',
            'list_character.*.item_cd'              => 'integer',
            'list_date.*.date_item'                 => 'date',
            'list_date.*.item_cd'                   => 'integer',
            'list_number_item.*.number_item'        => 'numeric',
            'list_number_item.*.item_cd'            => 'integer',
        ]);
        $basicsetting_authority = 0;
        $m0070_authority = 0;
        $authority_typ = 0;
        if (session()->has(AUTHORITY_KEY)) {
            $user = session(AUTHORITY_KEY);
            $authority_typ = $user->authority_typ;
            $m0070_authority = $user->excepts->screen_basicsetting_m0070->authority ?? 0;
            $basicsetting_authority = $user->setting_authority_typ;
        }
        $screen = $arr_request['screen'] ?? '';
        $data['screen']             =   $screen;
        if ($screen == 'sq0070') {
            $data['disable'] = array(
                'staffHistryOutputButton' => '0',
                'screen_q0071' => '0',
                'screen_m0070' => '1',
            );
            $data['organization_group'] =   getCombobox('M0022', 1, 4) ?? [];
            $data['combo_organization'] =   getCombobox('M0020', 1, 4) ?? [];
            $system = 4;
        }
        if ($screen == 'q0070') {
            $data['disable'] = array(
                'releasedPass' => '0',
                'mailButton' => '0',
                'screen_m0070' => '0',
                'screen_q0071' => '1',
                'authority_typ' => $authority_typ,
                'addNewButton' => ($basicsetting_authority > 0 && $m0070_authority > 0)  ? 1 : 0
            );
            $data['organization_group'] =   getCombobox('M0022', 1) ?? [];
            $data['combo_organization'] =   getCombobox('M0020', 1) ?? [];
        }
        if ($validator->passes()) {
            $arr_organization['list_organization_step1']          = $arr_request['organization_step1'] ?? [];
            $arr_organization['list_organization_step2']          = $arr_request['organization_step2'] ?? [];
            $arr_organization['list_organization_step3']          = $arr_request['organization_step3'] ?? [];
            $arr_organization['list_organization_step4']          = $arr_request['organization_step4'] ?? [];
            $arr_organization['list_organization_step5']          = $arr_request['organization_step5'] ?? [];
            //
            $arr_list_item['list_character']           = $arr_request['list_character'] ?? [];
            $arr_list_item['list_date']                = $arr_request['list_date'] ?? [];
            $arr_list_item['list_number_item']         = $arr_request['list_number_item'] ?? [];
            //
            $fiscal_year    = $arr_request['fiscal_year'] ?? -1;
            $group_cd       = $arr_request['group_cd'] ?? -1;
            //
            $json_list_item     = json_encode($arr_list_item, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
            $json_organization  = json_encode($arr_organization, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
            $query = Dao::executeSql('SPC_Q0070_FND1', [
                'employee_cd'              => SQLEscape($arr_request['employee_cd'] ?? '') ?? '',
                'employee_name'            => SQLEscape($arr_request['employee_name'] ?? '') ?? '',
                'employee_typ'             => $arr_request['employee_typ'] ?? -1,
                'list_org'                 => $json_organization,
                'position_cd'              => $arr_request['position_cd'] ?? -1,
                'grade'                    => $arr_request['grade'] ?? -1,
                'company_out_dt_flg'       => $arr_request['company_out_dt_flg'] ?? 0,
                'fiscal_year'              => (!$fiscal_year || $fiscal_year == '') ? -1 : $fiscal_year,
                'group_cd'                 => (!$group_cd    || $group_cd  == '') ? -1 : $group_cd,
                'ck_search'                => $arr_request['ck_search'] ?? 0,
                'list_item'                => $json_list_item,
                'company_cd'               => session_data()->company_cd ?? 0,
                'user_id'                  => session_data()->user_id ?? 0,
                'page_size'                => $arr_request['page_size'] ?? 20,
                'page'                     => $arr_request['page'] ?? 1,
                'system'                    => $system,
            ]);
            if (isset($query[0][0]['error_typ']) && $query[0][0]['error_typ'] == '999') {
                return ['error_typ' => '999'];
            }
            //
            if (!empty($query) && isset($query[0]['error_typ'])) {

                $data = [
                    'views' => [],
                    'paging' => [],
                ];
            } else {
                $data['views'] = $query[0] ?? [];
                $data['paging'] = $query[1][0] ?? [];
                $data['authority_typ'] = $query[2][0]['authority_typ'];
                $data['list_item'] = $query[3];
            }
            $data['items'] = $this->itemService->getItemsForEmployee(session_data()->company_cd, session_data()->user_id ?? 0);
            return $data;
        } else {
            return array('error_typ' => '999');
        }
    }

    /**
     * outCSV
     * @author longvv
     * @created at 2018-09-05
     * @return \Illuminate\Http\Response
     */
    public function outputHistoryCsv(Request $request)
    {
        $arr_request = $request->json()->all();
        $validator = Validator::make($arr_request, [
            'employee_typ'                          => 'integer',
            'position_cd'                           => 'integer',
            'grade'                                 => 'integer',
            'company_out_dt_flg'                    => 'integer',
            'fiscal_year'                           => 'integer',
            'group_cd'                              => 'integer',
            'ck_search'                             => 'integer',
            'page_size'                             => 'integer',
            'page'                                  => 'integer',
            'list_character.*.character_item'       =>  'string',
            'list_character.*.item_cd'              =>  'integer',
            'list_date.*.date_item'                 =>  'date',
            'list_date.*.item_cd'                   =>  'integer',
            'list_number_item.*.number_item'        =>  'numeric',
            'list_number_item.*.item_cd'            =>  'integer',
        ]);
        if ($validator->passes()) {
            try {
                $arr_organization['list_organization_step1']          = $arr_request['organization_step1'] ?? [];
                $arr_organization['list_organization_step2']          = $arr_request['organization_step2'] ?? [];
                $arr_organization['list_organization_step3']          = $arr_request['organization_step3'] ?? [];
                $arr_organization['list_organization_step4']          = $arr_request['organization_step4'] ?? [];
                $arr_organization['list_organization_step5']          = $arr_request['organization_step5'] ?? [];
                //
                $arr_list_item['list_character']           = $arr_request['list_character'] ?? [];
                $arr_list_item['list_date']                = $arr_request['list_date'] ?? [];
                $arr_list_item['list_number_item']         = $arr_request['list_number_item'] ?? [];
                //
                $json_list_item     = json_encode($arr_list_item, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
                $json_organization  = json_encode($arr_organization, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
                $result = Dao::executeSql('SPC_Q0070_RPT1', [
                    'employee_cd'              => SQLEscape($arr_request['employee_cd']) ?? '',
                    'employee_name'            => SQLEscape($arr_request['employee_name']) ?? '',
                    'employee_typ'             => $arr_request['employee_typ'] ?? -1,
                    'list_org'                 => $json_organization,
                    'position_cd'              =>  preventOScommand($arr_request['position_cd']) ?? -1,
                    'grade'                    =>  preventOScommand($arr_request['grade']) ?? -1,
                    'company_out_dt_flg'       =>  preventOScommand($arr_request['company_out_dt_flg']) ?? 0,
                    'fiscal_year'              =>  preventOScommand($arr_request['fiscal_year']) ?? -1,
                    'group_cd'                 =>  preventOScommand($arr_request['group_cd']) ?? -1,
                    'ck_search'                =>  preventOScommand($arr_request['ck_search']) ?? 0,
                    'list_item'                =>  $json_list_item,
                    'company_cd'               => session_data()->company_cd ?? 0,
                    'user_id'                  => session_data()->user_id,
                ]);
                if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
                    return response()->view('errors.query', [], 501);
                }
                $date = date("Ymd_His") . substr((string)microtime(), 2, 4);
                $csvname = 'Q0070' . $date . '.csv';
                $fileName =   $_SERVER['DOCUMENT_ROOT'] . '/download/' . $csvname;
                if (count($result[0]) == 1) {
                    $this->respon['status']     = NG;
                    $this->respon['message']  = L0020::getText(21)->message;
                    return response()->json($this->respon, 401);
                } else {
                    $fileNameReturn  = $this->saveCSV($fileName, $result);
                    if ($fileNameReturn != '') {
                        $this->respon['FileName'] = '/download/' . $fileNameReturn;
                    } else {
                        $this->respon['FileName'] = '';
                    }
                }
            } catch (\Exception $e) {
                $this->respon['status']     = EX;
                $this->respon['Exception']  = $e->getMessage();
            }
            return response()->json($this->respon);
        } else {
            return abort(500);
        }
    }

    /**
     * outCSV
     * @author longvv
     * @created at 2018-09-05
     * @return \Illuminate\Http\Response
     */
    public function outputEmployeeCsv(Request $request)
    {
        $arr_request = $request->json()->all();
        $validator = Validator::make($arr_request, [
            'employee_typ'                          => 'integer',
            'position_cd'                           => 'integer',
            'grade'                                 => 'integer',
            'company_out_dt_flg'                    => 'integer',
            'fiscal_year'                           => 'integer',
            'group_cd'                              => 'integer',
            'ck_search'                             => 'integer',
            'page_size'                             => 'integer',
            'page'                                  => 'integer',
            'list_character.*.character_item'       =>  'string',
            'list_character.*.item_cd'              =>  'integer',
            'list_date.*.date_item'                 =>  'date',
            'list_date.*.item_cd'                   =>  'integer',
            'list_number_item.*.number_item'        =>  'numeric',
            'list_number_item.*.item_cd'            =>  'integer',
        ]);
        if ($validator->passes()) {
            try {
                $arr_organization['list_organization_step1']          = $arr_request['organization_step1'] ?? [];
                $arr_organization['list_organization_step2']          = $arr_request['organization_step2'] ?? [];
                $arr_organization['list_organization_step3']          = $arr_request['organization_step3'] ?? [];
                $arr_organization['list_organization_step4']          = $arr_request['organization_step4'] ?? [];
                $arr_organization['list_organization_step5']          = $arr_request['organization_step5'] ?? [];
                //
                $arr_list_item['list_character']           = $arr_request['list_character'] ?? [];
                $arr_list_item['list_date']                = $arr_request['list_date'] ?? [];
                $arr_list_item['list_number_item']         = $arr_request['list_number_item'] ?? [];
                //
                $json_list_item     = json_encode($arr_list_item, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
                $json_organization  = json_encode($arr_organization, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
                $result = Dao::executeSql('SPC_Q0070_RPT2', [
                    'employee_cd'              => SQLEscape(preventOScommand($arr_request['employee_cd'])) ?? '',
                    'employee_name'            => SQLEscape(preventOScommand($arr_request['employee_name'])) ?? '',
                    'employee_typ'             => preventOScommand($arr_request['employee_typ']) ?? -1,
                    'list_org'                 => $json_organization,
                    'position_cd'              => preventOScommand($arr_request['position_cd']) ?? -1,
                    'grade'                    => preventOScommand($arr_request['grade']) ?? -1,
                    'company_out_dt_flg'       => preventOScommand($arr_request['company_out_dt_flg']) ?? 0,
                    'fiscal_year'              => preventOScommand($arr_request['fiscal_year']) ?? -1,
                    'group_cd'                 => preventOScommand($arr_request['group_cd']) ?? -1,
                    'ck_search'                => preventOScommand($arr_request['ck_search']) ?? 0,
                    'list_item'                =>  $json_list_item,
                    'company_cd'               => session_data()->company_cd ?? 0,
                    'user_id'                  => session_data()->user_id,
                    'language'                 => session_data()->language,
                ]);
                if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
                    return response()->view('errors.query', [], 501);
                }
                $date = date("Ymd_His") . substr((string)microtime(), 2, 4);
                $csvname = 'Q0070' . $date . '.csv';
                $fileName =   $_SERVER['DOCUMENT_ROOT'] . '/download/' . $csvname;
                if (count($result[0]) == 1) {
                    $this->respon['status']     = NG;
                    $this->respon['message']  = L0020::getText(21)->message;
                    return response()->json($this->respon, 401);
                } else {
                    $fileNameReturn  = $this->saveCSV($fileName, $result);
                    if ($fileNameReturn != '') {
                        $this->respon['FileName'] = '/download/' . $fileNameReturn;
                    } else {
                        $this->respon['FileName'] = '';
                    }
                }
            } catch (\Exception $e) {
                $this->respon['status']     = EX;
                $this->respon['Exception']  = $e->getMessage();
            }
            return response()->json($this->respon);
        } else {
            return abort(500);
        }
    }
    /**
     * save
     * @author longvv
     * @created at 2019-09-11
     * @return \Illuminate\Http\Response
     */
    public function releasedpass(Request $request)
    {
        if ($request->ajax()) {
            try {
                $json = json_encode($request->json()->all() ?? [], JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
                if (!validateJsonFormat($json)) {
                    return abort(500);
                } else {
                    $this->valid($request);
                    if ($this->respon['status'] == OK) {
                        $params['json']             =   $this->respon['data_sql'];
                        $params['cre_user']         =   session_data()->user_id;
                        $params['cre_ip']           =   $_SERVER['REMOTE_ADDR'];
                        $params['company_cd']       =   session_data()->company_cd;
                        $params['user_id']          =   session_data()->user_id;
                        //

                        $result = Dao::executeSql('SPC_Q0070_ACT1', $params);
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
                }
            } catch (\Exception $e) {
                $this->respon['status']     = EX;
                $this->respon['Exception']  = $e->getMessage();
            }
            return response()->json($this->respon);
        }
    }
    /**
     * sendMail
     * @author longvv
     * @created at 2019-09-11
     * @return \Illuminate\Http\Response
     */
    public function sendMail(Request $request)
    {
        if ($request->ajax()) {
            try {
                $json = json_encode($request->json()->all() ?? [], JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
                if (!validateJsonFormat($json)) {
                    return abort(500);
                }
                $this->valid($request);
                if ($this->respon['status'] == OK) {
                    $params['json']             =   $this->respon['data_sql'];
                    $params['cre_user']         =   session_data()->user_id;
                    $params['cre_ip']           =   $_SERVER['REMOTE_ADDR'];
                    $params['company_cd']       =   session_data()->company_cd;
                    $params['user_id']          =   session_data()->user_id;
                    // 
                    unset($this->respon['data_sql']);
                    // exec sql
                    $result = Dao::executeSql('SPC_Q0070_LST1', $params);
                    // check exception
                    if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                        return response()->view('errors.query', [], 501);
                    }
                    if (isset($result[0]) && !empty($result[0])) {
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
