<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <base href="{{ URL::to('/') }}">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <title>Test Excel</title>
    <!-- Bootstrap -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" />
  </head>
  <body>
    <button id="export" class="btn btn-primary" style="margin: 15px;">Export</button>
    <button id="import" class="btn btn-primary">Import</button>
    <button id="pdf-sample" class="btn btn-primary" style="margin: 15px;">PDF Export</button>
    <p>Chờ 1 lúc để export file hoàn thành</p>

    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
    <script type="text/javascript">
    	$(document).ready(function() {
    		$('#export').on('click', function() {
				// send data to post
				var data = {"_token": "{{ csrf_token() }}"};
				$.ajax({
					type		:	'POST',
		    		url			:	'/common/postexcel', 
		    		dataType	:	'json',
		    		data		:	data,
					success: function(res) {
						switch (res['status']){
	                    // Success
	                    case 200:
	                        location.href = '/common/excel/download?real_filename='+res['filename']+'&filename='+res['download_filename'];
	                        break;
	                    default:
	                        jError(_text[9]);
	                        break;
                }
					}
				});
    		});
    		//
    		$('#import').on('click', function() {
				// send data to post
				var data = {"_token": "{{ csrf_token() }}", "company_no": 1};
				$.ajax({
					type		:	'POST',
		    		url			:	'/common/excel/import', 
		    		dataType	:	'json',
		    		data		:	data,
					success: function(res) {
						switch (res['status']){
	                    // Success
	                    case 200:
	                        console.log(res);
	                        break;
	                    default:
	                        jError(_text[9]);
	                        break;
                }
					}
				});
    		});
    	});
    </script>
  </body>
</html>