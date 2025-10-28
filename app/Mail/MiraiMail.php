<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;
use Illuminate\Contracts\Queue\ShouldQueue;

class MiraiMail extends Mailable
{
    use Queueable, SerializesModels;

    /**
     * Create a new message instance.
     *
     * @return void
     */
    public function __construct($mail_info)
    {
        $this->company_nm       = $mail_info['company_nm'];
        
        $this->to               = $mail_info['to'];
        $this->bcc              = $mail_info['bcc']; //longvv add 2019/04/24
        $this->subject          = $mail_info['subject'];
        
        $this->employee_nm      = $mail_info['employee_nm'];
        $this->infomation_date  = $mail_info['infomation_date'];
        $this->body             = $mail_info['body'];
        $this->language         = $mail_info['language'];


    }

    /**
     * Build the message.
     *
     * @return $this
     */
    public function build()
    {

        return $this->view('mirai_mail')
        ->from(env('MAIL_FROM_ADDRESS'), mb_encode_mimeheader(env('MAIL_FROM_NAME')))
        ->subject($this->subject)
        ->with([
            'title' => $this->subject,
            'body' => $this->body,
            'infomation_date' => $this->infomation_date,
            'employee_nm' => $this->employee_nm,
            'language' => $this->language
        ]);
    }
}
