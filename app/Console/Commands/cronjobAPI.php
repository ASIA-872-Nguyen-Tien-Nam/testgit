<?php

namespace App\Console\Commands;
use Illuminate\Console\Command;
use App\Helpers\Dao;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Helpers\ANSFile;
use Carbon\Carbon;
use App\Modules\BasicSetting\Controllers\APIController;
use Session;
class cronjobAPI extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature    = 'cronjob:api';

    protected $time_start ;
    protected $time_end;
    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'This command will call api';

    protected $APIController;

    /**
     * Create a new command instance.
     *
     * @return void
     */
    public function __construct(APIController $APIController)
    {
        parent::__construct();
        $this->time_start   = 2300;
        $this->time_end     = 400;
        $this->APIController = $APIController;

    }
    /**
     * Execute the console command.
     *
     * @return mixed
     */
    public function handle(Request $request)
    {
        $err_content = '';
        // //        date_default_timezone_set('Asia/Ho_Chi_Minh');
        date_default_timezone_set('Asia/Tokyo');
        $current =  (int)date('Hi');

         if($current >= $this->time_start && $this->$time_end <= $this->time_end){
            try{
                //
                $this->writeLog('------Started------');
                $file_content = '';
                foreach(config('mirai_api') as $company_cd_refer => $value){
                    $request->company_cd_refer      = $company_cd_refer;
                    $request->api_office_cd         = $value['api_office_cd']??'';
                    $request->api_employee_use      = 1;
                    $request->api_position_use      = 1;
                    $request->api_organization_use  = 1;
                    $request->api_status            = 1;
                    $json = $this->APIController->processApi($request);
                    $file_content .= $json->getData()->file_content;
                }
                $dir = config_path('mirai_api.php');
                $fp = fopen($dir, 'w');
                fwrite($fp,'<?php'."\n".'return $settings = array('."\n".$file_content.');');
                fclose($fp);
                $this->writeLog('------Ended------');
            } catch (\Exception $e) {
                $err_content = $e->getMessage();
            }
        }else{
           echo 'Not time to run...';
           $error_content = 'Not time to run...';
           $this->writeLog($error_content);
        }
    }
    //
    public function writeLog($content){
        $debug_api ='Conjob Schedule API : '.$content;
        $time = date("Y-m-d H:i:s");
        $logFile = fopen(
            storage_path('logs' . DIRECTORY_SEPARATOR . date('Y-m-d') . '_API.log'),
            'a+'
        );
        fwrite($logFile, $time . ': ' . $debug_api . PHP_EOL);
        fclose($logFile);
    }
}
