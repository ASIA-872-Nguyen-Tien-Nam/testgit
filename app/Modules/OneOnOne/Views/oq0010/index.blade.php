@extends('oneonone/layout')

@section('asset_header')
<!-- START LIBRARY CSS -->
	{!!public_url('template/css/oneonone/oq0010/oq0010.index.css')!!}
@stop

@section('asset_footer')
<!-- START LIBRARY JS -->
	{!!public_url('template/js/oneonone/oq0010/oq0010.index.js')!!}
@stop
@push('asset_button')
{!!
	Helper::dropdownRender1on1(['backButton'])
!!}
@endpush
@section('content')
	<!-- START CONTENT -->
	<div class="container-fluid">
		<h5 style="margin-top:15px;">{{__('messages.video_file')}}</h5>
		@if(!empty($file_video))
		<div class="card" style="margin-top: 10px;">
			<div class="card-body">
				<div class="row">
					@foreach($file_video as $file_mp4)
					@php
						$refer_kbn = $file_mp4['refer_kbn'];
						$file_mp4['company_cd'] =  $file_mp4['refer_kbn']==1?0:session_data()->company_cd;
						$path_to_file = 'uploads/om0010/'.$file_mp4['company_cd'].'/'.$file_mp4['file_cd'].'.'.$file_mp4['character_end'];
						$pos = strpos(public_url($path_to_file), 'not found');
						$check = 0;
						if ($pos !== false) {
							$check = 0;
						} else {
							$check = 1;
						// Không tìm thấy
						}
					@endphp
					@if($check==1)
					<div class="col-md-4">			
						<div class="form-group">
								<button href="javascript:;" class="open_video video" src_file="{!! public_url($path_to_file) !!}" character_end="{{$file_mp4['character_end']}}" data-toggle="modal" data-target="#videoModal">
									<div class="media">
										<div class="media-left mr-10">
											<i class="fa fa-file-video-o" aria-hidden="true" style="font-size: 55px"></i>
										</div>
										<div class="media-body text-left text-overflow-line-2" data-container="body" data-toggle="tooltip" data-original-title="{{$file_mp4['title']==''?$file_mp4['name_file']:$file_mp4['title']}}">
											<h4 class="media-heading">{{$file_mp4['title']==''?$file_mp4['name_file']:$file_mp4['title']}}</h4>
										</div>
									</div>
								</button>
						</div>
					</div>
					@else
						<span></span>
					@endif
					@endforeach
				</div>
			</div><!-- end .card-body -->
		</div><!-- end .card -->
		@else 
			<div class="w-div-nodata  no-hover text-center" style="padding:10px">{{ $_text[21]['message'] }}</div>
		@endif
		<h5 style="margin-top:25px;">{{__('messages.document_file')}}</h5>
		@if(!empty($file_text))
		<div class="card" style="margin-top: 15px;">
			<div class="card-body">
				<div class="row">
					@foreach($file_text as $file_text_view)
					@php
						$refer_kbn = $file_text_view['refer_kbn'];
						$file_text_view['company_cd'] =  $file_text_view['refer_kbn']==1?0:session_data()->company_cd;
						$path_to_file = 'uploads/om0010/'.$file_text_view['company_cd'].'/'.$file_text_view['file_cd'].'.'.$file_text_view['character_end'];
					@endphp
					<div class="col-md-4">			
						<div class="form-group">
							<button class="download-file open_video" file_cd="{{$path_to_file}}" character_end="{{$file_text_view['character_end']}}" file_nm="{{$file_text_view['title']==''?$file_text_view['file_nm']:$file_text_view['title']}}" data-src="{!! public_url($path_to_file) !!}" namefile='{{$file_text_view['title']??''}}'>
								<div class="media">
									<div class="media-left mr-10">
										<i class="fa fa-file-text-o" aria-hidden="true" style="font-size: 55px"></i>
									</div>
									<div class="media-body text-left text-overflow-line-2" data-container="body" data-toggle="tooltip" data-original-title="{{$file_text_view['title']==''?$file_text_view['name_file']:$file_text_view['title']}}">
										<h4 class="media-heading">{{$file_text_view['title']==''?$file_text_view['name_file']:$file_text_view['title']}}</h4>
									</div>
								</div>
							</button>
						</div>
					</div>
					@endforeach
				</div>
			</div><!-- end .card-body -->
		</div><!-- end .card -->
		@else
			<div class="w-div-nodata  no-hover text-center" style="padding:10px">{{ $_text[21]['message'] }}</div>
		@endif
		<!-- video popup -->
		<div class="modal fade" id="videoModal" tabindex="-1" role="dialog" aria-hidden="true">
			<div class="modal-dialog modal-dialog-centered" role="document">
				<div class="modal-content">
					<div class="modal-body">
						<button type="button" class="close" data-dismiss="modal" id="btnClosePopup" aria-label="Close" style="margin-top: -10px; margin-right: -5px; margin-bottom: 2px">
							<span aria-hidden="true">&times;</span>
						</button>
						<video width="100%" height="100%" controls autoplay>
							<source src="" type="video/mp4">
						</video>
					</div>
				</div>
			</div>
		</div>
		<!-- end .video popup -->

	</div><!-- end .container-fluid -->
@stop