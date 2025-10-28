<?php

namespace App\Modules\EmployeeInfo\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;

class EDashboardController extends Controller
{
          
     /**
      * index
      *
      * @param  Request $request
      * @return void
      */
     public function index(Request $request)
     {
          // $data['home_flg']  =   '1';
          $data['title'] = trans('messages.employee_info_setting_menu');
          return view('EmployeeInfo::edashboard.index', $data);
     }
}
