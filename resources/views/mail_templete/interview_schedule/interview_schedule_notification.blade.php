<style>
    p,pre {
        font-family: 'Times New Roman', Times, serif;
        font-size: 15px;
    }
</style>
<html>
    ----------------------------
    <pre style="margin: 0px !important">本メールは「人事評価システム MIRAIC」より自動配信されております。</pre>
    ----------------------------

    <p style="margin-bottom: 0px">メンバー：{{$member_name}}</p>
    <p style="margin-top: 0px">コーチ　：{{$coach_name}}</p>

    <p style="margin: 0px">実施予定日：{{date("Y/m/d", strtotime($schedule_date))}}</p>
    <p style="margin: 0px">時刻：{{$time}}</p>
    <p style="margin: 0px">タイトル：{{$title}}</p>
    <pre style="margin: 0px;font-size: 15px;">場所：{{$place}}</pre>
    <p>URL：{{ env('MAIL_BODY_URL') ?? '' }}</p>
</html>