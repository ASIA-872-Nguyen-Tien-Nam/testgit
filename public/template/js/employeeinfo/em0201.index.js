/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日               :    2024/04
 * 作成者               :    matsumoto
 *
 * @package             :    MODULE MASTER
 * @copyright           :    Copyright (c) ANS-ASIA
 * @version             :    2.1.0
 * ****************************************************************************
 */
var _obj = {
  field_nm: { type: "text", attr: "id" },
  arrange_order: { type: "text", attr: "id" },
  search_kbn: {'type':'checkbox', 'attr':'id'}
};
var _flgLeft = 0;
$(document).ready(function () {
  try {
    initialize();
    initEvents();
  } catch (e) {
    alert("ready" + e.message);
  }
});

/*
 * INITIALIZE
 * @author      :   matsumoto - 2024/04 - create
 * @created at  :   2024/04
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function initialize() {
  try {
    $("#field_nm").focus();
    _formatTooltip();
  } catch (e) {
    alert("initialize: " + e.message);
  }
}

/*
 * INIT EVENTS
 * @author      :   matsumoto - 2024/04 - create
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function initEvents() {
  try {
    /* paging */
    // click page-link
    $(document).on(
      "click",
      "li.page-prev a.page-link:not(.pagging-disable)",
      function () {
        try {
          var page = $(this).attr("page");
          var search = $("#search_key").val();
          getLeftContent(page, search);
        } catch (e) {
          console.log("click page-link: " + e.message);
        }
      }
    );
    // click page-link
    $(document).on(
      "click",
      "li.page-next a.page-link:not(.pagging-disable)",
      function () {
        try {
          var page = $(this).attr("page");
          var search = $("#search_key").val();
          getLeftContent(page, search);
        } catch (e) {
          console.log("click page-link: " + e.message);
        }
      }
    );
    // click btn-search
    $(document).on("click", "#btn-search-key", function () {
      try {
        var page = 1;
        var search = $("#search_key").val();
        getLeftContent(page, search);
      } catch (e) {
        console.log("click btn-search: " + e.message);
      }
    });
    // change search-input
    $(document).on("change", "#search_key", function () {
      try {
        var page = 1;
        var search = $("#search_key").val();
        getLeftContent(page, search);
      } catch (e) {
        console.log("change search-input: " + e.message);
      }
    });
    // enter when focus search-input
    $(document).on("enterKey", "#search_key", function () {
      try {
        var page = 1;
        var search = $("#search_key").val();
        getLeftContent(page, search);
      } catch (e) {
        console.log("enter when focus search-input: " + e.message);
      }
    });
    /* end paging */

    // refer data when click field list search
    $(document).on("click", ".list-search-child", function () {
      try {
        $(".list-search-child").removeClass("active");
        $(this).addClass("active");
        getRightContent($(this).attr("id"));
      } catch (e) {
        console.log("refer data when click field list search: " + e.message);
      }
    });
    // click btn-add-new
    $(document).on("click", "#btn-add-new", function () {
      try {
        jMessage(5, function () {
          $("#field_nm").focus();
          $("#field_cd, #field_nm, #arrange_order").val("");
          $("#field_typ option:first").prop("selected", true);
          $('#mode').val(0);
          $('#search_kbn').prop('checked', false);
          $("#field_nm").removeClass("boder-error");
          $("#field_nm").next(".textbox-error").remove();
          $(".list-search-child").removeClass("active");
        });
      } catch (e) {
        console.log("click btn-add-new: " + e.message);
      }
    });
    // click btn-save
    $(document).on("click", "#btn-save", function (e) {
      try {
        jMessage(1, function (r) {
          _flgLeft = 1;
          if (r && _validate($("body"))) {
            saveData();
          }
        });
      } catch (e) {
        console.log("click btn-save: " + e.message);
      }
    });
    // click btn-delete
    $(document).on("click", "#btn-delete", function (e) {
      try {
        jMessage(3, function (r) {
          if (r) {
            deleteData();
          }
        });
      } catch (e) {
        console.log("click btn-delete: " + e.message);
      }
    });
    // click btn-back
    $(document).on("click", "#btn-back", function (e) {
      try {
        if (_validateDomain(window.location)) {
          window.location.href = "edashboard";
        } else {
          jError(
            "エラー",
            "このプロトコル又はホストドメインは拒否されました。"
          );
        }
      } catch (e) {
        console.log("click btn-back: " + e.message);
      }
    });
  } catch (e) {
    console.log(e.stack);
  }
}

