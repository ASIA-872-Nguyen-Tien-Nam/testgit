<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;
use Illuminate\Contracts\Queue\ShouldQueue;

class InterviewSchedule extends Mailable
{
    use Queueable, SerializesModels;

    public $subject;
    private $member_name;
    private $coach_name;
    private $schedule_date;
    private $time;
    private $title;
    private $place;
    private $language;
    private $folder;
    /**
     * Create a new message instance.
     *
     * @return void
     */
    public function __construct($mail_info)
    {
        $this->subject          = $mail_info['subject'] ?? '';
        $this->member_name      = $mail_info['member_nm'] ?? '';
        $this->coach_name       = $mail_info['coach_nm'] ?? '';
        $this->schedule_date    = $mail_info['schedule_date'] ?? '';
        $this->time             = $mail_info['time'] ?? '';
        $this->title            = $mail_info['title'] ?? '';
        $this->place            = $mail_info['place'] ?? '';
        $this->language         = $mail_info['language'] ?? '';
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
        return $this->view('mail_templete.' . $this->folder . '.interview_schedule_notification')
            ->text('mail_templete.' . $this->folder . '.interview_schedule_notification_plan')
            ->from(env('MAIL_FROM_ADDRESS'), mb_encode_mimeheader(env('MAIL_FROM_NAME')))
            ->subject($this->subject)
            ->with([
                'member_name'       => $this->member_name,
                'coach_name'        => $this->coach_name,
                'schedule_date'     => $this->schedule_date,
                'time'              => $this->time,
                'title'             => $this->title,
                'place'             => $this->place,
            ]);
    }
}
