<p>----------------------</p>
<p>This mail was sent automatically by MIRAIC mail delivery software.</p>
<p>----------------------</p>

<p>{{ $employee_nm }} </p>
<p>{{ date("Y/m/d") }}</p>
<p>The submitted objective Sheet has been declined.</p>
<p>Please check with Evaluator and change content if neccessary.</p>
<p></p>
<p>
    {!!  nl2br($mail_message) !!}
</p>
<p></p>

<p>URL：{{ env('MAIL_BODY_URL') ?? '' }}</p>