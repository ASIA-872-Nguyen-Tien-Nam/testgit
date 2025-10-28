<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
	<title>@yield('title','405 Method Not Allowed!')</title>
	<meta name="csrf-token" content="{{ csrf_token() }}">
	<link href="\template\image\logo\favico.png" rel="shortcut icon">
	<!-- Bootstrap -->
	{!! public_url('template/css/common/bootstrap.min.css') !!}
	{!! public_url('template/css/common/font-awesome.min.css') !!}
	<style>
            html, body {
                background-color: #fff;
                background: linear-gradient(-135deg, #36AAD6, #60AE8E) fixed;
				color: #fff;
				line-height: 1.3;
				-webkit-font-smoothing: antialiased;
				font-family: "游ゴシック体", YuGothic, "游ゴシック Medium", "Yu Gothic Medium", "游ゴシック", "Yu Gothic", "メイリオ", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol";
    			/*font-size: .875rem;*/
            }
            .container-fluid{
            	margin-top: 50px;
            }
            .face_error{
            	font-size: 10rem;
            }
            .text_first{
            	font-size: 2.5rem;
            }
            html, body, div, span, applet, object, iframe,
			h1, h2, h3, h4, h5, h6, p, blockquote, pre,
			a, abbr, acronym, address, big, cite, code,
			del, dfn, em, img, ins, kbd, q, s, samp,
			small, strike, strong, sub, sup, tt, var,
			b, u, i, center,
			dl, dt, dd, ol, ul, li,
			fieldset, form, label, legend,
			table, caption, tbody, tfoot, thead, tr, th, td,
			article, aside, canvas, details, embed,
			figure, figcaption, footer, header, hgroup,
			menu, nav, output, ruby, section, summary,
			time, mark, audio, video {
			  margin: 0;
			  padding: 0;
			  border: 0;
			  font-size: 100%;
			  font: inherit;
			  vertical-align: baseline;
			}
			h1 {
			  text-transform: uppercase;
			  font-size: 85px;
			  font-weight: 700;
			  letter-spacing: 0.015em;
			}
			.container {
			    max-width: 600px;
			    margin: 0 auto;
			    padding: 10% 0 0% 0;
			    text-align: center;
			}
			.container h1 {
			  font-size: 40px;
			  transition-duration: 1s;
			  transition-timing-function: ease-in-put;
			  font-weight: 200;
			}
			.wrapper.form-success .container h1 {
			  transform: translateY(85px);
			}
        </style>
</head>
<body>
	{{config(['app.locale' => \Session::get('website_language', config('app.locale'))])}}
	<div id="content" class="wrapper">
		<div class="container">
			<div class="row">
				<div class="col-md-12 text-center">
					<label class="text_first">{{ __('messages.label_030') }}</label>
				</div>
			</div>
			<div class="row">
				<div class="col-md-12 text-center">
					<div class="title">
					@if(\Session::get('website_language', config('app.locale')) == 'en')
						<h2>■{{ __('messages.once') }} {{ __('messages.return_to') }} <a href="#" onclick="backScreen()">{{ __('messages.previous_age') }}</a></h2>
					@else
						<h2>■{{ __('messages.once') }}<a href="#" onclick="backScreen()">{{ __('messages.previous_age') }}</a> {{ __('messages.return_to') }}</h2>
					@endif
	                </div>
				</div>
			</div>
		</div>
	</div><!--/#content --> 
</body>
</html>
<script>
	function  backScreen(){
		try{
            // location.href =document.referrer;
            window.history.go(-1);
		}catch(e){
			alert(e.message);
		}
	};
</script>