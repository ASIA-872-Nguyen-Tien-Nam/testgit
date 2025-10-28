<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <title>{{ $title or '' }}</title>
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <meta name="google" value="notranslate">
    <link href="/template/image/logo/logo-icon.png" rel="shortcut icon">
    <!-- Bootstrap -->
    {!! public_url('template/css/common/bootstrap.min.css') !!}
    {!! public_url('template/css/common/font-awesome.min.css') !!}
    {!! public_url('template/css/common/bootstrap-material-datetimepicker.css') !!}
    {!! public_url('template/css/common/jquery.datetimepicker.css') !!}
    {!! public_url('template/css/common/colorbox.css') !!}
    {!! public_url('template/css/common/sticky.css') !!}
    {!! public_url('template/css/common/jmessages.css') !!}
    {{-- public_url('template/css/form/layout.css') --}}
    {!! public_url('template/css/common/common.css') !!}
    {!! public_url('template/css/common/vertical-menu.css') !!}
    {!! public_url('template/css/common/jquery.resizableColumns.css') !!}
    {!! public_url('template/css/common/jquery.multiSelect.css') !!}
    {!! public_url('template/css/common/jquery-ui.css') !!}
    @yield('asset_header')
    @stack('header')
</head>

<body>
    @php
        $auth = session_data();
        $excepts = $auth->excepts;
        $navbars = navbar_group($excepts, [2, 4, 999]);
    @endphp
    <input type="hidden" class="anti_tab1231314" name="">
    <nav class="navbar navbar-expand-lg navbar-light navbar-mobile" style="padding-right: 0px;padding-left:0px">
        <div class="row" style="width:100%">
            <div class="col-2">
                <a tabindex="-1" class="navbar-brand logo" href="/menu">
                    <img src="/template/image/logo/logo-icon.png" height="40px">
                </a>
            </div>
            <div class="col-8" style="display:flex">
                <input type="text" placeholder="{{ __('messages.my_purpose') }}"
                    class=" form-control indexTab Convert-Halfsize">
                <button class="btn btn-primary" style="background: #5087C7 !important;left: 10px;padding-right: 20px;">
                    <a class="nav-link" style="color:white;padding:0px">{{ __('messages.edit') }}</a>
                </button>
            </div>
            <div class="col-2" style="padding-right: 0px;">
                <button style="float:right" class="navbar-toggler button-menu-common" type="button"
                    data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent"
                    aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
            </div>
        </div>
        <div class="" style="width:100%">
            <div class="col-12" style="padding: 0px">
                <div class="collapse navbar-collapse menu-common" id="navbarSupportedContent">
                    <div class="row" style="background: #2b71b9 ; width:100%;margin:0 auto">
                        <div class="col-6">
                            <ul class="nav flex-column">
                                @if ($navbars)
                                    @foreach ($navbars as $key => $row)
                                        @if ($key == 0 && count($row) == 1)
                                            <li class="nav-item">
                                                <a class="nav-link active" id="home_url" aria-current="page"
                                                    href="{{ url($row[0]->function_id) }}"><i class="fa fa-home"
                                                        aria-hidden="true"><span>
                                                            {{ __('messages.home') }}</span></i></a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link active" id="btn-change-language"
                                                    style="color:white; cursor:pointer"
                                                    aria-current="page">{{ __('messages.language_setting') }}</a>
                                            </li>
                                        @elseif ($key == 1)
                                            <li class="nav-item nav-item-common" data-toggle="collapse"
                                                href="#collapseExample3" role="button" aria-expanded="false"
                                                aria-controls="collapseExample3">
                                                <a class="nav-link" href="#">1on1 <span><i
                                                            class="fa fa-chevron-right"></i></a>
                                            </li>
                                            <ul class="nav flex-column">
                                                <div class="collapse menu-child-common" id="collapseExample3">
                                                    @foreach ($row as $screen)
                                                        <a class="nav-link"
                                                            href="{{ url($screen->function_id) }}">{{ $screen->function_nm }}</a>
                                                    @endforeach
                                                </div>
                                            </ul>
                                        @endif
                                    @endforeach
                                @endif
                            </ul>
                        </div>
                        <div class="col-6">
                            <ul class="nav flex-column">
                                @if ($navbars)
                                    @foreach ($navbars as $key => $row)
                                        @if ($key == 2)
                                            <li class="nav-item nav-item-common" data-toggle="collapse"
                                                href="#collapseExample4" role="button" aria-expanded="false"
                                                aria-controls="collapseExample4">
                                                <a class="nav-link" href="#">{{ __('messages.weekly_master') }}
                                                    <span><i class="fa fa-chevron-right"></i></a>
                                            </li>
                                            <ul class="nav flex-column">
                                                <div class="collapse menu-child-common" id="collapseExample4">
                                                    @foreach ($row as $screen)
                                                        <a class="nav-link"
                                                            href="{{ url($screen->function_id) }}">{{ $screen->function_nm }}</a>
                                                    @endforeach
                                                </div>
                                            </ul>
                                        @elseif($key == 3)
                                            <li class="nav-item nav-item-common" data-toggle="collapse"
                                                href="#collapseExample5" role="button" aria-expanded="false"
                                                aria-controls="collapseExample5">
                                                <a class="nav-link" href="#">{{ __('messages.set') }}
                                                    <span><i class="fa fa-chevron-right"></i></a>
                                            </li>
                                            <ul class="nav flex-column">
                                                <div class="collapse menu-child-common" id="collapseExample5">
                                                    @foreach ($row as $screen)
                                                        <a class="nav-link"
                                                            href="{{ url($screen->function_id) }}">{{ $screen->function_nm }}</a>
                                                    @endforeach
                                                </div>
                                            </ul>
                                        @endif
                                    @endforeach
                                @endif
                            </ul>
                        </div>
                        <div class="col-12" style="margin:0 auto;margin-top:20px;margin-bottom:20px">
                            <button class="btn btn-primary" style="background: #f7f7f7;margin:0 auto;width:100%">
                                <a class="nav-link" href="{{ url('logout') . '?user_id=' . $auth->user_id }}"
                                    style="color:black;padding:0px"><span><i class="fa fa-sign-out"
                                            aria-hidden="true"></i></span>{{ __('messages.logout') }}</a>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </nav>
    <nav class="navbar navbar-expand-md fixed-top header navbar-pc">
        <a class="navbar-brand logo" href="javascript:;" tabindex="-1">
            <img src="/template/image/logo/logo-icon.png" height="40px">
        </a>
        <div class="collapse navbar-collapse" id="navbarCollapse">
            <ul class="navbar-nav mr-auto">
                <input type="text" placeholder="{{ __('messages.my_purpose') }}"
                    class="search_layout_input form-control indexTab Convert-Halfsize">
                <button class="btn btn-primary" style="background: #5087C7 !important;margin-left: 10px;">
                    <a class="nav-link" style="color:white;padding:0px">{{ __('messages.edit') }}</a>
                </button>
                <li>
                    <a tabindex="-1" class="nav-link" style="color: red;">
                        @if ($auth->change_pass_status ?? 0 == 1)
                            <i class="fa fa-exclamation-circle" aria-hidden="true" style="font-size: 20px;"></i>
                            <span
                                style="margin-left: 10px;">{{ __('messages.please_change_your_password') }}（{{ __('messages.day_left_until_expiration') }}{{ $auth->pass_remain ?? 0 }}{{ __('messages.day') }}）</span>
                        @endif
                    </a>
                </li>
            </ul>
            <ul class="navbar-nav right">
                <li class="nav-item">
                    <a class="nav-link icon" href="#" id="download-manual" tabindex="-1">
                        <i class="fa fa-download" aria-hidden="true"></i>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="javascript:void(0)" role="button" id="dropdownMenu2" class="nav-link dropdown-toggle"
                        data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" tabindex="-1">
                        <table>
                            <tr>
                                @if ($auth && isset($auth->company_nm))
                                    <td class="txt ellipsis" data-toggle="tooltip"
                                        title="{{ htmlspecialchars($auth->company_nm) }}" style="width:200px">
                                        {{ $auth->company_nm }}</td>
                                @endif
                            </tr>
                            <tr>
                                <td class="txt">
                                    <div data-toggle="tooltip"
                                        title="{{ isset($auth->m0070->employee_nm) ? $auth->m0070->employee_nm : '' }}"
                                        class="text-overflow text-wrap" style="width: 200px; padding-left:4px;">
                                        {{ isset($auth->m0070->employee_nm) ? $auth->m0070->employee_nm : '' }}
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </a>
                    <div class="dropdown-menu" aria-labelledby="dropdownMenu2">
                        <button class="dropdown-item" id="btn-change-language"
                            type="button">{{ __('messages.language_setting') }}</button>
                    </div>
                </li>

                <li class="nav-item">
                    <a class="nav-link icon logout" href='{{ url('logout') . '?user_id=' . $auth->user_id }}'
                        tabindex="-1">
                        <i class="fa fa-sign-out" aria-hidden="true"></i>
                        <span>{{ __('messages.logout') }}</span>
                    </a>
                </li>
            </ul>
        </div>
    </nav>
    <div class="main">
        <div class="main-nav main-pc">
            <ul class="list-group mcd-menu">
                @if ($navbars)
                    @foreach ($navbars as $key => $row)
                        <li class="parent-list">
                            @if ($key == 0 && count($row) == 1)
                                <a tabindex="-1" id="home_url" href="{{ url($row[0]->function_id) }}">
                                    <p><i class="fa fa-book" aria-hidden="true"></i></p>
                                    <div>{{ $row[0]->function_nm }}</div>
                                </a>
                            @elseif($key == 1)
                                <a tabindex="-1" href="">
                                    <p><img style="width:50px;height:50px" src={!! public_url('template/image/icon/icon_2_write.png') !!}></p>
                                    <div>1on1</div>
                                </a>
                            @elseif($key == 2)
                                <a tabindex="-1" href="">
                                    <p><img style="width:50px;height:50px" src={!! public_url('template/image/icon/icon4.png') !!}></p>
                                    <div>{{ __('messages.weekly_master') }}</div>
                                </a>
                            @elseif($key == 3)
                                <a tabindex="-1" href="">
                                    <p><img style="width:50px;height:50px" src={!! public_url('template/image/icon/icon_4_write.png') !!}></p>
                                    <div>{{ __('messages.set') }}</div>
                                </a>
                            @endif
                            @if (count($row) > 0 && $key >= 1)
                                <ul>
                                    @foreach ($row as $screen)
                                        <li>
                                            <a tabindex="-1" href="{{ url($screen->function_id) }}">
                                                <i class="fa fa-genderless"></i>{{ $screen->function_nm }}
                                            </a>
                                        </li>
                                    @endforeach
                                </ul>
                            @endif
                        </li>
                    @endforeach
                @endif
            </ul>
        </div>
        <div class="content master-content">
            <div class="container-fluid">
                <div class="row" style="height:58px;position:relative">
                    <div class="col-10 col-xl-6 col-lg-6 header-left-function ">
                        <h5 class="title-screen">{{ $title ?? '' }}</h5>
                    </div>
                    @stack('asset_button')
                </div>
            </div>
            @yield('content')
        </div> <!-- end .content -->
    </div> <!-- end .main -->
    <footer class="footer footer-master">
        <div class="container" style="margin-right: 0px">
            <ol class="breadcrumb hide">
                <li class="breadcrumb-item">&nbsp;</li>
                <li class="breadcrumb-item"><a href="#">ヘルプ</a></li>
                <li class="breadcrumb-item active" aria-current="page">お問い合わせ</li>
            </ol>
        </div>
    </footer>
    <!-- domain js-->
    {!! public_url('template/js/common/domain.js') !!}
    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    {!! public_url('template/js/common/jquery.min.js') !!}
    {!! public_url('template/js/common/jquery.datetimepicker.full.min.js') !!}
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    {!! public_url('template/js/common/popper.js') !!}
    {!! public_url('template/js/common/bootstrap.min.js') !!}
    <script>
        var _text = {!! json_encode($_text) !!}
    </script>
    {!! public_url('template/js/common/moment-with-locales.min.js') !!}
    {!! public_url('template/js/common/bootstrap-material-datetimepicker.js') !!}
    {!! public_url('template/js/common/ansplugin.js') !!}
    {!! public_url('template/js/common/jmessages.js') !!}
    {!! public_url('template/js/common/common.js') !!}
    {!! public_url('template/js/common/app.js') !!}
    {!! public_url('template/js/common/jquery.colorbox-min.js') !!}
    {{-- {!!public_url('template/js/common/jquery-ui.js')!!} --}}
    {!! public_url('template/js/common/jquery.resizableColumns.js') !!}
    {!! public_url('template/js/common/bootstrap_multiselect.js') !!}
    {!! public_url('template/js/common/uniform.min.js') !!}
    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
 {!! public_url('template/js/common/html5shiv.min.js') !!}
 {!! public_url('template/js/common/respond.min.js') !!}
 <![endif]-->
    @yield('asset_common')
    {{-- @include('common') --}}
    <div class="div_loading">
        <div class="image_loading_popup">
            <img src="{{ asset('template/image/system/loading.gif') }}">
        </div>
    </div>
    @yield('asset_footer')
</body>

</html>
