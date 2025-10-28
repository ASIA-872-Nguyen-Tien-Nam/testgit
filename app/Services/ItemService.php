<?php
namespace App\Services;

use Dao;

class ItemService
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
    public function findItems($company_cd = 0,$key_search = '',$page = 1,$page_size = 20)
    {
        $params = [
            'search_key'    => $key_search,
            'current_page'  => $page,
            'page_size'     => $page_size,
            'company_cd'    => $company_cd // set for demo
        ];
        return Dao::executeSql('SPC_M0080_LST1',$params);
    }

    /**
     *  refer item for rightcontent
     *  @param  integer $company_cd
     *  @param  integer $item_cd
     *
     *  @return array
    */
    public function getItem($company_cd = 0,$item_cd = 0)
    {
        $params = [
            'item_cd'       => $item_cd,
            'company_cd'    => $company_cd
        ];
        return Dao::executeSql('SPC_M0080_INQ1',$params);
    }

    /**
     *  save item
     *  @param  integer $company_cd
     *  @param  json    $params
     *
     *  @return array
    */
    public function saveItem($company_cd = 0,$params = '')
    {
        return Dao::executeSql('SPC_M0080_ACT1',$params);
    }

    /**
     *  delete item
     *  @param  integer $company_cd
     *  @param  integer $item_cd
     *
     *  @return array
    */
    public function deleteItem($company_cd = 0,$params = '')
    {
        return Dao::executeSql('SPC_M0080_ACT2',$params);
    }

    /**
     *  get items for employee
     *  @param  integer $company_cd     user login information
     *  @param  string $user_id         user login information
     *  @param  string $mode            0 : for M0070 ; 1 : for other search
     *  @param  string $employee_cd     user for M0070, default : blank
     *
     *  @return array
    */
    public function getItemsForEmployee($company_cd = 0,$user_id = '',$mode = 1 ,$employee_cd = '')
    {
        // mode = 0 : for master ; mode = 1 : for search
        $params = [ 'company_cd'=>$company_cd
                    ,'user_id'=>$user_id
                    ,'mode'=>$mode
                    ,'employee_cd'=>$employee_cd
                    ];
        $result = Dao::executeSql('SPC_M0070_INQ2',$params);
        $temp = [];
        $item = 0;
        $temp[0] = [];
        foreach($result[1] as  $data){
            if($data['item_cd'] == $item){
               array_push($temp[$item],$data??[]);
            }else{
                $item = $data['item_cd'] ;
                $temp[$item] = [];
                array_push($temp[$item],$data??[]);
            }
        }
        unset($result[1]);
        $result[1] =  $temp;
        return $result;
    }
}