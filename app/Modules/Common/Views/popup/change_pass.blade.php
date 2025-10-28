@extends('popup')

@section('asset_header')
<!-- START LIBRARY CSS -->
{!!public_url('template/css/popup/change_pass.css')!!}
@stop

@section('asset_footer')
<!-- START LIBRARY JS -->
{!! public_url('template/js/popup/change_pass.js') !!}
@stop

@section('content')
<div class="card-body">
    <div class="row">
        <div class="col-md-6">                  
            <div class="form-group">
                <label class="control-label">{{__('messages.user_id')}}</label>
                <span class="num-length">
                 <input type="text" id="user_id" class="form-control" tabindex="1" placeholder="{{__('messages.user_id')}}"  disabled maxlength="10" value="{{($user_id !=''?$user_id:'')}}"/>
             </span>
         </div><!--/.form-group -->
     </div>  　　
 </div>
 <div class="clearfix"></div>
 <div class="row">
    <div class="col-md-6">                  
        <div class="form-group">
            <label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{__('messages.old_password')}}</label>
            <span class="num-length">
             <input type="text" id="old_password" class="form-control required" placeholder="{{__('messages.old_password')}}" tabindex="1" maxlength="20">
         </span>
     </div><!--/.form-group -->
 </div>  　　
</div>
<div class="clearfix"></div>
<div class="row">
    <div class="col-md-6">                  
        <div class="form-group">
            <label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{__('messages.new_password')}}</label>
            <span class="num-length">
             <input type="text" id="new_password" class="form-control required" tabindex="2" placeholder="{{__('messages.new_password')}}"  maxlength="20">
         </span>
     </div><!--/.form-group -->
 </div>  　　
</div>
<div class="clearfix"></div>
<div class="row">
    <div class="col-md-6">                  
        <div class="form-group">
            <label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{__('messages.new_password_confirm')}}</label>
            <span class="num-length">
             <input type="text" id="cf_new_password" class="form-control required" tabindex="3"  placeholder="{{__('messages.new_password_confirm')}}"  maxlength="20">
         </span>
     </div><!--/.form-group -->
 </div>  　　
</div>
<div class="clearfix"></div>
<ul class="navbar-nav text-right" id="end_tab">
    <li class="nav-item active">    
        <a href="javascript:;" id="btn-save" class="btn btn-horizontal btn-outline-primary" tabindex="4">        
            <i class="fa fa-pencil-square-o "></i>      
            <div>{{__('messages.register')}}</div>   
        </a>
    </li>
</ul>
<input type="hidden" class="anti_tab" name="">
</div>
@stop