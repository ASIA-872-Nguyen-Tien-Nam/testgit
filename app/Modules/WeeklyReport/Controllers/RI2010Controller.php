<?php

namespace App\Modules\WeeklyReport\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Contracts\Encryption\DecryptException;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Validation\Rule;
use Validator;
use App\Services\WeeklyReport\WeeklyReportService;
use App\Services\WeeklyReport\PersonalTargetService;
use App\Services\WeeklyReport\AdequacyService;
use App\Services\WeeklyReport\ReactionService;
use App\Services\APINeoService;
class RI2010Controller extends Controller
{
    /** WeeklyReportService */
    public $weeklyreport_service;
    /** PersonalTargetService */
    public $target_service;
    /** AdequacyService */
    public $adequacy_service;
    /** ReactionService */
    public $reaction_service;
    public $api_neo_service;

    public function __construct(
        WeeklyReportService $weeklyreport_service,
        PersonalTargetService $target_service,
        AdequacyService $adequacy_service,
        ReactionService $reaction_service,
        APINeoService $api_neo_service
    ) {
        parent::__construct();
        $this->weeklyreport_service = $weeklyreport_service;
        $this->target_service = $target_service;
        $this->adequacy_service = $adequacy_service;
        $this->reaction_service = $reaction_service;
        $this->api_neo_service = $api_neo_service;
    }

