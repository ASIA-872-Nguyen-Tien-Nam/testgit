<?php
/**
****************************************************************************
* ANSAsia Service SOAP PHP
*
* 処理概要/process overview       :   call 
* 作成日/create date            :   2017/10/12
* 作成者/creater              	:   thoantd – thoantd@ans-asia.com
*
* 更新日/update date          	:   
* 更新者/updater              	:   
* 更新内容 /update content     	:   
*
* @package                     :   Master
* @copyright                   :   Copyright (c) ANS-ASIA
* @version                     :   1.0.0
* **************************************************************************
*/
namespace App\Helpers;
use SoapClient;
use File;
class Service
{

	protected $client;
	private static $instance = null;
	protected $filename;
	protected $status;
	protected $param;

	public function __construct()
	{

		$this->setClient();
		$this->param = new \stdClass();
	}


	public static function getInstance()
	{
		if (self::$instance == null) {
			self::$instance = new Service();
		}
		return self::$instance;
	}

	/**
	 * PHP 5
	 * @author      : GiangNT
	 * @copyright   : Copyright (c) ANS-ASIA
	 * @package     : Export
	 * setClient
	 */
	private function setClient()
	{
		try {
			$this->client = new SoapClient(config('services.wcf_service.host'), array("trace" => 1, "exceptions" => 1));
			// check service call fail
		} catch (\Exception $e) {
			echo $e->getMessage();
		}
	}

	/** call wcf service
	 * @param $service_method service name
	 * @param $store_name name of store
	 * @param $store_param list param to run store procedure
	 * @param $screen   screen name
	 * @param $file_name export file name
	 * @return array
	 */
	public function execute($service_method, $store_name, $store_param, $screen, $file_name,$result_data = "")
	{	
		$result = array();
		try {
			//add vietdt 2022/08/22 Ver 1.9
			$language = \Session::get('website_language', config('app.locale'));
			array_unshift($store_param, $language);
			# generate query string and write log  
			$sql = $this->getSql($store_name, $store_param);
			$this->param->sql		= $sql;
			$this->param->screen	= $screen;
			$this->param->fileName	= $file_name;
			$this->param->P5		= $result_data;
			# execute service and get result
		
			$service_result			= $this->client->{$service_method}($this->param);
			$output_result			= array();
			$function 				= $service_method . 'Result';
			//
			if($this->checkSOAP($service_result)){
				$output_result = json_decode(str_replace("\r\n", "\\r\\n", str_replace("\\", "//", $service_result->$function)));
				// print_r($output_result);
				# check file exist
				// $path = config('services.wcf_service.download_path') . '/' . $output_result->filename;
			
				$result['status']	= OK;
				$result['filename'] = $output_result->filename;
				$result['message']	= $output_result->message;
				
			}else{
				$error_data = json_decode(str_replace("\r\n", "\\r\\n", str_replace("\\", "//", $service_result->$function)));
				if($error_data->status == '203'){
					$result['status']	= EPT;
					$result['message']	= trans('messages.label_027');										       										       
				}else{
					$result['status']	= NG;
					$result['filename'] = $output_result->filename??'';
					$result['message']	= trans('messages.label_028');	
				}
			}
		
			//
			// if ( File::exists($path) ) {
			// 	$result['status']	= OK;
			// 	$result['filename'] = $output_result->filename;
			// 	$result['message']	= $output_result->message;
			// } else {
			// 	$result['status']	= NG;
			// 	$result['filename'] = $output_result->filename;
			// 	$result['message']	= "ファイルを作成出来ませんでした。";
			// }
		} catch (\Exception $e) {
			$result['status'] = EX;
			$result['Exception'] = $e->getMessage();
		}
		return $result;
	}

	/**
	 * PHP 5
	 * @author      : GiangNT
	 * @copyright   : Copyright (c) ANS-ASIA
	 * @package     : Exports
	 * @return      : path to file
	 * getSql
	 */
	public function getStatus()
	{
		return $this->status;
	}


	/**
	 * PHP 5
	 * @author      : GiangNT
	 * @copyright   : Copyright (c) ANS-ASIA
	 * @package     : Exports
	 * @return      : file name form soap
	 */
	public function getFilename($result)
	{
		if ($this->checkSOAP($result)) {
			return $this->filename;
		}
		return "";
	}

