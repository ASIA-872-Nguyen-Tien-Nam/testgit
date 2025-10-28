@if(isset($floor['floor_map']) && $floor['floor_map'] != '')   
<div class="container-fluid">
	<div class="row">
        <input type="hidden" id="seating_chart_typ" value="{{ $floors['seating_chart_typ'] ?? $floor['seating_chart_typ'] }}">
        <input type="hidden" id="btn_seat_register" value="{{ $floors['btn_seat_register'] ?? $floor['btn_seat_register'] }}">
        <div id="rightcontent" class="col-sm-12 col-md-10 col-lg-9 col-ltx-10 wrapper2" style="padding-left: 0px;overflow-x: auto">
            <div class="seat_content mb-3" id="seat_area">
                <div class="layout">
                    @if ( isset($employees['list']) )
                    <embed type="image/jpg" src="{{ $floor['floor_map']}}" width="1464px" >
                    @else
                    <embed type="image/jpg" src="{{ $floor['floor_map']}}" width="1700px" >
                    @endif
                    <!-- {{-- <iframe id="background_image" src="{{ $floor['floor_map'] }}#toolbar=0&navpanes=0&scrollbar=0" title="Floor Map" align="top" height="1000px" width="1000px" frameborder="0" scrolling="auto" target="Floor Map" /> --}} -->
                    <img id="background_image" src="{{ $floor['floor_map']}}" hidden style="width: 100%; max-width: 1530px;">
                </div>
                @isset($seats)
                    @foreach ($seats as $seat)
                    <div class="seat-group">
                        <div class="seat_item {{$seat['search'] == 1 ? 'background-search' : ''}}" style="left: {{ $seat['x'] }}px; top: {{ $seat['y'] }}px" data-toggle="dropdown">
                            <div class="seat_item_extend">
                                <div class="text-overfollow" data-container="body" data-toggle="tooltip" data-original-title="{{ $seat['employee_nm_full'] }}">{{ $seat['employee_nm'] }}</div>
                                <input type="hidden" class="seat_item_employee_cd" value="{{ $seat['employee_cd'] }}">
                            </div>
                        </div>
                        <div class="dropdown-menu shadow dropdown-menu-seat" style="border: 1px solid #707070;">
                            <div class="dropdown-item btn-delete" style="border-bottom: 1px solid #b0b4b7 !important;font-weight: 600;color: #f72809;">{{ __('messages.leave') }}</div>
                            <div class="dropdown-item btn-profile" style="font-weight: 600;">{{ __('messages.view_profile') }}</div>
                        </div>
                    </div>
                    @endforeach
                @endisset
                <div class="seat_item_select" style="left:1408px; top: 0px; z-index: 99999" id="seat_selected">
                    {{ __('messages.seat_drag') }}
                </div>
            </div>
		</div> <!-- end #leftcontent -->
		@if ( isset($employees['list']) )
		<div id="leftcontent" class="col-sm-12 col-md-2 col-lg-3 col-ltx-2" style="padding-right: 0px">
			@include('EmployeeInfo::eq0200.employees')
		</div>
        @endif
	</div>
</div>
@endif
