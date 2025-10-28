<?php
/**
 ****************************************************************************
 * MIRAI
 * M0080Controller
 *
 * 処理概要/process overview   : M0080Controller
 * 作成日/create date   : 2020-09-24
 * 作成者/creater    : nghianm@ans-asia.com
 *
 *
 * @package         :  Master
 * @copyright       :  Copyright (c) ANS-ASIA
 * @version         :  1.0.0
 * **************************************************************************
 */
namespace App\Modules\BasicSetting\Controllers;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Validator;
use App\Services\ItemService;
class M0080Controller extends Controller
{
    protected $ItemService;
    public function __construct(ItemService $ItemService)
    {
       parent::__construct();
       $this->ItemService = $ItemService;
    }
    /**
     * Show the application index.
     * @author nghianm@ans-asia.com
     * @created at 2020-09-24
     * @return \Illuminate\Http\Response
     */
    public function getIndex(Request $request)
    {
        $data['category']       = trans('messages.home');
        $data['category_icon']  = 'fa fa-server';
        $data['title'] = trans('messages.optional_information_master');
        $data['library_19'] = getCombobox('19',0);
        $left = $this->getLeftContent($request);
        return view('BasicSetting::m0080.index', array_merge($data, $left));
    }
    /**
     * get left content
     * @author nghianm
     * @created at 2020-09-24
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
            'search_key' => SQLEscape($request->search_key??''),
            'current_page' => $request->current_page??1,
            'page_size' => 10,
            'company_cd' => session_data()->company_cd, // set for demo
        ];
        // $data = $params;      
        $res = $this->ItemService->findItems($params['company_cd'],$params['search_key']
        ,$params['current_page'],$params['page_size']);
        $data['search_key'] = htmlspecialchars($request->search_key) ?? '';
        $data['list'] = $res[0] ?? [];
        $data['paging'] = $res[1][0] ?? [];
        $data['list_authority'] = $res[2] ?? [];
        // render view
        if ( $request->ajax() ){
            if(isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999'){
                return response()->view('errors.query',[],501);
            }
            return view('BasicSetting::m0080.leftcontent', $data);
        }
        else{
            if(isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999'){
                return array('error_typ'=>'999');
            }
            return $data;
        }
    }
    /**
     * get right content
     * @author nghianm
     * @created at 2020/09/24
     * @return \Illuminate\Http\Response
     */
    public function getRightContent(Request $request)
    {
        $request_all         = $request->all();
        $validator = Validator::make($request_all, [
            'item_cd' => 'integer',
        ]);
		// validate
		if ($validator->fails()) {
			return response()->view('errors.query', [], 501);
		}
        if ($request->ajax()){
            $params = [
                'item_cd' => $request->item_cd ?? 0,
                'company_cd' => session_data()->company_cd, // set for demo
            ];
            $res = $this->ItemService->getItem($params['company_cd'],$params['item_cd']);
            if(isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999'){
                return response()->view('errors.query',[],501);
            }
            $data['listm0080'] = $res[0][0] ??[];
            $data['listm0081'] = $res[1] ??[];
            $data['listm0082'] = $res[2] ??[];
            $data['list_authority'] = $res[3] ??[];
            $data['library_19'] = getCombobox('19',0);
            return view('BasicSetting::m0080.rightcontent',$data);
            }
        return response()->view('errors.query',[],501);
    }
    /**
     * Save data
     * @author nghianm
     * @created at 2020-09-25
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
                    //$result = Dao::executeSql('SPC_S0020_ACT1',$params);
                    $res = $this->ItemService->saveItem($params['company_cd'] ,$params);
                    // check exception
                    if(isset($res[0][0]) && $res[0][0]['error_typ'] == '999'){
                        return response()->view('errors.query',[],501);
                    }else if(isset($res[0]) && !empty($res[0])){
                        $this->respon['status'] = NG;
                        foreach ($res[0] as $temp) {
                            array_push($this->respon['errors'], $temp);
                        }
                    }
                    if(isset($res[1][0])){
                        $this->respon['authority_cd']     = $res[1][0]['authority_cd'];
                    }
                }
            } catch (\Exception $e) {
                $this->respon['status']     = EX;
                $this->respon['Exception']  = $e->getMessage();
            }
            return response()->json($this->respon);
        }
        return 'Silent is golden.';
    }
    /**
     * Delete data
     * @author nghianm
     * @created at 2020/09/28
     * @return \Illuminate\Http\Response
     */
    public function postDelete(Request $request)
    {
        $request_all         = $request->all();
        $validator = Validator::make($request->all(), [
            'item_cd' => 'integer',
        ]);
		// validate
		if ($validator->fails()) {
			return response()->view('errors.query', [], 501);
		}
        if ( $request->ajax() )
        {
            try {
                $params = [
                'item_cd' => $request->item_cd ?? 0,
                'company_cd' => session_data()->company_cd, // set for demo
                ];
                $params['item_cd']       =   $request->item_cd ?? 0;
                $params['cre_user']      =   session_data()->user_id;
                $params['cre_ip']        =   $_SERVER['REMOTE_ADDR'];
                $params['company_cd']    =   session_data()->company_cd;
                //
                $res = $this->ItemService->deleteItem($params['company_cd'] ,$params);
                // check exception
                if(isset($res[0][0]) && $res[0][0]['error_typ'] == '999'){
                    return response()->view('errors.query',[],501);
                }else if(isset($res[0]) && !empty($res[0])){
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
        return 'Silent is golden.';
    }
}