<?php

/**
 *-------------------------------------------------------------------------*
 * Helpers
 * @created         :   2016/11/24
 * @author          :   tannq@ans-asia.com
 * @package         :   common
 * @copyright       :   Copyright (c) ANS-ASIA
 * @version         :   1.0.0
 *-------------------------------------------------------------------------*
 *
 */

use App\Helpers\Dao;
use Carbon\Carbon;
use Illuminate\Support\Facades\File;
/*
 * Add timestamp version
 */

if (!function_exists('file_cached')) {
	function file_cached($path, $bustQuery = false)
	{
		// Get the full path to the file.
		$realPath = public_path($path);

		if (!file_exists($realPath)) {
			throw new \LogicException("File not found at [{$realPath}]");
		}

		// Get the last updated timestamp of the file.
		$timestamp = filemtime($realPath);

		if (!$bustQuery) {
			// Get the extension of the file.
			$extension = pathinfo($realPath, PATHINFO_EXTENSION);

			// Strip the extension off of the path.
			$stripped = substr($path, 0, - (strlen($extension) + 1));

			// Put the timestamp between the filename and the extension.
			$path = implode('.', array($stripped, $timestamp, $extension));
		} else {
			// Append the timestamp to the path as a query string.
			$path  .= '?v=' . $timestamp;
		}

		return asset($path);
	}
}

/*
 * Call url file
 */
if (!function_exists('public_url')) {
	function public_url($url, $attributes = null)
	{
		$realPath = public_path($url);
		if (file_exists($url)) {
			$attr = '';
			if (!empty($attributes) && is_array($attributes)) {
				foreach ($attributes as $key => $val) {
					$attr .= $key . '="' . $val . '" ';
				}
			}
			$attr = rtrim($attr);
			if (ends_with($url, '.css')) {
				return '<link rel="stylesheet" href="' . file_cached($url, true) . '" type="text/css" ' . $attr . '>';
			} elseif (ends_with($url, '.js')) {
				return '<script src="' . file_cached($url, true) . '" type="text/javascript" charset="utf-8" ' . $attr . '></script>';
			} else {
				return asset($url);
			}
		}
		$console = 'File:[' . $url . '] not found';
		return "<script>console.log('" . $console . "')</script>";
	}
}

// numberformat
if (!function_exists('formatNumber')) {
	function formatNumber($number = '', $decimal = 0)
	{
		if ($number == '')
			return $number;

		$number = 1 * $number;
		if (($number - round($number)) != 0) {
			$number = number_format($number, $decimal, '.', ',');
		} else {
			$number = number_format($number, 0, '.', ',');
		}
		return $number;
	}
}

// make keyword
if (!function_exists('makeKeyword')) {
	function makeKeyword($keyword = null, $input = 'keyword')
	{
		$keyword = trim(\Request::get($input));
		$keyword = explode(' ', $keyword);
		$keyword = implode('%', $keyword);
		return $keyword = '%' . $keyword . '%';
	}
}
/**
 * getCombobox
 *
 * @param  string $table_key
 * @param  int $typ
 * @param  int $system
 * @return array
 */
if (!function_exists('getCombobox')) {
	function getCombobox($table_key = '', $typ = 0, $system = 1)
	{
		$params = array(
			$table_key,	$typ,	app('session_data')->user_id,	app('session_data')->company_cd,	$system
		);
		$data = \Dao::executeSql('SPC_COMBOBOX_INQ1', $params);
		return $data[0] ?? [];
	}
}

// get session login
if (!function_exists('session_data')) {
	function session_data($key = NULL)
	{
		if ($key !== NULL) {
			return app('session_data')->$key ?? '';
		}
		return app('session_data');
		// return app('session_data')->$key ?? app('session_data');
	}
}

// check  permission
if (!function_exists('checkPermission')) {
	function checkPermission($controller_nm, $functions = null)
	{
		$result 		= 0;
		$controller_nm 	= $controller_nm ? strtolower($controller_nm) : null;
		foreach ($functions as $temp) {
			if (strtolower($controller_nm) == strtolower($temp['function_id'])) {
				$result = 1;
			}
		}
		return $result;
	}
}
//  get getPermission
if (!function_exists('getPermission')) {
	function getPermission()
	{
		$functions = auth()->guard('web')->user()->listFunction();
		return $functions ?? [];
	}
}

