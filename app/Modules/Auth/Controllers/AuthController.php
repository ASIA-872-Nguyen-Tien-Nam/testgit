<?php 
namespace App\Modules\Auth\Controllers;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;

use Carbon\Carbon;
use File;
use Dao;
class AuthController extends Controller
{
	/**
     * get all message with language
     *
     * @author      :   tannq@ans-asia.com
     * @author      :
     * @param       :   null
     * @return      :   null
     * @access      :   public
     * @see         :
     */
    public function getMessages(){
        //execute store procedure
        $data = Dao::executeSql('SPC_GET_MESSAGE_LST');
        return $data[0] ?? [];
    }


    /**
     * get message and update into file msg.js
     *
     * @author      :   tannq@ans-asia.com
     * @author      :   
     * @param       :   null
     * @return      :   null
     * @access      :   public
     * @see         :
     */
    public function getLangMessages(){
        // language folder path
        $langJsFolderPath = public_path('template/js/common');
        $langPath = resource_path('lang/ja');
        if(!File::exists($langPath))
        {
            File::makeDirectory($langPath, $mode = 0777, true, true);       
        }
        
        $trans['messages'] = [];

        // get all languages from Database
        $_text    =    '';
        $_type    =    '';
        $_title   =    '';
        $script   =    '';
        
        $message_data = self::getMessages();
        if (!empty($message_data)) {
            foreach ($message_data as $row){
                $_text[$row['message_cd']]     = htmlspecialchars_decode($row['message']);
                $_type[$row['message_cd']]     = $row['message_typ'];
                $_title[$row['message_cd']]    = $row['message_nm'];

                $trans['messages'][$row['message_cd']] = htmlspecialchars_decode($row['message']);

                $script  = "var _text = " . json_encode($_text, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP) . ";";
                $script .= "var _type = " . json_encode($_type, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP) . ";";
                $script .= "var _title = " . json_encode($_title, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP) . ";";
            }
        }
        $langJs = fopen(
            $langJsFolderPath.'/msg.min.js',
            'a+'
        );
        exec( 'icacls "{'.$langJs.'}" /q /c /reset' );
        // File::put($langJs,'<?php return ' . var_export($data, true) . ';');
        fwrite($langJs, $script);
        fclose($langJs);

        // $langFilePath = $langPath . 'trans.php';
        $langFilePath = fopen(
            $langPath.'/trans.php',
            'a+'
        );
        exec( 'icacls "{'.$langFilePath.'}" /q /c /reset' );
        // $bytes_written = File::put($lang_file_path, $script);
        // write into file translates
        fwrite($langFilePath, '<?php return ' . var_export($trans, true) . ';');
        fclose($langFilePath);
    }
}