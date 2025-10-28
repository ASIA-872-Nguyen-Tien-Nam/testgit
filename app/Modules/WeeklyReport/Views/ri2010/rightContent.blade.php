@php
    //未処理の場合のみ表示
    $is_reject = 0;
    if (isset($reaction_rejects) && !empty($reaction_rejects)) {
        $is_reject = 1;
    }
    // 共有先社員のデータがある
    $is_shared = 0;
    if (isset($reaction_shareds) && !empty($reaction_shareds)) {
        $is_shared = 1;
    }
@endphp
{{-- Tab --}}
<ul class="nav nav-tabs tab-style">
    @if ($is_reject == 1)
        {{-- Reactions Tab --}}
        <li class="nav-item">
            <a class="nav-link hei" data-toggle="tab" href="#tab_comment1" role="tab"
                aria-selected="true">
                {{ __('ri2010.reaction') }}
                <div class="caret"></div>
            </a>
        </li>
        {{-- Reject Tab --}}
        <li class="nav-item">
            <a class="nav-link hei active show" data-toggle="tab" href="#tab_comment2"
                role="tab" aria-selected="true">
                {{ __('ri2010.reject_tab') }}
                <div class="caret"></div>
            </a>
        </li>
        {{-- Shared Tab --}}
        <li class="nav-item">
            <a class="nav-link hei" data-toggle="tab" href="#tab_comment3" role="tab"
                aria-selected="true">
                {{ __('ri2010.shared_tab') }}
                <div class="caret"></div>
            </a>
        </li>
    @elseif ($is_reject == 0 && $is_shared == 1)
        {{-- Reactions Tab --}}
        <li class="nav-item">
            <a class="nav-link hei" data-toggle="tab" href="#tab_comment1" role="tab"
                aria-selected="true">
                {{ __('ri2010.reaction') }}
                <div class="caret"></div>
            </a>
        </li>
        {{-- Shared Tab --}}
        <li class="nav-item">
            <a class="nav-link hei active show" data-toggle="tab" href="#tab_comment3"
                role="tab" aria-selected="true">
                {{ __('ri2010.shared_tab') }}
                <div class="caret"></div>
            </a>
        </li>
    @else
        {{-- Reactions Tab --}}
        <li class="nav-item">
            <a class="nav-link hei active show" data-toggle="tab" href="#tab_comment1"
                role="tab" aria-selected="true">
                {{ __('ri2010.reaction') }}
                <div class="caret"></div>
            </a>
        </li>
    @endif
</ul>
{{-- Tab Content --}}
<div class="tab-content list_detail w-result-tabs">
    @if ($is_reject == 1)
        <div class="tab-pane fade reaction" id="tab_comment1">
            {{-- Reactions --}}
            @include('WeeklyReport::ri2010.reaction')
        </div>
        <div class="tab-pane fade reaction active show" id="tab_comment2">
            {{-- Reject --}}
            @include('WeeklyReport::ri2010.reject')
        </div>
        <div class="tab-pane fade reaction" id="tab_comment3">
            {{-- Shareds --}}
            @include('WeeklyReport::ri2010.shared')
        </div>
    @elseif($is_reject == 0 && $is_shared == 1)
        <div class="tab-pane fade reaction" id="tab_comment1">
            {{-- Reactions --}}
            @include('WeeklyReport::ri2010.reaction')
        </div>
        <div class="tab-pane fade reaction active show" id="tab_comment3">
            {{-- Shareds --}}
            @include('WeeklyReport::ri2010.shared')
        </div>
    @else
        <div class="tab-pane fade active show reaction" id="tab_comment1">
            {{-- Reactions --}}
            @include('WeeklyReport::ri2010.reaction')
        </div>
    @endif
</div>
