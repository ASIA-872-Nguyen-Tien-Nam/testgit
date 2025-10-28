<?php
namespace App\Services;

use Dao;

class SettingGroupService
{
    public function __construct()
    {

    }

    /**
     *  search item for left content
     *  @param  integer $company_cd
     *  @param  string  $key_search
     *  @param  integer $page
     *  @param  integer $page_size
     *
     *  @return array
    */
    public function findGroups($company_cd = 0,$key_search = '',$page = 1,$page_size = 20)
    {
        $params = [
            'search_key'    => $key_search,
            'current_page'  => $page,
            'page_size'     => $page_size,
            'company_cd'    => $company_cd // set for demo
        ];
        return Dao::executeSql('SPC_OM0300_LST1',$params);
    }

    /**
     *  refer item for rightcontent
     *  @param  integer $company_cd
     *  @param  integer $group_cd
     *
     *  @return array
    */
    public function getGroup($company_cd = 0,$group_cd = 0)
    {
        $params = [
            'group_cd'       => $group_cd,
            'company_cd'     => $company_cd
        ];
        return Dao::executeSql('SPC_OM0300_INQ1',$params);
    }

    /**
     *  save item
     *  @param  json    $params
     *
     *  @return array
    */
    public function saveGroup($params = '')
    {
        return Dao::executeSql('SPC_OM0300_ACT1',$params);
    }
    /**
     *  delete item
     *  @param  integer $company_cd
     *  @param  json    $params
     *
     *  @return array
    */
    public function deleteGroup($params = '')
    {
        return Dao::executeSql('SPC_OM0300_ACT2',$params);
    }
}