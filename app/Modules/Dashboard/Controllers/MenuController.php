<?php

namespace App\Modules\Dashboard\Controllers;

use Illuminate\Http\Request;
use Cookie;
use App\Http\Controllers\Controller;

class MenuController extends Controller
{
    /**
     * Show the application index.
     * @author mail@gmail.com
     * @created at 2020-09-04 03:53:04
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        // check user is logined
        if (session()->has(AUTHORITY_KEY)) {
            $user = session(AUTHORITY_KEY);
            $w_1on1_authority_typ = $user->w_1on1_authority_typ ?? 0;
            $multireview_use_typ = (int)$user->multireview_use_typ ?? 0;
            $evaluation_use_typ = (int)$user->evaluation_use_typ ?? 0;
            $oneonone_use_typ = (int)($user->_1on1_use_typ ?? 0);
            $report_use_typ = (int)($user->report_use_typ ?? 0);
            $empinf_use_typ = (int)($user->empinf_use_typ ?? 0);
            $empsrch_use_typ = (int)($user->empsrch_use_typ ?? 0);
            $empcom_use_typ = (int)($user->empcom_use_typ ?? 0);
            $lang = \Session::get('website_language', config('app.locale'));
            if ($lang == null) {
                $lang = 'jp';
            };
            // 
            $setting_authority_typ  = (int)$user->setting_authority_typ ?? 0;
            $multireview_authority_typ = (int)$user->multireview_authority_typ ?? 0;
            $authority_typ = (int)$user->authority_typ ?? 0;
            $user_is_rater_1 = (int)$user->user_is_rater_1 ?? 0;    // add by viettd 2021/06/16
            $report_authority_typ = (int)$user->report_authority_typ ?? 0;
            $empinfo_authority_typ = (int)$user->empinfo_authority_typ ?? 0;
            $employee_information_users = $this->useEmployeeInformation($empinf_use_typ, $empsrch_use_typ, $empcom_use_typ, $empinfo_authority_typ);
            // param share for view
            $params = array(
                'evaluation_use_typ' => $evaluation_use_typ,
                '_1on1_use_typ' => $oneonone_use_typ,
                'multireview_use_typ' => $multireview_use_typ,
                'report_use_typ' => $report_use_typ,
                'empinf_use_typ' => $empinf_use_typ,
                'empsrch_use_typ' => $empsrch_use_typ,
                'empcom_use_typ' => $empcom_use_typ,
                'employee_information_use_typ' => $employee_information_users['employee_information_use_typ'],
                'screen_id' => $employee_information_users['screen_id'],
                'authority_typ' => $authority_typ,
                'w_1on1_authority_typ' => $w_1on1_authority_typ ?? 0,
                'multireview_authority_typ' => $multireview_authority_typ,
                'setting_authority_typ' => $setting_authority_typ,
                'report_authority_typ' => $report_authority_typ,
                'empinfo_authority_typ' => $empinfo_authority_typ,
                'evaluation_time_status' => (int)$user->evaluation_time_status ?? 0,
                'multireview_time_status' => (int)$user->multireview_time_status ?? 0,
                'oneonone_time_status' => (int)$user->oneonone_time_status ?? 0,
                'report_time_status' => (int)$user->report_time_status ?? 0,
                'title' => trans('messages.menu'),
                'home_flg' => '1',
                'user_is_rater_1' => $user_is_rater_1,
                'lang'=>$lang,
            );
            $redirect_to = 'login';
            $count_use_typ = $evaluation_use_typ + $oneonone_use_typ + $multireview_use_typ + $report_use_typ + $empinf_use_typ;
            $count_authority = $user->count_authority ?? 0;
            // if use multiple of services 
            if ($count_use_typ > 1 && $count_authority > 1) {
                return view('Dashboard::menu.index', $params);
            }
            // if use only 1 service
            if (($count_use_typ == 1 || $count_authority == 1) && $setting_authority_typ < 3) {
                // 1on1
                if ($user->w_1on1_authority_typ >= 1 && $oneonone_use_typ == 1) {
                    // check member?
                    if ($w_1on1_authority_typ == 1) {
                        $redirect_to = '/oneonone/odashboardmember';
                    } else if ($w_1on1_authority_typ == 2) {
                        $redirect_to = '/oneonone/odashboard';
                    } else if ($w_1on1_authority_typ > 2) {
                        $redirect_to = '/oneonone/odashboardadmin';
                    } else {
                        $redirect_to = '/logout';
                    }
                    return redirect($redirect_to);
                }
                // mulitireview
                if ($multireview_use_typ == 1 && $multireview_authority_typ >= 2) {
                    // when user is admin
                    if ($multireview_authority_typ >= 3) {
                        $redirect_to = '/multiview/mdashboard';
                        // when user is rater_1 (is supporter) 
                    } else if ($multireview_authority_typ == 2 && $user_is_rater_1 == 1) {
                        $redirect_to = '/multiview/mdashboard';
                        // when user is only supporter (is not rater_1) 
                    } else if ($multireview_authority_typ == 2 && $user_is_rater_1 == 0) {
                        $redirect_to = '/multiview/mdashboardsupporter';
                    } else {
                        $redirect_to = '/logout';
                    }
                    return redirect($redirect_to);
                }
                // report
                if ($report_use_typ == 1 && $report_authority_typ >= 0) {
                    // 1.報告者用
                    if ($report_authority_typ == 1) {
                        $redirect_to = '/weeklyreport/rdashboardreporter';
                    } elseif ($report_authority_typ == 2) {
                        $redirect_to = '/weeklyreport/rdashboardapprover';
                    } else {
                        $redirect_to = '/weeklyreport/rdashboard';
                    }
                    return redirect($redirect_to);
                }
                // Employee Information
                if ($empinf_use_typ == 1 && $empinfo_authority_typ >= 0 && $employee_information_users['employee_information_use_typ'] == 1) {
                    $redirect_to = $employee_information_users['employee_information_redirect_to'];
                    return redirect($redirect_to);
                }
                // eval
                if ($evaluation_use_typ == 1) {
                    $redirect_to = '/menu/rdashboard';
                }
                return redirect($redirect_to);
            } else {
                return view('Dashboard::menu.index', $params);
            }
        } else {
            return redirect('login');
        }
    }
    /**
     * Show the application index.
     * @author mail@gmail.com
     * @created at 2020-09-04 03:53:04
     * @return \Illuminate\Http\Response
     */
    public function getChoice(Request $request)
    {
        // check user is logined
        if (session()->has(AUTHORITY_KEY)) {
            $authority_typ = session(AUTHORITY_KEY)->authority_typ;
            $url = '';
            switch ($authority_typ) {
                case 1:
                    $url = '/master/portal/evaluator';
                    break;
                case 2:
                    $url = '/master/portal';
                    break;
                case 3:
                    $url = '/dashboard';
                    break;
                default:
                    $url = '/dashboard';
                    break;
            }
            return redirect($url);
        } else {
            return redirect('login');
        }
    }

