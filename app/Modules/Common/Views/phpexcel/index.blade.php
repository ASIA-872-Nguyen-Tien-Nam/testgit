@extends('layout')

@section('title',$title)

@section('asset_header')
<!-- START LIBRARY CSS -->
@stop

@section('asset_footer')
<!-- START LIBRARY JS -->
@stop

@section('asset_button')

@stop

@section('content')
	<div class="container-fluid">
		<div class="row">
			<div class="col-md-12">
				<div class="card" style="min-height: 78vh">
					<div class="card-content">

						<div class="card-header fluid">
							<h4 class="card-title">{{$title}}</h4>
						</div><!--/.card-header -->
						
						<div class="card-content">
							<div class="row">
								<div class="col-md-2">
									<div class="form-group">
										<button class="btn green" id="btn-importCSV">ImportCSV</button>
									</div><!-- /.form-group -->
								</div><!-- /.col-md-2 -->
								<div class="col-md-2">
									<div class="form-group">
										<button class="btn green" id="btn-importExcel">ImportExcel</button>
									</div><!-- /.form-group -->
								</div><!-- /.col-md-2 -->
								<div class="col-md-2">
									<div class="form-group">
										<button class="btn green" id="btn-exportExcel">ExportExcel</button>
									</div><!-- /.form-group -->
								</div><!-- /.col-md-2 -->
								<div class="col-md-2">
									<div class="form-group">
										<button class="btn green" id="btn-exportCSV">ExportCSV</button>
									</div><!-- /.form-group -->
								</div><!-- /.col-md-2 -->
							</div><!-- /.row -->
						</div><!-- /.card-content -->
					</div><!-- /.card-content -->
				</div><!-- /.card -->
			</div><!-- /.col-md-12 -->
		</div><!-- /.row -->
	</div><!-- /.container-fluid -->
@stop

@section('asset_common')
	<script type="text/javascript">
	$(document).ready(function () {
		//
		$(document).on('click', '#btn-export', function() {
			// send data to post
			var data = {};
			data.file_name 		=	'demo.xlsx';
			data.file_template	=	'template.xlsx';
			$.ajax({
				type		:	'POST',
	    		url			:	'/common/phpexcel/export', 
	    		dataType	:	'json',
	    		loading		: 	true, 
	    		data		:	data,
			 success: function(res) {
				console.log(res);
			 }
			});	
		});
		//
		$(document).on('click', '#btn-importCSV', function() {
			// send data to post
			var data = {};
			data.file_name 		=	'demo.csv';
			$.ajax({
				type		:	'POST',
	    		url			:	'/common/phpexcel/importCSV', 
	    		dataType	:	'json',
	    		loading		: 	true, 
	    		data		:	data,
			 success: function(res) {
				console.log(res);
			 }
			});	
		});		
		//
		$(document).on('click', '#btn-importExcel', function() {
			// send data to post
			var data = {};
			data.file_name 		=	'demo.xlsx';
			$.ajax({
				type		:	'POST',
	    		url			:	'/common/phpexcel/importExcel', 
	    		dataType	:	'json',
	    		loading		: 	true, 
	    		data		:	data,
			 success: function(res) {
				console.log(res);
			 }
			});	
		});	
		// exportCSV
		$(document).on('click', '#btn-exportCSV', function() {
			// send data to post
			var data = {};
			//
			$.ajax({
				type		:	'POST',
	    		url			:	'/common/phpexcel/exportCSV', 
	    		dataType	:	'json',
	    		loading		: 	true, 
	    		data		:	data,
			 success: function(res) {
				console.log(res);
				if(res['status'] == OK){
					var file_name = 'trandaiviet.csv';
					url = 
					window.location.href = '/common/download?source_file='+encodeURIComponent(res['export_file'])+'&file_name='+encodeURIComponent(file_name);
				}
			 }
			});	
		});	
		// exportExcel
		$(document).on('click', '#btn-exportExcel', function() {
			// send data to post
			var data = {};
			//
			$.ajax({
				type		:	'POST',
	    		url			:	'/common/phpexcel/exportExcel', 
	    		dataType	:	'json',
	    		loading		: 	true, 
	    		data		:	data,
			 success: function(res) {
				console.log(res);
				if(res['status'] == OK){
					var file_name = 'trandaiviet.xlsx';
					url = window.location.href = '/common/download?source_file='+encodeURIComponent(res['export_file'])+'&file_name='+encodeURIComponent(file_name)+'&delete_flag=1';
				}
			 }
			});	
		});	
	});
</script>
@stop