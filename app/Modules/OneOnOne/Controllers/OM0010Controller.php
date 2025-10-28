<?php

namespace App\Modules\OneOnOne\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Helpers\UploadCore;
use App\Services\FileUploadService;

class OM0010Controller extends Controller
{
    protected $fileUploadService;

    public function __construct(FileUploadService $fileUploadService)
    {
        parent::__construct();
        $this->fileUploadService = $fileUploadService;
    }
    /**
     * Show the application index.
     * @param $request
     *
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        $data['category'] = trans('messages.video_list');
        $data['category_icon'] = 'fa fa-play';
        $data['title'] = trans('messages.file_upload');
        // contract_company_attribute = 1 is Mirac
        $data['contract_company_attribute'] = session_data()->contract_company_attribute ?? 0;   // add by viettd 2021/06/10
        $refer =  $this->postRefer($request);
        return view('OneOnOne::om0010.index', array_merge($data, $refer));
    }
    /**
     * get List file
     * @param $request
     *
     * @return \Illuminate\Http\Response
     */
    public function postRefer(Request $request)
    {
        $company_cd                 = session_data()->company_cd;
        $data_service               = $this->fileUploadService->getFile($company_cd);
        if ((isset($data_service[0][0]['error_typ']) && $data_service[0][0]['error_typ'] == '999')) {
            return response()->view('errors.query', [], 501);
        }
        $data['data_file']          = $data_service[0] ?? [];
        foreach ($data['data_file'] as $key => $file_mp4) {
            $file_mp4['company_cd'] =  $file_mp4['refer_kbn'] == 1 ? 0 : session_data()->company_cd;
            $path_to_file = 'uploads/om0010/' . $file_mp4['company_cd'] . '/' . $file_mp4['file_cd'] . '.' . $file_mp4['character_end'];
            $pos = file_exists($path_to_file);
            if ($pos !== false) {
                $filesize = filesize($path_to_file);
                if ($filesize >= 1073741824) {
                    $filesize = ceil($filesize / 1073741824) . ' GB';
                } elseif ($filesize >= 1048576) {
                    $filesize = ceil($filesize / 1048576) . ' MB';
                } elseif ($filesize >= 1024) {
                    $filesize = ceil($filesize / 1024) . ' KB';
                } elseif ($filesize > 1) {
                    $filesize = $filesize . ' bytes';
                } elseif ($filesize == 1) {
                    $filesize = $filesize . ' byte';
                } else {
                    $filesize = '0 bytes';
                }
                $data['data_file'][$key]['filesize'] = $filesize;
            }
        }
        $data['active'] = getCombobox('30', 0) ?? [];
        if ($request->ajax()) {
            return view('OneOnOne::om0010.refer', $data);
            //return request ajax
        } else {
            return $data;
        }
    }

