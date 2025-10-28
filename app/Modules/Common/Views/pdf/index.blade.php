<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <base href="{{ URL::to('/') }}">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <title>TEST CREATE PDF FILE</title>
    <!-- Bootstrap -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" />
  </head>
  <body>
    <button id="pdf-preview" class="btn btn-primary" style="margin: 15px;">PDF Preview</button>
    <button id="pdf-download" class="btn btn-primary" style="margin: 15px;">PDF Download</button>
    <p>Chờ 1 lúc để export file hoàn thành</p>

    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
	{!!public_url('template/js/common/ansplugin.js')!!}
    <script type="text/javascript">
    	$(document).ready(function() {
    		$('#pdf-preview').on('click', function() {
    			// send data to post
                var data = {"_token": "{{ csrf_token() }}"};
                $.previewPDFAjax('/common/pdf/process', '/common/pdf/preview', data);
    		});
    		//
    		$('#pdf-download').on('click', function() {
    			// send data to post
				var data = {"_token": "{{ csrf_token() }}"};
                $.downloadFileAjax('/common/pdf/process', '/common/pdf/download', data);
    		});
    	});
    </script>
  </body>
</html>