<?php

namespace App\Http\Controllers;

use Illuminate\Foundation\Bus\DispatchesJobs;
use Illuminate\Routing\Controller as BaseController;
use Illuminate\Foundation\Validation\ValidatesRequests;
use Illuminate\Foundation\Auth\Access\AuthorizesRequests;

class Controller extends BaseController
{
    use AuthorizesRequests, DispatchesJobs, ValidatesRequests;
    protected $session_data;
    protected $messages = [
        'required'    => 8, // required for other
        'accepted'    => 8, // required for checkbox
        'not_in'      => 8, // required for select
        'date'        => 9,
        'time'        => 9,
        'date_format' => 9,
        'regex'       => 9,
        'numeric'     => 9,
        'email'       => 9,
        'phone'       => 9,
        'post_code'   => 9,
    ];
    public $respon = [];
    public $rules = [];
    private $enclosure  = '"';
    private $delimiter  = ',';
    private $lineEnding = PHP_EOL;
    const FROM_ENCODING = 'ASCII,JIS,UTF-8,eucJP-win,SJIS-win,SJIS';
    const TO_ENCODING = 'UTF-8';

    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @param  string|null  $guard
     * @return mixed
     */
    public function __construct()
    {
        $this->respon['status'] = OK;
        $this->respon['errors'] = [];
        $this->respon['data_sql'] = json_encode([]);
        view()->composer('*', function ($view) {
            $view->with('_text', \App\L0020::text(false));
            $view->with('_google_key', env('GOOGLE_KEY', ''));
        });
    }

    /**
     * Tiến hành validate.
     * Nếu quá trình validate thất bại sẽ trả về lỗi ở biến $this->respon
     * Nên trong controller xử lý trước khi install vào cơ sở dữ liệu thì gọi hàm này trước, 
     * Sau đó sẽ check $this->respon['status'] ==200 thì tiến hành tiếp theo
     * @author tannq@ans-asia.com
     */
    public function valid($request)
    {
        $r = $this->validArray($request);
        $item = $r['data'];
        $rules = $r['rules'];
        $data_sql = $r['data_sql'];
        $validator =  \Validator::make($item, $rules, $this->messages);
        $result = [];
        $this->respon['errors'] = [];
        if ($validator->fails()) {
            $this->respon['status']     = NG;
            // return $validator->errors();
            foreach ($validator->errors()->getMessages() as $key => $arr) {
                foreach ($arr as $message_no) {
                    $array = explode('.', $key);
                    // dump(count($array));
                    if (count($array) > 1) {
                        $item = '.' . $array[0];
                        $value1 = $array[1];
                    } else {
                        $item = $key;
                        $value1 = 0;
                    }

                    $item = array(
                        'message_no'    => $message_no,
                        'item'          => $item,
                        'order_by'      => 0,
                        'error_typ'     => 0,
                        'value1'        => $value1,
                        'value2'        => '',
                        'remark'        => '',
                    );
                    array_push($this->respon['errors'], $item);
                }
            }
        } else {
            $this->respon['data_sql'] = $data_sql;
            $this->respon['status'] = OK;
        }

        return $this->respon;
    }
    /**
     * Khởi tạo rules nếu submit lên ở dạng mảng.
     * @author tannq@ans-asia.com
     * @return array
     */
    private function validArray($request)
    {
        $rules = $this->rules;
        $data = $request->json()->all();
        $arrayRules = $data['rules'];
        $data_sql = $data['data_sql'];
        foreach ($arrayRules as $label => $value) {
            if (is_array($value) && !empty($rules[$label])) {
                $n = ltrim($label, '.');
                unset($arrayRules[$label]);
                $arrayRules[$n] = $value;
                $r = $rules[$label];
                unset($rules[$label]);
                for ($i = 0; $i < count($value); $i++) {
                    $rules[$n . '.' . $i] = $r;
                }
            }
        }
        // JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE
        // return ['data'=>$arrayRules,'rules'=>$rules,'data_sql'=>json_encode($data['data_sql'])];
        return ['data' => $arrayRules, 'rules' => $rules, 'data_sql' => json_encode($data['data_sql'], JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_HEX_AMP | JSON_UNESCAPED_UNICODE)];
    }
    /**
     * writeHeader
     * @author longvv@ans-asia.com
     * @return array
     */
    public function writeHeader()
    {
        //$header=reset($this->data);
        $header = reset($this->data);
        $keys = array_keys($header);
        $this->writeLine($keys);
    }
    /**
     * saveCSV
     * @author longvv@ans-asia.com
     * @return array
     * @author BaoNC  update
     */
    public function saveCSV($file_name, $data, $except_header = [])
    {
        $return = "";
        try {
            if (isset($data)) {
                if (isset($data[0])) {
                    $this->data = $data[0];
                    $this->handle = fopen($file_name, 'w');
                    $BOM = "\xEF\xBB\xBF";
                    fwrite($this->handle, $BOM);
                    //write header
                    // $this->writeHeader($this->data);
                    //write file
                    //2018/11/27-sondh
                    $count = count($data[0]);
                    // \Log::info($data[0]);
                    $index = 1;
                    foreach ($data[0] as $item) {
                        // add by viettd 2020/01/10

                        if (count($except_header) > 0) {
                            foreach ($except_header as $v) {
                                unset($item[$v]);
                            }
                        }
                        // end add by viettd 2020/01/10
                        $value = array_values($item);
                        $this->writeLine($value, $index, $count);
                        //
                        $index = $index + 1;
                    }
                }
                fclose($this->handle);
                // dowload fie
                $return = basename($file_name);
            }
        } catch (Exception $e) {
            pr($e);
        }
        return $return;
    }

