/**
 * ****************************************************************************
 * ANS ASIA
 *
 * 作成日               :    2024/03/04
 * 作成者               :    manhnd – manhnd@ans-asia.com
 *
 * @package             :    MODULE MASTER
 * @copyright           :    Copyright (c) ANS-ASIA
 * @version             :    2.1.0
 * ****************************************************************************
 */
var _obj = {
  organization_chart_use_typ: { type: "text", attr: "id" },
  seating_chart_use_typ: { type: "text", attr: "id" },
  search_function_use_typ: { type: "text", attr: "id" },
  initial_display: { type: "text", attr: "id" },
  tr: {
    attr: "list",
    item: {
      floor_id: { type: "text", attr: "class" },
      floor_name: { type: "text", attr: "class" },
      floor_map: { type: "text", attr: "class" },
      floor_map_name: { type: "text", attr: "class" },
    },
  },
  emailaddress_display_kbn: { type: "text", attr: "id" },
  company_mobile_display_kbn: { type: "text", attr: "id" },
  extension_number_display_kbn: { type: "text", attr: "id" },
};
$(function () {
  try {
    initEvents();
    initialize();
  } catch (e) {
    alert("ready: " + e.message);
  }
});
/*
 * INITIALIZE
 * @author      :   manhnd
 * @created at  :   2024/03/04
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function initialize() {
  try {
    $("select:first").focus();
  } catch (e) {
    alert("initialize: " + e.message);
  }
}
/*
 * INIT EVENTS
 * @author      :   manhnd
 * @created at  :   2024/03/04
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function initEvents() {
  try {
    // click btn-back
    $(document).on("click", "#btn-back", function () {
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
    // click btn-add-row
    $(document).on("click", "#btn-add-row", function () {
      try {
        addRow();
      } catch (e) {
        console.log("click btn add row: " + e.message);
      }
    });
    // click btn-remove-row
    $(document).on(
      "click",
      "#em0200_table .table tbody tr td .btn-remove-row",
      function () {
        try {
          removeRow($(this));
        } catch (e) {
          console.log("click btn remove row: " + e.message);
        }
      }
    );

    // click icon select file
    $(document).on(
      "click",
      "#em0200_table .table tbody tr td .face-file-btn",
      function () {
        try {
          $(this)
            .closest(".form-group")
            .find(".input-upload-file")
            .trigger("click");
        } catch (e) {
          console.log("click icon select file:" + e.message);
        }
      }
    );
    // change file
    $(document).on(
      "change",
      "#em0200_table .table tbody tr td .input-upload-file",
      function () {
        try {
          readURL(this);
        } catch (e) {
          console.log("change file:" + e.message);
        }
      }
    );

    // change value select
    $(document).on("change", "select", function () {
      try {
        var is_selected = $(this).find("option:selected").val();
        if (is_selected == 0) {
          $(this)
            .closest(".row")
            .find('input[type="checkbox"]')
            .attr("disabled", true)
            .prop("checked", false);
          //
          var initial_display = $("#initial_display").val();
          if (
            $(this).closest(".row").find(".organization").val() ==
            initial_display
          ) {
            $("#initial_display").val("0");
          }
        } else {
          $(this)
            .closest(".row")
            .find('input[type="checkbox"]')
            .attr("disabled", false);
        }
      } catch (e) {
        console.log("change value select: " + e.message);
      }
    });

    // change checkbox 初期表示に設定する
    $(document).on("change", ".organization", function () {
      try {
        var is_checked = $(this).is(":checked");
        $(".organization").prop("checked", false);
        $(this).prop("checked", is_checked);
        // set value for initial_display
        $("#initial_display").val($(".organization:checked").val());
      } catch (e) {
        console.log("change checkbox: " + e.message);
      }
    });

    // click btn-save
    $(document).on("click", "#btn-save", function () {
      try {
        jMessage(1, function (r) {
          if (r) {
            saveData();
          }
        });
      } catch (e) {
        console.log("click btn-save: " + e.message);
      }
    });

    // change checkbox in list 個人登録データ
    $(document).on(
      "change",
      "#emailaddress_display_kbn, #company_mobile_display_kbn, #extension_number_display_kbn",
      function () {
        try {
          if ($(this).is(":checked")) {
            $(this).val(1);
          } else {
            $(this).val(0);
          }
        } catch (e) {
          console.log("change checkbox in list 個人登録データ: " + e.message);
        }
      }
    );

    // // change radio
    // $(document).on(
    //   "change",
    //   "#em0200_table table tbody tr td .seating_chart_typ_radios",
    //   function () {
    //     try {
    //       if ($(this).is(":checked")) {
    //         $(this).closest("td").find(".seating_chart_typ").val($(this).val());
    //       }
    //     } catch (e) {
    //       console.log("change radio: " + e.message);
    //     }
    //   }
    // );
  } catch (e) {
    alert("initEvents: " + e.message);
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
        $(input).siblings().val(input.files[0]["name"]);
      };
      reader.readAsDataURL(input.files[0]);
    }
  } catch (e) {
    console.log("readURL: " + e.message);
  }
}

/*
 * addRow
 * @author      :   manhnd
 * @created at  :   2024/03/04
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function addRow() {
  try {
    var clone = $("#em0200_clone_table .table tbody tr").clone();
    $(clone).addClass("tr");
    var tr = resetRowAppend(clone);
    $("#em0200_table .table tbody").append(tr);
    $("#em0200_table .table tbody tr:last input:enabled:first").focus();
    $(".table-responsive").prop("scrollLeft", $(this).scrollLeft());
  } catch (e) {
    console.log("add new row: " + e.message);
  }
}

/*
 * resetRowAppend
 * @author      :   manhnd
 * @created at  :   2024/03/04
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function resetRowAppend(tr) {
  try {
    var index = $("#em0200_table tbody tr").length;
    $(tr)
      .find("td.first-column")
      .text(index + 1);
    $(tr)
      .find("td .radio_fixed_seats")
      .attr("id", `radio_fixed_seats_${index}`);
    $(tr)
      .find("td .label_radio_fixed_seats")
      .attr("for", `radio_fixed_seats_${index}`);
    $(tr)
      .find("td .radio_free_address")
      .attr("id", `radio_free_address_${index}`);
    $(tr)
      .find("td .label_radio_free_address")
      .attr("for", `radio_free_address_${index}`);
    $(tr)
      .find('td input[type="radio"]')
      .attr("name", `list[${index}][seat_type]`);
    return tr;
  } catch (e) {
    console.log("reset row before append: " + e.message);
  }
}

/*
 * removeRow
 * @author      :   manhnd
 * @created at  :   2024/03/04
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function removeRow(element) {
  try {
    resetRowDelete(element);
    // if has no row => create 1 empty row
    if ($("#em0200_table .table tbody tr").length == 0) {
      addRow();
    }
  } catch (e) {
    console.log("remove row: " + e.message);
  }
}

/*
 * resetRowDelete
 * @author      :   manhnd
 * @created at  :   2024/03/04
 * @return      :   null
 * @access      :   public
 * @see         :   init
 */
