<div class="col-md-12" style="margin-top : 10px">
    <div class="wmd-view table-responsive-right table-responsive _width" style="max-height: 400px">
        <table class="table table-bordered table-hover table-oneheader ofixed-boder table-head table-add" style="margin-bottom: 20px !important;">
            <thead>
                <tr>
                    <th class="text-center" style="width: 10%;">{{ __('messages.sort_order') }}</th>
                    <th class="text-center" style="width: 27%;">{{ __('messages.name') }}</th>
                    <th style="width: 3%"></th>
                </tr>
            </thead>
            <tbody>
            @if ( isset($list))
                @foreach ($list as $key => $value)
                <tr class="tr" style="cursor: pointer">
                    <input type="hidden" class="training_cd" value="{{$value['training_cd']}}">
                    <td class="text-right">
                        <span class="num-length arrange_order">
                            {{$value['arrange_order']}}
                        </span>
                    </td>
                    <td>
                        <span class="num-length training_nm">
                            {{$value['training_nm']}}
                        </span>
                    </td>
                    <td class="text-center">
                        <button tabindex="2" class="btn btn-rm btn-sm btn-remove-row-popup">
                            <i class="fa fa-remove"></i>
                        </button>
                    </td>
                </tr>
                @endforeach
            @endif
            </tbody>
        </table>
    </div><!-- end .table-responsive -->
</div>