    /*
     * index
     *
     * @param  Request $request
     * @return View
     */
    public function index(Request $request)
    {
        $data['title'] = trans('ri2010.screen_name');
        $data['screen_title'] = '2022年12月1週の週報';
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
        //FAKE DATA
        $company_cd = session_data()->company_cd ?? 0;
        $login_key = session_data()->login_key ?? '';
        $params['fiscal_year'] = $redirect_param->fiscal_year_weeklyreport ?? 0;
        $params['employee_cd'] = $redirect_param->employee_cd ?? '';
        $params['report_kind'] = $redirect_param->report_kind ?? 0;
        $params['report_no'] = $redirect_param->report_no ?? 0;
        $params['from'] = $redirect_param->from ?? '';
        $params['screen_id'] = $redirect_param->screen_id ?? '';
        $validator = Validator::make($params, [
            'fiscal_year' => ['integer'],
            'report_kind' => ['integer'],
            'report_no' => ['integer'],
            // 'list_report_no' => ['string'],
            'from'  => [
                'string',
                'required',
                Rule::in(['rdashboardreporter', 'rdashboardapprover', 'rdashboard', 'rq2010', 'rq2020', 'ri2010']),
            ],
            'screen_id'  => [
                'string',
                Rule::in(['rdashboardreporter_ri2010', 'rdashboardapprover_ri2010', 'rdashboard_ri2010', 'rq2010_ri2010', 'rq2020_ri2010', 'ri2010_ri2010']),
            ],
        ]);
        if ($validator->fails()) {
            return response()->view('errors.query', [], 501);
        }
        // get basic info
        $data['fiscal_year'] = $params['fiscal_year'] ?? 0;
        $data['report_kind'] = $params['report_kind'] ?? 0;
        $data['from'] = $params['from'] ?? '';
        // get target
        $target['target'] = $this->target_service->find($company_cd, $params['fiscal_year'], $params['employee_cd'], 0);
        // get report
        $report = $this->weeklyreport_service->findReportByCd($params['fiscal_year'], $params['employee_cd'], $params['report_kind'], $params['report_no'], $login_key);
        $employee = $report[0][0] ?? [];
        $paging = $report[1][0] ?? [];
        // has show paging in screen
        $data['is_paging'] = 0;
        if ($data['from'] == 'rdashboardreporter' ||  $data['from'] == 'rdashboardapprover' ||  $data['from'] == 'rdashboard' ||  $data['from'] == 'ri2010') {
            $data['is_paging'] = 1;
        }
        $organizations['organizations'] = getCombobox('M0022', 1);
        // 充実度 & 繁忙度 & その他
        $adequacy['adequacy'] = $this->adequacy_service->getAdequacyByMarkKbn(1);
        $adequacy['busyness'] = $this->adequacy_service->getAdequacyByMarkKbn(2);
        $adequacy['other'] = $this->adequacy_service->getAdequacyByMarkKbn(3);
        // get data master of 充実度 & 繁忙度 & その他
        $adequacy_1 = $this->adequacy_service->getAdequacy(1);
        $adequacy_2 = $this->adequacy_service->getAdequacy(2);
        $adequacy_3 = $this->adequacy_service->getAdequacy(3);
        $adequacy_master['adequacy_master'] =  $adequacy_1[0][0] ?? [];
        $adequacy_master['busyness_master'] =  $adequacy_2[0][0] ?? [];
        $adequacy_master['other_master'] = $adequacy_3[0][0] ?? [];
        $report_no_current = $paging['report_no_current'] ?? 0;
        $report_no_prev_1 = $paging['report_no_prev_1'] ?? 0;
        $report_no_prev_2 = $paging['report_no_prev_2'] ?? 0;
        $report_no_prev_3 = $paging['report_no_prev_3'] ?? 0;
        $report_current = [];
        $report_prev = [];
        // get permissions  
        $login_user_type = $this->weeklyreport_service->findLoginUserType($params['fiscal_year'], $params['employee_cd'], $params['report_kind'], $report_no_current);
        $permissions['permissions'] = $this->weeklyreport_service->findPermissonReportForUser($params['fiscal_year'], $params['employee_cd'], $params['report_kind'], $report_no_current, $login_user_type);
        if ($permissions['permissions']['login_use_typ'] == 0) {
            return response()->view('errors.403', [], 403);
        }
        $reaction_typ = $this->getCommentType($permissions['permissions']['login_use_typ'], $permissions['permissions']['admin_and_is_approver'], $permissions['permissions']['admin_and_is_viewer']);
        // Reactions
        $reactions['reactions_approver_viewer_reply'] =  $this->reaction_service->getReactionByMarkKbn(2);
        $reactions['reactions_reporter_reply'] =  $this->reaction_service->getReactionByMarkKbn(3);
        if ($permissions['permissions']['login_use_typ'] == 1) {
            $reactions['reactions'] = $reactions['reactions_reporter_reply'];
        } else {
            $reactions['reactions'] = $reactions['reactions_approver_viewer_reply'];
        }
        // 
        if ($report_no_current > 0) {
            $report_tmp = $this->weeklyreport_service->findReportDetailByCd($params['fiscal_year'], $params['employee_cd'], $params['report_kind'], $report_no_current, $reaction_typ);
            $report_current['report_current'] = $report_tmp[0][0] ?? [];
            $report_current['report_current_question'] = $report_tmp[1] ?? [];
        }
        if ($report_no_prev_1 > 0) {
            $report_tmp = $this->weeklyreport_service->findReportDetailByCd($params['fiscal_year'], $params['employee_cd'], $params['report_kind'], $report_no_prev_1, $reaction_typ);
            $report_prev['report_prev_1'] = $report_tmp[0][0] ?? [];
            $report_prev['report_prev_1_question'] = $report_tmp[1] ?? [];
        }
        if ($report_no_prev_2 > 0) {
            $report_tmp = $this->weeklyreport_service->findReportDetailByCd($params['fiscal_year'], $params['employee_cd'], $params['report_kind'], $report_no_prev_2, $reaction_typ);
            $report_prev['report_prev_2'] = $report_tmp[0][0] ?? [];
            $report_prev['report_prev_2_question'] = $report_tmp[1] ?? [];
        }
        if ($report_no_prev_3 > 0) {
            $report_tmp = $this->weeklyreport_service->findReportDetailByCd($params['fiscal_year'], $params['employee_cd'], $params['report_kind'], $report_no_prev_3, $reaction_typ);
            $report_prev['report_prev_3'] = $report_tmp[0][0] ?? [];
            $report_prev['report_prev_3_question'] = $report_tmp[1] ?? [];
        }
        $reaction_comments['reaction_comments'] = $this->weeklyreport_service->getReactionCommentsForReport($params['fiscal_year'], $params['employee_cd'], $params['report_kind'], $report_no_current, 0);
        $reaction_rejects['reaction_rejects'] = $this->weeklyreport_service->getReactionCommentsForReport($params['fiscal_year'], $params['employee_cd'], $params['report_kind'], $report_no_current, 1);
        $reaction_shareds['reaction_shareds'] = $this->weeklyreport_service->getReactionCommentsForReport($params['fiscal_year'], $params['employee_cd'], $params['report_kind'], $report_no_current, 2);
        // dd(array_merge($data, $employee, $paging, $target, $organizations, $report_prev, $report_current,$adequacy, $reactions,$permissions, $reaction_comments,$reaction_rejects,$reaction_shareds));

        $trans = $this->weeklyreport_service->findTranslate($params['fiscal_year'],$params['report_kind'],$params['report_no'],$params['employee_cd']);
        $data['supported_languages'] = $trans[0][0]['check_hide']??0;
        $data['language_name'] = $trans[0][0]['language_name']??'';
        $data['multilingual_use_typ'] = $trans[0][0]['multilingual_use_typ']??'';
        return view('WeeklyReport::ri2010.index', array_merge(
            $data,
            $employee,
            $paging,
            $target,
            $organizations,
            $report_prev,
            $report_current,
            $adequacy,
            $reactions,
            $permissions,
            $reaction_comments,
            $reaction_rejects,
            $reaction_shareds,
            $adequacy_master
        ));
    }

