<?php

namespace App\Modules\Master\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Helpers\Service;
use App\Services\MyPurposeService;
use App\Services\MiraiService;
use Validator;

class Q9001Controller extends Controller
{
    /** MyPurposeService */
    private $my_purpose;
    /** MiraiService */
    private $mirai;

    public function __construct(MyPurposeService $my_purpose, MiraiService $mirai)
    {
        parent::__construct();
        $this->my_purpose = $my_purpose;
        $this->mirai = $mirai;
    }

    /**
     * Show the index.
     * @author namnt
     * @created at 2023/02/06
     * @return \Illuminate\Http\Response
     */
    public function getIndex(Request $request)
    {
        $data['title'] = trans('q9001.my_purpose_list');
        $system = $this->getSystem($request);
        $data['M0020'] = getCombobox('M0020', 1, $system);
        $data['M0030'] = getCombobox('M0030', 1, $system);
        $data['M0040'] = getCombobox('M0040', 1, $system);
        $data['M0050'] = getCombobox('M0050', 1, $system);
        $data['M0060'] = getCombobox('M0060', 1, $system);
        $data['M0022'] = getCombobox('M0022', 1, $system);
        $data['system'] = $system;
        // 
        $company_cd = session_data()->company_cd ?? 0;
        $data['fiscal_year'] = $this->mirai->findFiscalYearFromDate($company_cd, $system);
        return view('Master::q9001.index', $data);
    }

    /**
     * postSearch
     *
     * @param  Request $request
     * @return void
     */
    public function postSearch(Request $request)
    {
        $payload = $request->json()->all() ?? [];
        // validate
        $validator = Validator::make($payload, [
            // 'employee_cd' => 'integer',
            'position_cd' => 'integer',
            'job_cd' => 'integer',
            'grade' => 'integer',
            'employee_typ' => 'integer',
        ]);
        if ($validator->fails()) {
            return response()->json('Error', 501);
        }
        $json = json_encode($payload, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
        if (!validateJsonFormat($json)) {
            return response()->view('errors.query', [], 501);
        }
        $system = $this->getSystem($request);
        $params['json']         =   preventOScommand($json);
        $params['employee_cd']  =   session_data()->employee_cd;
        $params['cre_user']     =   session_data()->user_id;
        $params['company_cd']   =   session_data()->company_cd;
        $params['mode']         =   0; // mode search
        $params['system']       =   $system;
        $result = $this->my_purpose->find(preventOScommand($json), session_data()->user_id, session_data()->company_cd, 0, $system);
        if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        $data['purposes'] = $result[0] ?? [];
        $data['paging'] = $result[1][0] ?? [];
        //return request ajax
        return view('Master::q9001.refer', $data);
    }

    /**
     * postDownload
     *
     * @param  Request $request
     * @return void
     */
    public function postDownload(Request $request)
    {
        $payload = $request->json()->all() ?? [];
        // validate
        $validator = Validator::make($payload, [
            'employee_cd' => 'integer',
            'position_cd' => 'integer',
            'job_cd' => 'integer',
            'grade' => 'integer',
            'employee_typ' => 'integer',
        ]);
        if ($validator->fails()) {
            return response()->json('Error', 501);
        }
        $json = json_encode($payload, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE);
        if (!validateJsonFormat($json)) {
            return response()->view('errors.query', [], 501);
        }
        try {
            $params = array(
                preventOScommand($json),
                session_data()->user_id,
                session_data()->company_cd,
                1,
                $this->getSystem($request)
            );
            // 
            $store_name = 'SPC_Q9001_FND1';
            $typeReport = 'FNC_OUT_EXL';
            $screen = 'Q9001';
            $file_name = 'Q9001_' . time() . '.xlsx';
            $service = new Service();
            $result = $service->execute($typeReport, $store_name, $params, $screen, $file_name);
            if (isset($result['filename'])) {
                $result['path_file'] =  '/download/' . $result['filename'];
            }
            $name = 'マイパーパス一覧_';
            if (session_data()->language == 'en') {
                $name = 'MypurposeList_';
            }
            $result['fileNameSave'] =   $name . time() . '.xlsx';
            $this->respon = $result;
        } catch (\Exception $e) {
            $this->respon['status']     = EX;
            $this->respon['Exception']  = $e->getMessage();
        }
        // return http request
        return response()->json($this->respon);
    }

    /**
     * getSystem
     *
     * @param  Request $request
     * @return Int
     */
    public function getSystem(Request $request)
    {
        $screen = $request->segment(1);
        if (isset($screen) && $screen == 'weeklyreport') {
            $system = 5;
        } elseif (isset($screen) && $screen == 'basicsetting') {
            $system = 4;
        } elseif (isset($screen) && $screen == 'master') {
            $system = 1;
        } elseif (isset($screen) && $screen == 'multiview') {
            $system = 3;
        } elseif (isset($screen) && $screen == 'oneonone') {
            $system = 2;
        }
        return $system;
    }
}
