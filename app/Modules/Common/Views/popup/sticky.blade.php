@extends('popup')

@push('header')
{{-- {!!public_url('template/css/popup/ri0020.index.css')!!} --}}
@endpush

@section('asset_footer')
    {!! public_url('template/js/popup/sticky.js') !!}
@stop

@section('content')
    <div class="col-md-12">
        <div class="row sticky">
            @if (isset($notes) && !empty($notes))
            @foreach ($notes as $item)
                @php $active = ''; @endphp
                @if ($note['note_kind'] == $item['note_kind'])
                @if ($note['note_no'] == $item['note_no'])
                    @php
                        $active = 'active';
                    @endphp
                @endif
                <div class="col-6 col-sm-6 col-md-2 col-lg-2 col-xl-2">
                    <div class="form-group">
                        <a href="javascript:;" class="btn btn__sticky--{{ $item['note_color'] }} btn-sticky {{ $active }}" note_no="{{ $item['note_no'] }}" style="background-color: {{ $item['note_color_code'] ?? '' }}" tabindex="">
                            {{ $item['note_name'] ?? '' }}  
                            <i class="fa fa-check" aria-hidden="true"></i>
                        </a>
                    </div>
                </div>
                @endif
            @endforeach
            @endif
        </div>

        <div class="row mt-3">
            <div class="col-12">
                <div class="form-group">
                    <span class="num-length">
                        <textarea type="text" class="form-control" tabindex="1" maxlength="200" id="note_explanation" placeholder="{{ __('ri2010.memo_placeholder') }}" value="{{ $note['note_explanation'] ?? '' }}">{{ $note['note_explanation'] ?? '' }}</textarea>
                    </span>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-12">
                <input type="hidden" id="sticky_data" fiscal_year={{ $fiscal_year ?? 0 }} employee_cd={{ $employee_cd ?? '' }} report_kind={{ $report_kind ?? 0 }} report_no={{ $report_no ?? 0 }} >
                <div class="group-btn" style="justify-content: center;display: flex">
                    {!! Helper::buttonRenderWeeklyReport(['stickyButton']) !!}
                </div>
            </div>
        </div>
        <input type="hidden" class="anti_tab">
    </div>
@stop
