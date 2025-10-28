<p>----------------------</p>
<p>本メールは「人事評価システム MIRAIC」より自動配信されております。</p>
<p>----------------------</p>

<p>{{ $employee_nm }} 様</p>

<p>{{$target_employee_nm}} さんから{{$repoter_employee_nm}}さんの報告書を共有しました。</p>
<p>ご確認頂き、修正下さいます様お願い致します。</p>
<p></p>
<p>
    {!!  nl2br($mail_message) !!}
</p>
<p></p>

<p>URL：{{ env('MAIL_BODY_URL') ?? '' }}</p>