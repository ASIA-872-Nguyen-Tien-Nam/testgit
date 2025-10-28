@extends('popup')

@section('asset_header')
<!-- START LIBRARY CSS -->
{!!public_url('template/css/popup/change_language.css')!!}
@stop

@section('asset_footer')
<!-- START LIBRARY JS -->
{!! public_url('template/js/popup/change_language.js') !!}
@stop

@section('content')
<div class="card-body">
    <div class="row" style="min-height:300px">
        <div class="language__setting col-md-6 col-xl-4 col-lg-4">
            <div class="form-group col-12">
                <label class="control-label {{$result['label_required1']??''}}">{{ __('messages.language') }}</label>
                <select tabindex="1" class="form-control {{$result['input_required1']??''}}" id="option_language">
                @foreach($L0010 as $dt)
                    @if($language == 'jp')
                    @if($dt['number_cd'] == 1)
                        <option value='{{$dt['number_cd']}}' selected>
                        {{$dt['name']}}
                        </option>
                        @else
                        <option value='{{$dt['number_cd']}}'>
                        {{$dt['name']}}
                        </option>
                        @endif
                    @else
                        @if($dt['number_cd'] == 2)
                        <option value='{{$dt['number_cd']}}' selected>
                        {{$dt['name']}}
                        </option>
                        @else
                        <option value='{{$dt['number_cd']}}'>
                        {{$dt['name']}}
                        </option>
                        @endif
                    @endif
                @endforeach
                </select>
            </div>
        </div>
	</div> <!-- end .row -->
<div class="clearfix"></div>
<ul class="navbar-nav text-right" id="end_tab">
    <li class="nav-item active">    
        <a href="javascript:;" id="btn-save-language" class="btn btn-horizontal btn-outline-primary" tabindex="2">        
            <i class="fa fa-pencil-square-o "></i>      
            <div>{{ __('messages.reflect') }}</div>   
        </a>
    </li>
</ul>
<input type="hidden" class="anti_tab" name="">
</div>
@stop