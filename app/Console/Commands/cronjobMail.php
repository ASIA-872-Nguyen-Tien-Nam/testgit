<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Helpers\Dao;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Helpers\ANSFile;
use Carbon\Carbon;
use App\Services\GoogleService;


class cronjobMail extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'cronjob:mail';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'This command will send mail';
    /**
     * Create a new command instance.
     *
     * @return void
     */
    public function __construct(GoogleService $googleService)
    {
        parent::__construct();
        $this->googleService = $googleService;
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
        
        try {
            $result = Dao::executeSql('SPC_MAIL_INQ1');
            $logscontent    = [];
            $error_content  = [];
            $errors         = 0;
            $errors2        = 0;
            foreach ($result[0] as $keys => $row) {
                $email                  =   $row['send_mailaddress'];
                if (filter_var($email, FILTER_VALIDATE_EMAIL)) {
                    try {
                        $data['subject']        =   $row['infomation_title'];
                        $data['company_nm']     =   $row['company_nm'];
                        $data['to']             =   $row['send_mailaddress'];
                        $data['bcc']            =   $row['mail_bcc']; //longvv add 2019/04/24
                        $data['subject']        =   $row['infomation_title'];
                        $data['employee_nm']    =   $row['employee_nm'];
                        $data['infomation_date'] =  $row['infomation_date'];
                        $data['body']           =   $row['infomation_message'];
                        $data['language']       =   $row['language'];
                        $data['screen_id']      =   'SYSTEM';
                        //Send Mail
                        $result = $this->googleService->sendCronJobMail($data);
                        // add by viettd 2021/07/01 
                        // delay 10s for each send mail times
                    } catch (\Exception $e1) {
                        $errors2++;
                        $error_content[$keys] = $e1->getMessage();
                    }
                } else {
                    $errors++;
                }
                //validate send mail
                if ($result['Exception']) {
                    $error_content[$keys] = $row['company_nm'] . ' | ' . $row['send_mailaddress'] . ' | ' . 'status : fail';
                } else {
                    $error_content[$keys] = $row['company_nm'] . ' | ' . $row['send_mailaddress'] . ' | ' . 'status : success';
                }
            }
            // when send all mail then updated history 
            $res = Dao::executeSql('SPC_MAIL_ACT1');
        } catch (\Exception $e) {
            array_push($error_content, $e->getMessage());
        }
        array_push($logscontent, $error_content);
        //log
        if (!file_exists(storage_path('logsMail'))) {
            mkdir(storage_path('logsMail'), 0777, true);
        }
        $time = date("Y-m-d H:i:s");
        $logFile = fopen(
            storage_path('logsMail' . DIRECTORY_SEPARATOR . date('Y-m-d') . '_send_mail.log'),
            'a+'
        );
        // 
        foreach ($logscontent[0] as $content) {
            $err_content = json_encode($content);
            fwrite($logFile, $time . ': ' . $err_content . PHP_EOL);
        }
        fclose($logFile);
    }
}