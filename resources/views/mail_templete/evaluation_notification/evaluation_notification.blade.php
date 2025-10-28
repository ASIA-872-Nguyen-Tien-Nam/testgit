<p>----------------------</p>
<p>本メールは「人事評価システム MIRAIC」より自動配信されております。</p>
<p>---------------------- </p>
<p></p>
<p>{{ $employee_nm }} 様</p>
<p></p>
<p>評価対象者：{!!  nl2br($target_employee_nm) !!} さん</p>
<p></p>
<p>前の処理が完了しました。MIRAICへログインし、処理を進めてください。</p>
<p></p>
<p>
    {!!  nl2br($mail_message) !!}
</p>

<p></p>

<p>URL：{{ env('MAIL_BODY_URL') ?? '' }}</p>