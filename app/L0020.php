<?php
/**
 ****************************************************************************
 * HRG
 * L0020_message
 *
 * 処理概要/process overview   	: get message
 * 作成日/create date   			: 2017/11/09
 * 作成者/creater    			: viettd@ans-asia.com
 * 
 * 更新日/update date    		: 
 * 更新者/updater    			: 
 * 更新内容 /update content  	: 
 * 
 * 
 * @package         :  Auth
 * @copyright       :  Copyright (c) ANS-ASIA
 * @version    		:  1.0.0
 * **************************************************************************
 */
namespace App;

use Illuminate\Database\Eloquent\Model;
use Cookie;

class L0020 extends Model
{
    protected $table = 'L0020';
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
    protected $primaryKey = 'messages_cd';

    public function scopeText($query,$json=true)
    {
        // $dao = \Dao::executeSql('SPC_MESSAGE_LST1',[0,'']);
        try {
            $language = \Session::get('website_language', config('app.locale'));
            if($language == 'en'){
                $messages = $query->whereNull('del_datetime')->orderBy('message_cd')->get(['message_typ', 'message_nm_english as message_nm', 'message_english as message', 'message_cd']);
            }else{
                $messages = $query->whereNull('del_datetime')->orderBy('message_cd')->get(['message_typ', 'message_nm', 'message', 'message_cd']);
            }
            $array = [];
            foreach($messages as $row)
            {
                $message_cd = $row->message_cd;
                unset($row['message_cd']);
                $array[$message_cd] = $row;
                
            }
            return $json ? json_encode($array) : $array;
        } catch (\Exception $e) {
            return $json ? json_encode([]) : [];
        }
        
    }

    public function scopeGetText($query,$message_cd)
    {
        $messages = $query->whereNull('del_datetime')->where('message_cd',$message_cd)->first(['message_typ','message_nm','message','message_english','message_cd','message_nm_english']);
        $data = new \stdclass();
        $data->message_typ = $messages ? $messages->message_typ : 0;
        if(Cookie::get('language')['language'] == 'en') {
            $data->message_nm = $messages ? $messages->message_nm_english : 'Message is not defined!';
            $data->message = $messages ? $messages->message_english : 'Message is not defined!';
        } else {
            $data->message_nm = $messages ? $messages->message_nm : 'Message is not defined!';
            $data->message = $messages ? $messages->message : 'Message is not defined!';
        }
        return $data;
    }
}
