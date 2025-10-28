<div class="row">
    <div class="col-md-12 col-lg-12 col-sm-12 col-xl-12 col-xxl-9">
        <div class="table-responsive" style="min-height: 40vh">
            <table class="table table-bordered table-hover  one-table">
                <thead>
                    <tr>
                        <th class="col-cb1"></th>
                        <th class="col-file">{{__('messages.file_name')}}</th>
                        <th class="col-file" style="width: 150px;">{{__('messages.file_size')}}</th>
                        <th class="col-title">{{__('messages.title')}}</th>
                        <th class="col-cb">{{__('messages.admin')}}</th>
                        <th class="col-cb">{{__('messages.coach')}}</th>
                        <th class="col-cb">{{__('messages.member')}}</th>
                    </tr>
                </thead>
                <tbody >
                    @if (isset($data_file[0])&& !empty($data_file[0]))
                        @foreach($data_file as $key => $row)
                        <tr class="list">
                            <td class="text-center td-del col-cb1">
                                <input type="hidden" class="refer_kbn" value="{{$row['refer_kbn']??''}}">
                                <input type="hidden" class="file_cd" value="{{$row['file_cd']??''}}">
                                @if($row['btn'] == 1 )
                                    <button class="btn btn-outline-danger btn_delete_file" tabindex="3">{{__('messages.delete')}}</button>
                                    <input type="hidden" class="user_use_typ" value="1">
                                @endif
                                @if($row['btn'] == 2 )
                                    <select name="" id="" class="user_use_typ form-control" tabindex="3">
                                    @if(isset($active[0])&& !empty($active[0]))
                                        <option {{$row['user_use_typ']== 0 ?'selected': ''}} value="0">{{ $active[0]['name']}}</option>
                                    @endif
                                    @if(isset($active[1])&& !empty($active[1]))
                                        <option {{$row['user_use_typ']== 1 ?'selected': ''}} value="1">{{ $active[1]['name']}}</option>
                                    @endif
                                    </select>
                                @endif
                                @if($row['btn'] == 99)
                                    <input type="hidden" class="user_use_typ" value="1">
                                @endif
                            </td>
                            <td class="col-file">
                                <input type="hidden" class="file_nm" value="{{$row['file_nm']??''}}">
                                {{$row['file_nm']??''}}
                                @if($row['file_status'] == 1 )
                                    <div class="new-item">New!</div>
                                @endif
                            </td>
                            <td class="col-file" style="width: 150px;">
                                {{$row['filesize']??'0 KB'}}
                            </td>
                            <td class="col-title">
                                <span class="num-length">
                                    <input type="text" class="form-control title" maxlength="50"  value="{{$row['title']}}"  {{$row['user_use_typ']== 0 ?'disabled': ''}} tabindex=3>
                                </span>
                            </td>
                            <td class="text-center col-cb">
                                <div class="md-checkbox-v2 mt-2">
                                    <label for="{{'admin_use_typ'.$key}}" class="container">
                                        <input name="admin_use_typ" id="{{'admin_use_typ'.$key}}" class="admin_use_typ" type="checkbox"
                                        value="{{$row['admin_use_typ']??0}}"  {{$row['admin_use_typ'] == 1 && $row['user_use_typ']== 1?'checked':''}} {{$row['user_use_typ']== 0 ?'disabled': ''}} tabindex=3>
                                        <span class="checkmark"></span>
                                    </label>
                                </div>
                            </td>
                            <td class="text-center col-cb">
                                <div class="md-checkbox-v2 mt-2">
                                    <label for="{{'coach_use_typ'.$key}}" class="container">
                                        <input name="coach_use_typ" id="{{'coach_use_typ'.$key}}" class="coach_use_typ" type="checkbox"
                                            value="{{$row['coach_use_typ']??0}}"  {{$row['coach_use_typ'] == 1 && $row['user_use_typ']== 1?'checked':''}} {{$row['user_use_typ']== 0 ?'disabled': ''}} tabindex=3>
                                        <span class="checkmark"></span>
                                    </label>
                                </div>
                            </td>
                            <td class="text-center col-cb">
                                <div class="md-checkbox-v2 mt-2">
                                    <label for="{{'member_use_typ'.$key}}" class="container">
                                        <input name="member_use_typ" id="{{'member_use_typ'.$key}}" class="member_use_typ" type="checkbox"
                                                value="{{$row['member_use_typ']??0}}" {{$row['member_use_typ'] == 1 && $row['user_use_typ']== 1?'checked':''}} {{$row['user_use_typ']== 0 ?'disabled': ''}} tabindex=3>
                                        <span class="checkmark"></span>
                                    </label>
                                </div>
                            </td>
                        </tr>
                        @endforeach
                    @else
                        <tr>
                            <td class="text-center hide-table" width="100px" colspan="6"> {{ $_text[21]['message'] }}</td>
                        </tr>
                    @endif

                </tbody>
            </table>
        </div><!-- end .table-responsive -->
    </div>
</div>
<div class="row justify-content-md-center">
    {!!
        Helper::buttonRender1on1(['saveButton'])
    !!}
</div>