    /**
     * postSave
     *
     * @param  Request $request
     * @return void
     */
    public function postSave(Request $request)
    {
        $params = $request->all();
        $validator = Validator::make($params, [
            'fiscal_year' => ['integer'],
            'employee_cd' => ['max:10'],
            'report_kind' => ['integer'],
            'report_no' => ['integer'],
            'report_date' => ['nullable', 'date'],
            'adequacy_kbn' => ['nullable', 'integer'],
            'busyness_kbn' => ['nullable', 'integer'],
            'other_kbn' => ['nullable', 'integer'],
            'reaction_cd' => ['nullable', 'integer'],
            'free_comment' => ['nullable', 'max:1200'],
            'comment' => ['nullable', 'max:1200'],
            'set_default' => ['nullable', 'integer'],
            'admin_and_is_approver' => ['nullable', 'integer'],
            'admin_and_is_viewer' => ['nullable', 'integer'],
            'mode' => ['integer'],
            'questions.*.question_no' => ['nullable', 'integer'],
            'questions.*.answer_sentence' => ['nullable', 'max:1200'],
            'questions.*.answer_number' => ['nullable', 'numeric'],
            'questions.*.answer_select' => ['nullable', 'integer'],
            'questions.*.question_no' => ['nullable', 'integer'],
            'language_name' => ['nullable'],
            'multilingual_use_typ'=> ['nullable'],
            'lists.*.no_1' => ['nullable'],
            'lists.*.no_2' => ['nullable'],
            'lists.*.comment' => ['nullable', 'max:1200'],
            'lists.*.comment_1' => ['nullable', 'max:1200'],
            'lists.*.comment_2' => ['nullable', 'max:1200'],
            'lists.*.comment_3' => ['nullable', 'max:1200'],
            'lists.*.comment_4' => ['nullable', 'max:1200'],
            'lists.*.approver_comment' => ['nullable', 'max:1200'],
        ]);
        if ($validator->fails()) {
            return response()->view('errors.query', [], 501);
        }
        try {
            $response['status'] = OK;
            $response['errors'] = [];
            $login_user_type = $this->weeklyreport_service->findLoginUserType($params['fiscal_year'], $params['employee_cd'], $params['report_kind'], $params['report_no']);
            $report = $this->weeklyreport_service->saveReport($params, $login_user_type);
            if (isset($report[0][0]) && !empty($report[0][0])) {
                $response['status'] = NG;
                foreach ($report[0][0] as $temp) {
                    array_push($response['errors'], $temp);
                }             
                return response()->json($response);
            }  
            //
            $report_tr['fiscal_year'] = $params['fiscal_year']??0;
            $report_tr['employee_cd'] = $params['employee_cd']??'';
            $report_tr['report_kind'] = $params['report_kind']??0;
            $report_tr['report_no']   = $params['report_no']??0;
            $language_name = '日本語';//$params['language_name']??'';
            $check_f4204 = 0;
            $status_cd = 0;
            if (isset($report[1][0]['check_f4204'])) {
                $check_f4204 = $report[1][0]['check_f4204'] ?? 0;
                $status_cd = $report[1][0]['status_cd'] ?? 0;
            } else {
                $check_f4204 = $report[2][0]['check_f4204'] ?? 0;
                $status_cd = $report[2][0]['status_cd'] ?? 0;
            }
            $report_tr['status_cd']         = $status_cd;
            $report_tr['login_user_type']   = $login_user_type;
            //
            $exists = !empty(array_filter($params['lists'], function($item) {
                return in_array($item['type'], ['F4201_tr', 'F4202_tr']);
            }));
            if($exists){
                $report_tr['type']         =  'reject_tr';
                $sql = $this->weeklyreport_service->saveTranslate($report_tr,'');
                if (isset($sql[0][0]['error_typ']) && $sql[0][0]['error_typ'] == '999') {
                    return response()->view('errors.query', [], 501);
                }  
            }
            if(($params['multilingual_use_typ']??0)==1 && $params['language_name'] !=''){
                foreach ($params['lists'] as &$list) {
                    if(($list['type'] ?? '') == 'F4204_tr') {
                        $list['no_1'] = session_data()->employee_cd ?? '';
                    }                           
                    $report_tr['type']         = $list['type'] ?? '';
                    $report_tr['no_1']         = $list['no_1'] ?? '';
                    $report_tr['no_2']         = $list['no_2'] ?? '';
                    $report_tr['comment']      = '';
                    $report_tr['comment_1']    = '';
                    $report_tr['comment_2']    = '';
                    $report_tr['comment_3']    = '';
                    $report_tr['comment_4']    = '';
                    $report_tr['approver_comment'] = '';
                    if( ($list['type']== 'F4202_tr' || $list['type']== 'F4201_tr' ) && $list['comment'] != '' ){
                        $api = $this->api_neo_service->callNeoAI($params['language_name'],$language_name,$list['comment'],3);                 
                        $report_tr['comment'] = $api['content'];
                    }
                    if( $list['type']== 'F4202_tr' && $list['approver_comment'] != '' ){
                        $api = $this->api_neo_service->callNeoAI($params['language_name'],$language_name,$list['approver_comment'],3);                 
                        $report_tr['approver_comment'] = $api['content'];
                    }
                    if( $list['type']== 'F4204_tr' && $list['comment'] != '' && $check_f4204 == 1 ){
                        $api = $this->api_neo_service->callNeoAI($params['language_name'],$language_name,$list['comment'],4);                 
                        $report_tr['comment'] = $api['content'];
                    }
                    if (!isset($api) || ($report_tr['comment'] == '' && $report_tr['approver_comment'] == '')) {
                        continue; 
                    }
                    if($api['status'] == NG){
                        $response['status'] = EX;
                        $response['Exception'] = $api['content'];
                    }else{
                        $sql = $this->weeklyreport_service->saveTranslate($report_tr,'');
                        if (isset($sql[0][0]['error_typ']) && $sql[0][0]['error_typ'] == '999') {
                            return response()->view('errors.query', [], 501);
                        }  
                    }
                }
            }
        } catch (\Exception $e) {
            $response['status'] = EX;
            $response['Exception'] = $e->getMessage();
        }
        return response()->json($response);
    }

