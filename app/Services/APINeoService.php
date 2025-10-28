<?php

namespace App\Services;

use GuzzleHttp\Exception\ClientException;
use GuzzleHttp\Client;

class APINeoService
{
    public function __construct() {}

    /**
     * call neoAI
     * @author namnt
     * @created at 2024-10-29
     * @return \Illuminate\Http\Response
     */
    public function callNeoAI($source_lang = '', $des_lang = '', $original_text = '', $type)
    {
        $http =  new Client();
        $data['status'] = OK;
        $data['content'] = '';
        try {
            if ($original_text == '') {
                return $data;
            }
            $endpoint_key = env('NEOAI_ENPOINT_LANG_REPORT') ?? '';
            $api_key = env('NEOAI_KEY_LANG_REPORT') ?? '';
            if ($type == 4) {
                $endpoint_key = env('NEOAI_ENPOINT_LANG_COMMENT') ?? '';
                $api_key = env('NEOAI_KEY_LANG_COMMENT') ?? '';
            }
            if ($source_lang == '') {
                $source_lang = '日本語';
            }
            $content = "# 元言語\n";
            $content .= $source_lang ."\n";
            $content .= "# 翻訳先の言語\n" . $des_lang ."\n";
            if ($type == 3) {
                $content .= "# 翻訳前の週報の内容\n" . $original_text;
            } else if ($type == 4) {
                $content .= "# 翻訳前のフィードバックコメントの内容 \n" . $original_text;
            }
            $body_data = [
                "messages" => [
                    [
                        "role" => "user",
                        "content" => $content
                    ]
                ],
                "stream" => false
            ];
            $response = $http->post('https://chat.neoai.jp/api/endpoints/' . $endpoint_key . '/chat/completions', [
                'headers' => [
                    'Authorization' => 'Bearer ' . $api_key,
                    'Content-Type' => 'application/json',
                    // Thêm các header khác nếu cần
                ],
                'body' => json_encode($body_data, JSON_UNESCAPED_UNICODE),
            ]);
            $data_response =  json_decode($response->getBody(), true);

            $this->setLog('https://chat.neoai.jp/api/endpoints/' . $endpoint_key . '/chat/completions', 'POST', '200', $api_key, $original_text, $data_response['content'] ?? '', $des_lang, $source_lang, $body_data);
            $data['content'] = $data_response['content'] ?? '';
        } catch (ClientException $e) {
            $statusCode = $e->getResponse()->getStatusCode();
            $this->setLog('https://chat.neoai.jp/api/endpoints/' . $endpoint_key . '/chat/completions', 'POST', $statusCode, $api_key, $original_text, $data_response['content'] ?? '', $des_lang, $source_lang, $body_data);
            $errorBody = $e->getResponse()->getBody()->getContents() ?? '';
            $errorData = json_decode($errorBody, true);
            $data['status'] = NG;
            $data['content'] = $errorData['error']??'';
        }
        return $data;
    }

    public function setLog($link_api, $method, $status, $api_key, $original_text, $response, $des_lang, $source_lang, $body_data)
    {
        //    Logging
        $time = date("Y-m-d H:i:s");
        $debug_api = 'Original Text: ' . $original_text . PHP_EOL
            . 'Body Request: ' . json_encode($body_data, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE) . PHP_EOL
            . 'URI Api: ' . $link_api . PHP_EOL
            . 'Method: ' . $method . PHP_EOL
            . 'API Key: ' . $api_key . PHP_EOL
            . 'Status: ' . $status . PHP_EOL
            . 'Response: ' . str_replace(["\r", "\n"], '', $response) . PHP_EOL
            . 'Des Language: ' . $des_lang . PHP_EOL
            . 'Source Language: ' . $source_lang . PHP_EOL
            . '----------------------------------------';
        $time = date("Y-m-d H:i:s");
        $logFile = fopen(
            storage_path('logs' . DIRECTORY_SEPARATOR . date('Y-m-d') . '_NEOAI_API.log'),
            'a+'
        );
        // link url / method / status
        fwrite($logFile, $time . ': ' . $debug_api . PHP_EOL);
        fclose($logFile);
    }
}
