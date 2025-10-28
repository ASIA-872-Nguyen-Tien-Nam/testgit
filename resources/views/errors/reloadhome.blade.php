<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <title>@yield('title','403 Permission denied!')</title>
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <link href="\template\image\logo\favico.png" rel="shortcut icon">
    <!-- Bootstrap -->
    {!! public_url('template/css/common/bootstrap.min.css') !!}
    {!! public_url('template/css/common/font-awesome.min.css') !!}

        {!! public_url('template/js/common/jquery.min.js') !!}
        {!! public_url('template/js/common/bootstrap.min.js') !!}
 
</head>
<body>
    
</body>

<script type="text/javascript">
    $(document).ready(function () {
    try {
        window.parent.location.reload();
    } catch (e) {
        console.log(1);
        //window.location.href = '/login';
    }
});
</script>
</html>