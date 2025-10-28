<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Helpers\Dao;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Helpers\ANSFile;
use Carbon\Carbon;
use App\Services\APIService;


class cronjobKOT extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'cronjob:kot';
    private $api_service;

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'This command will upload information employee';
    /**
     * Create a new command instance.
     *
     * @return void
     */
    public function __construct(APIService $api_service)
    {
        parent::__construct();
        $this->api_service = $api_service;
    }

    /**
     * Execute the console command.
     *
     * @return mixed
     */
    public function handle()
    {
        $err_content = '';
        date_default_timezone_set('Asia/Tokyo');
        $current =  (int)date('Hi');
        //
        
        $employee_lists = $this->api_service->getListEmployeeKot('');
        $http = new \GuzzleHttp\Client;
        
        $url = '';
        if( count($employee_lists)> 0) {
            foreach($employee_lists as $employee_list) {
                if($employee_list['gender'] == '') {
                    $employee_list['gender'] ='male';
                }
                $access_token = $employee_list['access_token']??'';
                if($access_token != '') {
                    $headers = [
                        'Authorization' => 'Bearer ' . $access_token,
                    ];
                    $employee_list['emailAddresses']=[];
                    $code = $this->checkExistsEmployee($employee_list['code'],$access_token);
                    $data_response=[];
                    if($code != '') {
                    $response = $http->put('https://api.kingtime.jp/v1.0/employees/'.$code.'?updateDate=2024-10-21', [
                        'headers' => [
                        'Authorization' => 'Bearer '.$access_token,
                        'Accept' => 'application/json',
                        // Thêm các header khác nếu cần
                            ],
                            'body' =>json_encode($employee_list,JSON_UNESCAPED_UNICODE),
                        ]);
                        $this->setLog('', $url, $access_token, 'GET', '200', $data['errors'][0]['messages'][0] ?? '');
                    } else {
                        $response = $http->post('https://api.kingtime.jp/v1.0/employees', [
                            'headers' => [
                            'Authorization' => 'Bearer '.$access_token,
                            'Accept' => 'application/json',
                            // Thêm các header khác nếu cần
                                ],
                                'body' =>json_encode($employee_list,JSON_UNESCAPED_UNICODE),
                            ]);
                            $this->setLog('', 'https://api.kingtime.jp/v1.0/employees', $access_token, 'GET', '200', $data['errors'][0]['messages'][0] ?? '');
                    }
                    $data_response =  json_decode($response->getBody(), true);
                } else {
                    $this->setLog('', $url, $access_token, 'GET', '100', $data['errors'][0]['messages'][0] ?? '');
                }
            }
        }
    
    }
    public function setLog($company_cd, $link_api, $access_token, $method, $status, $message)
    {
        //    Logging
        $debug_api = 'company-refer: ' . $company_cd . ',  ' . $link_api . ' ,access token: ' . $access_token . ' , method: ' . $method . ' ,  status: ' . $status . ', message:  ' . $message;
        $time = date("Y-m-d H:i:s");
        $logFile = fopen(
            storage_path('logs' . DIRECTORY_SEPARATOR . date('Y-m-d') . '_API.log'),
            'a+'
        );
        // link url / method / status
        fwrite($logFile, $time . ': ' . $debug_api . PHP_EOL);
        fclose($logFile);
    }
    public function checkExistsEmployee($employee_cd = '',$access_token='') {
        $http = new \GuzzleHttp\Client;
            $headers = [
                'Authorization' => 'Bearer ' . $access_token,
            ];
            $url = '';
            $employee_list=[];
            $data_api = $http->get('https://api.kingtime.jp/v1.0/employees/'.$employee_cd, [
                'headers' => $headers,
            ]);
            $data = json_decode($data_api->getBody(), true);
            return $data['key']??'';
    }
}