    /**
     * postReply
     *
     * @param  Request $request
     * @return void
     */
    public function postReply(Request $request)
    {
        $params = $request->all();
        $validator = Validator::make($params, [
            'fiscal_year' => ['integer'],
            'employee_cd' => ['max:10'],
            'report_kind' => ['integer'],
            'report_no' => ['integer'],
            'reaction_no' => ['max:10'],
            'reaction_type' => ['integer'],
            'reply_comment' => ['nullable', 'max:1200'],
            'reaction_cd' => ['nullable', 'integer'],
            'reply_cd' => ['nullable', 'integer'],
            'language_name' => ['nullable'],
            'multilingual_use_typ'=> ['nullable'],
            'lists.*.no_1' => ['nullable'],
            'lists.*.no_2' => ['nullable'],
            'lists.*.comment' => ['nullable', 'max:1200'],
            'lists.*.comment_1' => ['nullable', 'max:1200'],
            'lists.*.comment_2' => ['nullable', 'max:1200'],
            'lists.*.comment_3' => ['nullable', 'max:1200'],
            'lists.*.comment_4' => ['nullable', 'max:1200'],
            'lists.*.approver_comment' => ['nullable', 'max:1200'],
        ]);
        if ($validator->fails()) {
            return response()->view('errors.query', [], 501);
        }
        $param['fiscal_year']= $params['fiscal_year'];
        $param['employee_cd']= $params['employee_cd'];
        $param['report_kind']= $params['report_kind'];
        $param['report_no']= $params['report_no'];
        $param['reaction_no']= $params['reaction_no'];
        $param['reply_no']= $params['reply_no'];
        $param['reaction_type']= $params['reaction_type'];
        $param['reply_comment']= $params['reply_comment'];
        $param['reaction_cd']= $params['reaction_cd'];
        $param['reply_cd']= $params['reply_cd'];
        try {
            $response['status'] = OK;
            $response['errors'] = [];
            $report = $this->weeklyreport_service->replyReaction($param);
            if (isset($report[0][0]) && !empty($report[0][0])) {
                $response['status'] = NG;
                foreach ($report[0][0] as $temp) {
                    array_push($response['errors'], $temp);
                }             
                return response()->json($response);
            }  
             //
             $report_tr['fiscal_year'] = $params['fiscal_year']??0;
             $report_tr['employee_cd'] = $params['employee_cd']??'';
             $report_tr['report_kind'] = $params['report_kind']??0;
             $report_tr['report_no']   = $params['report_no']??0;
             $language_name = '日本語';//$params['language_name']??'';
             //
            if(($params['multilingual_use_typ']??0)==1 && $params['language_name'] !=''){
                foreach ($params['lists'] as &$list) {
                    if(($list['comment'] ?? '') != ''){
                        $report_tr['type']         = $list['type'] ?? '';
                        $report_tr['no_1']         = $list['no_1'] ?? '';
                        $report_tr['no_2']         = $report[1][0]['reply_no'] ?? 0;                             
                        $report_tr['comment']      = '';
                        $report_tr['comment_1']    = '';
                        $report_tr['comment_2']    = '';
                        $report_tr['comment_3']    = '';
                        $report_tr['comment_4']    = '';
                        $report_tr['approver_comment']    = '';
                        if( $list['comment'] != ''){
                            $api = $this->api_neo_service->callNeoAI($params['language_name'],$language_name,$list['comment'],4);                 
                            $report_tr['comment'] = $api['content'];
                        }
                        if (!isset($api) || $report_tr['comment'] == '') {
                            continue; 
                        }
                        if($api['status'] == NG){
                            $response['status'] = EX;
                            $response['Exception'] = $api['content'];
                        }else{
                            $sql = $this->weeklyreport_service->saveTranslate($report_tr,'');
                            if (isset($sql[0][0]['error_typ']) && $sql[0][0]['error_typ'] == '999') {
                                return response()->view('errors.query', [], 501);
                            }  
                        }
                    }
                }
            }
        } catch (\Exception $e) {
            $response['status'] = EX;
            $response['Exception'] = $e->getMessage();
        }
        return response()->json($response);
    }

