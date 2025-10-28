<p>----------------------</p>
<p>This mail was sent automatically by MIRAIC mail delivery software.</p>
<p>----------------------</p>

<p>{{ $employee_nm }} </p>

<p>The submitted objective Sheet has been declined.</p>
<p>{{$target_employee_nm}} shared {{ $repoter_employee_nm}}'s report.</p>
<p>Please check and change content if neccessary.</p>
<p></p>
<p>
    {!!  nl2br($mail_message) !!}
</p>
<p></p>

<p>URL：{{ env('MAIL_BODY_URL') ?? '' }}</p>