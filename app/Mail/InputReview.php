<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;
use Illuminate\Contracts\Queue\ShouldQueue;

class InputReview extends Mailable
{
    use Queueable, SerializesModels;
    public $subject;
    private $title;
    private $message;
    private $folder;
    private $language;
    /**
     * Create a new message instance.
     *
     * @return void
     */
    public function __construct($subject,$title,$message,$language)
    {
        $this->subject = $subject;
        $this->title = $title;
        $this->message = $message;
        $this->language = $language;
    }

    /**
     * Build the message.
     *
     * @return $this
     */
    public function build()
    {
        if ($this->language == 2) {
            $this->folder = 'interview_schedule_en';
        } else {
            $this->folder = 'interview_schedule';
        }
        return $this->view('mail_templete.' . $this->folder . '.input_review')
            ->text('mail_templete.interview_schedule.interview_schedule_notification_plan')
            ->from(env('MAIL_FROM_ADDRESS'), mb_encode_mimeheader(env('MAIL_FROM_NAME')))
            ->subject($this->subject)
            ->with([
                'title' => $this->title,
                'message_typ' => $this->message,
            ]);
    }
}
