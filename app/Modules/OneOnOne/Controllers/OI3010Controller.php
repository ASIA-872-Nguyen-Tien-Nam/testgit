<?php

namespace App\Modules\OneOnOne\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Services\QuestionaryService;
use App\Services\OneOnOneService;
use Dao;
use Validator;
use Crypt;
use Illuminate\Validation\Rule;
use Illuminate\Contracts\Encryption\DecryptException;

class OI3010Controller extends Controller
{
    protected $QuestionaryService;
    protected $OneOnOneService;
    public function __construct(QuestionaryService $QuestionaryService, OneOnOneService $OneOnOneService)
    {
        parent::__construct();
        $this->QuestionaryService = $QuestionaryService;
        $this->OneOnOneService = $OneOnOneService;
    }
    /**
     * Show the application index.
     * @author mail@ans-asia.com
     * @created at 2020-09-04 08:32:43
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        $data['title'] = trans('messages.questionnaire_entry');
        $data['category'] = trans('messages.implement');
        $data['category_icon'] = 'fa fa-users';
        $data['image'] = 'template/image/icon/icon_2_write.png';
        //
        $redirect_param = $request->redirect_param ?? '';
        if ($redirect_param != '') {
            try {
                $redirect_param = json_decode(Crypt::decryptString($redirect_param));
            } catch (DecryptException $e) {
                return response()->view('errors.403');
            }
        }
        $reqs = [
            'company_cd'                    => session_data()->company_cd,
            'fiscal_year'                   => $redirect_param->fiscal_year_1on1 ?? 0,
            'group_cd'                      => $redirect_param->group_cd_1on1 ?? 0,
            'times'                         => $redirect_param->times ?? 0,
            'questionnaire_cd'              => $redirect_param->questionnaire_cd ?? 0,
            'employee_cd'                   => $redirect_param->employee_cd ?? '',
            'coach_cd'                      => $redirect_param->coach_cd ?? '',
            'from'                          => $redirect_param->from ?? '',
            'source_from'                   => $redirect_param->source_from ?? '',
        ];

        $validator = Validator::make($reqs, [
            'fiscal_year'       => ['integer'],
            'group_cd'          => ['integer'],
            'times'             => ['integer'],
            'questionnaire_cd'  => ['integer'],
            'from'  => [
                'string',
                Rule::in(['odashboard', 'odashboardmember', 'oi2010']),
            ],
            'source_from'  => [
                'string',
                Rule::in(['odashboard', 'odashboardmember', 'oq2020']),
            ],
        ]);
        if ($validator->fails()) {
            return response()->view('errors.query', [], 501);
        }
        //
        $res = $this->QuestionaryService->getQuestionary($reqs['company_cd'], $reqs['questionnaire_cd']);
        if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }

        if ($reqs['employee_cd'] == '') {
            $reqs['employee_cd'] = $reqs['coach_cd'];
            $reqs['coach_cd'] = '';
        }
        $coach_service = $this->OneOnOneService->getCoachByMember($reqs['company_cd'], $reqs['fiscal_year'], $reqs['employee_cd'], $reqs['coach_cd'], $reqs['times']);
        if (isset($coach_service[0][0]['error_typ']) && $coach_service[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        $params = [
            'company_cd'                    => $reqs['company_cd'],
            'fiscal_year'                   => $reqs['fiscal_year'],
            'group_cd'                      => $reqs['group_cd'],
            'times'                         => $reqs['times'],
            'questionnaire_cd'              => $reqs['questionnaire_cd'],
            'employee_cd'                   => $reqs['employee_cd'],
            'coach_cd'                      => $reqs['coach_cd'],
        ];
        $result = Dao::executeSql('SPC_OI3010_INQ1', $params);
        if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        $data['condition_m2400'] = $res[0] ?? [];
        $data['current_times'] = $res[2] ?? [];
        $data['coach_nm'] = $coach_service[0] ?? [];
        $data['member_nm'] = $coach_service[1] ?? [];
        $data['comment'] = $result[0] ?? [];
        $data['list_question'] = $result[1] ?? [];
        $data['check_status'] = $result[2] ?? [];
        $data['from'] = $reqs['from'] ?? '';
        $data['source_from'] = $reqs['source_from'] ?? '';
        return view('OneOnOne::oi3010.index', array_merge($data, $reqs));
    }

    /**
     * Save data
     * @author nghianm
     * @created at 2020/11/19
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
                $params['company_cd']   =   session_data()->company_cd;
                $res = Dao::executeSql('SPC_OI3010_ACT1', $params);
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
}