    /**
     * useEmployeeInformation
     *
     * @param  Int $empinf_use_typ
     * @param  Int $empsrch_use_typ
     * @param  Int $empcom_use_typ
     * @param  Int $empinfo_authority_typ
     * @return Array
     */
    function useEmployeeInformation($empinf_use_typ, $empsrch_use_typ, $empcom_use_typ, $empinfo_authority_typ)
    {
        $uses['employee_information_use_typ'] = 0;
        $uses['employee_information_redirect_to'] = '';
        $uses['screen_id'] = '';
        // 社員情報機能 : 利用しない
        if ($empinf_use_typ == 0) {
            return $uses;
        }
        // 社員コミュニケーション機能を利用する　：しない　と　$empinfo_authority_typ = 1 . 一般ユーザー
        if ($empcom_use_typ == 0 && $empinfo_authority_typ <= 1) {
            return $uses;
        }
        // 社員コミュニケーション機能を利用する　：する
        if ($empcom_use_typ == 1) {
            $uses['employee_information_use_typ'] = 1;
            $uses['employee_information_redirect_to'] = '/employeeinfo/eq0200';
            $uses['screen_id'] = 'eq0200_screen';
            return $uses;
        }
        //  社員コミュニケーション機能を利用する　：しない　と　社員検索機能を利用する　：する　と　empinfo_authority_typ　＝3,4,5
        if ($empsrch_use_typ == 1 && $empinfo_authority_typ >= 3) {
            $uses['employee_information_use_typ'] = 1;
            $uses['employee_information_redirect_to'] = '/employeeinfo/eq0100';
            $uses['screen_id'] = 'eq0100_screen';
            return $uses;
        }
    }
}
