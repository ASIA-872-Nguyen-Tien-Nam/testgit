<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;
use Illuminate\Contracts\Queue\ShouldQueue;

class EvaluationNotification extends Mailable
{
    use Queueable, SerializesModels;

    public $subject;
    private $employee_nm;
    private $mail_message;
    private $mail_type;
    private $employees;
    private $language;
    private $target_employee_nm;
    private $repoter_employee_nm;
    private $folder;
    private $folder_weeklyreport;

    /**
     * Create a new message instance.
     *
     * @return void
     */
    public function __construct($mail)
    {
        $this->subject = $mail['subject'];
        $this->employee_nm = $mail['employee_nm'];
        $this->mail_message = $mail['mail_message'];
        $this->mail_type = $mail['mail_type'];
        $this->employees = $mail['employees'];
        $this->language  = $mail['language'];
        $this->target_employee_nm = $mail['target_employee_nm'] ?? '';
        $this->repoter_employee_nm = $mail['repoter_employee_nm'] ?? '';
    }

    /**
     * Build the message.
     *
     * @return $this
     */
    public function build()
    {
        if ($this->language == 2) {
            $this->folder = 'evaluation_notification_en';
            $this->folder_weeklyreport = 'weekly_report_en';
        }else{
            $this->folder = 'evaluation_notification';
            $this->folder_weeklyreport = 'weekly_report';
        }
        // mail_type = 1.差戻通知
        if ($this->mail_type == 1) {
            return $this->view('mail_templete.'. $this->folder.'.evaluation_cancel_notification')
            ->from(env('MAIL_FROM_ADDRESS'), mb_encode_mimeheader(env('MAIL_FROM_NAME')))
            ->subject($this->subject)
            ->with([
                'employee_nm' => $this->employee_nm,
                'mail_message' => $this->mail_message,
            ]);    
        
        }elseif ($this->mail_type == 2){
            return $this->view('mail_templete.' . $this->folder . '.evaluation_comprehensive_confirmed')
            ->from(env('MAIL_FROM_ADDRESS'), mb_encode_mimeheader(env('MAIL_FROM_NAME')))
            ->subject($this->subject)
            ->with([
                'employee_nm' => $this->employee_nm,
                'mail_message' => $this->mail_message,
                'employees' => $this->employees,
            ]); 
        }elseif ($this->mail_type == 3){
            return $this->view('mail_templete.' . $this->folder . '.evaluation_personal_feedback')
            ->from(env('MAIL_FROM_ADDRESS'), mb_encode_mimeheader(env('MAIL_FROM_NAME')))
            ->subject($this->subject)
            ->with([
                'employee_nm' => $this->employee_nm,
                'mail_message' => $this->mail_message,
            ]); 
        }
        elseif ($this->mail_type == 4){
            return $this->view('mail_templete.' . $this->folder_weeklyreport . '.weeklyreport_share')
            ->from(env('MAIL_FROM_ADDRESS'), mb_encode_mimeheader(env('MAIL_FROM_NAME')))
            ->subject($this->subject)
            ->with([
                'employee_nm' => $this->employee_nm,
                'target_employee_nm' => $this->target_employee_nm,
                'repoter_employee_nm' => $this->repoter_employee_nm,
                'mail_message' => $this->mail_message,
                
            ]); 
        }
        // normal send mail
        return $this->view('mail_templete.' . $this->folder . '.evaluation_notification')
        ->from(env('MAIL_FROM_ADDRESS'), mb_encode_mimeheader(env('MAIL_FROM_NAME')))
        ->subject($this->subject)
        ->with([
            'employee_nm' => $this->employee_nm,
            'mail_message' => $this->mail_message,
            'target_employee_nm' => $this->target_employee_nm,
        ]);
    }
}
