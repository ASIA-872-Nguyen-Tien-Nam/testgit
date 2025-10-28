<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Dao;
use App\Mail\PasswordNotification;
use Exception;
use Illuminate\Support\Facades\Mail;
use App\Services\GoogleService;

class cronjobPasswordNotification extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'cronjob:password_notification';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Send mail password change in batch';

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
        // start process
        date_default_timezone_set('Asia/Tokyo');
        $current =  date("Y-m-d H:i:s");
        $this->writeLog('============= Start process batch at ( '.$current.' ) =============');
        // GET ALL MAIL TO SEND
        $mails = Dao::executeSql('[SPC_PASSWORD_NOTIFICATION_MAIL_INQ1]');
        // check exception
        if (isset($mails[0][0]['error_typ']) && $mails[0][0]['error_typ'] == '999') {
            $this->writeLog($mails[0][0]['remark']);
        }else if(isset($mails[0]) && !empty($mails[0])){
            // loop list mail
            $mail_send_logs = [];
            foreach ($mails[0] as $mail) {
                // when mail address format is not correct
                if(!filter_var($mail['send_mail_address'],FILTER_VALIDATE_EMAIL)){
                    $mail_send_logs[] = 'This mail address ['.$mail['send_mail_address'].'] is not correct';
                    continue;
                }   
                // Send mail
                try{
                    // Mail::to($mail['send_mail_address'])->send(new PasswordNotification($mail));
                    $mail['screen_id']      =   'SYSTEM';
                    $result = $this->googleService->sendPasswordNotification($mail['send_mail_address'],$mail);
                    // check mail send error
                    if($result['Exception']){
                            $mail_send_logs[] = 'This mail address ['.$mail['send_mail_address'].'] is failed';
                        continue;
                    }
                    // mail send success
                    $mail_send_logs[] = 'This mail address ['.$mail['send_mail_address'].'] is successful';
                    $params['serial_no'] = (int)$mail['serial_no'];
                    $mail_history = Dao::executeSql('[SPC_PASSWORD_NOTIFICATION_MAIL_ACT1]',$params);
                    if (isset($mail_history[0][0]['error_typ']) && $mail_history[0][0]['error_typ'] == '999') {
                        $mail_send_logs[] = 'Update mail history has error: '.$mail_history[0][0]['remark'];
                    }
                }catch(\Swift_TransportException  $e){
                    $mail_send_logs[] = $e->getMessage();
                }
            }
            // log 
            $this->writeLog('Mail information sent ',$mail_send_logs);
        }
        // finished process
        $this->writeLog('============= Finished process batch at ( '.$current.' ) =============');
    }
    /**
     * writeLog
     *
     * @param  string $content
     * @return void
     */
    private function writeLog($content,$payloads = [])
    {
        $time = date("Y-m-d H:i:s");
        $logFile = fopen(
            storage_path('logsMail' . DIRECTORY_SEPARATOR . date('Y-m-d') . '_PASS_NOTIFICATION.log'),
            'a+'
        );
        fwrite($logFile, $time . ': ' . $content . PHP_EOL);
        // if $payloads is exits 
        if(!empty($payloads)){
            foreach ($payloads as $payload) {
                fwrite($logFile,'∟ ' . $payload . PHP_EOL);
            }
        }
        // close file
        fclose($logFile);
    }
}