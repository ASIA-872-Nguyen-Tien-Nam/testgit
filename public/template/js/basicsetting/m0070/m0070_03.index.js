/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日               :    2024/04/03
 * 作成者               :    manhnd – manhnd@ans-asia.com
 *
 * @package             :    MODULE BASICSETTING
 * @copyright           :    Copyright (c) ANS-ASIA
 * @version             :    2.1.0
 * ****************************************************************************
 */

var _obj_tab_3 = {
  list_tab_03: {
    attr: "list",
    item: {
      detail_no: { type: "text", attr: "class" },
      training_cd: { type: "text", attr: "class" },
      training_nm: { type: "text", attr: "class" },
      training_category_cd: { type: "text", attr: "class" },
      training_course_format_cd: { type: "text", attr: "class" },
      lecturer_name: { type: "text", attr: "class" },
      training_date_from: { type: "text", attr: "class" },
      training_date_to: { type: "text", attr: "class" },
      training_status: { type: "text", attr: "class" },
      passing_date: { type: "text", attr: "class" },
      report_submission: { type: "text", attr: "class" },
      report_submission_date: { type: "text", attr: "class" },
      report_storage_location: { type: "text", attr: "class" },
      nationality: { type: "text", attr: "class" },

      delete_file: { type: "text", attr: "class" },
    },
  },
};

$(document).ready(function () {
  try {
    initEventsTab3();
  } catch (e) {
    alert("ready" + e.message);
  }
});

