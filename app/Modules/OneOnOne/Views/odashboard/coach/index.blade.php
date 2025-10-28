@extends('oneonone/layout')
@push('header')
{!!public_url('template/css/form/dashboard.css')!!}
{!!public_url('template/css/oneonone/dashboard/odashboard.css')!!}
@endpush
@section('asset_footer')
{!!public_url('template/js/oneonone/dashboard/odashboard.js')!!}
@stop
@section('content')
<div class="container-fluid">
	<div class="row">
		<div class="col-md-12">
			<div class="card">
				<div class="card-body">
					<div class="row">
						<div class="col-md-7">
							<div id="div_coach_left_content">
								@include('OneOnOne::odashboard.coach.referLeftMembersForCoach')
							</div>
						</div><!-- end .col-md-7 -->
						<div class="col-md-5 mb-3" id="div_coach_right_content">
							@include('OneOnOne::odashboard.coach.referRightForCoach')
						</div><!-- end .col-md-5 -->
					</div><!-- end .row -->
				</div><!-- end .card-body -->
			</div>

			</div><!-- end .card -->
		</div><!-- end .col-md-6 -->
	</div><!-- end .row -->
</div><!-- end .container-fluid -->
@stop