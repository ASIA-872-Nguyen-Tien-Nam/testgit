  {{-- 1 --}}
  <div
      class="col-md-6 col-lg-6 col-xl-4 wrapper {{ ($result['target1_use_typ'] ?? 0) == 1 || ($data['count_data'] ?? -1) == 0 ? '' : 'hidden' }}">
      <div class="table-responsive wmd-view table-fixed-header  sticky-headers sticky-ltr-cells mt-10">
          <table class="table table-bordered table-hover table-ics marginbottom15" id="myTable">
              <thead>
                  <tr>
                      <th class="w-120px text-left">
                          <div class="d-flex justify-content-between">
                              <span class="ics-textbox" style="width: 88%;">
                                  <span class="num-length">
                                      <input type="text" style="min-width:100px" class="form-control form-control-sm"
                                          value='{{ $result['target1_nm'] ?? __('rm0020.target') . ' 1' }}'
                                          id="target1_name" maxlength="50" readonly="" tabindex="-1" />
                                  </span>
                              </span>
                              <div class="ics-group">
                                  <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                                      <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                                  </a>
                                  <input type="hidden" value={{ $result['target1_use_typ'] ?? '1' }}
                                      id="target1_use_typ">
                                  <a href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
                                      <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                  </a>
                              </div><!-- end .ics-group -->
                          </div>
                      </th>
                  </tr>
              </thead>
              <tbody>
                  <tr class="tr_employee">
                      <td class="w-120px">
                          <textarea class="form-control" readonly cols="30" rows="4" maxlength="400" id="generic_comment_1"
                              tabindex="-1"></textarea>
                      </td>
                  </tr>
              </tbody>
          </table>
      </div>
  </div>
  {{-- 2 --}}
  <div
      class="col-md-6 col-lg-6 col-xl-4 wrapper {{ ($result['target2_use_typ'] ?? 0) == 1 || ($data['count_data'] ?? -1) == 0 ? '' : 'hidden' }}">
      <div class="table-responsive wmd-view table-fixed-header  sticky-headers sticky-ltr-cells mt-10">
          <table class="table table-bordered table-hover table-ics marginbottom15" id="myTable">
              <thead>
                  <tr>
                      <th class="w-120px text-left">
                          <div class="d-flex justify-content-between">
                              <span class="ics-textbox" style="width: 88%;">
                                  <span class="num-length">
                                      <input type="text" style="min-width:100px" class="form-control form-control-sm"
                                          value='{{ $result['target2_nm'] ?? __('rm0020.target') . ' 2' }}'
                                          id="target2_name" maxlength="50" readonly="" tabindex="-1" />
                                  </span>
                              </span>
                              <div class="ics-group">
                                  <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                                      <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                                  </a>
                                  <input type="hidden" value={{ $result['target2_use_typ'] ?? '1' }}
                                      id="target2_use_typ">
                                  <a href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
                                      <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                  </a>
                              </div><!-- end .ics-group -->
                          </div>
                      </th>
                  </tr>
              </thead>
              <tbody>
                  <tr class="tr_employee">
                      <td class="w-120px">
                          <textarea class="form-control" readonly cols="30" rows="4" maxlength="400" id="generic_comment_1"
                              tabindex="-1"></textarea>
                      </td>
                  </tr>
              </tbody>
          </table>
      </div>
  </div>
  {{-- 3 --}}
  <div
      class="col-md-6 col-lg-6 col-xl-4 wrapper {{ ($result['target3_use_typ'] ?? 0) == 1 || ($data['count_data'] ?? -1) == 0 ? '' : 'hidden' }}">
      <div class="table-responsive wmd-view table-fixed-header  sticky-headers sticky-ltr-cells mt-10">
          <table class="table table-bordered table-hover table-ics marginbottom15" id="myTable">
              <thead>
                  <tr>
                      <th class="w-120px text-left">
                          <div class="d-flex justify-content-between">
                              <span class="ics-textbox" style="width: 88%;">
                                  <span class="num-length">
                                      <input type="text" style="min-width:100px" class="form-control form-control-sm"
                                          value='{{ $result['target3_nm'] ?? __('rm0020.target') . ' 3' }}'
                                          id="target3_name" maxlength="50" readonly="" tabindex="-1" />
                                  </span>
                              </span>
                              <div class="ics-group">
                                  <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                                      <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                                  </a>
                                  <input type="hidden" value={{ $result['target3_use_typ'] ?? '1' }}
                                      id="target3_use_typ">
                                  <a href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
                                      <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                  </a>
                              </div><!-- end .ics-group -->
                          </div>
                      </th>
                  </tr>
              </thead>
              <tbody>
                  <tr class="tr_employee">
                      <td class="w-120px">
                          <textarea class="form-control" readonly cols="30" rows="4" maxlength="400" id="generic_comment_1"
                              tabindex="-1"></textarea>
                      </td>
                  </tr>
              </tbody>
          </table>
      </div>
  </div>
  {{-- 4 --}}
  <div
      class="col-md-6 col-lg-6 col-xl-4 wrapper {{ ($result['target4_use_typ'] ?? 0) == 1 || ($data['count_data'] ?? -1) == 0 ? '' : 'hidden' }}">
      <div class="table-responsive wmd-view table-fixed-header  sticky-headers sticky-ltr-cells mt-10">
          <table class="table table-bordered table-hover table-ics marginbottom15" id="myTable">
              <thead>
                  <tr>
                      <th class="w-120px text-left">
                          <div class="d-flex justify-content-between">
                              <span class="ics-textbox" style="width: 88%;">
                                  <span class="num-length">
                                      <input type="text" style="min-width:100px"
                                          class="form-control form-control-sm"
                                          value='{{ $result['target4_nm'] ?? __('rm0020.target') . ' 4' }}'
                                          id="target4_name" maxlength="50" readonly="" tabindex="-1" />
                                  </span>
                              </span>
                              <div class="ics-group">
                                  <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                                      <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                                  </a>
                                  <input type="hidden" value={{ $result['target4_use_typ'] ?? '1' }}
                                      id="target4_use_typ">
                                  <a href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
                                      <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                  </a>
                              </div><!-- end .ics-group -->
                          </div>
                      </th>
                  </tr>
              </thead>
              <tbody>
                  <tr class="tr_employee">
                      <td class="w-120px">
                          <textarea class="form-control" readonly cols="30" rows="4" maxlength="400" id="generic_comment_1"
                              tabindex="-1"></textarea>
                      </td>
                  </tr>
              </tbody>
          </table>
      </div>
  </div>
  {{-- 5 --}}
  <div
      class="col-md-6 col-lg-6 col-xl-4 wrapper {{ ($result['target5_use_typ'] ?? 0) == 1 || ($data['count_data'] ?? -1) == 0 ? '' : 'hidden' }}">
      <div class="table-responsive wmd-view table-fixed-header  sticky-headers sticky-ltr-cells mt-10">
          <table class="table table-bordered table-hover table-ics marginbottom15" id="myTable">
              <thead>
                  <tr>
                      <th class="w-120px text-left">
                          <div class="d-flex justify-content-between">
                              <span class="ics-textbox" style="width: 88%;">
                                  <span class="num-length">
                                      <input type="text" style="min-width:100px"
                                          class="form-control form-control-sm"
                                          value='{{ $result['target5_nm'] ?? __('rm0020.target') . ' 5' }}'
                                          id="target5_name" maxlength="50" readonly="" tabindex="-1" />
                                  </span>
                              </span>
                              <div class="ics-group">
                                  <a href="javascript:;" class="ics ics-edit" tabindex="-1">
                                      <span class="ics-inner"><i class="fa fa-pencil"></i></span>
                                  </a>
                                  <input type="hidden" value={{ $result['target5_use_typ'] ?? '1' }}
                                      id="target5_use_typ">
                                  <a href="javascript:;" class="ics ics-eye" data-target=".td-1" tabindex="-1">
                                      <span class="ics-inner "><i class="fa fa-eye-slash"></i></span>
                                  </a>
                              </div><!-- end .ics-group -->
                          </div>
                      </th>
                  </tr>
              </thead>
              <tbody>
                  <tr class="tr_employee">
                      <td class="w-120px">
                          <textarea class="form-control" readonly cols="30" rows="4" maxlength="400" id="generic_comment_1"
                              tabindex="-1"></textarea>
                      </td>
                  </tr>
              </tbody>
          </table>
      </div>
  </div>
  <input type="hidden" id="count_data" value={{$data['count_data'] ?? 0}}>