function resetRowDelete(element) {
  try {
    var index_row_deleted =
      parseInt($(element).closest("tr").find(".first-column").text().trim()) -
      1;
    $("#em0200_table tbody tr").each(function (index) {
      if (index > index_row_deleted) {
        $(this).find("td.first-column").text(index);
        $(this)
          .find("td .radio_fixed_seats")
          .attr("id", `radio_fixed_seats_${index - 1}`);
        $(this)
          .find("td .label_radio_fixed_seats")
          .attr("for", `radio_fixed_seats_${index - 1}`);
        $(this)
          .find("td .radio_free_address")
          .attr("id", `radio_free_address_${index - 1}`);
        $(this)
          .find("td .label_radio_free_address")
          .attr("for", `radio_free_address_${index - 1}`);
        $(this)
          .find('td input[type="radio"]')
          .attr("name", `list[${index - 1}][seat_type]`);
      }
      $(element).closest("tr").remove();
    });
  } catch (e) {
    console.log("reset rows before delete: " + e.message);
  }
}

/**
 * save
 * @author      :   manhnd - 2024/03/25 - create
 * @author      :
 * @return      :   null
 * @access      :   public
 * @see         :
 */
function saveData() {
  try {
    var data = getData(_obj);
    data.data_sql.tr.forEach(function (row, index) {
      row.seating_chart_typ =
        $(
          `#em0200_table tbody tr td [name="list[${index}][seat_type]"]:checked`
        ).val() ?? "1";
    });
    var formData = new FormData();
    formData.append("head", JSON.stringify(data));
    $("#em0200_table table tbody tr td .floor_map_hidden").each(function (index) {
      var files = $(this).prop("files");
      if (files.length > 0) {
        formData.append(`files[]`, files[0]);
        formData.append(`files_index[]`, index + 1);
      }
    });
    // validate
    $("#em0200_table table tr td .has_error").removeClass("has_error");
    if (validateCheckbox()) {
      // if (validateItemsRequiredInTable(data.data_sql.tr) > 0) {
      //   $("#em0200_table table tr td .has_error:first").focus();
      //   return;
      // }
      return;
    }
    // if (validateItemsRequiredInTable(data.data_sql.tr) > 0) {
    //   $("#em0200_table table tr td .has_error:first").focus();
    //   return;
    // }
    // send data to post
    $.ajax({
      type: "POST",
      data: formData,
      url: "/employeeinfo/em0200/save",
      enctype: "multipart/form-data",
      cache: false,
      contentType: false,
      processData: false,
      success: function (res) {
        switch (res["status"]) {
          // success
          case OK:
            //
            jMessage(2, function (r) {
              // do something
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

// /**
//  * validateItemsRequiredInTable
//  * @author      :   manhnd - 2024/05/07 - create
//  * @author      :
//  * @return      :   null
//  * @access      :   public
//  * @see         :
//  */
// function validateItemsRequiredInTable(rows) {
//   try {
//     var count_errors = 0;
//     $("#em0200_table table tr td .has_error").removeClass("has_error");
//     // MC_ANSASIA-398
//     if ($("#seating_chart_use_typ").val() == 0) {
//       return count_errors;
//     }
//     rows.forEach(function (row, index) {
//       var element = $("table .tr")[index];
//       if (row["floor_name"] == "") {
//         $(element).find(".floor_name").addClass("has_error");
//         $(element)
//           .find(".floor_name")
//           .closest("td")
//           .append(
//             `<span class="checkbox-error" style="position: relative; top: 0;">${_text[8].message}</span>`
//           );
//         count_errors++;
//       }
//       if (row["floor_map"] == "") {
//         $(element).find(".floor_map").addClass("has_error");
//         $(element)
//           .find(".floor_map")
//           .closest("td")
//           .append(
//             `<span class="checkbox-error" style="position: relative; top: 0;">${_text[8].message}</span>`
//           );
//         count_errors++;
//       }
//     });
//     return count_errors;
//   } catch (e) {
//     console.log("validate items required in table detail: " + e.message);
//   }
// }

function validateCheckbox() {
  try {
    var count_checked = $(".organization:enabled:checked").length;
    $("span.checkbox-error").remove();
    $("label.border-error").removeClass("border-error");
    if ($(".organization:enabled").length == 0) {
      return false;
    }
    if (count_checked == 0) {
      $(".organization:enabled").each(function () {
        $(this)
          .closest(".md-checkbox-v2")
          .append(`<span class="checkbox-error">${_text[8].message}</span>`);
        $(this)
          .closest(".md-checkbox-v2")
          .find("label")
          .addClass("border-error");
      });
      return true;
    }
    return false;
  } catch (e) {
    console.log("validate checkbox: " + e.message);
  }
}