    /**
     * postComment
     *
     * @param  Request $request
     * @return void
     */
    public function postComment(Request $request)
    {
        $params = $request->all();
        $validator = Validator::make($params, [
            'fiscal_year' => ['integer'],
            'employee_cd' => ['max:10'],
            'report_kind' => ['integer'],
            'report_no' => ['integer'],
            'reaction_no' => ['max:10'],
            'question_no' => ['integer'],
            'approver_comment' => ['nullable', 'max:1200'],
        ]);
        if ($validator->fails()) {
            return response()->view('errors.query', [], 501);
        }
        try {
            $response['status'] = OK;
            $response['errors'] = [];
            $report = $this->weeklyreport_service->saveComment($params);
            if (isset($report[0]) && !empty($report[0])) {
                $response['status'] = NG;
                foreach ($report[0] as $temp) {
                    array_push($response['errors'], $temp);
                }
            }
        } catch (\Exception $e) {
            $response['status'] = EX;
            $response['Exception'] = $e->getMessage();
        }
        return response()->json($response);
    }

    /**
     * getCommentType
     *
     * @param  Int $login_use_typ
     * @param  Int $admin_and_is_approver
     * @param  Int $admin_and_is_viewer
     * @return Int
     */
    function getCommentType($login_use_typ = 0, $admin_and_is_approver = 0, $admin_and_is_viewer = 0)
    {
        if ($login_use_typ >= 21 && $login_use_typ <= 24) {
            return 1; // 1.承認者
        }
        if ($login_use_typ == 3) {
            return 2; // 2.閲覧者
        }
        // admin is approver
        if ($login_use_typ == 4 && $admin_and_is_approver == 1) {
            return 1; // 1.承認者
        }
        // admin is viewer
        if ($login_use_typ == 4 && $admin_and_is_viewer == 1) {
            return 2; // 2.閲覧者
        }
        return 0;
    }
     /**
     * postTranslate
     *
     * @param  Request $request
     * @return void
     */
    public function postTranslate(Request $request)
    {
        $params = $request->all();

        $validator = Validator::make($params, [
            'fiscal_year' => ['integer'],
            'employee_cd' => ['max:10'],
            'report_kind' => ['integer'],
            'report_no'   => ['integer'],
            'language_name' => ['nullable'],
            'multilingual_use_typ'=> ['nullable'],
            'list.*.no_1' => ['nullable'],
            'list.*.no_2' => ['nullable'],
            'list.*.comment' => ['nullable', 'max:1200'],
            'list.*.comment_1' => ['nullable', 'max:1200'],
            'list.*.comment_2' => ['nullable', 'max:1200'],
            'list.*.comment_3' => ['nullable', 'max:1200'],
            'list.*.comment_4' => ['nullable', 'max:1200'],
            'list.*.approver_user_1' => ['nullable', 'max:50'],
            'list.*.approver_user_2' => ['nullable', 'max:50'],
            'list.*.approver_user_3' => ['nullable', 'max:50'],
            'list.*.approver_user_4' => ['nullable', 'max:50'],
            'list.*.approver_comment' => ['nullable', 'max:1200'],
        ]);
        //
        if ($validator->fails()) {
            return response()->view('errors.query', [], 501);
        }
        $response['status'] = OK;
        $response['errors'] = [];
        //
        $report['fiscal_year'] = $params['fiscal_year']??0;
        $report['employee_cd'] = $params['employee_cd']??'';
        $report['report_kind'] = $params['report_kind']??0;
        $report['report_no']   = $params['report_no']??0;
        $login_user_id = session_data()->user_id ?? '';
        $language_name = $params['language_name']??'';
        //
        if(($params['multilingual_use_typ']??0)==1 && $language_name !=''){
            foreach ($params['list'] as &$list) {
                $report['type']             = $list['type'] ?? '';
                $report['no_1']             = $list['no_1'] ?? '';
                $report['no_2']             = $list['no_2'] ?? '';
                $report['comment']          = '';
                $report['comment_1']        = '';
                $report['comment_2']        = '';
                $report['comment_3']        = '';
                $report['comment_4']        = '';
                $report['approver_comment'] = '';


                if( $list['type'] == 'F4201_tr' && $list['comment'] != '' && $list['user_id'] != $login_user_id){
                    $api = $this->api_neo_service->callNeoAI($list['source_lang'],$language_name,$list['comment'],3);                 
                    $report['comment'] = $api['content'];
                }
                if( $list['type'] == 'F4202_tr' && $list['comment'] != '' && $list['user_id'] != $login_user_id){
                    $api = $this->api_neo_service->callNeoAI($list['source_lang'],$language_name,$list['comment'],3);                 
                    $report['comment'] = $api['content'];
                }
                if( $list['type'] == 'F4202_tr' && $list['comment_1'] != '' && $list['approver_user_1'] != $login_user_id){
                    $api = $this->api_neo_service->callNeoAI($list['source_lang_1'],$language_name,$list['comment_1'],3);                 
                    $report['comment_1'] = $api['content'];
                }
                if( $list['type'] == 'F4202_tr' && $list['comment_2'] != '' && $list['approver_user_2'] != $login_user_id){
                    $api = $this->api_neo_service->callNeoAI($list['source_lang_2'],$language_name,$list['comment_2'],3);                 
                    $report['comment_2'] = $api['content'];
                }
                if( $list['type'] == 'F4202_tr' && $list['comment_3'] != '' && $list['approver_user_3'] != $login_user_id){
                    $api = $this->api_neo_service->callNeoAI($list['source_lang_3'],$language_name,$list['comment_3'],3);                 
                    $report['comment_3'] = $api['content'];
                }
                if( $list['type'] == 'F4202_tr' && $list['comment_4'] != '' && $list['approver_user_4'] != $login_user_id){
                    $api = $this->api_neo_service->callNeoAI($list['source_lang_4'],$language_name,$list['comment_4'],3);                 
                    $report['comment_4'] = $api['content'];
                }
                if( $list['type'] == 'F4204_tr' && $list['comment'] != '' && $list['user_id'] != $login_user_id && $list['user_id'] != ''){
                    $api = $this->api_neo_service->callNeoAI($list['source_lang'],$language_name,$list['comment'],4);                 
                    $report['comment'] = $api['content'];
                }
                if( $list['type'] == 'F4205_tr' && $list['comment'] != '' && $list['user_id'] != $login_user_id && $list['user_id'] != ''){
                    $api = $this->api_neo_service->callNeoAI($list['source_lang'],$language_name,$list['comment'],4);                 
                    $report['comment'] = $api['content'];
                }  
                if (!isset($api) || ($list['type'] != 'F4202_tr' && $report['comment'] == '' && $report['comment_1'] == ''&& $report['comment_2'] == ''&& $report['comment_3'] == ''&& $report['comment_4'] == ''&&$report['approver_comment'] == '')) {
                    continue; 
                }
                if(isset($api) && $api['status'] == NG){
                    $response['status'] = EX;
                    $response['Exception'] = $api['content'];
                }else{
                    $sql = $this->weeklyreport_service->saveTranslate($report,$login_user_id);
                    if (isset($sql[0][0]['error_typ']) && $sql[0][0]['error_typ'] == '999') {
                        return response()->view('errors.query', [], 501);
                    }  
                }
            }
        }
        return response()->json($response);
    }
     /**
     * loadRight
     *
     * @param  Request $request
     * @return void
     */
    public function loadRight(Request $request)
    {
        $params = $request->all();
        $validator = Validator::make($params, [
            'fiscal_year' => ['integer'],
            'employee_cd' => ['max:10'],
            'report_kind' => ['integer'],
            'report_no' => ['integer'],
        ]);
        if ($validator->fails()) {
            return response()->view('errors.query', [], 501);
        }
        // get permissions  
        $login_user_type = $this->weeklyreport_service->findLoginUserType($params['fiscal_year'], $params['employee_cd'], $params['report_kind'], $params['report_no']);
        $permissions['permissions'] = $this->weeklyreport_service->findPermissonReportForUser($params['fiscal_year'], $params['employee_cd'], $params['report_kind'], $params['report_no'], $login_user_type);
        if ($permissions['permissions']['login_use_typ'] == 0) {
            return response()->view('errors.403', [], 403);
        }
        // Reactions
        $reactions['reactions_approver_viewer_reply'] =  $this->reaction_service->getReactionByMarkKbn(2);
        $reactions['reactions_reporter_reply'] =  $this->reaction_service->getReactionByMarkKbn(3);
        if ($permissions['permissions']['login_use_typ'] == 1) {
            $reactions['reactions'] = $reactions['reactions_reporter_reply'];
        } else {
            $reactions['reactions'] = $reactions['reactions_approver_viewer_reply'];
        }
        //
        $reaction_comments['reaction_comments'] = $this->weeklyreport_service->getReactionCommentsForReport($params['fiscal_year'], $params['employee_cd'], $params['report_kind'], $params['report_no'], 0);
        $reaction_rejects['reaction_rejects'] = $this->weeklyreport_service->getReactionCommentsForReport($params['fiscal_year'], $params['employee_cd'], $params['report_kind'], $params['report_no'], 1);
        $reaction_shareds['reaction_shareds'] = $this->weeklyreport_service->getReactionCommentsForReport($params['fiscal_year'], $params['employee_cd'], $params['report_kind'], $params['report_no'], 2); 
        return view('WeeklyReport::ri2010.rightContent', array_merge(
            $reaction_comments,
            $reaction_rejects,
            $reaction_shareds,
            $reactions
        ));
    }
}
