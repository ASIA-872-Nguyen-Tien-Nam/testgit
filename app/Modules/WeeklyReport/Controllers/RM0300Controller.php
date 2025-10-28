<?php

namespace App\Modules\WeeklyReport\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Validator;
use App\Services\WeeklyReport\SettingGroupService;

class RM0300Controller extends Controller
{
    protected $settingGroupService;
    public function __construct(SettingGroupService $settingGroupService)
	{
		parent::__construct();
		$this->settingGroupService       = $settingGroupService;
	}
    public function index(Request $request)
    {
        $data['category'] = trans('messages.preparation');
        $data['category_icon'] = 'fa fa-book';
        $data['title'] = __('rm0300.title');
        $left = $this->getLeftContent($request);
        return view('WeeklyReport::rm0300.index', array_merge($data, $left));
    }
    /**
     * get left content
     * @author namnt
     * @created at 2023-04-18
     * @return \Illuminate\Http\Response
     */
    public function getLeftContent(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'current_page' => 'integer',
			'search_key' => 'max:20'
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
            'search_key' => SQLEscape($request->search_key) ?? '',
            'current_page' => $request->current_page ?? 1,
            'page_size' => 10,
            'company_cd' => session_data()->company_cd, // set for demo
        ];
        // $data = $params;
        $data['search_key'] = htmlspecialchars($request->search_key) ?? '';
        $res = $this->settingGroupService->find($params);
        if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        $data['list'] = $res[0] ?? [];
        $data['paging'] = $res[1][0] ?? [];
        $data['list_m0040'] = $res[2] ?? [];
        $data['list_m0030'] = $res[3] ?? [];
        $data['list_m0050'] = $res[4] ?? [];
        $data['list_m0060'] = $res[5] ?? [];
        $data['list_m0040_2'] = $res[2] ?? [];
        $data['list_m0030_2'] = $res[3] ?? [];
        $data['list_m0050_2'] = $res[4] ?? [];
        $data['list_m0060_2'] = $res[5] ?? [];
        $data['organization_group_1'] 				= $sql[3] ?? [];
		$data['organization_group'] 				= getCombobox('M0022', 1,5) ?? [];
        $data['combo_organization'] 	= getCombobox('M0020', 1,5);
        $data['check_lang'] 				= 'en';
        $data['count_organization_cd'] 			= 0;
        $data['organization_group_total'] 			= 0;
        $data['organization_group_total2'] 			= 0;
        // render view
        if ($request->ajax()) {
            return view('WeeklyReport::rm0300.leftcontent', $data);
        } else {
            return $data;
        }
        return $data;
    }
    /**
     * save group
     * @author namnt
     * @created at 2023-04-18
     * @return \Illuminate\Http\Response
     */
    public function postSave(Request $request)
    {
        if ($request->ajax()) {
            try {
                $param_json = $request->json()->all()['data_sql'] ?? [];
                $validator = Validator::make($param_json, [
                    'group_cd'        =>  'integer',
                ]);
                if ($validator->fails()) {
                    return response()->view('errors.query', [], 501);
                }
                if (count($param_json) == 0) {
                    $param_json['group_cd']     = 0;
                    $param_json['group_nm']     = '';
                }
                $jsonOrg = $request->json()->all()['data_sql'];
                $organization_step1 = explode("|", $jsonOrg['organization_step1'] ?? '');
                $organization_step2 = explode("|", $jsonOrg['organization_step2'] ?? '');
                $organization_step3 = explode("|", $jsonOrg['organization_step3'] ?? '');
                $organization_step4 = explode("|", $jsonOrg['organization_step4'] ?? '');
                $organization_step5 = explode("|", $jsonOrg['organization_step5'] ?? '');
                $jsonOrg['organization_step1'] = $organization_step1[0] ?? '';
                $jsonOrg['organization_step2'] = $organization_step2[1] ?? ($organization_step2[0] ?? '');
                $jsonOrg['organization_step3'] = $organization_step3[2] ?? ($organization_step3[0] ?? '');
                $jsonOrg['organization_step4'] = $organization_step4[3] ?? ($organization_step4[0] ?? '');
                $jsonOrg['organization_step5'] = $organization_step5[4] ?? ($organization_step5[0] ?? '');
                $organization_step2_1 = explode("|", $jsonOrg['organization_step2_1'] ?? '');
                $organization_step2_2 = explode("|", $jsonOrg['organization_step2_2'] ?? '');
                $organization_step2_3 = explode("|", $jsonOrg['organization_step2_3'] ?? '');
                $organization_step2_4 = explode("|", $jsonOrg['organization_step2_4'] ?? '');
                $organization_step2_5 = explode("|", $jsonOrg['organization_step2_5'] ?? '');
                $jsonOrg['organization_step2_1'] = $organization_step2_1[0] ?? '';
                $jsonOrg['organization_step2_2'] = $organization_step2_2[1] ?? ($organization_step2_2[0] ?? '');
                $jsonOrg['organization_step2_3'] = $organization_step2_3[2] ?? ($organization_step2_3[0] ?? '');
                $jsonOrg['organization_step2_4'] = $organization_step2_4[3] ?? ($organization_step2_4[0] ?? '');
                $jsonOrg['organization_step2_5'] = $organization_step2_5[4] ?? ($organization_step2_5[0] ?? '');
                $json = json_encode($jsonOrg, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);

                //
                
                
                if (!validateJsonFormat($json)) {
                    return response()->view('errors.query', [], 501);
                }
                $params['json']         =   $json;
                $params['cre_user']     =   session_data()->user_id;
                $params['cre_ip']       =   $_SERVER['REMOTE_ADDR'];
                $params['company_cd']   =   session_data()->company_cd;
                
                $res = $this->settingGroupService->register($params);
                // check exception
                if (isset($res[0][0]) && $res[0][0]['error_typ'] == '999') {
                    return response()->view('errors.query', [], 501);
                } else if (isset($res[0]) && !empty($res[0])) {
                    $this->respon['status'] = NG;
                    foreach ($res[0] as $temp) {
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
     * get right content
     * @author namnt
     * @created at 2023-04-18
     * @return \Illuminate\Http\Response
     */
    public function getRightContent(Request $request)
    {
        $params = [
            'group_cd' => $request->group_cd ?? 0,
            'company_cd' => session_data()->company_cd, // set for demo
        ];
        $validator = Validator::make($params, [
            'group_cd' => 'integer',
            'company_cd' => 'integer'
        ]);
        if ($validator->fails()) {
            return response()->view('errors.query', [], 501);
        }
        $res = $this->settingGroupService->get($params);
        if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        $data['listm4600']  = $res[0][0] ?? [];
        $data['list_m0040'] = $res[1] ?? [];
        $data['list_m0030'] = $res[2] ?? [];
        $data['list_m0050'] = $res[3] ?? [];
        $data['list_m0060'] = $res[4] ?? [];
        $data['list_m0040_2'] = $res[5] ?? [];
        $data['list_m0030_2'] = $res[6] ?? [];
        $data['list_m0050_2'] = $res[7] ?? [];
        $data['list_m0060_2'] = $res[8] ?? [];
        $data['organization_group_1'] 				= [];
		$data['organization_group'] 	= getCombobox('M0022', 1,5) ?? [];
        $data['combo_organization'] 	= getCombobox('M0020', 1,5);
        $data['check_lang'] 				= 'en';
        $data['count_organization_cd'] 			= 0;
        $data['organization_group_total']['2'] 	= $res[10] ?? null;
		$data['organization_group_total']['3'] 	= $res[11] ?? null;
		$data['organization_group_total']['4'] 	= $res[12] ?? null;
		$data['organization_group_total']['5'] 	= $res[13] ?? null;
        $data['organization_group_total2']['2'] 	= $res[15] ?? null;
		$data['organization_group_total2']['3'] 	= $res[16] ?? null;
		$data['organization_group_total2']['4'] 	= $res[17] ?? null;
		$data['organization_group_total2']['5'] 	= $res[18] ?? null;
        return view('WeeklyReport::rm0300.rightcontent', $data);
    }
    /**
     * delete data
     * @author namnt
     * @created at 2023-04-18
     * @return \Illuminate\Http\Response
     */
    public function postDelete(Request $request)
    {
        if ($request->ajax()) {
            try {
                $params = [
                    'group_cd'         => $request->group_cd ?? 0,
                    'company_cd'        => session_data()->company_cd, // set for demo
                ];
                $validator = Validator::make($params, [
                    'group_cd'          => 'integer',
                    'company_cd'        => 'integer',
                ]);
                if ($validator->passes()) {
                    $params['group_cd']             =   $request->group_cd;
                    $params['cre_user']             =   session_data()->user_id;
                    $params['cre_ip']               =   $_SERVER['REMOTE_ADDR'];
                    $params['company_cd']           =   session_data()->company_cd;
                    //
                    $res = $this->settingGroupService->delete($params);
                    // check exception
                    if (isset($res[0][0]) && $res[0][0]['error_typ'] == '999') {
                        return response()->view('errors.query', [], 501);
                    } else if (isset($res[0]) && !empty($res[0])) {
                        $this->respon['status'] = NG;
                        foreach ($res[0] as $temp) {
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
    
}
