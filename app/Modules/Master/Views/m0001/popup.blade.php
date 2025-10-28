@extends('popup')

@section('asset_header')
{!! public_url('template/css/popup/m0001p.index.css') !!}
@stop

@section('asset_footer')
{!! public_url('template/js/popup/m0001p.index.js') !!}
@stop

@section('content')
<div class="card">
    <div class="card-body">
        <div class="row">
            <div class="col-md-12">                  
                <div class="form-group">
                    <label class="control-label lb-required" lb-required="{{ __('messages.required') }}">{{__('messages.user_id')}}</label>
                    <span class="num-length">
                      <input type="hidden" class="form-control" id="company_cd" value="{{isset($company_cd)?$company_cd:''}}" />
                      <input type="text" class="form-control {{isset($data['user_id'])?'':'required'}}" tabindex="1" placeholder="{{__('messages.user_id')}}" id="m0001_user_id" value="{{isset($data['user_id'])?$data['user_id']:''}}" maxlength="10" {{isset($data['user_id'])?'disabled':''}}/>
                   </span>
               </div><!--/.form-group -->
           </div><!--/.col-md-12 -->  　　
       </div><!--/.row -->
       <div class="clearfix"></div>
       <div class="row">
        <div class="col-md-12">                  
          <div class="form-group">
            <label class="control-label  {{$sso_use_typ == 0?'lb-required':''}}" lb-required="{{ __('messages.required') }}">{{__('messages.mail_password')}}</label>
            <span class="num-length">
             <input type="text" class="form-control {{$sso_use_typ == 0?'required':''}} " placeholder="{{__('messages.mail_password')}}" id="password" tabindex="2" maxlength="20" value="{{isset($data['password'])?$data['password']:''}}"  {{$sso_use_typ == 1?'disabled':''}}>
             <input type="text" class="form-control hidden" id="check_sso" value="{{$sso_use_typ }}">
           </span>
         </div><!--/.form-group -->
       </div> <!--/.col-md-12 -->   　　
     </div><!--/.row -->  
     <div class="clearfix"></div>
       <div class="row">
        <div class="col-md-12">                  
          <div class="form-group">
            <label class="control-label  {{$sso_use_typ == 1?'lb-required':''}}" lb-required="{{ __('messages.required') }}">{{__('messages.sso_user_id')}}</label>
            <span class="num-length">
             <input type="text" class="form-control {{$sso_use_typ == 1 && !isset($data['user_id'])?'required':''}}" placeholder="{{__('messages.sso_user_id')}}" id="sso_user" tabindex="3" maxlength="255" value="{{isset($data['sso_user'])?$data['sso_user']:''}}" {{isset($data['user_id'])?'disabled':''}}>
           </span>
         </div><!--/.form-group -->
       </div> <!--/.col-md-12 -->   　　
     </div><!--/.row -->  
     <div class="clearfix"></div>
    <div class="row">
        <div class="col-md-12">   
          <ul class="navbar-nav text-center">
            <li class="nav-item active">    
              <a href="javascript:;" id="btn-save" class="btn btn-horizontal btn-outline-primary">        
                <i class="fa fa-pencil-square-o "></i>      
                <div>{{__('messages.register')}}</div>   
              </a>
            </li>
          </ul>
        </div><!--/.col-md-12 -->   　
     </div><!--/.row -->  
  </div><!--/.card-body -->  
</div><!--/.card -->  
@stop