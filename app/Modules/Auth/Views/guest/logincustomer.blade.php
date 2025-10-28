<!doctype html>
<html lang="en" class="no-js">

<head>
    <meta charset="UTF-8" />
    <link href="{!! public_url('template/image/logo/logo-icon.png') !!}" rel="shortcut icon">
    <title>{{$title or 'メンテナンス中'}}</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <script>
        var _text = {!! json_encode(\App\L0020::text(false))  !!}
    </script>
    {!! public_url('template/css/common/bootstrap.min.css') !!}
    {!!public_url('template/css/common/jquery.datetimepicker.css')!!}
    {!! public_url('template/css/form/logincustomer.css') !!}
    {!! public_url('template/css/common/jmessages.css') !!}
    {!! public_url('template/js/common/jquery.min.js') !!}
    {!! public_url('template/js/common/jquery.datetimepicker.full.min.js') !!}
    {!! public_url('template/js/form/logincustomer.js') !!}
    {!! public_url('template/js/common/common.js') !!}
    {!!public_url('template/js/common/ansplugin.js')!!}
    {!!public_url('template/js/common/jmessages.js')!!}
</head>

<body>
    <div id="gradient">
        <div id="login">
            <!-- Main content -->
            <div class="content-wrapper">
                <!-- Form with validation -->
                <div class="wrapper">
                    <div class="container">
                        <h1>
                            <img src="{!! public_url('template/image/logo.png') !!}" alt="" style="width: 80%" />
                        </h1>

                        <form class="form">
                            <input type="hidden" name="token" value="{{ csrf_token() }}"/>
							<div style="margin: 0 0 10px">							  
                            <div class="my-input">
                                <input type="text" id="contract_cd" placeholder="{{__('messages.company_ID')}}" class="required"  value="{{$contract_cd??''}}"  style="margin: 0px">
                                <div>
                                    <div class="md-checkbox-v2 inline-block">
                                        <input name="remember_contract_cd" id="remember_contract_cd" {{ isset($remember_contract_cd)&&($remember_contract_cd==1)?'checked':''}} type="checkbox" value="1" tabindex=" -1">
                                        <label for="remember_contract_cd">{{__('messages.remember')}}</label>
                                    </div>
                                </div>
                            </div>
							<div style="margin: 0 0 10px">							  
                            <div class="my-input">
                                <input type="text" id="user_id" placeholder="{{__('messages.username')}}" class="required" value="{{$user_id??''}}"  style="margin: 0px">
                                <div>
                                    <div class="md-checkbox-v2 inline-block">
                                        <input name="remember_id" id="remember_id" {{ isset($remember_id)&&($remember_id==1)?'checked':''}} type="checkbox" value="1" tabindex=" -1">
                                        <label for="remember_id">{{__('messages.remember')}}</label>
                                    </div>
                                </div>
                            </div>
                            <div class="my-input">
                                <input style="margin-bottom: 0px"  type="password"  id="password"placeholder="{{__('messages.mail_password')}}" class="required" value="{{$password??''}}">
                                <input type="hidden"  id="contract_company_attribute" class="numeric" value="2">
                            </div>
                            <button style="margin-top: 10px"  type="submit" id="btn_login">{{__('messages.login')}}</button>
                        </form>
                    </div>
                </div>
                <!-- /form with validation -->
            </div>
            <!-- /main content -->
        </div>
    </div>
    @php
		$language = Config::get('app.locale');
	@endphp
    <input type="hidden" id="language_jmessages" value="{{$language}}">
    <script>
        $("#login-button").click(function(event) {
            event.preventDefault();
            $('form').fadeOut(500);
            $('.wrapper').addClass('form-success');
            setTimeout(function() {
                location.href='/master/portal';
            }, 600);
        });
    </script>

</body>

</html>