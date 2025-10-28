<?php

namespace App\Services\EmployeeInformation;

use Dao;

class Qualification
{

    /**
     * Find a Qualification
     *
     * @return void
     */
    function findQualification($params)
    {
        return Dao::executeSql('SPC_eM0010_INQ1', $params);
    }

    /**
     * Get Qualifications
     *
     * @return void
     */
    function getQualifications($params)
    {
        return Dao::executeSql('SPC_eM0010_LST1', $params);
    }

    /**
     * Save a Qualification
     * @param  Array $params
     * @return void
     */
    function saveQualification($params)
    {
        return Dao::executeSql('SPC_eM0010_ACT1', $params);
    }

    /**
     * Delete a Qualification
     *
     * @return void
     */
    function deleteQualification($params)
    {
        return Dao::executeSql('SPC_eM0010_ACT2', $params);
    }
}
