<?php

namespace App\Services\EmployeeInformation;

use Dao;

class Communicationfield
{

    /**
     * Find a Communicationfield
     *
     * @return void
     */
    function findCommunicationfield($params)
    {
        return Dao::executeSql('SPC_EM0201_INQ1', $params);
    }

    /**
     * Get Communicationfields
     *
     * @return void
     */
    function getCommunicationfield($params)
    {
        return Dao::executeSql('SPC_EM0201_LST1', $params);
    }

    /**
     * Save a Communicationfield
     * @param  Array $params
     * @return void
     */
    function saveCommunicationfield($params)
    {
        return Dao::executeSql('SPC_EM0201_ACT1', $params);
    }

    /**
     * Delete a Communicationfield
     *
     * @return void
     */
    function deleteCommunicationfield($params)
    {
        return Dao::executeSql('SPC_EM0201_ACT2', $params);
    }
}