	/**
	 * PHP 5
	 * @author      : GiangNT
	 * @copyright   : Copyright (c) ANS-ASIA
	 * @package     : Exports
	 * @return      : path to file
	 * check result from soap
	 */
	private function checkSOAP($result)
	{
		try {
			if (is_soap_fault($result)) {
				// trigger_error("SOAP Fault: (faultcode: {$result->faultcode}, faultstring: {$result->faultstring})", E_USER_ERROR);
				throw new \Exception("Line: " . __LINE__, 1);
			}
			$respon = get_object_vars($result);

			if (!is_array($respon)) {
				throw new \Exception("Line: " . __LINE__, 1);
			}

			$array_value = array_values($respon);
			$str_json = preg_replace("/\\\+/", "\\\\\\", $array_value[0]);
			$parse_respon = json_decode($str_json);

			if (!is_object($parse_respon)) {
				throw new \Exception("Line: " . __LINE__, 1);
			}
			$parse_respon = get_object_vars($parse_respon);
			if (isset($parse_respon['status']) && $parse_respon['status'] == 203) {
				$this->status = config('services.wcf_service.status.EPT');
				return false;
			}
			if (isset($parse_respon['status']) && $parse_respon['status'] == 205) {
				$this->status = config('services.wcf_service.status.SCS');
				return false;
			}
			if (isset($parse_respon['status']) && $parse_respon['status'] == 209) {
				$this->status = config('services.wcf_service.status.NODATA');
				return false;
			}

			if (isset($parse_respon['status']) && $parse_respon['status'] == 200 && isset($parse_respon['filename'])) {
				// if (!file_exists(mb_convert_encoding($parse_respon['filename'], 'SJIS', 'utf-8'))
				// 	|| !file_exists(config('services.wcf_service.download_path') . DIRECTORY_SEPARATOR . mb_convert_encoding(basename($parse_respon['filename']), 'SJIS', 'utf-8'))
				// ) {
				// 	throw new \Exception("Line: " . __LINE__, 1);
				// }

                $path = config('services.wcf_service.download_path') . DIRECTORY_SEPARATOR .$parse_respon['filename'];
                $wfio = '';
                $extension_loaded = get_loaded_extensions();
                if(in_array('wfio', $extension_loaded)){
                    $path = 'wfio://'.$path;
                } else {
                    $path = mb_convert_encoding($path, 'SJIS', 'utf-8');
                }
//                echo $path;die;
				if(!file_exists($path)){
					throw new Exception("Line: " .  __LINE__, 1);
				}
				$this->filename = basename($parse_respon['filename']);
			} else {
				throw new \Exception("Line: " . __LINE__, 1);
			}
			return true;
		} catch (\Exception $e) {
			// echo $e->getMessage(); die;
			$this->status = config('services.wcf_service.status.NG');
			return false;
		}
	}
    /**
    * Create Date: 2017/09/19
    * Update Date: N/A
    * Create by: NamNB
    * Update by: N/A
    * Description: get full sql
    */
    public function getSql($procName, $parameters = null)
    {
    	$syntax = '';
	    for ($i = 0; $i < count($parameters); $i++) {
	        $syntax .= (!empty($syntax) ? ',' : '') . '?';
	    }
	    $syntax = 'EXEC ' . $procName . ' ' . $syntax;
	    // write log file
	    $sql = $this->interpolateQuery($syntax, $parameters);
	    //$this->writeLog($sql);
	    return $sql;
    }
    /**
    * Create Date: 2017/09/19
    * Update Date: N/A
    * Create by: NamNB
    * Update by: N/A
    * Description: get raw query
    */
	public function interpolateQuery($query, $params) {
	    $keys = array();
	    $values = $params;

	    # build a regular expression for each parameter
	    foreach ($params as $key => $value) {
	        if (is_string($key)) {
	            $keys[] = '/:'.$key.'/';
	        } else {
	            $keys[] = '/[?]/';
	        }

	        if (is_array($value))
	            $values[$key] = implode(',', $value);

	        if (is_null($value))
	            $values[$key] = 'NULL';
	    }
	    // Walk the array to see if we can add single-quotes to strings
	    array_walk($values, function(&$v, $k) {
			if ($v != "NULL") {
				$v = "'" . $v . "'";
			}
		});

	    $query = preg_replace($keys, $values, $query, 1, $count);
	    return $query;
	}
    /**
    * Create Date: 2017/09/19
    * Update Date: N/A
    * Create by: NamNB
    * Update by: N/A
    * Description: write log query file
    */
    public static function writeLog($query)
    {
    	$filepath = storage_path('logs/' . 'service_' . date('Y_m_d', time()) . '.log');
        $exists = File::exists($filepath);
        $content = date('[Y/m/d H:i:s]', time()) . ' local.DEBUG: ' . $query;
        if ( $exists )
        {
            $content = "\n" . $content;
            File::append($filepath, $content.PHP_EOL);
        }
        else
        {
         	File::put($filepath, $content.PHP_EOL);   
        }
    }
}