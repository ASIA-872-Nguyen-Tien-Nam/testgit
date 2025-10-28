<?php

namespace App\Modules\WeeklyReport\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Contracts\Encryption\DecryptException;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Validation\Rule;
use Validator;
use Dao;
use App\Services\WeeklyReport\WeeklyReportService;
use App\Services\WeeklyReport\PersonalTargetService;
use App\Services\WeeklyReport\AdequacyService;
use App\Services\WeeklyReport\ReactionService;
use App\Services\MiraiService;
use Carbon\Carbon;
use App\Services\WeeklyReport\SettingGroupService;

class RQ2010Controller extends Controller
{
    /** WeeklyReportService */
    public $WeeklyReportService;
    /** PersonalTargetService */
    public $target_service;
    /** AdequacyService */
    public $adequacy_service;
    /** ReactionService */
    public $reaction_service;
    public $mirai;
    protected $weeklyReportService;
    protected $settingGroupService;

    public function __construct(
        WeeklyReportService $WeeklyReportService,
        PersonalTargetService $target_service,
        AdequacyService $adequacy_service,
        ReactionService $reaction_service,
        WeeklyReportService $weeklyReportService,
        MiraiService $mirai,
        SettingGroupService $settingGroupService
    ) {
        parent::__construct();
        $this->WeeklyReportService = $WeeklyReportService;
        $this->target_service = $target_service;
        $this->adequacy_service = $adequacy_service;
        $this->reaction_service = $reaction_service;
        $this->weeklyReportService     = $weeklyReportService;
        $this->mirai = $mirai;
        $this->settingGroupService       = $settingGroupService;
    }

    /**
     * getIndex
     *
     * @param  Request $request
     * @return void
     */
    public function getIndex(Request $request)
    {
        $data['title'] = trans('rq2010.list_of_weekly_reports');
        $company_cd  = session_data()->company_cd ?? 0;
        $data['job'] = getCombobox('M0030', 1, 5) ?? [];
        $data['position'] = getCombobox('M0040', 1, 5) ?? [];
        $data['grade'] = getCombobox('M0050', 1, 5) ?? [];
        $data['employee_typ'] = getCombobox('M0060', 1, 5) ?? [];
        $data['adequacy'] = $this->adequacy_service->getAdequacyByMarkKbn(1);
        $data['busyness'] = $this->adequacy_service->getAdequacyByMarkKbn(2);
        $data['other'] = $this->adequacy_service->getAdequacyByMarkKbn(3);
        $data['report_kinds'] = $this->weeklyReportService->getScheduleSetting($company_cd, 0);
        $data['system'] = 5;
        $data['M0022'] = getCombobox('M0022', 1, 5);
        $data['M0020'] = getCombobox('M0020', 1, 5);
        $data['L0041'] = getCombobox('L0041', 1, 5);
        $data['M4101'] = getCombobox('M4101', 1, 5);
        $data['my_group'] = getCombobox('F4010', 1, 5);
        // 
        $data['report_authority_typ'] = session_data()->report_authority_typ ?? 0;
        $params_group = [
            'search_key' => '',
            'current_page' => 1,
            'page_size' => 1000,
            'company_cd' => session_data()->company_cd, // set for demo
        ];
        // $data = $params;
        $data['group'] = $this->settingGroupService->find($params_group)[0];
        $now = Carbon::now();
        $year = $now->year;
        $data['year_month_from'] = $year . '/01';
        $data['year_month_to'] = $year . '/12';
        $data['fiscal_year'] = $year;
        // render view
        return view('WeeklyReport::rq2010.index', $data);
    }

