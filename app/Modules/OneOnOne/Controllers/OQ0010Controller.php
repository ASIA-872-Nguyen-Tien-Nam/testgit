<?php

namespace App\Modules\OneOnOne\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Services\FileUploadService;

class OQ0010Controller extends Controller
{
    protected $fileUploadService;

    public function __construct(FileUploadService $fileUploadService)
    {
        parent::__construct();
        $this->fileUploadService = $fileUploadService;
    }
    /**
     * Show the application index.
     * @author mail@ans-asia.com 
     * @created at 2020-11-04 08:03:05
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        $data['category'] = trans('messages.viewing_videos');
        $data['category_icon'] = 'fa fa-play';
        $data['title'] = trans('messages.1on1_commentary');
        $params['company_cd'] = session_data()->company_cd;
        $params['employee_cd'] = session_data()->employee_cd;
        $params['1on1_authority_typ'] = session_data('1on1_authority_typ');
        $params['1on1_authority_cd'] = session_data('1on1_authority_cd');
        $params['refer_kbn'] = session_data()->company_cd == 0 ? '1' : '2';
        $res = $this->fileUploadService->getFile($params['company_cd'], $params['employee_cd'], $params['1on1_authority_typ'], $params['1on1_authority_cd'], $params['refer_kbn']);
        if (isset($res[0][0]['error_typ']) && $res[0][0]['error_typ'] == '999') {
            return response()->view('errors.query', [], 501);
        }
        $data['file_video'] = $res[1] ?? [];
        $data['file_text'] = $res[2] ?? [];
        return view('OneOnOne::oq0010.index', array_merge($data, $res));
    }
}
