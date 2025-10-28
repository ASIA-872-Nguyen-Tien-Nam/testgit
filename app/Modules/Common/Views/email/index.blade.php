@extends('layout')

@section('title',$title)

@section('content')
	<div class="container-fluid">
		<div class="row">
			<div class="col-md-6">
				<div class="card" style="min-height: 78vh">
					<div class="card-content">
						<div class="form-group">
						    <label for="item1" class="required">Customer Name</label>
						    <input type="text" class="form-control input-sm" id="customer_name" value="May Weather">
					  	</div>
						<div class="form-group">
						    <label for="item1" class="required">To</label>
						    <input type="text" class="form-control input-sm" id="to" value="namnguyen2091@gmail.com">
					  	</div>
						<div class="form-group">
						    <label for="item1" class="required">Subject</label>
						    <input type="text" class="form-control input-sm" id="subject" value="This is sample email 1">
					  	</div>
						<div class="form-group">
						    <label for="item1">CC</label>
						    <input type="text" class="form-control input-sm" id="cc" value="namnb@ans-asia.com">
					  	</div>
						<div class="form-group">
						    <label for="item1">BCC</label>
						    <input type="text" class="form-control input-sm" id="bcc" value="lovemetender258@gmail.com">
					  	</div>
						<div class="form-group">
						    <label for="body" class="required">Content</label>
						    <textarea id="body" name="body" class="form-control" style="height: 200px;">email</textarea>
					  	</div>
						<div class="form-group">
						    <label for="attachs">Attachment (pending)</label>
						    <input type="text" class="form-control input-sm" id="attachs" value="" readonly="readonly">
					  	</div>
						<button type="button" class="btn btn-primary hidden" id="btn-send-html">Send with HTML</button>
						<button type="button" class="btn btn-primary" id="btn-send-raw">Send Raw</button>
					</div><!-- /.card-content -->
				</div><!-- /.card -->
			</div><!-- /.col-md-6 -->
			<div class="col-md-6">
				<div class="card" style="min-height: 78vh">
					<div class="card-content">
						<p><b>Customer Name:</b> biến truyền qua view, view chính là mail body (tùy chọn)</p>
						<p><b>To:</b> Người nhận, nếu nhiều người nhận ngăn cách nhau bởi dấu phẩy (bắt buộc)</p>
						<p><b>Subject:</b> Tiêu đề email (bắt buộc)</p>
						<p><b>CC:</b> nếu nhiều người nhận ngăn cách nhau bởi dấu phẩy (tùy chọn)</p>
						<p><b>BCC:</b> nếu nhiều người nhận ngăn cách nhau bởi dấu phẩy (tùy chọn)</p>
						<p><b>_token: </b> tự sinh bởi hàm csrf_token()</p>
						<p><b>data: </b>biến truyền qua view template</p>
						<p><b>body: </b>tên view template (bắt buộc) hoặc nội dung bất kỳ điền vào Content</p>
						<p><b>mail_type: </b> html hoặc text</p>
						<p><b>Example (gửi bằng body html)</b></p>
						<code>
							var data = {<br>
								'_token': '{{ csrf_token() }}',<br>
								'data' : {customer_name: $('#customer_name').val()},<br>
								'to': $('#to').val(),<br>
								'subject': $('#subject').val(),<br>
								'body': $('#body').val(),<br>
								'cc': $('#cc').val(),<br>
								'bcc': $('#bcc').val(),<br>
								'mail_type': 'html',<br>
								'attachs': $('#attachs').val(),<br>
							};<br>
							$.sendEmail(data, function(res) {<br>
								alert(res['status']);<br>
							});
						</code>
						<p><b>Example (gửi bằng body text)</b></p>
						<code>
							var data = {<br>
								'_token': '{{ csrf_token() }}',<br>
								'to': $('#to').val(),<br>
								'subject': $('#subject').val(),<br>
								'body': $('#body').val(),<br>
								'cc': $('#cc').val(),<br>
								'bcc': $('#bcc').val(),<br>
								'mail_type': 'text',<br>
								'attachs': $('#attachs').val(),<br>
							};<br>
							$.sendEmail(data, function(res) {<br>
								alert(res['status']);<br>
							});
						</code>
					</div>
				</div>
			</div>
		</div><!-- /.row -->
	</div><!-- /.container-fluid -->
@stop

@section('asset_footer')
<script type="text/javascript">
	$(document).ready(function() {
		$('#btn-send-html').on('click', function() {
			var data = {
				'_token': '{{ csrf_token() }}',
				'data' : {customer_name: $('#customer_name').val()},
				'to': $('#to').val(),
				'subject': $('#subject').val(),
				'body': $('#body').val(),
				'cc': $('#cc').val(),
				'bcc': $('#bcc').val(),
				'mail_type': 'html',
				'attachs': $('#attachs').val(),
			};
			$.sendEmail(data, function(res) {
				alert(res['status']);
			});
		});
		//
		$('#btn-send-raw').on('click', function() {
			var data = {
				'_token': '{{ csrf_token() }}',
				'to': $('#to').val(),
				'subject': $('#subject').val(),
				'body': $('#body').val(),
				'cc': $('#cc').val(),
				'bcc': $('#bcc').val(),
				'mail_type': 'text',
				'attachs': $('#attachs').val(),
			};
			$.sendEmail(data, function(res) {
				alert(res['status']);
			});
		});
	});
</script>
<script type="text/javascript">
	// $(document).ready(function() {
	// 	$('#btn-send-email').on('click', function() {
	// 		var data = {
	// 			'_token': '{{ csrf_token() }}',
	// 			'data' : {customer_name: $('#customer_name').val()},
	// 			'to': $('#to').val(),
	// 			'subject': $('#subject').val(),
	// 			'body': 'email',
	// 			'cc': $('#cc').val(),
	// 			'bcc': $('#bcc').val(),
	// 		};
	// 		//$('.div_loading').css('display', 'block');
	// 		$.ajax({
	// 			type		:	'POST',
	//     		url			:	'/common/email/send', 
	//     		dataType	:	'json',
	//     		loading		:	true,
	//     		data		:	data,
	// 			success: function(res) {
	// 				console.log(res);
	// 				switch (res['status']){
	//                     // Success
	//                     case 200:
	//                         alert('OK');
	//                         break;
	//                     default:
	//                         alert('Failed');
	//                         break;
 //                    }
	// 			},
	// 			complete: function() {
	// 				$('.div_loading').css('display', 'none');
	// 			}
	// 		});
	// 	});
	// });
</script>
@stop