// menu
if (!function_exists('navbar_group')) {
	function navbar_group($screens, $system_typ = [])
	{
		$array = [];
		foreach ($screens as $key => $values) {
			$category 		= $values->category;
			$navbar   		= isset($values->navbar) ? $values->navbar : 0;
			$authority   	= isset($values->authority) ? $values->authority : 0;
			// 
			if (in_array($values->system_typ, $system_typ)) {
				if ($navbar == 1 && $authority > 0) {
					$array[$category][] = $values;
				}
			}
		}
		return $array;
	}
}
if (!function_exists('setCache')) {
	function setCache($array = '')
	{
		$user_cd 	= session_data()->user_id;
		$screen_id 	= isset($array['screen_id']) ? preventOScommand($array['screen_id']) 	: '';
		$cache_data = Cache::get($user_cd) ?? [];
		foreach ($array as $key => $value) {
			if ($key == 'html') {
				$cache_data_new[$key] = htmlspecialchars($value, ENT_QUOTES);
			} else {
				$cache_data_new[$key] = $value;
			}
		}
		$cache_data[$screen_id]		=	$cache_data_new;
		Cache::forever($user_cd, $cache_data);
		return true;
	}
}
if (!function_exists('getCache')) {
	function getCache($screen_id = '', $user_cd = '')
	{
		$result = [];
		$cache_data = Cache::get($user_cd);
		if ($cache_data) {
			$data = [];
			$data = isset($cache_data[$screen_id]) ? $cache_data[$screen_id] : NULL;
			if ($data) {
				foreach ($data as $key => $value) {
					$result[$key] = $value;
				}
			}
		}
		return $result;
	}
}
if (!function_exists('deleteCache')) {
	function deleteCache($screen_id = '', $user_cd = '', $key = NULL)
	{
		if ($screen_id) {
			$cache_data = Cache::get($user_cd);
			if (isset($cache_data)) {
				if (isset($cache_data[$screen_id])) {
					if ($key) {
						$cache_data[$screen_id][$key] = NULL;
					} else {
						$cache_data[$screen_id] = NULL;
					}
				}
				Cache::forever($user_cd, $cache_data);
			}
		} else {
			if ($user_cd) {
				Cache::forget($user_cd);
			}
		}
		return true;
	}
}

/**
 * SQLEscapse
 * @author  viettd
 * @param  string $input
 * @return string sql (after escapse)
 */
if (!function_exists('SQLEscape')) {
	function SQLEscape($input = '')
	{
		if ($input === NULL) {
			$input = NULL;
		}
		$input = str_replace('[', '[[]', $input);
		$input = str_replace('%', '[%]', $input);
		$input = str_replace('_', '[_]', $input);
		$input = str_replace('\\', '[\\]', $input);
		$input = str_replace('\'', '\'\'', $input);
		//
		return $input;
	}
}

/**
 * preventOScommand
 * @author  viettd
 * @param  string $input
 * @return string sql (after escapse)
 */
if (!function_exists('preventOScommand')) {
	function preventOScommand($input = NULL)
	{
		if ($input === NULL) {
			$input = NULL;
		}
		if (
			strpos($input, '>') !== false
			|| strpos($input, '<') !== false
			|| strpos($input, '|') !== false
			|| strpos($input, '#') !== false
			|| strpos($input, ';') !== false
			|| strpos($input, '&') !== false
			|| strpos($input, '`') !== false
			|| strpos($input, '$') !== false
			|| strpos($input, '0x0a') !== false
			|| strpos($input, '\n') !== false
			|| strpos($input, '!') !== false
			|| strpos($input, '?') !== false
			|| strpos($input, '^') !== false
			|| strpos($input, '~') !== false
			|| strpos($input, '+') !== false
			|| strpos($input, 'sleep') !== false
			|| strpos($input, 'timeout') !== false
			|| strpos($input, '%') !== false
			|| strpos($input, "'") !== false
			|| strpos($input, 'WAITFOR DELAY') !== false
		) {
			$input = NULL;
		}
		//
		return $input;
	}
}
/**
 * validateJsonFormat
 * @author  viettd
 * @param  string $input
 * @return string sql (after escapse)
 */

