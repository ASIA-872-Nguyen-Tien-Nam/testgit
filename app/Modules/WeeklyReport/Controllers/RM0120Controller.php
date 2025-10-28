<?php

namespace App\Modules\WeeklyReport\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Services\WeeklyReport\ReactionService;
use Validator;

class RM0120Controller extends Controller
{
    protected $reactionService;
    public function __construct(ReactionService $reactionService)
    {
        parent::__construct();
        $this->reactionService = $reactionService;
    }
    /**
     * Show the application index.
     * @author quangnd 
     * @created at 2023/02/07
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        $data['title']           = trans('rm0120.reaction_master');
        // render view
        $left = $this->getLeftContent($request);
        $right         = $this->getReaction();
        $right['data_header']['name'] = $right['data_select'][0]['name']??'';
        return view('WeeklyReport::rm0120.index',  array_merge($data, $left, $right));
    }

    /**
     * get left content
     * @author duongntt
     * @created at 2018-08-20
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
            'page_size'     => 10,
            'company_cd'    => session_data()->company_cd,
        ];
        $data = [
            'search_key'    => htmlspecialchars($request->search_key) ?? '',
        ];
        $res = $this->reactionService->getLeftContent($params);
        if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        //
        $data['list']       = $res[0] ?? [];
        $data['paging']     = $res[1][0] ?? [];
        // render view
        if ($request->ajax()) {
            return view('WeeklyReport::rm0120.leftcontent', $data);
        } else {
            return $data;
        }
    }
    /**
     * refer call services and change key
     * @author quangnd 
     * @created at 2023/04/13
     * @return \Illuminate\Http\Response
     */
    public function getReaction($mark_kbn = 1, $mode = 0)
    {
        $data['data_select']     = getCombobox(36);
        $data['data_radio']      = getCombobox(37);
        $data['data_image2']     = getCombobox(48);
        $data['data_image3']     = getCombobox(50); 
        $data['points']          = [10, 6.6, 3.3, 0];
        
        if ($mode == 1) {
            $data_adequacy_service = $this->reactionService->getReaction($mark_kbn);
            if ((isset($data_adequacy_service[0][0]['error_typ']) && $data_adequacy_service[0][0]['error_typ'] == '999')) {
                return response()->view('errors.query', [], 501);
            }
            $data['data_header']     = $data_adequacy_service[0][0] ?? [];
        }
        return $data;
    }
    /**
     * get right content
     * @author quangnd
     * @created at 2023/04/07
     * @return \Illuminate\Http\Response
     */
    public function getRightContent(Request $request)
    {
        if ($request->ajax()) {
            $validator = Validator::make($request->all(), [
                'mark_kbn'            => 'integer',
            ]);
            // validate Laravel
            if ($validator->fails()) {
                return response()->view('errors.query', [], 501);
            }
            $mark_kbn    = $request->mark_kbn ?? 1;
            $data = $this->getReaction($mark_kbn, 1);
            return view('WeeklyReport::rm0120.refer', $data);
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
        if ($request->ajax()) {
            try {
                $this->valid($request);
                if ($this->respon['status'] == OK) {
                    $params['json']         =   $this->respon['data_sql'];
                    $params['cre_user']     =   session_data()->user_id;
                    $params['cre_ip']       =   $_SERVER['REMOTE_ADDR'];
                    $params['company_cd']   =   session_data()->company_cd;
                    $result = $this->reactionService->saveReaction($params);
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
    /**
     * remove data.
    * @author quangnd
    * @created at 2023/04/07
    * @return \Illuminate\Http\Response
    */
    public function postDelete(Request $request)
    {
        if ($request->ajax()) {
            try {
                    $validator = Validator::make($request->all(), [
                        'mark_kbn'             => 'integer',
                    ]);
                    if ($validator->fails()) {
                        return response()->view('errors.query', [], 501);
                    }
                    $mark_kbn          = $request->mark_kbn ?? 0;
                    $result = $this->reactionService->deleteReaction($mark_kbn);
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
