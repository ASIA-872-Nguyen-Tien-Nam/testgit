<?php 

namespace App\Modules\WeeklyReport\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Services\WeeklyReport\QuestionService;
use App\Services\WeeklyReport\WeeklyReportService;
use Validator;

class RM0100Controller extends Controller
{
    protected $questionService;
    protected $weeklyReportService;
    public function __construct(QuestionService $questionService, WeeklyReportService $weeklyReportService) 
    {
        parent::__construct();
        $this->questionService      = $questionService;
        $this->weeklyReportService  = $weeklyReportService;
    }
    /**
     * Show the application index.
     * @author quangnd
     * @created at 2023/02/07
     * @return \Illuminate\Http\Response
     */
    public function getIndex(Request $request)
    {
        $data['title'] = trans('rm0100.question_master');
        // render view
        $left   = $this->getLeftContent($request);
        $right  = $this->getRightContent($request);
        return view('WeeklyReport::rm0100.index', array_merge($data, $left, $right));
    }
    /**
     * get left content
     * @author quangnd
     * @created at 2023/04/07
     * @return \Illuminate\Http\Response
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
            'page_size'     => 20,
            'company_cd'    => session_data()->company_cd,
            'language'      => session_data()->language,
        ];
        $data = [
            'search_key'    => htmlspecialchars($request->search_key) ?? '',
        ];
        //dd(1);
        $res = $this->questionService->findQuestions($params);
        if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        //
        $data['list']       = $res[0] ?? [];
        $data['paging']     = $res[1][0] ?? [];
        $data['company_mc'] = $res[2][0] ?? [];
        
        // render view
        if ($request->ajax()) {
            return view('WeeklyReport::rm0100.leftcontent', $data);
        } else {
            return $data;
        }
    }
    /**
     * get right content
     * @author quangnd
     * @created at 2023/04/07
     * @return \Illuminate\Http\Response
     */
    public function getRightContent(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'company_cd'            => 'integer',
            'report_kind'           => 'integer',
            'question_no'           => 'integer',
        ]);
        // validate Laravel
		if ($validator->fails()) {
			return response()->view('errors.query', [], 501);
		}
        $params = [
            'company_cd'    => $request->company_cd ?? 0,
            'report_kind'   => $request->report_kind ?? 0,              
            'question_no'   => $request->question_no ?? 0,
            'language'      => session_data()->language,
        ];
        $res = $this->questionService->getQuestion($params);
        if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        $report_kinds = $this->weeklyReportService->getReportKinds(session_data()->company_cd??0);
        $data['m4125']          = $res[0][0] ?? [];
        $data['m4126']          = $res[1] ?? [];
        $data['answer_kind']    = getCombobox(42);
        $data['answer_kbn']     = getCombobox(43);
        $data['report_kinds']   = $report_kinds[0] ?? [];
        //
        if ($request->ajax()) {
            return view('WeeklyReport::rm0100.rightcontent',$data);
        } else {
            return $data;
        }
    }
     /**
     * Save data
     * @author quangnd
     * @created at 2023/04/07
     * @return \Illuminate\Http\Response
     */
    public function postSave(Request $request)
    {
        if ( $request->ajax() )
		{
			try {
                $this->valid($request);
                if($this->respon['status'] == OK)
                {
                    $params['json']         =   $this->respon['data_sql'];
                    $params['cre_user']     =   session_data()->user_id;
                    $params['cre_ip']       =   $_SERVER['REMOTE_ADDR'];
                    $params['company_cd']   =   session_data()->company_cd;
                    // //
                    $result = $this->questionService->saveQuestion($params);
                    // check exception
                    if(isset($result[0][0]) && $result[0][0]['error_typ'] == '999'){
                        return response()->view('errors.query',[],501);
                    }else if(isset($result[0]) && !empty($result[0])){
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
     /**
     * Delete data
     * @author quangnd
     * @created at 2023/04/07
     * @return \Illuminate\Http\Response
     */
    public function postDelete(Request $request)
    {
        if ($request->ajax()) {
            try {
                $params['report_kind']           =   $request->report_kind;
                $params['question_no']           =   $request->question_no;
                $params['company_cd_refer']      =   $request->company_cd_refer;
                //
                $validator = Validator::make($params, [
                    'report_kind'               => 'integer',
                    'question_no'               => 'integer',
                    'company_cd_refer'          => 'integer|min:0',
                ]);
                //
                if ($validator->fails()) {
                    return response()->view('errors.query', [], 501);
                }
                $params['cre_user']                 =   session_data()->user_id;
                $params['cre_ip']                   =   $_SERVER['REMOTE_ADDR'];
                $params['company_cd']               =   session_data()->company_cd;
                // 
                $result = $this->questionService->deleteQuestion($params);
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