<?php 

namespace App\Services;

use Dao;

class AccountAuthorityService {

    /**
     * searchAccountAuthority
     * search list account authority
     *  @param  array $params
     *  @param  array $mode  ０：共通設定　１：人事評価　２：１on１　３：マルチレビュー 4.週報 5.社員情報
     *
     * @return array
    */
    public function searchAccountAuthority($params = [], $mode = 0)
    {
        if($mode == 1)
        {
            return Dao::executeSql('SPC_S0030_LST1',$params);
        }
        else if ($mode == 2)
        {
            return Dao::executeSql('SPC_oS0030_LST1',$params);
        }
        else if ($mode == 3)
        {
            return Dao::executeSql('SPC_mS0030_LST1',$params);
        }
        else if ($mode == 0)
        {
            return Dao::executeSql('SPC_sS0030_LST1',$params);
        }
        else if ($mode == 4)
        {
            return Dao::executeSql('SPC_rS0030_LST1',$params);
        }
        else if ($mode == 5)
        {
            return Dao::executeSql('SPC_eS0030_LST1',$params);
        }
        //
        return [];
    }
    /**
     * getAccountAuthority
     * get account authority
     *  @param  array $params
     *  @param  array $mode  ０：共通設定　１：人事評価　２：１on１　３：マルチレビュー 4.週報 5.社員情報
     *
     * @return array
    */
    public function getAccountAuthority($params = [], $mode = 0)
    {
        if($mode == 1)
        {
            return Dao::executeSql('SPC_S0030_INQ1',$params);
        }
        else if ($mode == 2)
        {
            return Dao::executeSql('SPC_oS0030_INQ1',$params);
        }
        else if ($mode == 3)
        {
            return Dao::executeSql('SPC_mS0030_INQ1',$params);
        }
        else if ($mode == 0)
        {
            return Dao::executeSql('SPC_sS0030_INQ1',$params);
        }
        else if ($mode == 4)
        {
            return Dao::executeSql('SPC_rS0030_INQ1',$params);
        }
        else if ($mode == 5)
        {
            return Dao::executeSql('SPC_eS0030_INQ1',$params);
        }
        //
        return [];
    }
    /**
     * saveAccountAuthority
     * save data of authority master
     *  @param  array $params
     *  @param  array $mode  ０：共通設定　１：人事評価　２：１on１　３：マルチレビュー 4.週報 5.社員情報
     *
     * @return array
    */
    public function saveAccountAuthority($params = [],$mode = 0)
    {
        if($mode == 1)
        {
            return Dao::executeSql('SPC_S0030_ACT1',$params);
        }
        else if ($mode == 2)
        {
            return Dao::executeSql('SPC_oS0030_ACT1',$params);
        }
        else if ($mode == 3)
        {
            return Dao::executeSql('SPC_mS0030_ACT1',$params);
        }
        else if ($mode == 0)
        {
            return Dao::executeSql('SPC_sS0030_ACT1',$params);
        }
        else if ($mode == 4)
        {
            return Dao::executeSql('SPC_rS0030_ACT1',$params);
        }
        else if ($mode == 5)
        {
            return Dao::executeSql('SPC_eS0030_ACT1',$params);
        }
        //
        return [];
    }
    /**
     * deleteAccountAuthority
     * delete data of authority master
     *  @param  array $params
     *  @param  array $mode  ０：共通設定　１：人事評価　２：１on１　３：マルチレビュー 4.週報 5.社員情報
     *
     * @return array
    */
    public function deleteAccountAuthority($params = [],$mode = 0)
    {
        if($mode == 1)
        {
            return Dao::executeSql('SPC_S0030_ACT1',$params);
        }
        else if ($mode == 2)
        {
            return Dao::executeSql('SPC_oS0030_ACT1',$params);
        }
        else if ($mode == 3)
        {
            return Dao::executeSql('SPC_mS0030_ACT1',$params);
        }
        else if ($mode == 0)
        {
            return Dao::executeSql('SPC_sS0030_ACT1',$params);
        }
        else if ($mode == 4)
        {
            return Dao::executeSql('SPC_rS0030_ACT1',$params);
        }
        else if ($mode == 5)
        {
            return Dao::executeSql('SPC_eS0030_ACT1',$params);
        }
        //
        return [];
    }
}
