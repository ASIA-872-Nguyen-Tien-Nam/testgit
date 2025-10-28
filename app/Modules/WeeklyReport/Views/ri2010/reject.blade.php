@if (isset($reaction_rejects) && !empty($reaction_rejects))
    @foreach ($reaction_rejects as $reaction_reject)
    {{-- reject with reaction_type = 4 --}}
    @if ($reaction_reject['reaction_type'] == 4)
    <div class="row mb-2 reaction__row">
        <div class="col-sm-12 col-md-12">
            <span>{{ $reaction_reject['reaction_datetime'] }} {{ $reaction_reject['reaction_user'] }}</span>
        </div>
    </div>
    <div class="row mb-2 reaction__row line-solid">
        <div class="col-sm-12 col-md-12">
            <div class="infomation_message">
                {!! nl2br($reaction_reject['share_text']) !!}
            </div>
        </div>
    </div>
    @endif
    @endforeach
@else
    <div class="text-center mb-3">
        {{ $_text[21]['message'] }}
    </div>
@endif