if (!function_exists('validateJsonFormat')) {
	function validateJsonFormat($string = '')
	{
		if ($string === '') {
			return false;
		}
		//
		if ($string === NULL) {
			return false;
		}
		// check first chareacter
		$len 		= strlen($string);
		// {key : val}
		if ($len <= 5) {
			return false;
		}
		//
		$first_c 	= substr($string, 0, 1);
		$last_c 	= substr($string, $len - 1, 1);
		//
		if ($first_c != '{' || $last_c != '}') {
			return false;
		}
		return true;
	}
}


/**
 * validateCommandOS
 * @author  viettd
 * @param  string $input
 * @return string sql (after escapse)
 */
if (!function_exists('validateCommandOS')) {
	function validateCommandOS($input = NULL)
	{
		if (
			strpos($input, '>') !== false
			|| strpos($input, '<') !== false
			|| strpos($input, '|') !== false
			|| strpos($input, '#') !== false
			|| strpos($input, ';') !== false
			|| strpos($input, '&') !== false
			|| strpos($input, '`') !== false
			|| strpos($input, '$') !== false
			|| strpos($input, '0x0a') !== false
			|| strpos($input, '\n') !== false
			|| strpos($input, '!') !== false
			|| strpos($input, '?') !== false
			|| strpos($input, '^') !== false
			|| strpos($input, '~') !== false
			|| strpos($input, '+') !== false
			|| strpos($input, 'sleep') !== false
			|| strpos($input, 'timeout') !== false
			|| strpos($input, '%') !== false
			|| strpos($input, "'") !== false
			|| strpos($input, 'WAITFOR DELAY') !== false
		) {
			return false;
		}
		//
		return true;
	}
}
/**
 * validateCommandOSArray
 * @author  viettd
 * @param  string $input
 * @return string sql (after escapse)
 */
if (!function_exists('validateCommandOSArray')) {
	function validateCommandOSArray($array = [], $except = ['html'])
	{
		if (is_array($array) && count($array) > 0) {
			foreach ($array as $key => $input) {
				if (!in_array($key, $except)) {
					if (
						strpos($input, '>') !== false
						|| strpos($input, '<') !== false
						|| strpos($input, '|') !== false
						|| strpos($input, '#') !== false
						|| strpos($input, ';') !== false
						|| strpos($input, '&') !== false
						|| strpos($input, '`') !== false
						|| strpos($input, '$') !== false
						|| strpos($input, '0x0a') !== false
						|| strpos($input, '\n') !== false
						|| strpos($input, '!') !== false
						|| strpos($input, '?') !== false
						|| strpos($input, '^') !== false
						|| strpos($input, '~') !== false
						|| strpos($input, '+') !== false
						|| strpos($input, 'sleep') !== false
						|| strpos($input, 'timeout') !== false
						|| strpos($input, '%') !== false
						|| strpos($input, "'") !== false
						|| strpos($input, 'WAITFOR DELAY') !== false
					) {
						return false;
					}
				}
			}
		}
		//
		return true;
	}
}


/**
 * create file config
 * @author datnt
 * @created at 2020-06-25 07:46:26
 * @return void
 */
