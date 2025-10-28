<?php
/**
 ****************************************************************************
 * UNITE_MEDICAL
 * S0030
 *
 * 処理概要/process overview   : S0010
 * 作成日/create date   : 2017-10-12 08:20:28
 * 作成者/creater    : tannq@ans-asia.com
 * 
 * 更新日/update date    : 
 * 更新者/updater    : 
 * 更新内容 /update content  : 
 * 
 * 
 * @package         :  Auth
 * @copyright       :  Copyright (c) ANS-ASIA
 * @version    :  1.0.0
 * **************************************************************************
 */
namespace App;

use Illuminate\Notifications\Notifiable;
use Illuminate\Foundation\Auth\User as Authenticatable;

class S0010 extends Authenticatable
{
    use Notifiable;
    protected $table = 'S0010';
    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [];

    /**
     * The attributes that should be hidden for arrays.
     *
     * @var array
     */
    protected $hidden = [
        'password',
    ];

    /**
     * disabled auto increment.
     * @author      :   Tannq 2017/07/24
     * @see         :
     */
    public $incrementing = false;

    /**
     * disabled timestamps.
     * @author      :   Tannq 2017/07/24
     * @see         :
     */
    public $timestamps = false;

     /**
     * Change primary key default.
     * @author      :   Tannq 2017/07/24
     */
    protected $primaryKey = 'user_id';


    public function m0070() {
        return $this->hasOne('App\M0070','employee_cd','employee_cd');
    }

    public function getIdInArray($array, $term)
    {
        try {
            foreach($array as $key=>$value)
            {
                if($value==$term) {
                    return $key;
                }
            }
            throw new Exception('The employee status entered does not exist!');
        } catch (Exception $e) {
            echo $this->alert('errors', $e->getMessage(), "\n");
        }
    }

    /**
     * get login type from s0030 where library cd = 2.
     * @author      :   Tannq 2017/07/24
     */
    public function loginTyp()
    {
        return $this->hasOne('App\S0020','library_detail_cd','login_typ')->where('company_cd',$this->company_cd)->where('library_cd',2)->select(['library_detail_cd','library_nm']);
    }

    /**
     * check user login allowed
     * @author      :   Tannq 2017/07/24
     */
    public function hasLogin()
    {
        $library_detail_cd = $this->loginTyp ? $this->loginTyp->library_detail_cd :null;
        return $library_detail_cd==1 ?? false;
    }

    /**
     * get listPermission
     * @author      :   Tannq 2017/07/24
     */
    public function listPermission($use_typ = 1)
    {
        $user_id  = $this->user_id;
        
        $query = \Dao::executeSql('SPC_AUTH_PERMISSION',[$user_id]);
        if(isset($query[0]) && isset($query[0][0]['error_typ'])) {
            return [];
        }
        return $query[0] ?? [];
    }

    /**
     * get function_id
     * @author      :   Tannq 2017/07/24
     */
    public function listFunction($use_typ = 1)
    {
        $array = [];
        $query = $this->listPermission($use_typ);
        // $array = [];
        // foreach($query as $row)
        // {   
        //     $array[] = strtolower($row['function_id']);
        // }
        $array = $query;
        return $query;
    }
  
}