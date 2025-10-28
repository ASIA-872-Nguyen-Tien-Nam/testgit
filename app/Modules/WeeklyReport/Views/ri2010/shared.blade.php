@if (isset($reaction_shareds) && !empty($reaction_shareds))
    @foreach ($reaction_shareds as $reaction_shared)
        {{-- shared with reaction_type = 5 --}}
        @if ($reaction_shared['reaction_type'] == 5)
        <div class="row mb-2 reaction__row">
            <div class="col-sm-12 col-md-12">
                <span>{{ $reaction_shared['reaction_datetime'] }} {{ $reaction_shared['reaction_user'] }}</span>
            </div>
        </div>
        <div class="row mb-2 reaction__row line-solid">
            <div class="col-sm-12 col-md-12">
                <div class="text-overfollow infomation_message" data-container="body" data-html="true" data-toggle="tooltip" data-original-title="{!!nl2br($reaction_shared['share_text'] ?? '')!!}">
                    {!! nl2br($reaction_shared['share_text']) !!}
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