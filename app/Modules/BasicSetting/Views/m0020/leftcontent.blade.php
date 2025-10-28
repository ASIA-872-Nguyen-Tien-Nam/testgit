<?php
function gen($item, $level, $i='', $j='', $k='', $l='', $m='') {
    $html = '<ul>';
    foreach ($item as $key => $tmp) {
        $html .= '<li>';
        $html .= '<a class="lv1" txt="" data-toggle="collapse" href="#collapse-lvl-'.$i.'-'.$j.'-'.$k.'-'.$l.'-'.$m.'" typ="'.$level.'" cd="" aria-expanded="true">
                <div class="text-overfollow" data-container="body" data-toggle="tooltip" title="" data-original-title="'.$item['organization_nm'].'"><i class="fa fa-chevron-right"></i><span>&nbsp;</span><span>'.$item['organization_nm'].'</span></div>
            </a>';
        $html .= '</li>';
    }
    $html .= '</ul>';
}
?>
<div class="col-md-12 col-xs-12 col-lg-12">
    <nav class="pager-wrap pagin-fix">
    </nav>
</div>
<input type="hidden" class="cr_same_org" value="{{__('messages.create_same_level_org')}}"/>
<input type="hidden" class="cr_sub_org"  value="{{__('messages.create_subordinate_org')}}"/>
<div class="col-md-12 col-xs-12 col-lg-12">
    <div class="list-search-v">
        <div class="list-search-head">
            {{ __('messages.registration_list') }}
        </div>
        <div class="list-search-content">
            
        </div>
    </div>
</div>