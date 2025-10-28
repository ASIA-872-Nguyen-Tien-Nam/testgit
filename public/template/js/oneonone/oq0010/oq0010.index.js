/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日          :   2020/02/05
 * 作成者          :   nghianm – nghianm@ans-asia.com
 *
 * @package         :   
 * @copyright       :   Copyright (c) ANS-ASIA
 * @version         :   1.0.0
 * ****************************************************************************
 */
$(function(){
    try{
        initEvents();
    }catch(e){
        alert('initialize: ' + e.message);
    }
});
/*
 * initEvents
 * @author    : nghianm – nghianm@ans-asia.com - create
 * @author    :
 * @return    : null
 * @access    : public
 * @see       : init
 */
function initEvents() {
    try{
        //back
        $(document).on('click', '#btn-back', function (e) {
            try {
                // 
                var home_url = $('#home_url').attr('href');
                _backButtonFunction(home_url);
            } catch (e) {
                alert('#btn-back' + e.message);
            }
        });
        // click open video
        $(document).on('click', '.video', function(e) {
            try{
            	var src_file = $(this).attr('src_file');
                var video = $("video")[0];
    			 var sources = $("source");
    			 sources[0].src = src_file;
    			 video.load();
            }catch(e){
                alert('open video: '+e.message);
            }
        });
        $(document).on('click', '.error_video', function(e) {
            try{
                jMessage(123);return;
            }catch(e){
                alert('error_video: '+e.message);
            }
        });
        // download file
        $(document).on('click', '.download-file', function(e) {
            try{
                var file_name       = $(this).attr('file_nm');
                var file_adress     = $(this).attr('data-src');
                var check  = file_adress.indexOf('not found');
                if(check != -1){
                    jMessage(123);return;
                }
                if(file_name !=''){
                   downloadfileHTML(file_adress ,file_name, function () {
                       // deleteFile(file_adress);
                   });
                }else{
                   jMessage(21);return;
                }
            }catch(e){
                alert('download-file: '+e.message);
            }
        });
        // close popup video
        $(document).on('hidden.bs.modal', '#videoModal', function(e) {
            try{
                $('video').trigger('pause');
                $('.open_video').blur();
            }catch(e){
                alert('close video: '+e.message);
            }
        });

    } catch(e){
        alert('initEvents: ' + e.message);
    }
}
