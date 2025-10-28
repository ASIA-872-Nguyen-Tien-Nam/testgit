<div class="row">
    <div class="col-md-5">
        <div class="form-group">
            <label class="control-label lb-required">{{__('messages.authority_name')}}</label>
                <span class="num-length">
                    <input type="hidden" id="authority_cd" class="form-control required" maxlength="20" value="{{$data[0]['authority_cd']}}">
                    <input tabindex="1" type="text" id="authority_nm" class="form-control required" maxlength="50" value="{{$data[0]['authority_nm']}}">
                </span>
        </div>
    </div>
    <div class="col-md-3">
        <label class="control-label">{{__('messages.usage_category')}}</label>
        <table>
            <tr>
                <td style="height: 38px;">
                    <div class="md-checkbox-v2">
                        <input name="use_typ" id="use_typ" {{$data[0]['use_typ']==1?'checked':''}} value="{{$data[0]['use_typ']}}" type="checkbox" tabindex="2">
                        <label for="use_typ" style="margin: 0;" class="lbl-text">&nbsp;{{__('messages.label_002')}}</label>
                    </div>
                </td>
            </tr>
        </table>
    </div>
    <div class="col-md-2">
        <div class="form-group">
            <label class="control-label">{{__('messages.sort_order')}}</label>
            <span class="num-length">
                <div class="input-group">
                    <input type="text" id="arrange_order" class="form-control only-number" maxlength="4" value="{{$data[0]['arrange_order']}}" tabindex="3">
                </div>
            </span>
        </div>
    </div>
</div> <!-- end .row -->
<div class="row">
    <div class="col-md-6">
        <div class="row">
            <div class="col-md-6 col-sm-6 col-ltx-3">
                <p>{{__('messages.set_functions_authority ')}}</p>
            </div>

            <div class="col-md-6 col-sm-6 col-ltx-7 div-reflect">
                <p><button id="btn-reflect" class="btn btn-primary focusin" tabindex="4">{{__('messages.batch_reflect')}}</button></p>
                <div class="form-group">
                    <select class="form-control required " id="reflect" tabindex="5">
                        @foreach($combobox as $cb)
                            <option value="{{$cb['number_cd']}}">{{$cb['name']}}</option>
                        @endforeach
                    </select>
                </div>
            </div>
        </div>

        <div class="table-responsive wmd-view table-fixed-header table-data">
            <table class="table table-bordered table-hover fixed-header">
                <thead>
                <tr>
                    <th>{{__('messages.function_name')}}</th>
                    <th width="200">{{__('messages.use_authority')}}</th>
                </tr>
                </thead>
                <tbody>
                @foreach($result as $key=>$value)
                    <tr class="function list_function">
                        <input type="hidden" class="function_id" value="{{$value['function_id']}}">
                        <input type="hidden" class="function_nm" value="{{$value['function_nm']}}">
                        <td>{{$value['function_nm']}}</td>
                        <td>
                            <select class="form-control required authority" tabindex="{{5+$key}}">
                                @foreach($combobox as $cb)
                                    <option value="{{$cb['number_cd']}}" {{$value['authority']==$cb['number_cd']?'selected':''}}>
                                        {{$cb['name']}}
                                    </option>
                                @endforeach
                            </select>
                        </td>
                    </tr>
                @endforeach
                </tbody>
            </table>
        </div>
    </div>

    <div class="col-md-6">
        <p>{{__('messages.authority_range')}}</p>
        <div class="table-responsive table-data table-hover" id="table-organization">
            <ul>
                @for ($i=0; $i<=4; $i++)
                <li>
                    <a href="#" class="lv1">
                        <table class="ck-inline">
                            <tr>
                                <td>
                                    <div class="md-checkbox-v2">
                                        <input name="XXX1" id="XXX1" value="0" type="checkbox" >
                                        <label for="use_typ" class="lbl-text no"></label>
                                    </div>
                                </td>
                                <td>XXX</td>
                            </tr>
                        </table>
                    </a>
                    <ul>
                        <li>
                            <a href="#" class="lv2">
                                <table class="ck-inline">
                                    <tr>
                                        <td>
                                            <div class="md-checkbox-v2">
                                                <input name="XXX1" id="XXX1" value="0" type="checkbox" >
                                                <label for="use_typ" class="lbl-text no"></label>
                                            </div>
                                        </td>
                                        <td>XXX</td>
                                    </tr>
                                </table>
                            </a>
                            <ul>
                                <li>
                                    <a href="#" class="lv3">
                                        <table class="ck-inline">
                                            <tr>
                                                <td>
                                                    <div class="md-checkbox-v2">
                                                        <input name="XXX1" id="XXX1" value="0" type="checkbox" >
                                                        <label for="use_typ" class="lbl-text no"></label>
                                                    </div>
                                                </td>
                                                <td>XXX</td>
                                            </tr>
                                        </table>
                                    </a>
                                    <ul>
                                        <a href="#" class="lv4">
                                            <table class="ck-inline">
                                                <tr>
                                                    <td>
                                                        <div class="md-checkbox-v2">
                                                            <input name="XXX1" id="XXX1" value="0" type="checkbox" >
                                                            <label for="use_typ" class="lbl-text no"></label>
                                                        </div>
                                                    </td>
                                                    <td>XXX</td>
                                                </tr>
                                            </table>
                                        </a>
                                        <ul>
                                            <li>
                                                <a href="#" class="lv5">
                                                    <table class="ck-inline">
                                                        <tr>
                                                            <td>
                                                                <div class="md-checkbox-v2">
                                                                    <input name="XXX1" id="XXX1" value="0" type="checkbox" >
                                                                    <label for="use_typ" class="lbl-text no"></label>
                                                                </div>
                                                            </td>
                                                            <td>XXX</td>
                                                        </tr>
                                                    </table>
                                                </a>
                                            </li>
                                        </ul>
                                    </ul>
                                </li>
                            </ul>
                        </li>
                        <li>
                            <a href="#" class="lv2">
                                <table class="ck-inline">
                                    <tr>
                                        <td>
                                            <div class="md-checkbox-v2">
                                                <input name="XXX1" id="XXX1" value="0" type="checkbox" >
                                                <label for="use_typ" class="lbl-text no"></label>
                                            </div>
                                        </td>
                                        <td>XXX</td>
                                    </tr>
                                </table>
                            </a>
                        </li>
                    </ul>
                </li>
                @endfor
            </ul>
        </div>
    </div>
</div>


