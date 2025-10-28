<?php

/**
 ****************************************************************************
 * 
 * S0001Controller
 *
 * 処理概要/process overview   : 
 * 作成日/create date   : 
 * 作成者/creater    : 
 *
 * 更新日/update date    :
 * 更新者/updater    :
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
use Validator;
use Carbon\Carbon;
use Illuminate\Http\Response;
use Session;
use App\Helpers\Service;
use App\Helpers\Dao;
use League\OAuth2\Client\Provider\Exception\IdentityProviderException;
use League\OAuth2\Client\Provider\Google;



class S0001Controller extends Controller
{
    private $client_id;
    private $client_secret;
    private $redirect_uri;
    private $provider;
    private $google_options;
    
    /**
     * Default Constructor
     */
    public function __construct()
    {
        parent::__construct();
        $this->redirect_uri = env('GOOGLE_REDIRECT_URI');
        $this->google_options = [
            'scope' => [
                'https://mail.google.com/'
            ]
        ];
        $sql = Dao::executeSql('SPC_S0001_INQ1');
        $params = [
            'clientId'      => $sql[0][0]['client_id']??'',
            'clientSecret'  => $sql[0][0]['client_secret']??'',
            'redirectUri'   => $this->redirect_uri,
            'accessType'    => 'offline',
            'prompt'        =>'consent',
        ];
        // Create Google Provider
        $this->provider = new Google($params);
    }
    /**
     * Show the application index.
     * @author viettd
     * @created at 2018-06-25 04:28:05
     * @return \Illuminate\Http\Response
     */
    public function getIndex()
    {
        $data['title'] = trans('messages.manage_setting_screen');
        $sql = Dao::executeSql('SPC_S0001_INQ1');
        if(isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999'){
            return response()->view('errors.query',[],501);
        }
		$data['S0001'] = $sql[0] ?? [];
        $data['S0002'] = $sql[1] ?? [];
        return view('Master::s0001.index',$data);
    }
    
    /**
     * Generate url to retreive token
     */
    public function directAuth(Request $request)
    {
        $redirect_uri = $this->provider->getAuthorizationUrl($this->google_options);
        return $redirect_uri;
    }

    /**
     * Retreive Token 
     */
    public function googleCallback(Request $request)
    {
        try {
            if(!$request->get('code')) {
                return redirect('customer/master/s0001');
            }
            $code = $request->get('code');
           
            // Generate Token From Code 
            $tokenObj = $this->provider->getAccessToken(
                'authorization_code',
                [
                    'code' => $code
                ]
                );
                $params = [
                    'access_token'  => $tokenObj->getToken(),
                    'refresh_token' => $tokenObj->getRefreshToken(),
                    'expiry_date'   => date('m/d/Y H:i:s', $tokenObj->getExpires()),
                    'cre_user'    =>   session_data()->user_id,
                    'cre_ip'      =>   $_SERVER['REMOTE_ADDR'],
                    'company_cd'   =>   session_data()->company_cd,
                ];
                // $data = $params;
                $res = Dao::executeSql('SPC_S0001_ACT2', $params);
                if(isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999'){
                    return response()->view('errors.query',[],501);
                }
                return redirect('customer/master/s0001');
        } catch(IdentityProviderException $e) {
            return response()->view('errors.query',[],501);
        }
    }
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
                    //
                    $result = Dao::executeSql('SPC_S0001_ACT1',$params);
                    // check exception
                    if(isset($result[0][0]) && $result[0][0]['error_typ'] == '999'){
                        return response()->view('errors.query',[],501);
                    }else if(isset($result[0]) && !empty($result[0])){
                        $this->respon['status'] = NG;
                        foreach ($result[0] as $temp) {
                            array_push($this->respon['errors'], $temp);
                        }
                    }
                    if(isset($result[1][0])){
                        $this->respon['position_cd']     = $result[1][0]['position_cd'];
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
