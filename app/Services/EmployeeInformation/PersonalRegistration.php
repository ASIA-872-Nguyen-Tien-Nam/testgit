<?php

namespace App\Services\EmployeeInformation;

use Dao;

class PersonalRegistration
{

    /**
     * get personal data
     *
     * @return void
     */
    function getPersonalRegistration($params)
    {
        return Dao::executeSql('SPC_eI0200_INQ1', $params);
    }

    /**
     * Save personal data
     * @param  Array $params
     * @return void
     */
    function savePersonalData($params)
    {
        return Dao::executeSql('SPC_eI0200_ACT1', $params);
    }
}