/**
 * save
 *
 * @author      :   matsumoto - 2024/04 - create
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function saveData() {
  try {
    var field_cd = $("#field_cd").val();
    var data = getData(_obj);
    data.data_sql.mode = $("#mode").val();
    data.data_sql.field_cd = field_cd;
    $.ajax({
      type: "POST",
      url: "/employeeinfo/em0201/save",
      dataType: "json",
      loading: true,
      data: JSON.stringify(data),
      success: function (res) {
        switch (res["status"]) {
          // success
          case OK:
            jMessage(2, function (r) {
              clearData(_obj);
              location.reload();
            });
            break;
          // error
          case NG:
            if (typeof res["errors"] != "undefined") {
              processError(res["errors"]);
            }
            break;
          // Exception
          case EX:
            jError(res["Exception"]);
            break;
          default:
            break;
        }
      },
    });
  } catch (e) {
    alert("save" + e.message);
  }
}

/**
 * delete
 *
 * @author      :   matsumoto - 2024/04 - create
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function deleteData() {
  try {
    var field_cd = $("#field_cd").val();
    var data = getData(_obj);
    data.data_sql.mode = $("#mode").val();
    data.data_sql.field_cd = field_cd;
    // send data to post
    $.ajax({
      type: "POST",
      url: "/employeeinfo/em0201/delete",
      dataType: "json",
      loading: true,
      data: JSON.stringify(data),
      success: function (res) {
        switch (res["status"]) {
          // success
          case OK:
            jMessage(4, function (r) {
              clearData(_obj);
              location.reload();
            });
            break;
          // error
          case NG:
            if (typeof res["errors"] != "undefined") {
              processError(res["errors"]);
            }
            break;
          // Exception
          case EX:
            jError(res["Exception"]);
            break;
          default:
            break;
        }
      },
    });
  } catch (e) {
    alert("save" + e.message);
  }
}

/**
 * refer data menu left
 * @author      :   matsumoto - 2024/04 - create
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function getLeftContent(page, search) {
  try {
    // send data to post
    $.ajax({
      type: "POST",
      url: "/employeeinfo/em0201/leftcontent",
      dataType: "html",
      loading: true,
      data: { current_page: page, search_key: search },
      success: function (res) {
        if(_isJson(res) ==true && JSON.parse(res)['status'] != undefined && JSON.parse(res)['status'] == 164) {
          jMessage(164);
        } else {
          $("#leftcontent .inner").empty();
          $("#leftcontent .inner").html(res);
          $('[data-toggle="tooltip"]').tooltip({ trigger: "hover" });
          if (_flgLeft != 1) {
            $("#search_key").focus();
          } else {
            _flgLeft = 0;
          }
          _formatTooltip();
        }
      },
    });
  } catch (e) {
    alert("get left content: " + e.message);
  }
}


/**
 * refer data
 * @author      :   matsumoto - 2024/04 - create
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function getRightContent(field_cd) {
  try {
    // send data to post
    $.ajax({
      type: "POST",
      url: "/employeeinfo/em0201/rightcontent",
      dataType: "json",
      data: { field_cd: field_cd },
      success: function (res) {
        $("#field_cd").val(htmlEntities(res.field_cd));
        $("#field_nm").val(htmlEntities(res.field_nm));
         //true
         $('#search_kbn').prop('checked', res.search_kbn == '1' ? true:false);
        $("#arrange_order").val(res["arrange_order"]);
        $("#field_nm").focus();
        $("#field_nm").removeClass("boder-error");
        $("#field_nm").next(".textbox-error").remove();
        // set mode
        $("#mode").val("1");
      },
    });
  } catch (e) {
    alert("get right content: " + e.message);
  }
}




