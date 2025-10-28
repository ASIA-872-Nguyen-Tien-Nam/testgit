<p>----------------------</p>
<p>This e-mail was sent automatically by MIRAIC e-mail delivery software.</p>
<p>---------------------- </p>
<p></p>
<p>{{ $employee_nm }}</p>
<p></p>
<p>We are informing you of your Login/Password below.</p>
<p>Please login using your "CompanyID" and "UserID"  that of which we will inform you.</p>
<p>Please check your registered information in case you need changes to be made after logging in with the URL below.</p>
<p>We recommend you change your password after logging in.</p>
<p>Please use the password below to login to the system.</p>
<p></p>
<p>URL：{{ env('MAIL_BODY_URL') ?? '' }}</p>
<p>Password： {{ $password }}</p>


