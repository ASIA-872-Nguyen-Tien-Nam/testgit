<!doctype html>
<html lang="en" class="no-js">

<head>
    <meta charset="UTF-8" />
    <link href="{!! public_url('template/image/logo/logo-icon.png') !!}" rel="shortcut icon">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>{{$title or 'メンテナンス中'}}</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    {!! public_url('template/css/common/bootstrap.min.css') !!}
    {!! public_url('template/css/form/login.css') !!}
    {!! public_url('template/css/common/jmessages.css') !!}
    {!! public_url('template/js/common/jquery.min.js') !!}
    {{-- public_url('template/css/form/layout.css') --}}
    {{-- {!!public_url('template/css/common/common.css')!!} --}}
    <!-- domain js-->
    {!! public_url('template/js/common/domain.js') !!}
    <script>
        var _text = {!! json_encode(\App\L0020::text(false))  !!}
    </script>
    {!! public_url('template/js/form/login.js') !!}
    {!! public_url('template/js/common/common.js') !!}
    {!!public_url('template/js/common/ansplugin.js')!!}
    {!!public_url('template/js/common/jmessages.js')!!}
    {!!public_url('template/js/common/app.js')!!}
</head>

<body>
    <div id="gradient">
        <div id="login">
            <!-- Main content -->
            <div class="content-wrapper">
                <!-- Form with validation -->
                <div class="wrapper">
                    <div class="container" style="padding:15% 0">
                        <img src="{!! public_url('template/image/logo.png') !!}" alt="" style="width: 80%" />
                        <h2 style="margin-top:40px;margin-left:auto;font-size: 30px;">只今メンテナンス中です。</h2>
                    </div>
                </div>
                <!-- /form with validation -->
            </div>
            <!-- /main content -->
        </div>
    </div>
    <!-- LOADING IMAGE -->

</body>

</html>