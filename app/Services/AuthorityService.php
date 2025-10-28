<?php 
namespace App\Services;

use Dao;

class AuthorityService {
    /**
     * searchAuthority
     * search list authority master for leftcontent
     *  @param  array $params
     *  @param  array $mode  ０：共通設定　１：人事評価　２：１on１　３：マルチレビュー 4: 週報　5.社員情報
     *
     * @return array
    */
    public function searchAuthority($params = [],$mode = 0)
    {
        if($mode == 1)
        {
            return Dao::executeSql('SPC_S0020_LST1',$params);
        }
        else if ($mode == 2)
        {
            return Dao::executeSql('SPC_oS0020_LST1',$params);
        }
        else if ($mode == 3)
        {
            return Dao::executeSql('SPC_mS0020_LST1',$params);
        }
        else if ($mode == 0)
        {
            return Dao::executeSql('SPC_sS0020_LST1',$params);
        }
        else if ($mode == 4)
        {
            return Dao::executeSql('SPC_rS0020_LST1',$params);
        }
        else if ($mode == 5)
        {
            return Dao::executeSql('SPC_eS0020_LST1',$params);
        }
        //
        return [];
    }
    /**
     * referData
     * refer data
     * @param  array $params
     * @param  array $mode  ０：共通設定　１：人事評価　２：１on１　３：マルチレビュー 4: 週報　5.社員情報
     *
     * @return array
    */
    public function referData($params = [],$mode = 0)
    {
        if($mode == 1)
        {
            return Dao::executeSql('SPC_S0020_INQ1',$params);
        }
        else if ($mode == 2)
        {
            return Dao::executeSql('SPC_oS0020_INQ1',$params);
        }
        else if ($mode == 3)
        {
            return Dao::executeSql('SPC_mS0020_INQ1',$params);
        }
        else if ($mode == 0)
        {
            return Dao::executeSql('SPC_sS0020_INQ1',$params);
        }
        else if ($mode == 4)
        {
            return Dao::executeSql('SPC_rS0020_INQ1',$params);
        }
        else if ($mode == 5)
        {
            return Dao::executeSql('SPC_eS0020_INQ1',$params);
        }
        //
        return [];
    }
    /**
     * getAuthority
     * get data of authority master
     *  @param  array $params
     *  @param  array $mode  ０：共通設定　１：人事評価　２：１on１　３：マルチレビュー 4: 週報　5.社員情報
     *
     * @return array
    */
    public function getAuthority($params = [],$mode = 0)
    {
        if($mode == 1)
        {
            return Dao::executeSql('SPC_S0020_INQ2',$params);
        }
        else if ($mode == 2)
        {
            return Dao::executeSql('SPC_oS0020_INQ2',$params);
        }
        else if ($mode == 3)
        {
            return Dao::executeSql('SPC_mS0020_INQ2',$params);
        }
        else if ($mode == 0)
        {
            return Dao::executeSql('SPC_sS0020_INQ2',$params);
        }
        else if ($mode == 4)
        {
            return Dao::executeSql('SPC_rS0020_INQ2',$params);
        }
        else if ($mode == 5)
        {
            return Dao::executeSql('SPC_eS0020_INQ2',$params);
        }
        //
        return [];
    }
    /**
     * saveAuthority
     * save data of authority master
     *  @param  array $params
     *  @param  array $mode  ０：共通設定　１：人事評価　２：１on１　３：マルチレビュー 4: 週報　5.社員情報
     *
     * @return array
    */
    public function saveAuthority($params = [],$mode = 0)
    {
        if($mode == 1)
        {
            return Dao::executeSql('SPC_S0020_ACT1',$params);
        }
        else if ($mode == 2)
        {
            return Dao::executeSql('SPC_oS0020_ACT1',$params);
        }
        else if ($mode == 3)
        {
            return Dao::executeSql('SPC_mS0020_ACT1',$params);
        }
        else if ($mode == 0)
        {
            return Dao::executeSql('SPC_sS0020_ACT1',$params);
        }
        else if ($mode == 4)
        {
            return Dao::executeSql('SPC_rS0020_ACT1',$params);
        }
        else if ($mode == 5)
        {
            return Dao::executeSql('SPC_eS0020_ACT1',$params);
        }
        //
        return [];
    }
    /**
     * deleteAuthority
     * delete data of authority master
     *  @param  array $params
     *  @param  array $mode  ０：共通設定　１：人事評価　２：１on１　３：マルチレビュー 4: 週報　5.社員情報
     *
     * @return array
    */
    public function deleteAuthority($params = [],$mode = 0)
    {
        if($mode == 1)
        {
            return Dao::executeSql('SPC_S0020_ACT2',$params);
        }
        else if ($mode == 2)
        {
            return Dao::executeSql('SPC_oS0020_ACT2',$params);
        }
        else if ($mode == 3)
        {
            return Dao::executeSql('SPC_mS0020_ACT2',$params);
        }
        else if ($mode == 0)
        {
            return Dao::executeSql('SPC_sS0020_ACT2',$params);
        }
        else if ($mode == 4)
        {
            return Dao::executeSql('SPC_rS0020_ACT2',$params);
        }
        else if ($mode == 5)
        {
            return Dao::executeSql('SPC_eS0020_ACT2',$params);
        }
        //
        return [];
    }
}


