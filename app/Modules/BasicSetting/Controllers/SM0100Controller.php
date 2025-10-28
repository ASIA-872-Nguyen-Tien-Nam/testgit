<?php

namespace App\Modules\BasicSetting\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Services\EmployeeTabAuthorityService;
use Validator;
use Carbon\Carbon;
use File;
use Dao;

class SM0100Controller extends Controller
{
    protected $accountAuthorityService;

	public function __construct(EmployeeTabAuthorityService $employeeTabAuthorityService)
	{
		parent::__construct();
		$this->employeeTabAuthorityService = $employeeTabAuthorityService;
	}
    /**
     * Show the application index.
     * @author nghianm
     * @created at 2020/10/08 06:50:17
     * @return \Illuminate\Http\Response
     */
    public function getIndex(Request $request)
    {
        $data['category'] = trans('messages.home');
        $data['category_icon'] = 'fa fa-home';
        $data['title'] = trans('messages.basic_usage_setting');
        $params = [
            'company_cd'    => session_data()->company_cd,
            'lang'          => session_data()->language,
        ];
        $rows = Dao::executeSql('SPC_SM0100_INQ1', $params);
        if (isset($rows[0][0]['error_typ']) && $rows[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        $data['rows'] = $rows[0][0] ?? [];
        $data['row2'] =getCombobox('3',0);
        $data['lang'] = session_data()->language;
        $data['row3'] = getCombobox('9',0);
        $data['item_start_evaluation'] = $rows[1][0]['item_start_evaluation'] ?? 0;
        $data['item_start_1on1'] = $rows[1][0]['item_start_1on1'] ?? 0;
        $data['item_start_report'] = $rows[1][0]['item_start_report'] ?? 0;
        $data['row4'] = $rows[3] ?? [];
        $data['row5'] = $rows[4] ?? [];
        $data['items_tab'] = $this->employeeTabAuthorityService->getListTab(session_data()->company_cd, $data['lang'])[0];
        return view('BasicSetting::sm0100.index', $data);
    }

    /**
     * Save data
     * @author nghianm 
     * @created at 2020/10/08
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
                    //
                    $result = Dao::executeSql('SPC_SM0100_ACT1', $params);
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
