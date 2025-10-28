<?php
/**
 ****************************************************************************
 * UNITE_MEDICAL
 * LoginController
 *
 * 処理概要/process overview   : M0010
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

use Illuminate\Database\Eloquent\Model;

class M0010 extends Model
{
    protected $table = 'M0010';

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
    protected $primaryKey = 'employee_cd';
}
