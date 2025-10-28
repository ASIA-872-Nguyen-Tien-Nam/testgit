
@if($language == 2 )
<p>----------------------</p>
<p>This e-mail is automatically sent from the "MIRAIC Personnel Assessment System".</p>
<p>---------------------- </p>
<Br>
<p>{{ $employee_nm }}</p>
<Br>
<p>{{$infomation_date}}</p>
<pre>{{ $body }}</pre>
<p>URL：{{ env('MAIL_BODY_URL') ?? '' }}</p>

@else

<p>----------------------</p>
<p>本メールは「人事評価システム MIRAIC」より自動配信されております。</p>
<p>---------------------- </p>
<Br>
<p>{{ $employee_nm }} 様</p>
<Br>
<p>{{$infomation_date}}</p>
<pre>{{ $body }}</pre>
<p>URL：{{ env('MAIL_BODY_URL') ?? '' }}</p>
@endif