/*
 * INIT EVENTS
 * @author      :   manhnd
 * @created at  :   2024/03/04
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function initEventsTab3() {
  try {
    // click btn-add-new
    $(document).on("click", "#btn-add-new-row-tab3", function () {
      try {
        var clone = $("#table-empty tbody").clone();
        $(clone).addClass("list_tab_03");
        $("#table-tab03").prepend(clone);
        $("#table-tab03 tbody").each(function (index) {
          $(this)
            .find(".tr .no")
            .text(index + 1);
        });
        $.formatInput();
      } catch (e) {
        console.log("click btn-add-new: " + e.message);
      }
    });
    // click btn-remove-row
    $(document).on("click", ".btn-remove-row-tab3", function () {
      try {
        var index_row_deleted =
          parseInt($(this).closest("tbody").find(".tr .no").text().trim()) - 1;
        $("#table-tab03 tbody").each(function (index) {
          if (index > index_row_deleted) {
            $(this).find(".tr .no").text(index);
          }
        });
        $(this).closest("tbody").remove();
      } catch (e) {
        console.log("click btn-remove-row: " + e.message);
      }
    });

    // click icon select file
    $(document).on("click", "#table-tab03 tr td .button-upload", function () {
      try {
        $(this)
          .closest(".form-group")
          .find(".input-import-file")
          .trigger("click");
      } catch (e) {
        console.log("click icon select file:" + e.message);
      }
    });
    // change file
    $(document).on(
      "change",
      "#table-tab03 tr td .input-import-file",
      function () {
        try {
          readURL(this);
        } catch (e) {
          console.log("change file:" + e.message);
        }
      }
    );
    // focus 研修コード
    $(document).on("focus", "#tab14 .training_cd", function (e) {
      try {
        var data = JSON.parse($(this).attr("trainings"));
        $(this)
          .autocomplete({
            source: data,
            minLength: 0,
            select: function (event, ui) {
              $(this).val(ui.item.training_cd);
              $(this).closest("tr").find(".training_nm").val(ui.item.label);
              $(this)
                .closest("tr")
                .find(
                  `.training_category_cd option[value="${ui.item.training_category_cd}"]`
                )
                .prop("selected", true);
              $(this)
                .closest("tr")
                .find(
                  `.training_course_format_cd option[value="${ui.item.training_course_format_cd}"]`
                )
                .prop("selected", true);
              if (ui.item.editable_kbn == 0) {
                $(this)
                  .closest("tr")
                  .find(".training_nm")
                  .attr("disabled", true);
                $(this)
                  .closest("tr")
                  .find(".training_category_cd")
                  .attr("disabled", true);
                $(this)
                  .closest("tr")
                  .find(".training_course_format_cd")
                  .attr("disabled", true);
              }
              if (ui.item.editable_kbn == 1) {
                $(this)
                  .closest("tr")
                  .find(".training_nm")
                  .attr("disabled", false);
                $(this)
                  .closest("tr")
                  .find(".training_category_cd")
                  .attr("disabled", false);
                $(this)
                  .closest("tr")
                  .find(".training_course_format_cd")
                  .attr("disabled", false);
              }
              return false;
            },
            open: function (event, ui) {
              var $input = $(event.target);
              var $results = $input.autocomplete("widget");
              var scrollTop = $(window).scrollTop();
              var top = $results.position().top;
              var height = $results.outerHeight();
              // set width
              $results.css("width", "285px");
              if (top + height > $(window).innerHeight() + scrollTop) {
                newTop = top - height - $input.outerHeight();
                if (newTop > scrollTop) $results.css("top", newTop + "px");
              }
            },
          })
          .on("focus", function () {
            $(this).keydown();
          })
          .autocomplete("instance")._renderItem = function (ul, item) {
          return $("<li>")
            .append("<div>" + item.label + "</div>")
            .appendTo(ul);
        };
      } catch (e) {
        alert("#btn-item-evaluation-input1 :" + e.message);
      }
    });
    // change
    $(document).on("change", "#tab14 .training_cd", function (e) {
      try {
        var data = JSON.parse($(this).attr("trainings"));
        var input = $(this).val();
        if (input == "") {
          $(this).val("");
          $(this).closest("tr").find(".training_nm").val("");
          $(this)
            .closest("tr")
            .find(".training_category_cd option:first")
            .prop("selected", true);
          $(this)
            .closest("tr")
            .find(".training_course_format_cd option:first")
            .prop("selected", true);
          $(this).closest("tr").find(".training_nm").attr("disabled", true);
          $(this)
            .closest("tr")
            .find(".training_category_cd")
            .attr("disabled", true);
          $(this)
            .closest("tr")
            .find(".training_course_format_cd")
            .attr("disabled", true);
        } else {
          var result = data.find(function (item) {
            return item.training_cd === input;
          });
          if (result == undefined) {
            $(this).closest("tr").find(".training_nm").val('').attr('disabled',true);
            $(this).closest("tr").find(".training_category_cd").attr('disabled',true);
            $(this).closest("tr").find(".training_category_cd option:selected").prop('selected',false);
            $(this).closest("tr").find(".training_course_format_cd").attr('disabled',true);
            $(this).closest("tr").find(".training_course_format_cd option:selected").prop('selected',false);
            return
          }
          $(this).closest("tr").find(".training_nm").val(result["label"]);
          $(this)
            .closest("tr")
            .find(
              `.training_category_cd option[value="${result["training_category_cd"]}"]`
            )
            .prop("selected", true);
          $(this)
            .closest("tr")
            .find(
              `.training_course_format_cd option[value="${result["training_course_format_cd"]}"]`
            )
            .prop("selected", true);
          if (result["editable_kbn"] == 0) {
            $(this).closest("tr").find(".training_nm").attr("disabled", true);
            $(this)
              .closest("tr")
              .find(".training_category_cd")
              .attr("disabled", true);
            $(this)
              .closest("tr")
              .find(".training_course_format_cd")
              .attr("disabled", true);
          }
          if (result["editable_kbn"] == 1) {
            $(this).closest("tr").find(".training_nm").attr("disabled", false);
            $(this)
              .closest("tr")
              .find(".training_category_cd")
              .attr("disabled", false);
            $(this)
              .closest("tr")
              .find(".training_course_format_cd")
              .attr("disabled", false);
          }
        }
        $(this).focus()
      } catch (e) {
        alert("#btn-item-evaluation-input1 :" + e.message);
      }
    });

    // click btn-download
    $(document).on("click", "#table-tab03 tr td .button-download", function () {
      try {
        var file_name = $(this)
          .siblings(".display-input")
          .attr("diploma_file_name");
        var file_down = $(this).siblings(".display-input").attr("diploma_file");
        var company_cd = $(".company_cd").val();
        file_address =
          "/uploads/m0070/" + company_cd + "/training_history/" + file_down;
        if (file_name != "") {
          downloadfileHTML(file_address, file_name, function () {});
        } else {
          jMessage(21);
          return;
        }
      } catch (e) {
        alert("#btn-download" + e.message);
      }
    });

    // click btn-remove
    $(document).on("click", "#table-tab03 .button-remove", function () {
      try {
        $(this).closest(".form-group").find(".display-input").val("");
        $(this)
          .closest(".form-group")
          .find(".display-input")
          .attr("diploma_file", "");
        $(this)
          .closest(".form-group")
          .find(".display-input")
          .attr("diploma_file_name", "");
        $(this)
          .closest(".form-group")
          .find(".diploma_file_uploaddatetime")
          .text("");
        $(this).closest(".form-group").find(".delete_file").val("1");
      } catch (e) {
        console.log("click btn-remove: " + e.message);
      }
    });
  } catch (e) {
    alert("initEventsTab3: " + e.message);
  }
}

/**
 * saveDataTab03
 *
 * @author      :   Manhnd - 2024/04/04 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function saveDataTab03() {
  try {
    var data = getData(_obj_tab_3);
    data.data_sql.employee_cd = $("#employee_cd").val();
    data.data_sql.list_tab_03?.reverse();
    var formData = new FormData();
    formData.append("head", JSON.stringify(data));

    var elements = $("#table-tab03 tr td .input-import-file");
    var reverseArray = elements.toArray().reverse();

    $(reverseArray).each(function (index) {
      var files = $(this).prop("files");
      if (files.length > 0) {
        formData.append(`files[]`, files[0]);
        // formData.append(`files_index[]`, index + 1);
        formData.append(`files_index[]`, index);
      }
    });
    return new Promise((resolve, reject) => {
      $.ajax({
        type: "POST",
        data: formData,
        url: "/basicsetting/m0070/postSaveTab03",
        enctype: "multipart/form-data",
        cache: false,
        contentType: false,
        processData: false,
        success: function (res) {
          switch (res["status"]) {
            // success
            case OK:
              var employee_cd = $("#employee_cd").val();
              getRefer03(employee_cd);
              resolve(true);
              break;
            // error
            case NG:
              console.log(res["errors"]);
              if (typeof res["errors"] != "undefined") {
                processError(res["errors"]);
              }
              // resolve(true)
              break;
            case 404:
              resolve(true);
              break;
            // Exception
            case EX:
              resolve(true);
              break;
            default:
              break;
          }
        },
        error: function (xhr, status, error) {
          temp = temp + 1;
          reject(error);
        },
      });
    });
  } catch (e) {
    console.log("save data tab03: " + e.message);
  }
}

/**
 * readURL
 *
 * @author      :   manhnd - 2024/03/13 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function readURL(input) {
  try {
    if (input.files && input.files[0]) {
      var reader = new FileReader();
      reader.onload = function (e) {
        $(input).siblings().find(".display-input").val(input.files[0]["name"]);
      };
      reader.readAsDataURL(input.files[0]);
      //
      $(input).closest(".form-group").find(".delete_file").val("0");
    }
  } catch (e) {
    console.log("readURL: " + e.message);
  }
}

/**
 * getRefer03
 *
 * @author      :   manhnd - 2024/04/08 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function getRefer03(employee_cd) {
  try {
    $.ajax({
      type: "POST",
      url: "/basicsetting/m0070/referTab03",
      dataType: "html",

      data: { employee_cd: employee_cd, mode: "1" },
      success: function (res) {
        $(".tab-content").find("#tab14").remove();
        $(".tab-content").append(res);
        $.formatInput();
        activeHref();
      },
    });
  } catch (e) {
    alert("getRefer02: " + e.message);
  }
}