if (!function_exists('writeConfigFileAPI')) {
	function writeConfigFileAPI($mode, $company_refer, $access_token = '', $refresh_token = '', $api_office_cd = '')
	{
		$dir = config_path('mirai_api.php');
		$temp = config('mirai_api');
		$final_str = '';
		$arr_api	=	'';
		$content = '';
		if ($mode == 'ADD') {
			$arr_api = "\t\t'accessToken'=>" . "'" . $access_token . "',\n \t\t'refreshToken'=>" . "'" . $refresh_token . "',\n \t\t'api_office_cd'=>" . "'" . $api_office_cd . "',\n";
			$final_str = "\t'" . $company_refer . "'=>array(\n" . $arr_api . "\t),\n";
			$content = $final_str;
			if (file_exists($dir)) {
				foreach ($temp as $ke => $vl) {
					if ($ke != $company_refer) {
						$str = '';
						if (gettype($vl) != 'array') {
							if ($vl == '1') {
								$str .= "\t\t'" . $ke . "'=>true,\n";
							} else if ($vl == '0') {
								$str .= "\t\t'" . $ke . "'=>false,\n";
							} else {
								$str .= "\t\t'" . $ke . "'=>'" . $vl . "',\n";
							}
						} else {
							$str2 = '';
							foreach ($vl as $k => $v) {
								$str2 .= "\t\t'" . $k . "'=>'" . $v . "',\n";
							}
							$str .= "\t'" . $ke . "'=>array(\n" . $str2 . "\t" . '),' . "\n";
						}
						$final_str .= $str;
					}
				}
			}
		}
		if ($mode == 'REMOVE') {
			if (file_exists($dir)) {
				foreach ($temp as $ke => $vl) {
					if ($ke != $company_refer) {
						$str = '';
						if (gettype($vl) != 'array') {
							if ($vl == '1') {
								$str .= "\t\t'" . $ke . "'=>true,\n";
							} else if ($vl == '0') {
								$str .= "\t\t'" . $ke . "'=>false,\n";
							} else {
								$str .= "\t\t'" . $ke . "'=>'" . $vl . "',\n";
							}
						} else {
							$str2 = '';
							foreach ($vl as $k => $v) {
								$str2 .= "\t\t'" . $k . "'=>'" . $v . "',\n";
							}
							$str .= "\t'" . $ke . "'=>array(\n" . $str2 . "\t\t" . '),' . "\n";
						}
						$final_str .= $str;
					}
				}
			}
		}
		if ($mode == 'A0003P') {
			$temp[$company_refer]['api_office_cd'] = $api_office_cd;
			foreach ($temp as $ke => $vl) {
				$str = '';
				if (gettype($vl) != 'array') {
					if ($vl == '1') {
						$str .= "\t\t'" . $ke . "'=>true,\n";
					} else if ($vl == '0') {
						$str .= "\t\t'" . $ke . "'=>false,\n";
					} else {
						$str .= "\t\t'" . $ke . "'=>'" . $vl . "',\n";
					}
				} else {
					$str2 = '';
					foreach ($vl as $k => $v) {
						$str2 .= "\t\t'" . $k . "'=>'" . $v . "',\n";
					}
					$str .= "\t'" . $ke . "'=>array(\n" . $str2 . "\t" . '),' . "\n";
				}
				$final_str .= $str;
			}
		}
		//

		//
		$fp = fopen($dir, 'w');
		fwrite($fp, '<?php' . "\n" . 'return $settings = array(' . "\n" . $final_str . ');');
		fclose($fp);
		return $content;
	}
}

/**
 * deleteCacheReports
 *
 * @return Array
 */
if (!function_exists('deleteCacheReports')) {
	function deleteCacheReports($session_key = '')
	{
		$params['session_key'] = $session_key;
		return Dao::executeSql('SPC_WEEKLYREPORT_CACHE_REPORTS_ACT2', $params);
	}
}

/**
 * check M0070 Tab is used
 *
 * @param  String $tab_key
 * @return Int
 */
if (!function_exists('checkM0070TabIsUsed')) {
	function checkM0070TabIsUsed($tab_key = '', $screen = 0)
	{
		$auth = session_data();
		$params['tab_key'] = $tab_key;
		$params['user_id'] =  $auth->user_id ?? '';
		$params['company_cd'] = $auth->company_cd ?? 0;
		$params['screen'] = $screen;
		$data = Dao::executeSql('SPC_PERMISSION_M0070_TAB_CHK1', $params);
		return $data[0][0]['chk'] ?? 0;
	}
}
