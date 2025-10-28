<?php

namespace App\Modules\WeeklyReport\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Contracts\Encryption\DecryptException;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Validation\Rule;

use App\Services\WeeklyReport\WeeklyReportService;
use App\Services\WeeklyReport\PersonalTargetService;
use App\Services\WeeklyReport\AdequacyService;
use App\Services\MiraiService;
use Validator;
use Dao;

class RQ2020Controller extends Controller
{
    /** PersonalTargetService */
    public $target_service;
    /** MiraiService */
    public $mirai_service;
    /** WeeklyReportService */
    public $weeklyreport_service;
    /** AdequacyService */
    public $adequacy_service;
    public function __construct(PersonalTargetService $target_service, AdequacyService $adequacy_service, WeeklyReportService $weeklyreport_service, MiraiService $mirai_service)
    {
        parent::__construct();
        $this->weeklyreport_service     = $weeklyreport_service;
        $this->mirai_service            = $mirai_service;
        $this->target_service           = $target_service;
        $this->adequacy_service         = $adequacy_service;
    }
    /**
     * 
     * @author namnt 
     * @created at 2023-02-12
     * @return \Illuminate\Http\Response
     */
    public function getIndex(Request $request)
    {
        $data['title'] = trans('rq2020.weekly_personal_history');
        $params['company_cd']  = session_data()->company_cd ?? 0;
        $data['fiscal_year_today'] = $this->mirai_service->findFiscalYearFromDate($params['company_cd'], 5) ?? 0;
        $data['fiscal_year']   = $this->weeklyreport_service->getScheduleSetting($params['company_cd'], 1) ?? [];
        $data['report_kinds']  = $this->weeklyreport_service->getScheduleSetting($params['company_cd'], 0) ?? [];
        // get data from url query
        $redirect_param = $request->redirect_param ?? '';
        if ($redirect_param != '') {
            try {
                $redirect_param = json_decode(Crypt::decryptString($redirect_param));
            } catch (DecryptException $e) {
                return response()->view('errors.403');
            }
        }
        $params = [];
        $params['fiscal_year_param'] = $redirect_param->fiscal_year_weeklyreport ?? $data['fiscal_year_today'];
        $params['employee_cd_param'] = $redirect_param->employee_cd ??(session_data()->report_authority_typ>=3 ?'': session_data()->m0070->employee_cd);
        $params['report_kind_param'] = $redirect_param->report_kind ?? 0;
        $params['year_month_from_param'] = $redirect_param->year_month_from ?? '';
        $params['year_month_to_param'] = $redirect_param->year_month_to ?? '';
        $params['employee_nm_param'] = $redirect_param->employee_nm ?? (session_data()->report_authority_typ>=3 ?'':session_data()->m0070->employee_nm);
        $params['from'] = $redirect_param->from ?? 'rq2010';
        $params['screen_id'] = $redirect_param->screen_id ?? '';
        $validator = Validator::make($params, [
            'fiscal_year' => ['integer'],
            'report_kind' => ['integer'],
            'from'  => [
                'string',
                'required',
                Rule::in(['rdashboardreporter', 'rdashboardapprover', 'rdashboard', 'rq2010', 'rq2020','ri2010']),
            ],
            'screen_id'  => [
                'string',
                Rule::in(['rdashboardreporter_ri2010', 'rdashboardapprover_ri2010', 'rdashboard_ri2010', 'rq2010_ri2010', 'rq2020_ri2010','ri2010_ri2010', 'rq2010_rq2020']),
            ],
        ]);
        if ($validator->fails()) {
            return response()->view('errors.query', [], 501);
        }
        $adequacy = [];
        if($redirect_param != ''){
            $param['company_cd']         =  session_data()->company_cd;
            $param['fiscal_year']        =  $params['fiscal_year_param'];
            $param['year_month_start']   =  str_replace('/','',$params['year_month_from_param']);
            $param['year_month_end']     =  str_replace('/','',$params['year_month_to_param']);
            $param['report_kinds']       =  $params['report_kind_param'];
            $param['employee_cd']        =  $params['employee_cd_param'];
            $param['employee_cd_login']  =  session_data()->employee_cd ?? '';
            $param['mode']				 =	 0;
            $result = Dao::executeSql('SPC_rQ2020_FND1', $param);
            if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
                return response()->view('errors.query', [], 501);
            }
            $data['target']     = $this->target_service->find($param['company_cd'],  $param['fiscal_year'] ,  $param['employee_cd'], 0);
            $adequacy           = $this->getAdequacy();
            $data['reports']    = $result[0];
        }
        //dd($params);
        // render view
        return view('WeeklyReport::rq2020.index', array_merge($data, $params, $adequacy));
    }
    /**
     * Search
     * @author mail@ans-asia.com
     * @created at 2020-09-04 08:29:12 
     * @return void
     */
    public function postSearch(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'report_kinds'                   => 'integer',
            'fiscal_year'                    => 'integer',
            "year_month_start"               => "integer",
            "year_month_end"                 => "integer",
        ]);
        if ($validator->fails()) {
            return response()->view('errors.query', [], 501);
        }
        // success
        $params['company_cd']         =  session_data()->company_cd;
        $params['fiscal_year']        =  $request->fiscal_year ?? 0;
        $params['year_month_start']   =  $request->year_month_start ??'';
        $params['year_month_end']     =  $request->year_month_end ??'';
        $params['report_kinds']       =  $request->report_kinds ?? 0;
        $params['employee_cd']        =  $request->employee_cd ?? '';
        $params['employee_cd_login']  = session_data()->employee_cd ?? '';
        $params['mode']				  =	 0;
        $result = Dao::executeSql('SPC_rQ2020_FND1', $params);
        if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        $data['target']     = $this->target_service->find($params['company_cd'],  $params['fiscal_year'] ,  $params['employee_cd'], 0);
        $adequacy           = $this->getAdequacy();
        $data['reports']    = $result[0];
        return view('WeeklyReport::rq2020.refer', array_merge($data,$adequacy));     
    }
    /**
    * get Adequacy from Master 
    *
    * @return Array
    */
    public function getAdequacy()
    {
        // 充実度 & 繁忙度 & その他
        $adequacy['adequacy'] = $this->adequacy_service->getAdequacyByMarkKbn(1);
        $adequacy['busyness'] = $this->adequacy_service->getAdequacyByMarkKbn(2);
        $adequacy['other'] = $this->adequacy_service->getAdequacyByMarkKbn(3);
        return $adequacy;
    }
    	/**
	 * export
	 * @author tuantv
	 * @created at 2018-10-03 08:13:36
	 * @return void
	 */
	public function export(Request $request)
	{
		$validator = Validator::make($request->all(), [
            'report_kinds'                   => 'integer',
            'fiscal_year'                    => 'integer',
            "year_month_start"               => "integer",
            "year_month_end"                 => "integer",
        ]);
		if ($validator->fails()) {
			return response()->view('errors.query', [], 501);
		}
		// success
        $params['company_cd']         =  session_data()->company_cd;
        $params['fiscal_year']        =  $request->fiscal_year ?? 0;
        $params['year_month_start']   =  $request->year_month_start ??'';
        $params['year_month_end']     =  $request->year_month_end ??'';
        $params['report_kinds']       =  $request->report_kinds ?? 0;
        $params['employee_cd']        =  $request->employee_cd ?? '';
        $params['employee_cd_login']  = session_data()->employee_cd ?? '';
        $params['mode']				  =	 1;
        $result = Dao::executeSql('SPC_rQ2020_FND1', $params,true);
		if (empty($result[0]) | count($result[0]) == 1) {
			$this->respon['status']     = NG; // no data
			return response()->json($this->respon);
		}
		//
		$date = date("Ymd_His") . substr((string)microtime(), 2, 4);
		$csvname = 'rQ2020' . $date . '.csv';
		$fileName =   $_SERVER['DOCUMENT_ROOT'] . '/download/' . $csvname;
		$fileNameReturn  = $this->saveCSV($fileName, $result);
		if ($fileNameReturn != '') {
			$this->respon['FileName'] = '/download/' . $fileNameReturn;
		} else {
			$this->respon['FileName'] = '';
		}
		//
		return response()->json($this->respon);
	}
    /**
     * 
     * @author namnt 
     * @created at 2023-02-12
     * @return \Illuminate\Http\Response
     */
    public function fiscal(Request $request)
    {
        // render view
        return view('WeeklyReport::rq2020.refer');
    }
}
