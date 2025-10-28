<p>----------------------</p>
<p>This e-mail was sent  automatically by MIRAIC e-mail delivey software.</p>
<p>---------------------- </p>
<p></p>
<p>{{ $employee_nm }} </p>
<p></p>
<p>The member(s) listed above completed their Evaluation.</p>
<p>Please login to MIRAIC and check the result.</p>
<p>
    {!!  nl2br($mail_message) !!}
</p>

<p></p>

<p>URL：{{ env('MAIL_BODY_URL') ?? '' }}</p>