    /**
     * Save information
     * @param $request
     *
     * @return \Illuminate\Http\Response
     */
    public function postSave(Request $request)
    {
        if ($request->ajax()) {
            try {
                $this->respon['status'] = OK;
                $this->respon['errors'] = [];
                $head = $request->head;
                $param = json_decode($head, true)['data_sql'];
                $rules = [
                    'refer_kbn'         => 'int',
                    'file_cd'             => 'int',
                    'admin_use_typ'     => 'int',
                    'coach_use_typ'     => 'int',
                    'member_use_typ'     => 'int',
                ];
                $validator = \Validator::make($param, $rules);
                if ($validator->fails()) {
                    return response()->view('errors.query', [], 501);
                } else {
                    $mode   = 'SAVE';
                    $res    =  $this->fileUploadService->saveFile($param, $mode, '');
                    // check exception
                    if (isset($res[0][0]) && $res[0][0]['error_typ'] == '999') {
                        return response()->view('errors.query', [], 501);
                    } else if (isset($res[0]) && !empty($res[0])) {
                        $this->respon['status'] = NG;
                        foreach ($res[0] as $temp) {
                            array_push($this->respon['errors'], $temp);
                        }
                    }
                }
            } catch (\Exception $e) {
                $this->respon['status']     = EX;
                $this->respon['Exception']  = $e->getMessage();
            }
            return response()->json($this->respon);
        }
    }
    /**
     * Delete information
     * @param $request
     *
     * @return \Illuminate\Http\Response
     */
    public function postDelete(Request $request)
    {
        if ($request->ajax()) {
            try {
                $this->respon['status'] = OK;
                $this->respon['errors'] = [];
                $rules = [
                    'refer_kbn'             => 'int',
                    'file_cd'                 => 'int',
                ];
                $validator = \Validator::make($request->all(), $rules);
                if ($validator->fails()) {
                    return response()->view('errors.query', [], 501);
                } else {
                    $refer_kbn =    $request->refer_kbn ?? 0;
                    $file_cd   =    $request->file_cd ?? 0;
                    $result    =    $this->fileUploadService->deleteFile($refer_kbn, $file_cd);
                    // check exception
                    if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                        return response()->view('errors.query', [], 501);
                    } else if (isset($result[0]) && !empty($result[0])) {
                        $this->respon['status'] = NG;
                        foreach ($result[0] as $temp) {
                            array_push($this->respon['errors'], $temp);
                        }
                    }
                }
            } catch (\Exception $e) {
                $this->respon['status']     = EX;
                $this->respon['Exception']  = $e->getMessage();
            }
            return response()->json($this->respon);
        }
    }

    /**
     * postUploadVideo
     * @param $request
     *
     * @return \Illuminate\Http\Response
     */
    public function postUpload(Request $request)
    {
        try {
            $wfio = '';
            $company_cd  = session_data()->company_cd;
            $company_contract_attr = session_data()->contract_company_attribute;
            if ($company_contract_attr == 1) {
                $company_cd = 0;
            }
            $last_step = $request->last_step ?? 0;
            $extension_loaded = get_loaded_extensions();
            if (in_array('wfio', $extension_loaded)) {
                $wfio = 'wfio://';
            }
            $file       = $request->except('_token')['file'];
            $ext        = $request->extention ?? '';
            $filename   = $request->file_name ?? 'abc';

            $destination_path = public_path("/uploads/om0010/$company_cd");  // Determine the name of the uploaded file
            $uploadPath = '/uploads/om0010/' . $company_cd . '/' . $filename;
            // When the first upload does not have a file, the file is created, and then the upload only needs to append the data to the file.
            if (!file_exists($destination_path . '/' . $filename)) {
                $file->move($wfio . $destination_path, $filename);
            } else {
                file_put_contents($destination_path . '/' . $filename, file_get_contents($file), FILE_APPEND);
            }
            if ($last_step == 1) {
                $head = $request->head;
                $param = json_decode($head, true)['data_sql'];
                $this->respon['status'] = OK;
                $this->respon['errors'] = [];
                $rules = [
                    'refer_kbn'         => 'int',
                    'file_cd'             => 'int',
                    'admin_use_typ'     => 'int',
                    'coach_use_typ'     => 'int',
                    'member_use_typ'     => 'int',
                ];
                $validator = \Validator::make($param, $rules);
                if ($validator->fails()) {
                    return response()->view('errors.query', [], 501);
                } else {
                    $this->respon =  $this->renameFile($param, $filename, $uploadPath, $ext);
                }
            }
        } catch (\Exception $e) {
            $this->respon['status']     = EX;
            $this->respon['Exception']  = $e->getMessage();
        }
        return response()->json($this->respon);
    }

    /**
     * rename file after upload
     * @param array $param
     * @param string $upload_file_name
     * @param string $uploadPath
     * @param string $ext
     *
     * @return \Illuminate\Http\Response
     */
    public function renameFile($param = [], $upload_file_name = '', $uploadPath  = '', $ext = '')
    {
        try {
            $mode = 'UPLOAD';
            $company_cd  = session_data()->company_cd;
            $company_contract_attr = session_data()->contract_company_attribute;
            if ($company_contract_attr == 1) {
                $company_cd = 0;
            }
            $result =  $this->fileUploadService->saveFile($param, $mode, $upload_file_name);
            if (isset($result[0][0]) && $result[0][0]['error_typ'] == '999') {
                if ($uploadPath != '') {
                    unlink(public_path($uploadPath));
                }
                $this->respon['status'] = '501';
                $this->respon['errors'] = $result[0][0];
            } else if (isset($result[0]) && !empty($result[0])) {
                if ($uploadPath != '') {
                    unlink(public_path($uploadPath));
                }
                $this->respon['status'] = NG;
                foreach ($result[0] as $temp) {
                    array_push($this->respon['errors'], $temp);
                }
            } else {
                $file_nm = $result[1][0]['file_cd'] . '.' . $ext;
                rename(public_path($uploadPath), public_path("uploads/om0010/$company_cd/$file_nm"));
                $this->respon['status']     = OK;
            }
        } catch (\Exception $e) {
            $this->respon['status']     = EX;
            $this->respon['Exception']  = $e->getMessage();
        }
        return $this->respon;
    }
}
