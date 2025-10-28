<?php

namespace App\Modules\Multiview\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Services\AccountAuthorityService;
use Validator;
use Carbon\Carbon;
use File;

class MS0030Controller extends Controller
{
    protected $accountAuthorityService;

    public function __construct(AccountAuthorityService $accountAuthorityService)
    {
        parent::__construct();
        $this->accountAuthorityService = $accountAuthorityService;
    }

    /**
     * Show the application index.
     * @author namnb
     * @created at 2018-07-04 06:50:17
     * @author tuantv
     * @created at 2018-08-23 06:50:17
     * @return \Illuminate\Http\Response
     */
    public function getIndex(Request $request)
    {
        $data['category'] = trans('messages.set');
        $data['category_icon'] = 'fa fa-cogs';
        $data['title'] = trans('messages.mr_authority_assignment_settings');
        $params['company_cd'] = session_data()->company_cd;
        $params['authority_cd'] = session_data()->authority_cd;
        $post = $this->postSearch($request);
        if (isset($post['error_typ']) && $post['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        $data['organization_group'] = getCombobox('M0022', 1, 3) ?? [];
        $data['combo_organization'] = getCombobox('M0020', 1, 3) ?? [];
        return view('Multiview::ms0030.index', array_merge($data, $post));
    }
    /**
     * search data
     * @author tuantv
     * @created at 2018-08-24
     * @return \Illuminate\Http\Response
     */
    public function postSearch(Request $request)
    {
        $data = $request->data;
        $belong_cd1 = session_data()->authority_typ == 2 ? (session_data()->m0070->belong_cd1 ?? '') : '-1';
        $belong_cd2 = session_data()->authority_typ == 2 ? (session_data()->m0070->belong_cd2 ?? '') : '-1';
        $belong_cd3 = session_data()->authority_typ == 2 ? (session_data()->m0070->belong_cd3 ?? '') : '-1';
        $belong_cd4 = session_data()->authority_typ == 2 ? (session_data()->m0070->belong_cd4 ?? '') : '-1';
        $belong_cd5 = session_data()->authority_typ == 2 ? (session_data()->m0070->belong_cd5 ?? '') : '-1';
        $page_size = $data['page_size'] ?? 20;
        $page = $data['page'] ?? 1;
        $json = [
            'json' => json_encode([
                'list_organization_step1' => $this->genOrgLine($data['organization_cd1'] ?? ''),
                'list_organization_step2' => $this->genOrgLine($data['organization_cd2'] ?? ''),
                'list_organization_step3' => $this->genOrgLine($data['organization_cd3'] ?? ''),
                'list_organization_step4' => $this->genOrgLine($data['organization_cd4'] ?? ''),
                'list_organization_step5' => $this->genOrgLine($data['organization_cd5'] ?? ''),
            ], JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE)
        ];
        $cd1 = explode('|', $data['organization_cd1'] ?? '');
        $cd2 = explode('|', $data['organization_cd2'] ?? '');
        $cd3 = explode('|', $data['organization_cd3'] ?? '');
        $cd4 = explode('|', $data['organization_cd4'] ?? '');
        $cd5 = explode('|', $data['organization_cd5'] ?? '');

        if (isset($cd1[0]) && empty($cd1[0])) $cd1[0] = '-1';
        if (isset($cd2[1]) && empty($cd2[1])) $cd2[1] = '-1';
        if (isset($cd3[2]) && empty($cd3[2])) $cd3[2] = '-1';
        if (isset($cd4[3]) && empty($cd4[3])) $cd4[3] = '-1';
        if (isset($cd5[4]) && empty($cd5[4])) $cd5[4] = '-1';

        $params = [
            'company_cd' => session_data()->company_cd??'',
            'employee_cd' => preventOScommand($data['employee_cd']??'') ?? '',
            'employee_nm' => SQLEscape(preventOScommand($data['employee_nm']??'')) ?? '',
            'organization_cd1' => $cd1[0] ?? '-1',
            'organization_cd2' => $cd2[1] ?? '-1',
            'organization_cd3' => $cd3[2] ?? '-1',
            'organization_cd4' => $cd4[3] ?? '-1',
            'organization_cd5' => $cd5[4] ?? '-1',
            'position_cd' => preventOScommand($data['position_cd'] ?? ''),
            'check_authority' => preventOScommand($data['check_authority']??''),
            'authority_cd' => preventOScommand($data['authority_cd']??''),
            'employee_typ' => preventOScommand($data['employee_typ']??''),
            'user_id' => session_data()->user_id ?? '',
            'page_size' =>  $page_size ?? 20,
            'page' =>  $page ?? 1,
            'json' => $json['json']
        ];
        $param2['company_cd'] = session_data()->company_cd;
        $param2['authority_cd'] = session_data()->authority_cd;
        $param2['authority_typ'] = session_data()->authority_typ;
        // $data_init = Dao::executeSql('SPC_S0030_INQ1',$param2);
        $data_init = $this->accountAuthorityService->getAccountAuthority($param2, 3);
        if (isset($data_init[0][0]['error_typ']) && $data_init[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        //
        // $res = Dao::executeSql('SPC_S0030_LST1', $params);
        $res = $this->accountAuthorityService->searchAccountAuthority($params, 3);
        if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        //
        $data['data_init'] = $data_init ?? [];
        $data['M0040'] = getCombobox('M0040', 1, 3);
        //
        $data['list'] = $res[0] ?? [];
        $data['paging'] = $res[1][0] ?? [];
        $data['authority_typ'] = session_data('authority_typ');
        $data['belong_cd1'] = $belong_cd1;
        $data['belong_cd2'] = $belong_cd2;
        $data['belong_cd3'] = $belong_cd3;
        $data['belong_cd4'] = $belong_cd4;
        $data['belong_cd5'] = $belong_cd5;
        $data['group_typ'] = $res[2] ?? [];
        $data['organization_group'] = getCombobox('M0022', 1, 3) ?? [];
        $data['combo_organization'] = getCombobox('M0020', 1, 3) ?? [];
        // render view
        if ($request->ajax()) {
            if ((isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') || (isset($data_init[0][0]['error_typ']) && $data_init[0][0]['error_typ'] == '999')) {
                return response()->view('errors.query', [], 501);
            }
            return view('Multiview::ms0030.search', $data)->render();
        } else {
            if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
                return array('error_typ' => '999');
            }
            return $data;
        }
    }

    /**
     * [genOrgLine description]
     * @param  [String] $cd1 [description]
     * @param  [String] $cd2 [description]
     * @param  [String] $cd3 [description]
     * @param  [String] $cd4 [description]
     * @param  [String] $cd5 [description]
     * @return [String]      [description]
     */
    public function genOrgLine($data)
    {
        $step = explode('|', $data);
        if (empty($step) || $step[0] == 0 || $step[0] == -1) return [];
        return [[
            'organization_cd1' => $step[0] ?? '',
            'organization_cd2' => $step[1] ?? '',
            'organization_cd3' => $step[2] ?? '',
            'organization_cd4' => $step[3] ?? '',
            'organization_cd5' => $step[4] ?? ''
        ]];
    }

    /**
     * save
     * @author tuantv
     * @created at 2018-08-27
     * @return \Illuminate\Http\Response
     */
    public function postSave(Request $request)
    {
        if ($request->ajax()) {
            try {

                $json = json_encode($request->json()->all() ?? [], JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
                if (!validateJsonFormat($json)) {
					return response()->view('errors.query', [], 501);
                }
                $params['json']          =   preventOScommand($json);
                $params['cre_user']      =   session_data()->user_id;
                $params['cre_ip']        =   $_SERVER['REMOTE_ADDR'];
                $params['company_cd']    =   session_data()->company_cd;
                $params['mode']          =   0; //mode = 0: update
                $result = $this->accountAuthorityService->saveAccountAuthority($params, 3);
                // check exception
                if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                    $this->respon['status']     = EX;
                    $this->respon['Exception']  = $result[0][0]['remark'];
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
     * save
     * @author tuantv
     * @created at 2018-08-27
     * @return \Illuminate\Http\Response
     */
    public function postDelete(Request $request)
    {
        if ($request->ajax()) {
            try {
                $json = json_encode($request->json()->all() ?? [], JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
				if (!validateJsonFormat($json)) {
					return response()->view('errors.query', [], 501);
				}
                $params['json']          =   preventOScommand($json);
                $params['cre_user']      =   session_data()->user_id;
                $params['cre_ip']        =   $_SERVER['REMOTE_ADDR'];
                $params['company_cd']    =   session_data()->company_cd;
                $params['mode']          =   1; //mode = 1: delete
                $result = $this->accountAuthorityService->deleteAccountAuthority($params, 3);
                // check exception
                if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                    $this->respon['status']     = EX;
                    $this->respon['Exception']  = $result[0][0]['remark'];
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