    /**
     * writeLine
     * @author longvv@ans-asia.com
     * @return array
     * @author BaoNC  update
     */
    public function writeLine($values = null, $index = null, $count = null)
    {
        if (is_array($values)) {
            $strCheck = array(",");

            // No leading delimiter
            $writeDelimiter = false;

            // Build the line
            $line = '';

            foreach ($values as $element) {
                // Escape enclosures
                $element = str_replace($this->enclosure, $this->enclosure . $this->enclosure, $element);
                $element = html_entity_decode($element);
                // Add delimiter
                if ($writeDelimiter) {
                    $line .= $this->delimiter;
                } else {
                    $writeDelimiter = true;
                }

                // Add enclosed string
                if (strpos($element, ',') !== false) {
                    $line .= $this->enclosure . $element . $this->enclosure;
                } else {
                    $line .=  $element;
                }
            }

            // Add line ending
            if ($index != null && $count != null && $count != $index) {
                $line .= $this->lineEnding;
            }
            // Write to file
            //            fwrite($this->handle, "\xEF\xBB\xBF");

            fwrite($this->handle, $line);
        } else {
            throw new Exception("Invalid data row passed to CSV writer.");
        }
    }

    /**
     * loadCSV
     * @return array
     * @author BaoNC  update
     */

    public function loadCSV($file)
    {
        // Create an array to hold the data
        // 
        $arrData = array();
        $files = file($file);
        foreach ($files as $key => $row) {
            $row = preg_split('/(\,(?=(?:[^"]*"[^"]*")*[^"]*\Z))/', trim($row));
            $checkarray = array();
            foreach ($row as $indexs => $value) {
                $checkarray[$indexs] =  mb_convert_encoding($value, self::TO_ENCODING, self::FROM_ENCODING);
            }
            $arrData[$key] = $checkarray;
        }

        $arrDataReturn = $this->changeValeCSV($arrData);
        return $arrDataReturn;
    }

    /**
     * changeValeCSV
     * @return array
     * @author BaoNC  update
     */

    public function changeValeCSV($arr)
    {
        $arrData = array();
        foreach ($arr as $key => $rows) {
            $arrElement = array();
            foreach ($rows as $keys => $row) {
                // Add enclosed string
                if (strpos($row, ',') !== false) {

                    $first = substr($row, 0, 1);
                    $last = substr($row, -1);
                    if ($last == '"') {
                        $row = substr($row, 1); // Remove Last  
                    }
                    if ($first == '"') {
                        $row = substr($row, 0, -1); // Remove   first
                    }
                    $line =  $row;  // Remove Last and first
                } else {
                    $line = $row;
                }
                $arrElement[$keys] =  $line;
            }
            $arrData[$key] =  $arrElement;
        }

        return $arrData;
    }
}
