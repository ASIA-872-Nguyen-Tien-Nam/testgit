<style>
    p,pre {
        font-family: 'Times New Roman', Times, serif;
        font-size: 15px;
    }
</style>
<html>
    ----------------------------
    <pre style="margin: 0px !important">This e-mail is automatically sent from the "MIRAIC Personnel Assessment System".</pre>
    ----------------------------

    <p style="margin-bottom: 0px">Member：{{$member_name}}</p>
    <p style="margin-top: 0px">Coach：{{$coach_name}}</p>

    <p style="margin: 0px">Scheduled Date：{{date("Y/m/d", strtotime($schedule_date))}}</p>
    <p style="margin: 0px">Time：{{$time}}</p>
    <p style="margin: 0px">Title：{{$title}}</p>
    <pre style="margin: 0px;font-size: 15px;">Place：{{$place}}</pre>
    <p>URL：{{ env('MAIL_BODY_URL') ?? '' }}</p>
</html>