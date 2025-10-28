  /**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日		    :	2018/06/22
 * 作成者		    :	sondh – sondh@ans-asia.com
 *
 * @package		:	MODULE MASTER
 * @copyright	    :	Copyright (c) ANS-ASIA
 * @version		:	1.0.0
 * ****************************************************************************
 */
 var _obj = {
  'pop_tr': {'attr' : 'list', 'item' : {
    'item_cd'  : {'type' : 'text', 'attr' : 'class'},
    'display_kbn'         : {'type' : 'checkbox', 'attr' : 'class'},
    }
  }
 }
 $(function(){
     checkAllStatus();
 })
 $(document).on('click','#ckb_all',function(){
    try{
      if($(this).prop('checked')){
        checkall(1);
      }else{
        checkall(0);
      }
    }catch(e){
      alert('#ckball:'+e.message);
    }
  });
 $(document).on('click','.checkbox_row',function(){
    checkAllStatus();
});
 var index = 0;
  $(document).on('click', '.pop_tr ', function(){
    try{
    	$('.tr_selected').removeClass('tr_selected');
    	index = $(this).index();
    	// if($(this).hasClass('tr_selected')){
    		// $(this).removeClass('tr_selected');
    	// }else{
       		$(this).addClass('tr_selected');
    	// }
    }catch(e){
        alert('#btn-back: ' + e.message); 
    }
});
  $(document).on('click','#move_up',function(){
  	upNdown('up');
  }) 
  $(document).on('click','.display_kbn',function(){
    if($(this).is(':checked')){
      $(this).val('1');
    }else{
      $(this).val('0');
    }
  })
  $(document).on('click','#move_down',function(){
  	upNdown('down');
  })
  $(document).on('click','#btn-save-popup',function(){
  	savePopup();
  })
  function upNdown(direction){
    var rows = document.getElementById("table_data").rows,
        parent = rows[index].parentNode;
     if(direction === "up")
     {
         if(index > 1 &&( $('.tr_checkall')[0] != rows[index])){
            parent.insertBefore(rows[index],rows[index - 1]);
            // when the row go up the index will be equal to index - 1
            index--;
        }
     }
     if(direction === "down" &&( $('.tr_checkall')[0] != rows[index]))
     {
         if(index < rows.length -1){
            parent.insertBefore(rows[index + 1],rows[index]);
            // when the row go down the index will be equal to index + 1
            index++;
        }
     }

}
function savePopup(){
  var data = getData(_obj);
  $.ajax({
      type        :   'POST',
      url         :   '/master/i2040/savepopup', 
      loading     :   true,
      data        :   data,
     success: function(res) {
      $('#btn-close-popup').click();
      if(parent.$('#btn-list-title').parents('.container-fluid').find('#fiscal_year').val() != -1){
        parent.$('#btn-list-title').parents('.container-fluid').find('#btn-search').click();
        parent.$('body').css('overflow','scroll');
      }else{
        window.location.reload();
      }
      // $('#btn-close-popup').parents('body').find('#btn-search').click();
     }
    }); 
}
/*
 * checkall
 * @author    : viettd - 2018/06/21 - create
 * @author    :
 * @return    : null
 * @access    : public
 * @see     : init
 */
function checkall(param) {
    try{
        if(param == 1){
            $('.checkbox_row').prop('checked',true);
            $('.checkbox_row').val('1');
            $('#table_data tbody tr').addClass('active');
        }else{
            $('.checkbox_row').prop('checked',false);
            $('#table_data tbody tr').removeClass('active');
            $('.checkbox_row').val('0');
        }
    }catch(e){
        alert('checkall' + e.message);
    }
}
function checkAllStatus(){
    try{
        var length = $("#table_data tbody tr .checkbox_row").length;
        var number = 0;
        var number = $("#table_data tbody tr .checkbox_row:checked").length;
        if(length == number) {
            $("#ckb_all").prop("checked",true);
        }else {
            $("#ckb_all").prop("checked",false);
        }
    }catch(e){
        alert('.checkbox_row:'+e.message);
    }
}