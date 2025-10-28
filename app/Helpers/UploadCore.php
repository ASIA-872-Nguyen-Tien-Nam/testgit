<?php
/**
 ****************************************************************************
 * UNITE_MEDICAL
 * Helper
 *
 *  @author <tannq@ans-asia.com>
 * @created at 2017-08-10 07:45:06
 *
 * 更新日/update date 			:
 * 更新者/updater				:
 * 更新内容	/update content		:
 *
 * @package    	 				: 	Helper
 * @copyright   				: 	Copyright (c) ANS-ASIA
 * @version						: 	1.0.0
 * **************************************************************************
 */
namespace App\Helpers;
use Carbon\Carbon;
use File;
use Exception;

class UploadCore
{
    /**
     * [$upload description]
     * @var [type]
     */
    protected static $core;

    /**
     * [callUpload description]
     * @return [type] [description]
     */
    public static function call()
    {
        if (self::$core == null) {
            self::$core = new UploadCore();
        }
        return self::$core;
    }

    /**
     * [doUpload description]
     * @return [type] [description]
     */
    public static function start($request)
    {
        $dataRequest     = $request->except('_token');
        if(isset($request['rules'])){
            $defaultRules    = $request['rules'];
        }else{
            $defaultRules    = config('filesystems.options.rules');
        }
        if(isset($request['folder'])){
            $folder    = $request['folder'];
        }else{
            $folder    = config('filesystems.options.folder');
        }
        if(isset($request['rename_upload'])){
            $rename_upload    = $request['rename_upload'];
        }else{
            $rename_upload    = config('filesystems.options.rename_upload');
        }
        // $folder          = config('filesystems.options.folder');
        // $rename_upload   = config('filesystems.options.rename_upload');
        $folder          = $folder ? "/{$folder}" : null;
        $array           = [];
        $array['errors'] = NULL;
        $array['status'] = 200;
        // Date now
        // Upload to server
        if(config('filesystems.default')=='ans')
        {
            // return self::uploadApi($dataRequest);
        }
        $wfio = '';
        $extension_loaded = get_loaded_extensions();
        if(in_array('wfio', $extension_loaded)){
            $wfio = 'wfio://';
        }
        $date = Carbon::now()->format('Ymd');
        // return $wfio.public_path("uploads/{$date}");
        try
        {
            if(File::exists($wfio.public_path("uploads{$folder}")))
            {
                File::makeDirectory($wfio.public_path("uploads{$folder}"),'0755',true,true);
            }
            // if(File::exists($wfio.public_path("uploads/{$date}")))
            // {
            //     File::makeDirectory($wfio.public_path("uploads/{$date}"),'0755',true,true);
            // }

            // if(File::exists($wfio.public_path("uploads/{$date}{$folder}")))
            // {
            //     File::makeDirectory($wfio.public_path("uploads/{$date}{$folder}"),'0755',true,true);
            // }

            // Destination path
            $destination_path       =public_path("uploads{$folder}");

            // data response
            // Upload to local
            foreach($dataRequest as $input=>$content)
            {
                // check request type file
                // if file size > 2m then $request->hasFile only return null, you can setting php.ini change value upload_max_filesize
                if($request->hasFile($input) || File::isFile($request->input($input)))
                {
                    $file  = $request->file($input) ?? $request->input($input);

                    // check validate
                    $validator = \Validator::make([$input=>$file], [$input=>$defaultRules]);
                    
                    // if validate fails return error
                    if($validator->fails())
                    {
                        $array[$input] = [
                            'errors'   =>$validator->errors()->all(),
                            'status'   =>405,
                            'url'      =>NULL,
                            'mimeType' =>$file->getmimeType(),
                            'path'     =>NULL,
                            'name'     =>$file->getClientOriginalName(),
                        ];
                    } else {
                        // get extension file : png,jpg,....
                        $ex             = $file->getClientOriginalExtension();

                        // get client file name
                        $clientName     = $file->getClientOriginalName();

                        // get client file name
                        $getmimeType    = $file->getmimeType();

                        // trim extension
                        // $fileName       = rtrim($clientName,'.'.$ex);

                        // replace Special characters with "-"
                        // $fileName       = str_slug($fileName,'-');
                        // $fileName       = $fileName.'.'.$ex;
                        // $fileName = UploadCore::array_utf8_encode($fileName);
                        // $fileName       = mb_convert_encoding($fileName,"SJIS-win", "auto");
                        // Upload success and move file to destination path
                        $rename_upload = $rename_upload ? mb_strtolower($rename_upload.'.'.$ex) : mb_strtolower($clientName);
                        // var_dump($rename_upload);
                        // var_dump($wfio.$destination_path);
                        $upload_success = $file->move($wfio.$destination_path, $rename_upload);
                       // var_dump($upload_success);
                        $array[$input] = [
                            'errors'   =>null,
                            'status'   =>200,
                            'url'      => url("uploads{$folder}/{$rename_upload}"),
                            'mimeType' =>$getmimeType,
                            'path'     =>"/uploads{$folder}/{$rename_upload}",
                            'name'     =>$rename_upload,
                        ];

                    }
                }
            }
        } catch (\Exception $e) {
            $array['errors'] = $e->getMessage();
            $array['status'] = 500;
        }
        return $array;
    }
    /**
     * [doUpload description]
     * @return [type] [description]
     */
    public static function pdfToImg($request)
    {

        $dataRequest     = $request->except('_token');
        if(isset($request['rules'])){
            $defaultRules    = $request['rules'];
        }else{
            $defaultRules    = config('filesystems.options.rules');
        }
        if(isset($request['folder'])){
            $folder    = $request['folder'];
        }else{
            $folder    = config('filesystems.options.folder');
        }
        if(isset($request['rename_upload'])){
            $rename_upload    = $request['rename_upload'];
        }else{
            $rename_upload    = config('filesystems.options.rename_upload');
        }
        // $folder          = config('filesystems.options.folder');
        // $rename_upload   = config('filesystems.options.rename_upload');
        $folder          = $folder ? "/{$folder}" : null;
        $array           = [];
        $array['errors'] = NULL;
        $array['status'] = 200;
        // Date now
        // Upload to server
        if(config('filesystems.default')=='ans')
        {
            // return self::uploadApi($dataRequest);
        }
        $wfio = '';
        $extension_loaded = get_loaded_extensions();
        if(in_array('wfio', $extension_loaded)){
            $wfio = 'wfio://';
        }
        $date = Carbon::now()->format('Ymd');
        // return $wfio.public_path("uploads/{$date}");
        try
        {
            if(File::exists($wfio.public_path("uploads{$folder}")))
            {
                File::makeDirectory($wfio.public_path("uploads{$folder}"),'0755',true,true);
            }
            // if(File::exists($wfio.public_path("uploads/{$date}")))
            // {
            //     File::makeDirectory($wfio.public_path("uploads/{$date}"),'0755',true,true);
            // }

            // if(File::exists($wfio.public_path("uploads/{$date}{$folder}")))
            // {
            //     File::makeDirectory($wfio.public_path("uploads/{$date}{$folder}"),'0755',true,true);
            // }

            // Destination path
            $destination_path       =public_path("uploads{$folder}");

            // data response
            // Upload to local
            foreach($dataRequest as $input=>$content)
            {
                // check request type file
                // if file size > 2m then $request->hasFile only return null, you can setting php.ini change value upload_max_filesize
                if($request->hasFile($input) || File::isFile($request->input($input)))
                {

                    $file  = $request->file($input) ?? $request->input($input);

                    // check validate
                    $validator = \Validator::make([$input=>$file], [$input=>$defaultRules]);
                    
                    // if validate fails return error
                    if($validator->fails())
                    {
                        $array[$input] = [
                            'errors'   =>$validator->errors()->all(),
                            'status'   =>405,
                            'url'      =>NULL,
                            'mimeType' =>$file->getmimeType(),
                            'path'     =>NULL,
                            'name'     =>$file->getClientOriginalName(),
                        ];
                    } else {
                        // get extension file : png,jpg,....
                        $ex             = $file->getClientOriginalExtension();

                        // get client file name
                        $clientName     = $file->getClientOriginalName();

                        // get client file name
                        $getmimeType    = $file->getmimeType();

                        // trim extension
                        // $fileName       = rtrim($clientName,'.'.$ex);

                        // replace Special characters with "-"
                        // $fileName       = str_slug($fileName,'-');
                        // $fileName       = $fileName.'.'.$ex;
                        // $fileName = UploadCore::array_utf8_encode($fileName);
                        // $fileName       = mb_convert_encoding($fileName,"SJIS-win", "auto");
                        // Upload success and move file to destination path
                        $rename_upload = $rename_upload ? mb_strtolower($rename_upload.'.'.$ex) : mb_strtolower($clientName);
                        // var_dump($rename_upload);
                        // var_dump($wfio.$destination_path);
                        $upload_success = $file->move($wfio.$destination_path, $rename_upload);
                       // var_dump($upload_success);
                        
                    $rename_upload_img = str_replace('.pdf','',$rename_upload);
                    $pdfFilePath =public_path("/uploads{$folder}/{$rename_upload}");
                    $outputPath = public_path("/uploads{$folder}/{$rename_upload_img}.jpg");

                    $cmd = "gs -dNOPAUSE -sDEVICE=jpeg -r300 -sOutputFile=$outputPath $pdfFilePath -dBATCH";
                    exec($cmd, $output, $return_var);
                    $array[$input] = [
                        'errors'   =>null,
                        'status'   =>200,
                        'url'      => url("uploads{$folder}/{$rename_upload}"),
                        'mimeType' =>$getmimeType,
                        'path'     =>"/uploads{$folder}/{$rename_upload}",
                        'name'     =>$rename_upload,
                        'image'     =>$output,
                    ];

                    }
                }
            }
        } catch (\Exception $e) {
            $array['errors'] = $e->getMessage();
            $array['status'] = 500;
        }
        return $array;
    }
    /**
     * Upload to server
     * @param  [type] $dataRequest [description]
     * @return [type]              [description]
     */
    public static function uploadApi($dataRequest)
    {
        $defaultRules = config('filesystems.options.rules');
        $folder = config('filesystems.options.folder');
        $folder = $folder ? $folder : '';
        $multipart    = [];
        foreach($dataRequest as $input=>$content)
        {
            if(request()->hasFile($input))
            {
                $file  = request()->file($input);
                $image_path = $file->getPathname();
                $image_mime = $file->getmimeType();
                $image_org  = $file->getClientOriginalName();

                $multipart[] = [
                    'name'     => $input,
                    'filename' => $image_org,
                    'Mime-Type'=> $image_mime,
                    'contents' => fopen( $image_path, 'r' ),
                ];
            }
        }

        try {

            $client = app('api.client');

            $res = $client->request('POST', config('filesystems.disks.ans.driver'),[
                // 'debug' => true,
                'verify' => false,
                // 'auth' => ['admin@admin.com', '123'],
                'multipart' => $multipart,
                'query'=>[
                    'folder'=>$folder,
                ]

            ]);
            $json = json_decode($res->getBody());
            return $json;
        } catch (Exception $e) {
            // If there are network errors, we need to ensure the application doesn't crash.
            // if $e->hasResponse is not null we can attempt to get the message
            // Otherwise, we'll just pass a network unavailable message.

            //PostTooLargeException
            if ($e instanceof \Illuminate\Http\Exceptions\PostTooLargeException)
            {
                return (['errors'=>$e->getMessage(),'status'=>$e->getCode()]);
                // return response()->json(['errors'=>$err->getReasonPhrase(),'status'=>$e->getCode()],$e->getCode());
            }
            if ($e->hasResponse()) {
                $err = $e->getResponse();
                // response 500
                if ($e instanceof \GuzzleHttp\Exception\ServerException)
                {
                    return ['errors'=>1];
                    return (['errors'=>$err->getReasonPhrase(),'status'=>$e->getCode()]);
                    // return response()->json(['errors'=>$err->getReasonPhrase(),'status'=>$e->getCode()],$e->getCode());
                }

                // response ClientException
                if ($e instanceof \GuzzleHttp\Exception\ClientException )
                {
                    return (['errors'=>$err->getReasonPhrase(),'status'=>$e->getCode()]);
                    // return response()->json(['errors'=>$err->getReasonPhrase(),'status'=>$e->getCode()],$e->getCode());
                }

                //BadResponseException
                if ($e instanceof \GuzzleHttp\Exception\BadResponseException )
                {
                    return (['errors'=>$err->getReasonPhrase(),'status'=>$e->getCode()]);
                    // return response()->json(['errors'=>$err->getReasonPhrase(),'status'=>$e->getCode()],$e->getCode());
                }


            }
            return (['errors'=>$e->getMessage(),'status'=>$e->getCode()]);
            // return response()->json(['errors'=>$e->getMessage(),'status'=>$e->getCode()],$e->getCode());
        }
    }

    public static function array_utf8_encode($dat)
    {
        if (is_string($dat))
            return utf8_encode($dat);
        if (!is_array($dat))
            return $dat;
        $ret = array();
        foreach ($dat as $i => $d)
            $ret[$i] = self::array_utf8_encode($d);
        return $ret;
    }
}