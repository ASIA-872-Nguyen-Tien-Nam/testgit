<p>----------------------</p>
<p>This e-mail was sent  automatically by MIRAIC e-mail delivey software.</p>
<p>---------------------- </p>
<p></p>
<p>{{ $employee_nm }} </p>
<p></p>
<p>Appraiser: Mr./Ms. {!!  nl2br($target_employee_nm) !!}</p>
<p></p>
<p>The member(s) listed above have completed their Last Evaluation.</p>
<p>Please login to MIRAIC and begin processing.</p>
<p>
    {!!  nl2br($mail_message) !!}
</p>

<p></p>

<p>URL：{{ env('MAIL_BODY_URL') ?? '' }}</p>