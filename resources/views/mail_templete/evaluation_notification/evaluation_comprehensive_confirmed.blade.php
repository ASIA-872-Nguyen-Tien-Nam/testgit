<p>----------------------</p>
<p>本メールは「人事評価システム MIRAIC」より自動配信されております。</p>
<p>---------------------- </p>
<p></p>
<p>{{ $employee_nm }} 様</p>
<p></p>
@isset($employees)
@foreach ($employees as $employee)
<p>評価対象者: {{ $employee['name'] }} さん</p>
@endforeach
@endisset
<p></p>
<p>前の評価が完了しました。MIRAICへログインし、処理を進めてください。</p>
<p></p>
<p>
    {!!  nl2br($mail_message) !!}
</p>

<p></p>

<p>URL：{{ env('MAIL_BODY_URL') ?? '' }}</p>