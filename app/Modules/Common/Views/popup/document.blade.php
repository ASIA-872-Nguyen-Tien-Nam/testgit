@extends('popup')

<!-- @section('asset_header') -->
<!-- START LIBRARY CSS -->
<!-- {!!public_url('template/css/popup/change_pass.css')!!} -->
<style type="text/css">
    li{
        cursor: pointer;
    }
    .p-content {
        margin-top: 50px!important;
    }
</style>
@stop

@section('asset_footer')
<!-- START LIBRARY JS -->
<!-- {!! public_url('template/js/popup/change_pass.js') !!} -->
<script type="text/javascript">
$( document ).ready(function() {
    $('li').click(function(){
        var module_typ = $('#module_typ').val();
        var file_name = $(this).attr('file_name');
        var file_address = '';
        // 1on1
        if(module_typ == 2){
            file_address        = '/oneonone_manual/'+file_name; 
        }else if (module_typ == 3){
            file_address        = '/mulitiview_manual/'+file_name; 
        }else{
            file_address        = '/manual/'+file_name; 
        }
        // download file
        if(file_name !=''){
            downloadfileHTML(file_address ,file_name, function () {
            });
        }else{
            jMessage(21);return;
        }
    });
});
</script>
@stop

@section('content')
<div class="card-body">
    <input type="hidden" id="module_typ" value="{{ $module_typ ?? 1}}" />
    <div class="row">
        <div class="col-md-12">
            <ul class="list-group list-group-flush">
                @if(isset($files) && count($files) > 0)
                    @foreach($files as $row)
                        <li class="list-group-item list-group-item-action btn_document_click" file_name="{{$row}}">
                            <a href="#">{{$row}}</a>
                        </li>
                    @endforeach
                @endif
            </ul>
        </div>  　　
    </div>
</div>
@stop