    /**
     * postSearch
     *
     * @param  Request $request
     * @return void
     */
    public function postSearch(Request $request)
    {
        $now = Carbon::now();
        $year = $now->year;
        $json_array = [];
        $json_array['list_organization_step1'] = ($request->json()->all())['list_organization_step1'] ?? [];
        $json_array['list_organization_step2'] = ($request->json()->all())['list_organization_step2'] ?? [];
        $json_array['list_organization_step3'] = ($request->json()->all())['list_organization_step3'] ?? [];
        $json_array['list_organization_step4'] = ($request->json()->all())['list_organization_step4'] ?? [];
        $json_array['list_organization_step5'] = ($request->json()->all())['list_organization_step5'] ?? [];
        $json_array['status'] = ($request->json()->all())['status'];
        // $param_json = ($request->json()->all())['list_organization_step2'];
        $json = json_encode($json_array, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
        $param_request = $request->json()->all();
        $param['year_month_from']       = $param_request['year_month_from'] . '/1';
        $param['year_month_to']         = $param_request['year_month_to'] . '/28';
        $param['report_kind']           = $param_request['report_kind'];
        $param['group']                 = $param_request['group'];
        $param['my_group']              = $param_request['my_group'];
        $param['reporter_cd']              = $param_request['reporter_cd'];
        $param['note_kind']             = $param_request['note_kind'];
        $param['free_word']             = $param_request['free_word'];
        $param['adequacy']              = $param_request['adequacy'] ?? 0;
        $param['busyness']              = $param_request['busyness'] ?? 0;
        $param['other']                 = $param_request['other'] ?? 0;
        $param['is_shared']             = $param_request['is_shared'] ?? 0;
        $param['position']              = $param_request['position'];
        $param['job']                   = $param_request['job'];
        $param['grade']                 = $param_request['grade'];
        $param['employee_typ']          = $param_request['employee_typ'];
        $param['approver_cd']            = $param_request['approver_cd'];
        $param['json']                  = $json;
        $param['page']                  = $param_request['page'] ?? 1;
        $param['page_size']             = $param_request['page_size'] ?? 20;
        $param['mode']                  = 0;
        $param['fiscal_year']           = $param_request['fiscal_year']?? $year;
        $reports = $this->WeeklyReportService->getReportsForPage($param);
        // check has reports 
        if (isset($reports[0])) {
            foreach ($reports[0] as $key => $value) {
                if ($value['note_json'] != '') {
                    $reports[0][$key]['note_json'] = $this->convertNoteEmployees(json_decode(htmlspecialchars_decode($value['note_json']), true));
                }
            }
        }
        $data['list'] = $reports[0] ?? [];
        $data['paging'] = $reports[1][0] ?? [];
        $data['M0022'] = getCombobox('M0022', 1, 5);
        $data['adequacy'] = $this->adequacy_service->getAdequacyByMarkKbn(1);
        $data['busyness'] = $this->adequacy_service->getAdequacyByMarkKbn(2);
        $data['other'] = $this->adequacy_service->getAdequacyByMarkKbn(3);
        $data['report_authority_typ'] = session_data()->report_authority_typ ?? 0;
        return view('WeeklyReport::rq2010.refer', array_merge($data));
    }

    /**
     * convertNoteEmployees
     *
     * @param  Array $notes
     * @return Array
     */
    public function convertNoteEmployees($notes = [])
    {
        // when has 1 note
        if (count($notes) < 2) {
            return $notes;
        }
        // when has many notes
        $notes_result[0] = $notes[0];
        $i = 1;
        foreach ($notes as $key => $note) {
            $is_exists = false;
            // when 2th record check exists note_no
            if ($key > 0) {
                foreach ($notes_result as $key_child => $value_child) {
                    if ($note['note_no'] == $value_child['note_no']) {
                        $notes_result[$key_child]['note_employee_nm'] = $notes_result[$key_child]['note_employee_nm'] . ','.$note['note_employee_nm'];
                        $is_exists = true;
                    }
                }
                // if has not existed in $notes_result
                if (!$is_exists) {
                    $notes_result[$i] = $note;
                    $i++;
                }
            }        
        }
        return $notes_result;
    }
    /**
     * export
     * @author namnt
     * @created at 2023-05-09
     * @return void
     */
	public function exportCSV(Request $request)
	{
		if ($request->ajax()) {
			$param_json = $request->json()->all() ?? [];
			if (count($param_json) == 0) {
				$param_json['fiscal_year']                      = date('Y');
				$param_json['group_cd']                   		= -1;
				$param_json['ck_search']                   		= 0;
				$param_json['list_treatment_applications_no']   = [];
				$param_json['list_organization_step1']          = [];
				$param_json['list_organization_step2']          = [];
				$param_json['list_organization_step3']          = [];
				$param_json['list_organization_step4']          = [];
				$param_json['list_organization_step5']          = [];
			}
			//
			$json = json_encode($param_json, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
			if (!validateJsonFormat($json)) {
				return response()->view('errors.query', [], 501);
			} else {
                $now = Carbon::now();
                $year = $now->year;
				$param_json = $request->json()->all();
				$json = json_encode($param_json, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
				//return request ajax
				$json_array = [];
                $json_array['list_organization_step1'] = ($request->json()->all())['list_organization_step1'] ?? [];
                $json_array['list_organization_step2'] = ($request->json()->all())['list_organization_step2'] ?? [];
                $json_array['list_organization_step3'] = ($request->json()->all())['list_organization_step3'] ?? [];
                $json_array['list_organization_step4'] = ($request->json()->all())['list_organization_step4'] ?? [];
                $json_array['list_organization_step5'] = ($request->json()->all())['list_organization_step5'] ?? [];
                $json_array['status'] = ($request->json()->all())['status'];
                // $param_json = ($request->json()->all())['list_organization_step2'];
                $json = json_encode($json_array, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
                $param_request = $request->json()->all();
                $param['year_month_from']       = $param_request['year_month_from'] . '/01';
                $param['year_month_to']         = $param_request['year_month_to'] . '/01';
                $param['report_kind']           = $param_request['report_kind'];
                $param['group']                 = $param_request['group'];
                $param['my_group']              = $param_request['my_group'];
                $param['reporter_cd']              = $param_request['reporter_cd'];
                $param['note_kind']             = $param_request['note_kind'];
                $param['free_word']             = $param_request['free_word'];
                $param['adequacy']              = $param_request['adequacy'] ?? 0;
                $param['busyness']              = $param_request['busyness'] ?? 0;
                $param['other']                 = $param_request['other'] ?? 0;
                $param['is_shared']             = $param_request['is_shared'] ?? 0;
                $param['position']              = $param_request['position'];
                $param['job']                   = $param_request['job'];
                $param['grade']                 = $param_request['grade'];
                $param['employee_typ']          = $param_request['employee_typ'];
                $param['approver_cd']            = $param_request['approver_cd'];
                $param['json']                  = $json;
                $param['page']                  = $param_request['page'] ?? 1;
                $param['page_size']             = $param_request['page_size'] ?? 20;
                $param['mode']                  = 1;
                $param['fiscal_year']           = $this->mirai->findFiscalYearFromDate(session_data()->company_cd,5,$param['year_month_to'] )?? $year;
				$result_row = $this->WeeklyReportService->getReportsForPage($param,true)[0];
                foreach($result_row as $key => $value) {
                    if($value['note_json'] != '') {
                    if(sizeof(json_decode(htmlspecialchars_decode($value['note_json']), true))>0) {
                        $note_csv = $this->convertNoteCSV(json_decode(htmlspecialchars_decode($value['note_json']), true));
                        $result_row[$key]['note_json'] = $note_csv['note_no'];
                        $result_row[$key]['note_emp_nm'] = $note_csv['note_employee_nm'];
                    }
                }
                }
                if(session_data()->language == 'en') {
                    $result_header_previous = ['Year','Report kind','Report no','Employee Code','Employee name'];
                    $result_header_after = ['Position name','Job name','Grade name','Employee type name','Title','Status name','Adequacy kbn','Busyness kbn','Other kbn','Question No 1','Answer 1','Question No 2','Answer 2','Question No 3','Answer 3','Question No 4','Answer 4','Question No 5','Answer 5','Question No 6','Answer 6','Question No 7','Answer 7','Question No 8','Answer 8','Question No 9','Answer 9','Question No 10','Answer 10','Free comment','Note number','Note employee name'];
                    $result_header[0] = array_merge($result_header_previous,$this->getNumberOrg(),$result_header_after);
                } else {
                    $result_header_previous = ['年度','報告書種類','報告書番号','社員番号','社員名'];
                    $result_header_after = ['役職','職種','等級','社員区分','タイトル','ステータス','充実度','繁忙度','その他','質問1','回答1','質問2','回答2','質問3','回答3','質問4','回答4','質問5','回答5','質問6','回答6','質問7','回答7','質問8','回答8','質問9','回答9','質問10','回答10','自由記入欄','付箋','付箋の社員名'];
                    $result_header[0] = array_merge($result_header_previous,$this->getNumberOrg(),$result_header_after);
                }
                
				if (isset($result_row[0][0]['error_typ']) && $result_row[0][0]['error_typ'] == '999') {
					$this->respon['status']     = EX;
					$this->respon['Exception']  = $e->getMessage();
					return response()->json($this->respon);
				} else {
					if (empty($result_row[0])) {
						$this->respon['status']     = NG; // no data
						return response()->json($this->respon);
					} else {
						//
                        $result = array();
                        $result[0][] = $result_header[0];
                        for($i=0;$i<sizeof($result_row);$i++)
                        {
                            $result[0][] = $result_row[$i];
                        }
						$date = date("Ymd_His") . substr((string)microtime(), 2, 4);
						$csvname = 'RQ1020' . $date . '.csv';
						$fileName =   $_SERVER['DOCUMENT_ROOT'] . '/download/' . $csvname;
						$fileNameReturn  = $this->saveCSV($fileName, $result);
						if ($fileNameReturn != '') {
							$this->respon['FileName'] = '/download/' . $fileNameReturn;
						} else {
							$this->respon['FileName'] = '';
						}
					}
					//
					return response()->json($this->respon);
				}
			}
		}
	}

    /**
     * convertNoteEmployees
     *
     * @param  Array $notes
     * @return Array
     */
    public function convertNoteCSV($json_note)
    {
        $array_csv = array();
        $array_csv['note_no']='';
        $array_csv['note_employee_nm']='';
        if(sizeof($json_note)>0) {
            foreach($json_note as $key => $value) {
                $array_csv['note_no'] .= '|'.$value['note_no'];
                $array_csv['note_employee_nm'] .= '|'.$value['note_employee_nm'];
            }
        }
        return $array_csv;
    }
    /**
     * postDelete
     *
     * @param  Request $request
     * @return void
     */
    public function postDelete(Request $request) {
        if ($request->ajax()) {
			try {
				$this->valid($request);
				if ($this->respon['status'] == OK) {
					$params['json']          =   $this->respon['data_sql'];
					$params['cre_user']      =   session_data()->user_id;
					$params['cre_ip']        =   $_SERVER['REMOTE_ADDR'];
					$params['company_cd']    =   session_data()->company_cd;
					$result = Dao::executeSql('SPC_RQ2010_ACT1', $params);
					if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
						return response()->view('errors.query', [], 501);
					} else if (isset($result[0]) && !empty($result[0])) {
						$res = [
							'status' => NG,
							'errors' => $result[0]
						];
						return response()->json($res);
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
     * getNumberOrg
     *
     * @param  Request $request
     * @return void
     */
    public function getNumberOrg() {
        $number = sizeof(getCombobox('M0022', 1, 5)); 
        $array_name_org = array();
        if( $number == 0) {
            $number = 1; //always has 1 org
        }
        for($i=1;$i<=$number;$i++) {
            if(session_data()->language == 'en') {
                $array_name_org[] = 'Organization name '.$i; 
            } else {
                $array_name_org[] = '組織'.$i; 
            }
        }
        return $array_name_org;
    }
    public function getFiscalYear(Request $request) {
        if ($request->ajax()) {
			try {
				if ($this->respon['status'] == OK) {
					$params['json']          =   $this->respon['data_sql'];
					$params['cre_user']      =   session_data()->user_id;
					$params['cre_ip']        =   $_SERVER['REMOTE_ADDR'];
					$params['company_cd']    =   session_data()->company_cd;
					$result =  $this->mirai->findFiscalYearFromDate(session_data()->company_cd,5,$request->date_from );
					if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
						return response()->view('errors.query', [], 501);
					} else if (isset($result[0]) && !empty($result[0])) {
						$res = [
							'status' => NG,
							'errors' => $result[0]
						];
						return response()->json($res);
					}
				}
			} catch (\Exception $e) {
				$this->respon['status']     = EX;
				$this->respon['Exception']  = $e->getMessage();
			}
			return response()->json($result);
		}
    }
}