<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;
use Illuminate\Contracts\Queue\ShouldQueue;

class PasswordNotification extends Mailable
{
    use Queueable, SerializesModels;

    public $subject;
    private $employee_nm;
    private $password;
    private $language;
    
    /**
     * Create a new message instance.
     *
     * @return void
     */
    public function __construct($mail)
    {
        $this->subject = $mail['subject'];
        //$this->subject = '人事評価システムMIRAICのログインパスワードの通知';
        $this->employee_nm = $mail['employee_nm'];
        $this->password = $mail['password'];
        $this->language = $mail['language']??'';
    }

    /**
     * Build the message.
     *
     * @return $this
     */
    public function build()
    {
        // return $this->view('view.first_name');
        if($this->language == 2){ //2 is english
            $this->subject = 'Notification Of Login Password For Personnel Evaluation System MIRAIC';
        return $this->view('mail_templete.password_notification.password_notification_en')
            // ->text('mail_templete.interview_schedule.interview_schedule_notification_plan')
            ->from(env('MAIL_FROM_ADDRESS'), mb_encode_mimeheader(env('MAIL_FROM_NAME')))
            ->subject($this->subject)
            ->with([
                'employee_nm' => $this->employee_nm,
                'password' => $this->password,
            ]);
        }else{
            return $this->view('mail_templete.password_notification.password_notification')
            // ->text('mail_templete.interview_schedule.interview_schedule_notification_plan')
            ->from(env('MAIL_FROM_ADDRESS'), mb_encode_mimeheader(env('MAIL_FROM_NAME')))
            ->subject($this->subject)
            ->with([
                'employee_nm' => $this->employee_nm,
                'password' => $this->password,
            ]);
        }
    }
}