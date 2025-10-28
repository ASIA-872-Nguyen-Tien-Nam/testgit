<?php

namespace App\Services;

use Google\Client;
use Google\Service\Gmail as GoogleGmail;
use Google_Service_Gmail;
use App\Mail\PasswordNotification;
use App\Mail\InterviewSchedule;
use App\Mail\InputReview;
use App\Mail\EvaluationNotification;
use Illuminate\Support\Facades\View;
use App\Helpers\Dao;
use App\Mail\MiraiMail;
use Illuminate\Support\Facades\Log;

class GoogleService
{
    protected $client;
    protected $gmailService;

    public function __construct()
    {
        $sql = Dao::executeSql('SPC_S0001_INQ1');
        if (isset($sql[0][0]['error_typ']) && $sql[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        $this->client = new Client();
        $this->client->setApplicationName(config('mail.application_name'));
        $this->client->setClientId($sql[0][0]['client_id'] ?? '');
        $this->client->setClientSecret($sql[0][0]['client_secret'] ?? '');
        $this->client->setRedirectUri(env('MAIL_BODY_URL') . '/customer/master/s0001/get-token');
        $this->client->addScope(Google_Service_Gmail::GMAIL_SEND);
        $this->client->setAccessType('offline');
        $this->client->setPrompt('consent');
        $this->client->setAccessToken([
            'access_token' => $sql[2][0]['access_token'] ?? '',
            'refresh_token' => $sql[2][0]['refresh_token'] ?? '',
            'token_type' => 'Bearer',
            'expires_in' => 3600
        ]);
        $this->gmailService = new GoogleGmail($this->client);
    }

    public function getAuthUrl()
    {
        return $this->client->createAuthUrl();
    }

    public function authenticate($code)
    {
        return $this->client->fetchAccessTokenWithAuthCode($code);
    }

    public function setAccessToken($token)
    {
        $this->client->setAccessToken($token);
    }

    /**
     * base64url_encode
     *
     * @param  String $data
     * @return String
     */
    function base64url_encode($data)
    {
        return str_replace(['+', '/', '='], ['-', '_', ''], base64_encode($data));
    }

    /**
     * sendPasswordNotification
     *
     * @param  String $to
     * @param  Array $mailData
     * @return Array
     */
    public function sendPasswordNotification($to, $mailData)
    {
        try {
            $class = new PasswordNotification($mailData);
            $htmlContent = View::make($class->build()->view, $class->build()->viewData)->render();
            $boundary = uniqid(rand(), true);
            if ($mailData['language'] == 2) { //2 is english
                $mailData['subject'] = 'MIRAIC Login Password Notification';
            }
            $rawMessage = $this->rawMessages($to, $mailData, $boundary, $htmlContent);
            $rawMessage = $this->base64url_encode($rawMessage);
            $message = new \Google_Service_Gmail_Message();
            $message->setRaw($rawMessage);
            try {
                return $this->gmailService->users_messages->send('me', $message);
            } catch (\Exception $e) {
                Log::error($e->getMessage());
                if ($e->getMessage() == 'json key is missing the refresh_token field' ||  json_decode($e->getMessage())->error == 'invalid_grant') {
                    $res = $this->sendMailFail($mailData['screen_id'] ?? '');
                }
                $this->respon['status']     = EX;
                $this->respon['Exception']  = $e->getMessage();
                return $this->respon;
            }
        } catch (\Exception $e) {
            $this->respon['status']     = EX;
            $this->respon['Exception']  = $e->getMessage();
            return $this->respon;
        }
    }

    /**
     * sendInterviewSchedule
     *
     * @param  String $to
     * @param  Array $mailData
     * @return Array
     */
    public function sendInterviewSchedule($to, $mailData)
    {
        try {
            $class = new InterviewSchedule($mailData);
            $htmlContent = View::make($class->build()->view, $class->build()->viewData)->render();
            $boundary = uniqid(rand(), true);
            $rawMessage = $this->rawMessages($to, $mailData, $boundary, $htmlContent);
            $rawMessage = $this->base64url_encode($rawMessage);
            $message = new \Google_Service_Gmail_Message();
            $message->setRaw($rawMessage);
            try {
                return $this->gmailService->users_messages->send('me', $message);
            } catch (\Exception $e) {
                if ($e->getMessage() == 'json key is missing the refresh_token field' ||  json_decode($e->getMessage())->error == 'invalid_grant') {
                    $res = $this->sendMailFail($mailData['screen_id'] ?? '');
                }
                Log::error($e->getMessage());
                $this->respon['status']     = EX;
                $this->respon['Exception']  = $e->getMessage();
                return $this->respon;
            }
        } catch (Exception $e) {
            $this->respon['status']     = EX;
            $this->respon['Exception']  = $e->getMessage();
        }
    }

    /**
     * sendInputReview
     *
     * @param  String $to
     * @param  Array $mailData
     * @return Array
     */
    public function sendInputReview($to, $mailData)
    {
        try {
            if ($mailData['language'] == 2) { //2 is english
                $mailData['subject'] = 'Multi-review Notification';
            }
            $class = new InputReview($mailData['subject'], $mailData['title'], $mailData['message'], $mailData['language']);
            $htmlContent = View::make($class->build()->view, $class->build()->viewData)->render();
            $boundary = uniqid(rand(), true);
            $rawMessage = $this->rawMessages($to, $mailData, $boundary, $htmlContent);
            $rawMessage = $this->base64url_encode($rawMessage);
            $message = new \Google_Service_Gmail_Message();
            $message->setRaw($rawMessage);
            try {
                return $this->gmailService->users_messages->send('me', $message);
            } catch (\Exception $e) {
                if ($e->getMessage() == 'json key is missing the refresh_token field' ||  json_decode($e->getMessage())->error == 'invalid_grant') {
                    $res = $this->sendMailFail($mailData['screen_id'] ?? '');
                }
                Log::error($e->getMessage());
                $this->respon['status']     = EX;
                $this->respon['Exception']  = $e->getMessage();
                return $this->respon;
            }
        } catch (Exception $e) {
            $this->respon['status']     = EX;
            $this->respon['Exception']  = $e->getMessage();
        }
    }

    /**
     * sendEvaluationNotification
     *
     * @param  String $to
     * @param  Array $mailData
     * @return Array
     */
    public function sendEvaluationNotification($to, $mailData)
    {
        try {
            $class = new EvaluationNotification($mailData);
            $htmlContent = View::make($class->build()->view, $class->build()->viewData)->render();
            $boundary = uniqid(rand(), true);
            $rawMessage = $this->rawMessages($to, $mailData, $boundary, $htmlContent);
            $rawMessage = $this->base64url_encode($rawMessage);
            $message = new \Google_Service_Gmail_Message();
            $message->setRaw($rawMessage);
            try {
                return $this->gmailService->users_messages->send('me', $message);
            } catch (\Exception $e) {
                if ($e->getMessage() == 'json key is missing the refresh_token field' ||  json_decode($e->getMessage())->error == 'invalid_grant') {
                    $res = $this->sendMailFail($mailData['screen_id'] ?? '');
                }
                Log::error($e->getMessage());
                $this->respon['status']     = EX;
                $this->respon['Exception']  = $e->getMessage();
                return $this->respon;
            }
        } catch (Exception $e) {
            $this->respon['status']     = EX;
            $this->respon['Exception']  = $e->getMessage();
        }
    }

    /**
     * sendCronJobMail
     *
     * @param  Array $mailData
     * @return Array
     */
    public function sendCronJobMail($mailData)
    {
        $to = $mailData['to'];
        $bcc = $mailData['bcc'];
        $class = new MiraiMail($mailData);
        $htmlContent = View::make($class->build()->view, $class->build()->viewData)->render();
        $boundary = uniqid(rand(), true);
        $rawMessage = $this->rawMessages($to, $mailData, $boundary, $htmlContent,$bcc);
        $rawMessage = $this->base64url_encode($rawMessage);
        $message = new \Google_Service_Gmail_Message();
        $message->setRaw($rawMessage);
        try {
            return $this->gmailService->users_messages->send('me', $message);
        } catch (\Exception $e) {
            if ($e->getMessage() == 'json key is missing the refresh_token field' ||  json_decode($e->getMessage())->error == 'invalid_grant') {
                $res =  $this->sendMailFail('SYSTEM');
            }
            Log::error($e->getMessage());
            $this->respon['status']     = EX;
            $this->respon['Exception']  = $e->getMessage();
            return $this->respon;
        }
    }

    /**
     * rawMessages
     *
     * @param  String $to
     * @param  Array $mailData
     * @param  String $boundary
     * @param  String $htmlContent
     * @return String
     */
    public function rawMessages($to, $mailData, $boundary, $htmlContent,$bcc = null)
    {
        $rawMessage = "From: ".env('MAIL_FROM_NAME')."". " <" . env('MAIL_FROM_ADDRESS') . ">\r\n"; 
        $rawMessage .= "To: " . $to . "\r\n";
        $rawMessage .= "Bcc: ". $bcc . "\r\n";
        $rawMessage .= "Subject: " . mb_encode_mimeheader($mailData['subject']) . "\r\n";
        $rawMessage .= "MIME-Version: 1.0\r\n";
        $rawMessage .= "Content-Type: multipart/alternative; boundary=\"{$boundary}\"\r\n\r\n";
        // Mail body
        $rawMessage .= "--{$boundary}\r\n";
        $rawMessage .= "Content-Type: text/html; charset=UTF-8\r\n\r\n";
        $rawMessage .= $htmlContent . "\r\n\r\n";
        $rawMessage .= "--{$boundary}--";
        return $rawMessage;
    }

    /**
     * sendMailFail
     *
     * @param  String $screen_id
     * @return Array
     */
    public function sendMailFail($screen_id)
    {
        $params['access_token'] = '';
        $params['refresh_token'] = '';
        $params['expiry_date'] = null;
        $params['cre_user'] = $screen_id == 'SYSTEM' ? 'mirai.bat' : session_data()->user_id;
        $params['cre_ip'] = $screen_id == 'SYSTEM' ? 'user.bat' : $_SERVER['REMOTE_ADDR'];
        $params['company_cd'] = $screen_id == 'SYSTEM' ? '' : session_data()->company_cd;
        $params['screen_id'] = $screen_id;
        return Dao::executeSql('SPC_S0001_ACT2', $params);
    }
}
