<?php

namespace App\Http\Middleware;

use Closure;
use Dao;
use Validator;
use Crypt;
use Illuminate\Contracts\Encryption\DecryptException;

class EvaluationPermission
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @return mixed
     */
    public function handle($request, Closure $next)
    {
        $redirect_param = $request->redirect_param ?? '';
        // 
        if ($redirect_param != '') {
            try {
                $redirect_param = json_decode(Crypt::decryptString($redirect_param));
            } catch (DecryptException $e) {
                return response()->view('errors.403');
            }
        }
        $reqs = [
            'fiscal_year'   => $redirect_param->fiscal_year ?? date('Y'),
            'employee_cd'   => $redirect_param->employee_cd ?? '',
            'sheet_cd'  => $redirect_param->sheet_cd ?? 0,
        ];
        $validator = Validator::make($reqs, [
            'fiscal_year' => ['integer'],
            'sheet_cd' => ['integer'],
        ]);
        if ($validator->fails()) {
            return response()->view('errors.query', [], 501);
        }
        $params['fiscal_year'] = $reqs['fiscal_year'] ?? 0;
        $params['employee_cd'] = $reqs['employee_cd'] ?? '';
        $params['sheet_cd'] = $reqs['sheet_cd'] ?? 0;
        $params['cre_user'] = session_data()->user_id;
        $params['company_cd']   = session_data()->company_cd;
        //
        $result = Dao::executeSql('SPC_EVALUATION_PERMISSION_CHK1', $params);
        if (isset($result[0][0]['error_typ']) && $result[0][0]['error_typ'] == '999') {
            // return 501 error
            return response()->view('errors.query', [], 501);
        }
        //
        if (isset($result[0][0]['authority']) && $result[0][0]['authority'] == 0) {
            if ($request->ajax()) {
                return response()->json([
                    'errors' => 'Permission denied'
                ], 403);
            }
            return response()->view('errors.403');
        }
        // pass
        return $next($request);
    }
}
