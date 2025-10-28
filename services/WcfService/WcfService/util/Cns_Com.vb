''' 機能概要*****************************************************************************************************
''' <summary>
''' 定数
''' </summary>
''' <remarks></remarks>
''' 
''' 作成者  ：山下 2012.12.10
''' 
''' *************************************************************************************************************
Public Class Cns_Com
    'M911
    Public Shared D_DAT As DataSet = Nothing
    '
    Public Const C_M911_KEY_BAK_IMG_TYP As String = "BAK_IMG_TYP"
    Public Const C_M911_KEY_MNU_IMG_TYP As String = "MNU_IMG_TYP"
    'S101
    Public Const C_S101_KEY_IMG_MAX_SIZ As String = "008"
    '
    Public Shared C_refer_out_hire_typ As Boolean = False ' refer from M021A if = false disalble label out_hire_typ 
    Public Shared C_out_hire_typ As Integer = Nothing
    Public Shared C_program_id_frm As String = Nothing
    '
    Public Shared C_DGD_HED_HGT As Integer = 26                                 '行の高さ
    Public Shared C_DGD_ROW_HGT As Integer = 21                                 '行の高さ
    Public Shared C_DGD_FNT_NAM As String = "ＭＳ ゴシック"                     'データグリッド行のフォント名設定
    Public Shared C_DGD_FNT_SIZ As Double = 9.75                                'データグリッド行のフォントpt設定
    '
    '処理モードメッセージ
    Public Shared C_MOD_ADD_MSG As String = "新規"
    Public Shared C_MOD_UPD_MSG As String = "修正"
    Public Shared C_MOD_DEL_MSG As String = "削除"
    Public Shared C_MOD_REF_MSG As String = "参照"
    Public Shared C_MOD_FND_MSG As String = "検索"
    Public Shared C_MOD_RPT_MSG As String = "出力"
    Public Shared C_MOD_MNU_MSG As String = "処理を選択して下さい"
    Public Shared C_MOD_BAC_MSG As String = "更新"
    Public Shared C_MOD_INQ_MSG As String = "問合"
    Public Shared C_MOD_ADD_UPD_MSG As String = "新規／修正"
    Public Shared C_MOD_CPY_MSG As String = "複写"
    Public Shared C_MOD_SUM_MSG As String = "計上"
    Public Shared C_MOD_CRE_MSG As String = "作成"
    Public Shared C_MOD_PRV_MSG As String = "前"
    Public Shared C_MOD_NXT_MSG As String = "次"
    Public Shared C_MOD_EXE_MSG As String = "登録"
    Public Shared C_MOD_LST_MSG As String = "一覧"
    Public Shared C_MOD_BCK_MSG As String = "戻る"
    Public Shared C_MOD_END_MSG As String = "終了"
    Public Shared C_MOD_CLR_MSG As String = "クリア"
    Public Shared C_MOD_CSV_MSG As String = "CSV"
    Public Shared C_MOD_XLS_MSG As String = "EXCEL"
    Public Shared C_MOD_PDF_MSG As String = "PDF"
    Public Shared C_MOD_SEL_MSG As String = "選択"
    Public Shared C_MOD_RSL_MSG As String = "結果"


    'メッセージ
    Public Shared C_MSG_SRC_WIT As String = "暫くお待ち下さい"                      '処理中
    Public Shared C_MSG_SRC_RST As String = "結果件数："                            '検索結果
    Public Shared C_MSG_SRC_NOT As String = "該当情報がありませんでした"            '該当データなし
    Public Shared C_MSG_SRC_NUT As String = "以下に検索結果を表示します"            '検索待受
    Public Shared C_MSG_MST_INP As String = "入力してください"                      '必修項目入力要請
    Public Shared C_MSG_MST_SEL As String = "選択してください"                      '必修項目選択要請
    Public Shared C_MSG_DEL_APT As String = "削除してよろしいですか"                '削除処理実行確認
    Public Shared C_MSG_CCL_APT As String = "ｷｬﾝｾﾙしてよろしいですか"               'キャンセル処理実行確認
    Public Shared C_MSG_BAC_APT As String = "更新してよろしいですか"                '更新処理実行確認
    Public Shared C_MSG_ADD_APT As String = "登録してよろしいですか"                '登録処理実行確認
    Public Shared C_MSG_PRT_APT As String = "印刷してよろしいですか"                '印刷処理実行確認
    Public Shared C_MSG_END_APT As String = "編集中の値は破棄されますが、よろしいですか？" '終了処理実行確認
    Public Shared C_MSG_CMD_CPT As String = "正常に終了しました"                    '処理正常終了
    Public Shared C_MSG_ERR_TTL As String = "以下、入力値を見直してください"        'エラーリストタイトル
    Public Shared C_MSG_MST_TTL As String = "年月日Fromが年月日Toより大きくなっています"
    Public Shared C_MSG_MST_TTL_OLD As String = "前月年月日Fromが前月年月日Toより大きくなっています"
    Public Shared C_MSG_MST_CHK_MON_FRO As String = "年月日Fromが前月年月日Fromより1ヶ月前でなければなりません。"
    Public Shared C_MSG_MST_CHK_MON_TO As String = "年月日Toが前月年月日Toより1ヶ月前でなければなりません。"
    Public Shared C_MSG_ERR_FMT As String = "入力形式が正しくありません"            '
    Public Shared C_MSG_ERR_INP As String = "入力値が不正です"                      '
    Public Shared C_MSG_KEY_DEF As String = "呼出キーと更新キーが異なります"        'キー値アンマッチ
    Public Shared C_MSG_NOT_LST As String = "この項目は参照出来ません"              '非項目参照警告
    Public Shared C_MSG_NOT_OUT_DAT As String = "出力対象データがありませんでした"  '出力対象データ無し
    Public Shared C_MSG_END_OUT As String = "正常に出力されました"                  '出力終了メッセージ
    Public Shared C_MSG_KOU_DBL As String = "項目が重複指定されています"            '重複指定エラー
    Public Shared C_MSG_SCR_CAL As String = "画面呼出中"                            '画面呼出中
    Public Shared C_MSG_OUT_DAT As String = "出力データ抽出中"                      '
    Public Shared C_MSG_FND_DAT As String = "検索データ抽出中"                      '
    Public Shared C_MSG_OUT_CSV As String = "CSVファイル作成中"                     '
    Public Shared C_MSG_OUT_PDF As String = "PDFファイル作成中"                     '
    Public Shared C_MSG_OUT_PDF_EXT As String = "分割PDFファイル作成中"             '
    Public Shared C_MSG_OUT_XLS As String = "EXCELファイル作成中"                   '
    Public Shared C_MSG_FIL_SAV As String = "上記に保存致しました。"                '
    Public Shared C_MSG_OUT_RPT As String = "印刷準備中"                            '
    Public Shared C_MSG_OUT_PRV As String = "プレビュー準備中"                      '
    Public Shared C_MSG_OUT_EXC As String = "印刷中"                                '
    Public Shared C_MSG_OTH_001 As String = "更新"
    Public Shared C_MSG_OTH_002 As String = "確認"
    Public Shared C_MSG_OTH_003 As String = "エラー"
    Public Shared C_MSG_MNU_NOT As String = "メニュー構成情報が存在しません"
    Public Shared C_MSG_MNU_001 As String = "メニュー"
    Public Shared C_MSG_MRS_NOT As String = "最低でも一行は入力して下さい"          '
    Public Shared C_MSG_MST_REC As String = " より大きくなっています"                ' %1が%2より大きくなっています
    Public Shared C_MSG_OUT_STT As String = "ス  テ  ー  タ  ス"
    Public Shared C_MSG_OUT_CCL As String = "処理が中断されました"
    Public Shared C_MSG_OUT_NOT As String = "対象データが存在しない為、キャンセルされました"
    Public Shared C_MSG_MRS_CHO As String = "選択してください。"          '
    Public Shared C_MSG_SET_DAT As String = "一括変更しますか？" '
    Public Shared C_MSG_SAV_DAT As String = "登録しますか？" '
    Public Shared C_MSG_DEL_DAT As String = "選択した請求先締更新を解除解除しますか？" '


    '格納フォルダー
    Public Shared C_DIR_FND As String = "_▼Parameter\Find"
    Public Shared C_DIR_RPT As String = "_▼Parameter\Report"
    Public Shared C_DIR_INP As String = "_▼Parameter\Input"
    Public Shared C_DIR_CSV As String = "_▼Work\Csv"
    Public Shared C_DIR_XLS As String = "_▼Work\Excel"

    '拡張子
    Public Shared C_FIL_PRM_EXN As String = ".ini" 'パラメーターファイル
    Public Shared C_FIL_CSV_EXN As String = ".csv" 'CSVファイル
    Public Shared C_FIL_XLS_EXN As String = ".xlsx" 'EXCEL(2007)ファイル
    Public Shared C_FIL_PDF_EXN As String = ".pdf" 'PDFﾀﾞﾝﾛｰﾄﾞﾌｧｲﾙ

    '更新ステータスライン
    Public Shared C_BAC_LIN_SRT As String = "【開  始】□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□" '
    Public Shared C_BAC_LIN_END As String = vbCrLf & "【終  了】□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□□" '
    Public Shared C_BAC_LIN_ERR As String = "《 E r r o r ! ! 》" '
    Public Shared C_BAC_LIN_IFO As String = "--------------------------------------------------------------------------------------------------------------------------" '

    '項目名
    Public Shared C_office_cd As String = "営業所CD"
    Public Shared C_user_cd As String = "ユーザーCD"
    Public Shared C_name_cd As String = "名称CD"
    Public Shared C_delivery_cd As String = "納入先CD"
    Public Shared C_zip As String = "郵便番号"
    Public Shared C_shipper_cd As String = "荷主CD"
    Public Shared C_car_cd As String = "車両CD"
    Public Shared C_shipper_nm As String = "取引先名漢字"
    Public Shared C_cust_cd As String = "取引先CD"
    Public Shared C_hire_cd As String = "傭車先CD"
    Public Shared C_hire_nm As String = "傭車先"
    Public Shared C_billing_cd As String = "請求先CD"
    Public Shared C_billing_nm As String = "請求先"
    Public Shared C_carcd As Integer = 0
    Public Shared C_rcvcd As Integer = 0


    ' Public Shared C_ym As String = "郵便番号"

    'プリンター
    Public Shared C_PRT_LST_NM As String = "プリンター情報一覧"

    '帳票
    Public Shared C_RPT_MGN_TOP As Single = 0.59 '1.5cm
    Public Shared C_RPT_MGN_BTM As Single = 0.0
    Public Shared C_RPT_MGN_LFT As Single = 0.57
    Public Shared C_RPT_MGN_RIT As Single = 0.0
    Public Shared C_DELIMITER As String = "|#|@"

End Class
