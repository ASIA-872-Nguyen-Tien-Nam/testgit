$(document).ready(function() {

    $(document).on('click','[data-toggle="q2020_popup1"]',function(e) {
        e.preventDefault();
        showPopup("/master/q2020/popup1");
    });
    $(document).on('click','[data-toggle="q2020_popup2"]',function(e) {
        e.preventDefault();
        showPopup("/master/q2020/popup2");
    });

    $('.checkAll').change(function(){
        var item=$(this).attr('item');

        if($(this).prop('checked')) {
            $('td input[name=ckb'+item+']').prop('checked', true);
        } else {
            $('td input[name=ckb'+item+']').prop('checked', false);
        }
    });
    $('input[name=ckb1]').change(function(){
        $num=$('.checkAll').attr('num');
        if($(this).prop('checked')) {
            $num=parseInt($num)+1;
            if($num>=6)  $('.checkAll').prop('checked', true);
        } else {
            $('.checkAll').prop('checked', false);
            $num=parseInt($num)-1;
        }
        $('.checkAll').attr('num',$num);
    });


});