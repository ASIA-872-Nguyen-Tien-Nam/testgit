<?php

namespace App\Services\EmployeeInformation;

use Dao;

class Communication
{
    /**
     * Find a Communication
     *
     * @return Array
     */
    function findCommunication($company_cd)
    {
        $params['company_cd'] = $company_cd;
        return Dao::executeSql('SPC_eM0200_INQ1', $params);
    }

    /**
     * Save a Communication
     * @param  Array $params
     * @return Array
     */
    function saveCommunication($params)
    {
        return Dao::executeSql('SPC_eM0200_ACT1', $params);
    }

    /**
     * refer organizations charts
     *
     * @param  Int $company_cd
     * @param  String $user_id
     * @param  String $key_search
     * @return Array
     */
    function referOrganizationCharts($company_cd, $user_id, $key_search)
    {
        $params['language']   = session_data()->language ?? '';
        $params['key_search'] = $key_search;
        $params['user_id'] = $user_id;
        $params['company_cd'] = $company_cd;
        return Dao::executeSql('SPC_eQ0200_LST1', $params);
    }

    /**
     * referSeatCharts
     *
     * @param  Int $company_cd
     * @param  String $user_id
     * @param  Int $floor_id
     * @param  String $search_key
     * @return void
     */
    function referSeatCharts($company_cd, $user_id, $floor_id, $search_key)
    {
        $params['floor_id'] = $floor_id;
        $params['search_key'] = $search_key;
        $params['user_id'] = $user_id;
        $params['company_cd'] = $company_cd;
        return Dao::executeSql('SPC_eQ0200_LST2', $params);
    }

    /**
     * addSeatChart
     *
     * @param  Int $floor_id
     * @param  String $employee_cd
     * @param  Numeric $x
     * @param  Numeric $y
     * @return Array
     */
    function addSeatChart($floor_id, $employee_cd, $x, $y)
    {
        $params['floor_id'] = $floor_id;
        $params['employee_cd'] = $employee_cd;
        $params['x'] = $x;
        $params['y'] = $y;
        $params['cre_user'] = session_data()->user_id ?? '';
        $params['cre_ip'] = $_SERVER['REMOTE_ADDR'];
        $params['company_cd'] = session_data()->company_cd ?? 0;
        return Dao::executeSql('SPC_eQ0200_ACT1', $params);
    }

    /**
     * searchEmployeeInformation
     *
     * @param  String $json
     * @return Array
     */
    function searchEmployeeInformation($json)
    {
        $params['json'] = $json;
        $params['user_id'] = session_data()->user_id ?? '';
        $params['company_cd'] = session_data()->company_cd ?? 0;
        return Dao::executeSql('SPC_eQ0200_LST3', $params);
    }

    /**
     * Find a Communication
     *
     * @return Array
     */
    function referEmployee($params)
    {
        return Dao::executeSql('SPC_eQ0200_LST4', $params);
    }

    /**
     * Delete seats
     *
     * @return void
     */
    function deleteSeats($params = [])
    {
        return Dao::executeSql('SPC_eQ0200_ACT2', $params);
    }
}
