<?php

namespace App\Services;

use Dao;

class OneOnOneService
{
    /**
     *  refer COACH FROM MEMBER
     *  @param  integer $company_cd
     *  @param  integer $fiscal_year
     *  @param  integer $employee_cd
     *  @param  integer $times
     *
     *  @return array
     */
    public function getCoachByMember($company_cd = 0, $fiscal_year = 0, $employee_cd = '', $coach_cd = '', $times = 0)
    {
        $params = [
            'company_cd'               => $company_cd,
            'fiscal_year'              => $fiscal_year,
            'employee_cd'              => $employee_cd,
            'coach_cd'                 => $coach_cd,
            'times'                     => $times,
        ];
        return Dao::executeSql('SPC_1on1_PERMISSION_CHK1', $params);
    }
    /**
     * get1on1ScheduleList
     *
     * @param  int $company_cd
     * @param  int $fiscal_year
     * @param  string $employee_cd
     * @param  int $w_1on1_authority_typ
     * @param  int $from_coach
     * @return void
     */
    public function get1on1ScheduleList($company_cd = 0, $fiscal_year = 0, $employee_cd = '', $w_1on1_authority_typ = 0, $from_coach = 0)
    {
        $params = [
            'company_cd'               => $company_cd,
            'fiscal_year'              => $fiscal_year,
            'employee_cd'              => $employee_cd,
            'w_1on1_authority_typ'     => $w_1on1_authority_typ,
            'from_coach'               => $from_coach,
        ];
        return Dao::executeSql('SPC_1ON1_GET_SCHEDULE_FND1', $params);
    }
    /**
     * getNotificationList
     *
     * @param  int $company_cd
     * @param  string $employee_cd
     * @param  int $information_typ
     * @param  int $fiscal_year
     *
     * @return array
     */
    public function getNotificationList($company_cd = 0, $employee_cd = '', $information_typ = 0, $fiscal_year = 0, $coach_member = 0)
    {
        $params = [
            'company_cd'                => $company_cd,
            'employee_cd'               => $employee_cd,
            'information_typ'           => $information_typ,
            'fiscal_year'               => $fiscal_year,
            'coach_member'              => $coach_member,   //screen 1:coach , 2:member
            'language'                  => session_data()->language,
        ];
        return Dao::executeSql('SPC_1ON1_GET_NOTIFICATION_FND1', $params);
    }
    /**
     * findGroupForMember
     *
     * @param  int $company_cd
     * @param  int $fiscal_year
     * @param  string $employee_cd
     *
     * @return array
     */
    public function findGroupForMember($company_cd = 0, $fiscal_year = 0, $employee_cd = '')
    {
        $params = [
            'company_cd'                => $company_cd,
            'fiscal_year'               => $fiscal_year,
            'employee_cd'               => $employee_cd,
        ];
        return Dao::executeSql('SPC_1ON1_FIND_GROUP_FOR_MEMBER_FND1', $params);
    }
    /**
     * getCurrentFiscalYear
     *
     * @param  int $company_cd
     * @param  date $date
     *
     * @return array
     */
    public function getCurrentFiscalYear($company_cd = 0, $date = '')
    {
        $params = [
            'company_cd' => $company_cd,
            'date'       => $date
        ];
        $result = Dao::executeSql('SPC_1on1_GET_CURRENT_YEAR', $params);
        return $result[0][0];
    }
    /**
     * getLoginUser1on1Object
     *
     * @param  integer $company_cd
     * @param  integer $fiscal_year
     * @param  string $employee_cd
     * @param  integer $times
     * @return 1.Member | 2.Coach | 20.Coach of once times | 21.Coach at this time | 3.Admin | 5.General Admin | 0.Other
     */
    public function getLoginUser1on1Object($company_cd = 0, $fiscal_year = 0, $employee_cd = '', $login_employee_cd = '', $times = 0)
    {
        $params = [
            'company_cd'        => $company_cd,
            'fiscal_year'       => $fiscal_year,
            'employee_cd'       => $employee_cd,
            'login_employee_cd' => $login_employee_cd,
            'times'             => $times,
        ];
        $result = Dao::executeSql('SPC_1on1_GET_LOGIN_USER_OBJECT', $params);
        return $result[0][0]['object_cd'] ?? 0;
    }

    /**
     * check used to coach or member
     *
     * @param  int $company_cd
     * @param  string $employee_cd
     *
     * @return array
     */
    public function usedToCoachOrMember($company_cd = 0, $employee_cd = '')
    {
        $params = [
            'company_cd'                => $company_cd,
            'employee_cd'               => $employee_cd,
        ];
        return Dao::executeSql('SPC_1ON1_USED_TO_COACH_OR_MEMBER_FND1', $params);
    }
}
