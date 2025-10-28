<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\Mail;
use Dao;
use App\Mail\EvaluationNotification;
use App\Services\GoogleService;

class cronjobEvaluationNotification extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'cronjob:evaluation_notification';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Send mail for evaluation confirm & feedback in batch process';

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
        $this->writeLog('============= Start process batch at ( ' . $current . ' ) =============');
        // GET ALL MAIL TO SEND
        $mails = Dao::executeSql('[SPC_EVALUATION_NOTIFICATION_MAIL_INQ2]');
        // check exception
        if (isset($mails[0][0]['error_typ']) && $mails[0][0]['error_typ'] == '999') {
            $this->writeLog($mails[0][0]['remark']);
        } else if (isset($mails[0]) && !empty($mails[0])) {
            // loop list mail
            $mail_send_logs = [];
            foreach ($mails[0] as $mail) {
                // when mail address format is not correct
                if (!filter_var($mail['send_mailaddress'], FILTER_VALIDATE_EMAIL)) {
                    $mail_send_logs[] = 'This mail address [' . $mail['send_mailaddress'] . '] is not correct';
                    continue;
                }
                // Send mail
                try {
                    // when mail_type = 2.評価確定
                    $mail['employees'] = [];
                    if ($mail['mail_type'] == 2) {
                        $mail['employees'] = json_decode(html_entity_decode($mail['target_employee_list']), true);
                    }
                    $mail['screen_id']      =   'SYSTEM';
                    // Mail::to($mail['send_mailaddress'])->send(new EvaluationNotification($mail));
                    $result = $this->googleService->sendEvaluationNotification($mail['send_mailaddress'],$mail);
                    // check mail send error
                    if($result['Exception']){
                        $mail_send_logs[] = 'This mail address ['.$mail['send_mail_address'].'] is failed';
                    continue;
                }
                    // mail send success
                    $mail_send_logs[] = 'This mail address [' . $mail['send_mailaddress'] . '] is successful';
                    $params['company_cd'] = $mail['company_cd'];
                    $params['information_date'] = $mail['information_date'];
                    $params['information_typ'] = $mail['information_typ'];
                    $params['employee_cd'] = $mail['employee_cd'];
                    $mail_history = Dao::executeSql('[SPC_EVALUATION_NOTIFICATION_MAIL_ACT1]', $params);

                    if (isset($mail_history[0][0]['error_typ']) && $mail_history[0][0]['error_typ'] == '999') {
                        $mail_send_logs[] = 'Update mail history has error: ' . $mail_history[0][0]['remark'];
                    }
                } catch (\Swift_TransportException  $e) {
                    $mail_send_logs[] = $e->getMessage();
                }
            }
            // log 
            $this->writeLog('Mail information sent ', $mail_send_logs);
        }
        // finished process
        $this->writeLog('============= Finished process batch at ( ' . $current . ' ) =============');
    }

    /**
     * writeLog
     *
     * @param  string $content
     * @return void
     */
    private function writeLog($content, $payloads = [])
    {
        $time = date("Y-m-d H:i:s");
        $logFile = fopen(
            storage_path('logsMail' . DIRECTORY_SEPARATOR . date('Y-m-d') . '_EVALUATION_NOTIFICATION_MAIL.log'),
            'a+'
        );
        fwrite($logFile, $time . ': ' . $content . PHP_EOL);
        // if $payloads is exits 
        if (!empty($payloads)) {
            foreach ($payloads as $payload) {
                fwrite($logFile, '∟ ' . $payload . PHP_EOL);
            }
        }
        // close file
        fclose($logFile);
    }
}
