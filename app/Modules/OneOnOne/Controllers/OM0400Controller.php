<?php

namespace App\Modules\OneOnOne\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Validator;
use App\Services\QuestionaryService;

class OM0400Controller extends Controller
{
    protected $QuestionaryService;
    public function __construct(QuestionaryService $QuestionaryService)
    {
        parent::__construct();
        $this->QuestionaryService = $QuestionaryService;
    }
    /**
     * Show the application index.
     * @author mail@ans-asia.com 
     * @created at 2020-09-04 08:32:27
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        $data['category']       = trans('messages.questionnaire');
        $data['category_icon']  = 'fa fa-clipboard';
        $data['title']          = trans('messages.questionnaire_master');
        $left = $this->getLeftContent($request);
        //
        return view('OneOnOne::om0400.index', array_merge($data, $left));
    }
    /**
     * get left content
     * @author nghianm
     * @created at 2020-10-26
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
        $res = $this->QuestionaryService->findQuestionarys($params['company_cd'], $params['search_key'], $params['current_page'], $params['page_size'], 0, 0);
        // render view
        if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        $data['list']       = $res[0] ?? [];
        $data['paging']     = $res[1][0] ?? [];
        if ($request->ajax()) {
            return view('OneOnOne::om0400.leftcontent', $data);
        } else {
            return $data;
        }
    }
    /**
     * get right content
     * @author nghianm
     * @created at 2020/10/26
     * @return \Illuminate\Http\Response
     */
    public function getRightContent(Request $request)
    {
        $params = [
            'questionnaire_cd'          => $request->questionnaire_cd ?? 0,
            'company_cd'                => $request->company_cd ?? 0,
        ];
        $validator = Validator::make($params, [
            'questionnaire_cd'          => 'integer',
            'company_cd'                => 'integer',
        ]);
        if ($validator->fails()) {
            return response()->view('errors.query', [], 501);
        }
        $res = $this->QuestionaryService->getQuestionary($params['company_cd'], $params['questionnaire_cd']);
        if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        if (session_data()->contract_company_attribute  == 1) {
            $data['mode']          = 'MC';
        } else {
            $data['mode']          = 'user_company';
        }
        $data['listm2400'] = $res[0][0] ?? [];
        $data['listm2401'] = $res[1] ?? [];
        return view('OneOnOne::om0400.rightcontent', $data);
    }
    /**
     * Save data
     * @author nghianm
     * @created at 2020/10/26
     * @return \Illuminate\Http\Response
     */
    public function postSave(Request $request)
    {
        try {
            $this->valid($request);
            if ($this->respon['status'] == OK) {
                $params['json']         =   $this->respon['data_sql'];
                $params['cre_user']     =   session_data()->user_id;
                $params['cre_ip']       =   $_SERVER['REMOTE_ADDR'];
                $params['company_cd']   =   session_data()->contract_company_attribute == 1 ? 0 : session_data()->company_cd;
                // $result = Dao::executeSql('SPC_S0020_ACT1',$params);
                $res = $this->QuestionaryService->saveQuestionary($params['company_cd'], $params);
                // check exception
                if (isset($res[0][0]) && $res[0][0]['error_typ'] == '999') {
                    return response()->view('errors.query', [], 501);
                } else if (isset($res[0]) && !empty($res[0])) {
                    $this->respon['status'] = NG;
                    foreach ($res[0] as $temp) {
                        array_push($this->respon['errors'], $temp);
                    }
                }
                if (isset($res[1][0])) {
                    $this->respon['authority_cd']     = $res[1][0]['authority_cd'];
                }
            }
        } catch (\Exception $e) {
            $this->respon['status']     = EX;
            $this->respon['Exception']  = $e->getMessage();
        }
        return response()->json($this->respon);
    }
    /**
     * Delete data
     * @author nghianm
     * @created at 2020/10/26
     * @return \Illuminate\Http\Response
     */
    public function postDelete(Request $request)
    {
        try {
            $params = [
                'questionnaire_cd'          => $request->questionnaire_cd ?? 0,
                'company_cd'                => session_data()->company_cd, // set for demo
            ];
            $validator = Validator::make($params, [
                'questionnaire_cd'  => 'integer',
                'company_cd'        => 'integer',
            ]);
            if ($validator->fails()) {
                return response()->view('errors.query', [], 501);
            }
            $params['questionnaire_cd']             =   $request->questionnaire_cd;
            $params['cre_user']                     =   session_data()->user_id;
            $params['cre_ip']                       =   $_SERVER['REMOTE_ADDR'];
            $params['company_cd']                   =   session_data()->contract_company_attribute == 1 ? 0 : session_data()->company_cd;
            //
            $res = $this->QuestionaryService->deleteQuestionary($params['company_cd'], $params);
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
