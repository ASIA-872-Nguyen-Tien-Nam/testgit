<?php

namespace App\Modules\OneOnOne\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Validator;
use App\Services\SettingGroupService;

class OM0300Controller extends Controller
{
    protected $SettingGroupService;
    public function __construct(SettingGroupService $SettingGroupService)
    {
        parent::__construct();
        $this->SettingGroupService = $SettingGroupService;
    }
    /**
     * Show the application index.
     * @author mail@ans-asia.com 
     * @created at 2020-11-05 08:30:50
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        $data['category'] = trans('messages.preparation');
        $data['category_icon'] = 'fa fa-book';
        $data['title'] = trans('messages.1on1_group_setting');
        $left = $this->getLeftContent($request);
        return view('OneOnOne::om0300.index', array_merge($data, $left));
    }
    /**
     * get left content
     * @author nghianm
     * @created at 2020-11-05
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
        $res = $this->SettingGroupService->findGroups(
            $params['company_cd'],
            $params['search_key'],
            $params['current_page'],
            $params['page_size']
        );
        if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        $data['list'] = $res[0] ?? [];
        $data['paging'] = $res[1][0] ?? [];
        $data['list_m0040'] = $res[2] ?? [];
        $data['list_m0030'] = $res[3] ?? [];
        $data['list_m0050'] = $res[4] ?? [];
        $data['list_m0060'] = $res[5] ?? [];
        // render view
        if ($request->ajax()) {
            return view('OneOnOne::om0300.leftcontent', $data);
        } else {
            return $data;
        }
    }
    /**
     * get right content
     * @author nghianm
     * @created at 2020-11-06
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
        $res = $this->SettingGroupService->getGroup($params['company_cd'], $params['group_cd']);
        if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        $data['listm2600']  = $res[0][0] ?? [];
        $data['list_m0040'] = $res[1] ?? [];
        $data['list_m0030'] = $res[2] ?? [];
        $data['list_m0050'] = $res[3] ?? [];
        $data['list_m0060'] = $res[4] ?? [];
        return view('OneOnOne::om0300.rightcontent', $data);
    }
    /**
     * Save
     * @author nghianm 
     * @created at 2020-11-06 07:46:26
     * @return void
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
                $json = json_encode($param_json, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
                //
                if (!validateJsonFormat($json)) {
                    return response()->view('errors.query', [], 501);
                }
                $params['json']         =   $json;
                $params['cre_user']     =   session_data()->user_id;
                $params['cre_ip']       =   $_SERVER['REMOTE_ADDR'];
                $params['company_cd']   =   session_data()->company_cd;
                $res = $this->SettingGroupService->saveGroup($params);
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
     * Delete data
     * @author nghianm
     * @created at 2020/11/06
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
                    $res = $this->SettingGroupService->deleteGroup($params);
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
