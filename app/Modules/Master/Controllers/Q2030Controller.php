<?php
/**
 ****************************************************************************
 * MIRAI
 * Q2030Controller
 *
 * 処理概要/process overview   : Q2030Controller
 * 作成日/create date   : 2018-06-21 07:59:36
 * 作成者/creater    : quyentb
 *
 * 更新日/update date    : 2018/10/09
 * 更新者/updater    : sondh
 * 更新内容 /update content  :
 *
 *
 * @package         :  Master
 * @copyright       :  Copyright (c) ANS-ASIA
 * @version    :  1.0.0
 * **************************************************************************
 */
namespace App\Modules\Master\Controllers;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Dao;
use Carbon\Carbon;
use File;
use App\L0020;
class Q2030Controller extends Controller
{
	/**
     * Show the application index.
     * @author sondh
     * @created at 2018-10-10 07:59:36
     * @return \Illuminate\Http\Response
     */
	public function getIndex(Request $request)
	{
        $params = [
            'fiscal_year' => date('Y', time()),
            'user_id'     => session_data()->user_id ?? '',
            'company_cd'  => session_data()->company_cd, // set for demo
            'check_fiscal'=> 0,
        ];

		$data['category'] 		= trans('messages.personnel_assessment');
		$data['category_icon'] 	= 'fa fa-line-chart';
		$data['title'] = trans('messages.eval_analysis');
        $data['f0010'] = getCombobox('F0010',1);
		$res = Dao::executeSql('SPC_Q2030_INQ1',$params);
        if(isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999'){
            return response()->view('errors.query',[],501);
        }
       
		return view('Master::q2030.index',array_merge($data, $res))
            ->with('data',$data??[])
            ->with('f0010',$data['f0010']??[])
            ->with('m0020',$res[1]??[])
            ->with('m0130',[])
            ->with('f0011',$res[0]??[])
            ->with('M0022',getCombobox('M0022',1)??[])
            ->with('fiscal',$res[2][0]['fiscal_year']??[])
            ;
	}
	/**
     * Show the application index.
     * @author sondh
     * @created at 2018-10-10 07:59:36
     * @return void
     */
    public function postRefer(Request $request)
    {
    	if($request->ajax())
    	{
            $params = [
                'fiscal_year' => $request->fiscal_year,
                'user_id'     => session_data()->user_id ?? '',
                'company_cd'  => session_data()->company_cd,
                'check_fiscal'=> 1,
            ];
            $res = Dao::executeSql('SPC_Q2030_INQ1',$params);
            if(isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999'){
                return response()->view('errors.query',[],501);
            }
            return view('Master::q2030.refer_treatment')
                ->with('result',$res[0]??[]);
    	}
    }
    /**
     * Show the application index.
     * @author sondh
     * @created at 2018-10-10 07:59:36
     * @return void
     */
    public function postSearch(Request $request)
    {
        if($request->ajax())
        {
            $params = [
                'fiscal_year' => $request->fiscal_year,
                'treatment_applications_no' => $request->treatment_applications_no,
                'evaluation_step' => $request->evaluation_step,
                'organization_cd' => $request->organization_cd,
                'company_cd' => session_data()->company_cd,
                'user_id'    =>session_data()->user_id ?? '',
                'page_size'  => $request->page_size ?? 20,
                'page'       => $request->page ?? 1,
            ];
            $select_target_1 = $request->select_target_1;
            $data['m0130'] = getCombobox('M0130',1);
            if($select_target_1 == 1){
                $res = Dao::executeSql('SPC_Q2030_FND1',$params);
            }else if($select_target_1 == 2){
                $res = Dao::executeSql('SPC_Q2030_FND2',$params);
            }else if($select_target_1 == 3){
                $res = Dao::executeSql('SPC_Q2030_FND3',$params);
            }else if($select_target_1 == 4){
                $res = Dao::executeSql('SPC_Q2030_FND4',$params);
            }else{
                $res = Dao::executeSql('SPC_Q2030_FND5',$params);
            }
            if(isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999'){
                return response()->view('errors.query',[],501);
            }
            //
            $a_data = [];
            if (isset($res[0][0]['group_cd'])) {
                //lap de get con
                foreach ($res[0] as $row){
                    $i=0;
                    $group_cd = $row['group_cd'];
                    $a_child = [];
                    $data_value = [];
                    foreach ($res[1] as $item){
                        $group_cd_chk = $item['group_cd'];
                        if($group_cd == $group_cd_chk){
                            $data_value['group_cd'] = $item['group_cd'];
                            $data_value['rank_cd'] = $item['rank_cd'];
                            $data_value['result'] = $item['result'];
                            //
                            $a_child[$i] =$data_value;
                            //
                            $i = $i + 1;
                        }
                    }
                    $a_data[$group_cd] = $a_child;
                }
            }
            return view('Master::q2030.search')
                ->with('m0130',$res[4]??[])
                ->with('rank',$a_data??[])
                ->with('paging',$res[3][0]??[])
                ->with('result',$res??[]);
        }
    }
    /**
     * Show the application index.
     * @author sondh
     * @created at 2018-10-10 07:59:36
     * @return void
     */
    public function postReferDetail(Request $request)
    {
        if($request->ajax())
        {
            $params = [
                'fiscal_year' => $request->fiscal_year,
                'treatment_applications_no' => $request->treatment_applications_no,
                'evaluation_step' => $request->evaluation_step,
                'select_target_1' => $request->select_target_1,
                'organization_cd' => $request->organization_cd,
                'unit_display' => $request->unit_display,
                'rank_cd' => $request->rank_cd,
                'company_cd' => session_data()->company_cd,
                'user_id'    =>session_data()->user_id ?? '',
                'page_size'  => $request->page_size ?? 20,
                'page'       => $request->page ?? 1,
            ];
            if($request->select_target_1 == 5) {
                $res = Dao::executeSql('SPC_Q2030_INQ3', $params);
            }else{
                $res = Dao::executeSql('SPC_Q2030_INQ2',$params);
            }
            if(isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999'){
                return response()->view('errors.query',[],501);
            }
            return view('Master::q2030.refer_detail')
                ->with('paging',$res[1][0]??[])
                ->with('result',$res[0]??[])
                ->with('M0022',getCombobox('M0022',1)??[])
                ->with('M0020',getCombobox('M0020',1)??[]);
        }
    }
    /**
     * export
     * @author sondh
     * @created at 2018-10-15 08:13:36
     * @return void
     */
    public function postExport(Request $request)
    {
        try {
            $params = [
                'fiscal_year' => $request->fiscal_year,
                'treatment_applications_no' => $request->treatment_applications_no,
                'evaluation_step' => $request->evaluation_step,
                'select_target_1' => $request->select_target_1,
                'organization_cd' => $request->organization_cd,
                'unit_display' => $request->unit_display,
                'rank_cd' => $request->rank_cd,
                'company_cd' => session_data()->company_cd,
                'user_id'    =>session_data()->user_id ?? '',
            ];
            //
            if($request->select_target_1 == 5) {
                $result = Dao::executeSql('SPC_Q2030_RPT2',$params);
            }else{
                $result = Dao::executeSql('SPC_Q2030_RPT1',$params);
            }
            if(isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999'){
                return response()->view('errors.query',[],501);
            }
            //
            $date = date("Ymd_His") . substr((string)microtime(), 2, 4);
            $csvname = 'Q2030'.$date.'.csv';
            $fileName =   $_SERVER['DOCUMENT_ROOT'] . '/download/'.$csvname;
            if(count($result[0]) <=1) {
                $this->respon['status']     = NG;
                $this->respon['message']    = L0020::getText(21)->message;
                return response()->json($this->respon,401);
            } else {
                $fileNameReturn  = $this->saveCSV($fileName,$result);
                if($fileNameReturn != ''){
                    $this->respon['FileName'] = '/download/'.$fileNameReturn;
                }else{
                    $this->respon['FileName'] = '';
                }
            }
        } catch (\Exception $e) {
            $this->respon['status']     = EX;
            $this->respon['Exception']  = $e->getMessage();
        }
        return response()->json($this->respon);
    }
}