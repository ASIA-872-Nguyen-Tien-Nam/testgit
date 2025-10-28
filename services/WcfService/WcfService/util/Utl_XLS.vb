'機能概要********************************************************************************************
'*
'*  処理概要：Excel / CSV作成
'*
'*  作成日  ：2012/06/01
'*  作成者  ：ANS 金子 雄輔
'*
'*  更新日  ：
'*  更新者  ：
'*  更新内容：
'*
'****************************************************************************************************

'****************************************************************************************************
'*  インポート
'****************************************************************************************************
Imports System.IO
Imports System.IO.Path

'****************************************************************************************************
'*  クラス
'****************************************************************************************************
Public Class Utl_XLS

#Region "■Common Value■"

    '************************************************************************************************
    '*  メンバ変数
    '************************************************************************************************
    Private P_LMT As Integer = Nothing     '挿入可能最大行数
    Private P_MSG As String = Nothing      'メッセージ
    Private P_DIR As String = Nothing      'Excel / CSVを作成するディレクトリまでのパス
    Private P_PTH As String = Nothing      '作成したExcel / CSVまでのパス
    Private D_UTL_RDB As Utl_RDB = Nothing 'データベースクラス

#End Region

#Region "■Constructor■"

    '************************************************************************************************
    '*
    '*  概要：コンストラクタ
    '*
    '*  引数：なし
    '*
    '************************************************************************************************
    ''' <summary>
    ''' コンストラクタ
    ''' </summary>
    ''' <remarks></remarks>
    Public Sub New()
        Try
            P_LMT = 65536 'Excel2003での最大行数
            P_MSG = ""
            P_PTH = ""
            P_DIR = ConfigurationManager.AppSettings("FIL_SAV_PTH")
            'P_DIRの末尾を"\"に
            If Not P_DIR.Substring(P_DIR.Length - 1, 1).Equals("\") Then
                P_DIR &= "\"
            End If
            'P_DIRが存在しない場合は作成
            If Not Directory.Exists(P_DIR) Then
                Directory.CreateDirectory(P_DIR)
            End If
            'データベース接続
            D_UTL_RDB = New Utl_RDB()
            '
        Catch ex As Exception
            Call Utl_ERR.FNC_ERR_RTN(ex)
        End Try
        '
EXIT_SUB:
        Exit Sub
    End Sub

#End Region

#Region "■User Function■"

    ''' <summary>
    ''' データ取得
    ''' </summary>
    ''' <param name="P1">ダウンロードタイプ xls:Excel / csv:CSV</param>
    ''' <param name="P2">SQL 文</param>
    ''' <param name="OP1">ヘッダーの有無 true:あり / false:なし [デフォルト：True]</param>
    ''' <returns>True:作成成功 / False:作成失敗</returns>
    ''' <remarks></remarks>
    Public Function FNC_GET_DAT( _
        ByVal P1 As String, _
        ByVal P2 As String, _
        Optional ByVal OP1 As Boolean = True _
    ) As Boolean
        Dim D_RTN As Boolean = False   '戻り値
        Dim D_SQL As String = Nothing  'SQL文
        Dim D_DAT As DataSet = Nothing 'SQL実行結果取得用
        Dim D_CNT As Integer = Nothing 'レコード数取得
        '
        Try
            '引数調整
            If IsNothing(P1) OrElse P1.Equals("") Then
                'データ取得対象無し
                P1 = "xls"
            End If
            P1 = LCase(P1)
            If Not P1.Equals("xls") AndAlso P1.Equals("csv") Then
                'ExcelでもCSVでもない場合 -> Excel
                P1 = "xls"
            End If
            '
            If UCase(P2).IndexOf("INSERT") > -1 OrElse _
               UCase(P2).IndexOf("UPDATE") > -1 OrElse _
               UCase(P2).IndexOf("DELETE") > -1 Then
                '念の為、更新系クエリ文字を含むものは実行しない
                P_MSG = "指定された SQL 文を実行する権限がありません。"
                Call Utl_ERR.FNC_ERR_RTN(P_MSG, P2)
                GoTo EXIT_FUNCTION
            End If
            '
            'SQL 実行
            If Not P1.Equals("csv") Then
                'Excelの場合最大行数の確認が必要
                D_SQL = P1 & ";SELECT @@ROWCOUNT AS CNT"
                '
                If Not D_UTL_RDB.FNC_SQL_EXE(D_DAT, D_SQL) Then
                    'SQL実行エラー
                    P_MSG = "SQL の実行に失敗しました。"
                    Call Utl_ERR.FNC_ERR_RTN(P_MSG, D_SQL)
                    GoTo EXIT_FUNCTION
                End If
                '
                If Not D_UTL_RDB.FNC_CHK_DAT(D_DAT, 0, False) Then
                    'データ取得失敗
                    P_MSG = "データの取得に失敗しました。"
                    Call Utl_ERR.FNC_ERR_RTN(P_MSG, D_SQL)
                    GoTo EXIT_FUNCTION
                End If
                '
                If Not D_UTL_RDB.FNC_CHK_DAT(D_DAT, 1, False) Then
                    'データ取得失敗
                    P_MSG = "レコード件数の取得に失敗しました。"
                    Call Utl_ERR.FNC_ERR_RTN(P_MSG, D_SQL)
                    GoTo EXIT_FUNCTION
                End If
                '
                D_CNT = D_UTL_RDB.FNC_CNV_NUL(D_DAT.Tables(1).Rows(0).Item("CNT"), 0)
                If (D_CNT > P_LMT - 1) Then
                    '挿入可能最大行数超過
                    P_MSG = D_CNT.ToString() & "件のレコードがあります" & vbLf _
                          & "ファイルには" & P_LMT.ToString() & "件以上のレコードを書き込めません"
                    GoTo EXIT_FUNCTION
                End If
                '
                'If Not FNC_GEN_XLS(D_DAT.Tables(0), OP1) Then
                '    'Excel 作成エラー
                '    GoTo EXIT_FUNCTION
                'End If
            Else
                D_SQL = P1
                '
                If Not D_UTL_RDB.FNC_SQL_EXE(D_DAT, D_SQL) Then
                    'SQL実行エラー
                    P_MSG = "SQL の実行に失敗しました。"
                    Call Utl_ERR.FNC_ERR_RTN(P_MSG, D_SQL)
                    GoTo EXIT_FUNCTION
                End If
                '
                If Not D_UTL_RDB.FNC_CHK_DAT(D_DAT, 0, False) Then
                    'データ取得失敗
                    P_MSG = "データの取得に失敗しました。"
                    Call Utl_ERR.FNC_ERR_RTN(P_MSG, D_SQL)
                    GoTo EXIT_FUNCTION
                End If
                '
                If Not FNC_GEN_CSV(D_DAT.Tables(0), OP1) Then
                    'CSV 作成エラー
                    GoTo EXIT_FUNCTION
                End If
            End If
            '
            D_RTN = True
            '
        Catch ex As Exception
            P_MSG = "予期しないエラーが発生しました"
            Call Utl_ERR.FNC_ERR_RTN(ex)
            '
        Finally
            Call D_UTL_RDB.FNC_CLS_CON()
        End Try
        '
EXIT_FUNCTION:
        FNC_GET_DAT = D_RTN
        Exit Function
    End Function


    ''' <summary>
    ''' CSV 作成
    ''' </summary>
    ''' <param name="P1">データ</param>
    ''' <param name="OP1">ヘッダーの有無 true:あり / false:なし</param>
    ''' <returns>True.作成成功, False.作成失敗</returns>
    ''' <remarks></remarks>
    Public Function FNC_GEN_CSV( _
        ByVal P1 As DataTable, _
        Optional ByVal OP1 As Boolean = True _
    ) As Boolean
        Dim D_RTN As Boolean = False        '戻値
        Dim D_FIL As String = Nothing       'ファイル名
        Dim D_PUT As StreamWriter = Nothing 'StreamWriter
        Dim D_CSV As String = Nothing       '1行分のCSV文字列
        '
        Try
            'ファイル名設定
            D_FIL = "data_" & Now.ToString("yyyyMMdd_HHmmss") & ".csv"
            '
            'ファイルパス確定
            P_PTH = P_DIR & D_FIL
            '
            'ファイル作成
            'CSV作成
            D_PUT = New StreamWriter(P_PTH, False, System.Text.Encoding.GetEncoding("Shift-JIS"))
            '
            If OP1 Then
                'ヘダー有り
                D_CSV = ""
                For I As Integer = 0 To P1.Columns.Count - 1
                    If I.Equals(CInt(0)) Then
                        D_CSV &= FNC_CNV_CSV(P1.Columns(I).ColumnName)
                    Else
                        D_CSV &= "," & FNC_CNV_CSV(P1.Columns(I).ColumnName)
                    End If
                Next I
                D_PUT.WriteLine(D_CSV)
            End If
            '
            '明細部
            For I As Integer = 0 To P1.Rows.Count - 1
                D_CSV = ""
                For J As Integer = 0 To P1.Columns.Count - 1
                    If J.Equals(CInt(0)) Then
                        D_CSV &= FNC_CNV_CSV(P1.Rows(I)(J))
                    Else
                        D_CSV &= "," & FNC_CNV_CSV(P1.Rows(I)(J))
                    End If
                Next J
                '
                D_PUT.WriteLine(D_CSV)
            Next I
            '
            D_RTN = True
            '
        Catch ex As Exception
            P_MSG = "予期しないエラーが発生しました"
            File.Delete(P_PTH)
            Call Utl_ERR.FNC_ERR_RTN(ex)
            '
        Finally
            If Not IsNothing(D_PUT) Then
                D_PUT.Close()
                D_PUT = Nothing
            End If
        End Try
        '
EXIT_FUNCTION:
        FNC_GEN_CSV = D_RTN
        Exit Function
    End Function

    '************************************************************************************************
    '*
    '*  処理：CSV値置換
    '*
    '*  引数：1.対象値
    '*
    '*  選択：1.ダブルクォーテーション囲み true:囲む / false:囲まない [デフォルト：true]
    '*
    '*  戻値：変換値
    '*
    '************************************************************************************************
    ''' <summary>
    ''' Null値置換
    ''' </summary>
    ''' <param name="P1">対象値</param>
    ''' <param name="OP1">ダブルクォーテーション囲み true:囲む / false:囲まない [デフォルト：true]</param>
    ''' <returns>変換値</returns>
    ''' <remarks></remarks>
    Public Function FNC_CNV_CSV( _
        ByVal P1 As Object, _
        Optional ByVal OP1 As Boolean = True _
    ) As String
        Dim D_RTN As String = ""
        '
        Try
            If IsDBNull(P1) OrElse IsNothing(P1) Then
                D_RTN = ""
            Else
                D_RTN = P1.ToString
            End If
            '
            D_RTN.Replace(vbLf, "").Replace(vbCr, "").Replace(vbLf, "")
            If OP1 Then
                D_RTN = """" & Replace(D_RTN, """", """""") & """"
            End If
            '
        Catch ex As Exception
            Call Utl_ERR.FNC_ERR_RTN(ex)
        End Try
        '
EXIT_FUNCTION:
        FNC_CNV_CSV = D_RTN
        Exit Function
    End Function

    '************************************************************************************************
    '*
    '*  概要：Windowsで使えないファイル名判定
    '*
    '*  引数：1.ファイル名
    '*        2.確認拡張子名
    '*
    '*  戻値：禁止文字を"_"で置換したファイル名
    '*
    '************************************************************************************************
    ''' <summary>
    ''' Windowsで使えないファイル名判定
    ''' </summary>
    ''' <param name="P1">ファイル名</param>
    ''' <param name="P2">確認拡張子名</param>
    ''' <returns>禁止文字を"_"で置換したファイル名</returns>
    ''' <remarks></remarks>
    Public Function FNC_CNV_FIL(ByRef P1 As String, ByVal P2 As String) As Boolean
        Dim D_RTN As Boolean = False      '戻値
        Dim D_INV_CHR As Char() = Nothing 'Windowsで利用できないファイル名
        Dim D_TMP As String = Nothing     '一時文字列
        '
        Try
            '引数調整
            If IsNothing(P1) OrElse P1.Trim.Equals("") Then
                D_TMP = "new"
            Else
                D_TMP = P1.Trim
            End If
            '
            If IsNothing(P2) OrElse P2.Trim.Equals("") Then
                P2 = ""
            Else
                P2 = P2.Trim
                If Not P2.Substring(0, 1).Equals(".") Then
                    P2 = "." & P2
                End If
            End If
            '
            'Windowsで利用できないファイル名取得
            D_INV_CHR = Path.GetInvalidFileNameChars()
            '
            '拡張子確認
            If Not Path.GetExtension(D_TMP).Equals(P2) Then
                D_TMP = D_TMP & P2
            End If
            '
            'Windowsで使えないファイル名置換
            For Each D_CHR As Char In D_INV_CHR
                D_TMP = D_TMP.Replace(D_CHR, "_")
            Next D_CHR
            '
            D_RTN = True
            '
        Catch ex As Exception
            Call Utl_ERR.FNC_ERR_RTN(ex)
            '
        End Try
        '
EXIT_FUNCTION:
        P1 = D_TMP
        FNC_CNV_FIL = D_RTN
        Exit Function
    End Function

    '************************************************************************************************
    '*
    '*  概要：ファイル名重複確認 (重複時リネーム)
    '*
    '*  引数：1.ディレクトリパス
    '*        2.ファイルパス
    '*
    '*  選択：1.確認回数
    '*
    '*  戻値：true:変更成功 / false:変更失敗
    '*
    '************************************************************************************************
    ''' <summary>
    ''' ファイル名重複確認 (重複時リネーム)
    ''' </summary>
    ''' <param name="P1">ディレクトリパス</param>
    ''' <param name="P2">ファイル名</param>
    ''' <param name="OP1">確認回数[デフォルト：100]</param>
    ''' <returns>True:ファイル名重複無し(リネーム成功) / False:ファイル名リネーム失敗</returns>
    ''' <remarks></remarks>
    Public Function FNC_CHK_DUP( _
        ByVal P1 As String, _
        ByRef P2 As String, _
        Optional ByVal OP1 As Integer = 100 _
    ) As Boolean
        Dim D_RTN As Boolean = False  '戻値
        Dim D_FIL As String = Nothing 'ファイル名
        Dim D_EXT As String = Nothing 'ファイル拡張子
        Dim D_TMP As String = Nothing '一時文字列
        '
        Try
            'ディレクトリ確認
            If Not Directory.Exists(P1) Then
                If Directory.CreateDirectory(P1).Equals(CLng(0)) Then
                    P_MSG = "ファイル保存用ディレクトリの作成に失敗しました"
                    GoTo EXIT_FUNCTION
                End If
            End If
            'ディレクトリの末尾を"\"にする
            If Not P1.Substring(P1.Length - 1, 1).Equals("\") Then
                P1 &= "\"
            End If
            '
            'ファイル名非存在確認
            D_TMP = P2
            If Not File.Exists(P1 & D_TMP) Then
                '非存在 -> そのままのファイル名が使える
                D_RTN = True
                GoTo EXIT_FUNCTION
            End If
            '
            'ファイル名 / 拡張子取得
            D_FIL = GetFileNameWithoutExtension(P2)
            D_EXT = GetExtension(P2)
            For I As Integer = 1 To OP1 Step 1
                '新ファイル名非存在確認
                If Not File.Exists(P1 & D_FIL & "(" & I.ToString() & ")" & D_EXT) Then
                    '新ファイル名が非存在 -> ファイル名に確定
                    D_TMP = D_FIL & "(" & I.ToString() & ")" & D_EXT
                    D_RTN = True
                    Exit For
                End If
            Next I
            '
        Catch ex As Exception
            Call Utl_ERR.FNC_ERR_RTN(ex)
        End Try
        '
EXIT_FUNCTION:
        P2 = D_TMP
        FNC_CHK_DUP = D_RTN
        Exit Function
    End Function

    ''' <summary>
    ''' パス取得
    ''' </summary>
    ''' <returns>パス</returns>
    ''' <remarks></remarks>
    Public Function FNC_GET_PTH() As String
        FNC_GET_PTH = P_PTH
    End Function

    ''' <summary>
    ''' メッセージ取得
    ''' </summary>
    ''' <returns>メッセージ</returns>
    ''' <remarks></remarks>
    Public Function FNC_GET_MSG() As String
        FNC_GET_MSG = P_MSG
    End Function

    ''' <summary>
    ''' Funtiong Read CSV to Datatables
    ''' </summary>
    ''' <param name="filePath">File Path</param>
    ''' <param name="delimiters"></param>
    ''' <returns>Datatable</returns>
    ''' <remarks></remarks>
    Public Shared Function FNC_READ_CSV_TO_DATATABLE(filePath As String, Optional delimiters As String = ";") As DataTable
        Dim textFileReader As New Microsoft.VisualBasic.FileIO.TextFieldParser(filePath, System.Text.Encoding.GetEncoding("Shift_JIS"))

        textFileReader.TextFieldType = FileIO.FieldType.Delimited
        textFileReader.SetDelimiters(delimiters)


        Dim textFileTable As DataTable = Nothing
        Dim textFileTable_2 As DataTable = New DataTable("TextFileTable_Result")

        Dim column As DataColumn
        Dim row As DataRow 
        Dim upperBound As Int32
        Dim columnCount As Int32
        Dim currentRow As String()

        While Not textFileReader.EndOfData
            Try
                currentRow = textFileReader.ReadFields()
                If Not currentRow Is Nothing Then
                    ''# Check if DataTable has been created
                    If textFileTable Is Nothing Then
                        textFileTable = New DataTable("TextFileTable") 
                        ''# Get number of columns
                        upperBound = currentRow.GetUpperBound(0)
                        ''# Create new DataTable
                        For columnCount = 0 To upperBound
                            column = New DataColumn()
                            column.DataType = Type.GetType("System.String")
                            column.ColumnName = currentRow(columnCount).ToString
                            column.Caption = "Column_" & columnCount
                            column.ReadOnly = True
                            column.Unique = False
                            textFileTable.Columns.Add(column)
                        Next
                        Continue While
                    End If
                    row = textFileTable.NewRow 
                    For columnCount = 0 To upperBound
                        row(columnCount) = currentRow(columnCount).ToString
                    Next
                    textFileTable.Rows.Add(row) 
                End If
            Catch ex As Exception
                Call Utl_ERR.FNC_ERR_RTN(ex)
            End Try
        End While
        textFileReader.Dispose()
        Return textFileTable.Select("", "請求番号 Asc  ").CopyToDataTable
        Return textFileTable
    End Function

#End Region

#Region "■Enum■"

    ''' <summary>
    ''' Excelのカラーインデックス
    ''' </summary>
    ''' <remarks>
    ''' Excel.XlColorIndexの組込定数と
    ''' Excel.XlColorIndexの組込定数に存在しない56種類のカラーインデックス
    ''' </remarks>
    Public Enum ColorIndex
        ''' <summary>
        ''' 自動設定
        ''' </summary>
        ''' <remarks></remarks>
        Automatic = -4105
        ''' <summary>
        ''' 色なし
        ''' </summary>
        ''' <remarks></remarks>
        None = -4142
        ''' <summary>
        ''' 黒
        ''' </summary>
        ''' <remarks></remarks>
        Black = 1
        ''' <summary>
        ''' 白
        ''' </summary>
        ''' <remarks></remarks>
        White = 2
        ''' <summary>
        ''' 赤
        ''' </summary>
        ''' <remarks></remarks>
        Red = 3
        ''' <summary>
        ''' 明るい緑
        ''' </summary>
        ''' <remarks></remarks>
        LightGreen = 4
        ''' <summary>
        ''' 青
        ''' </summary>
        ''' <remarks></remarks>
        Blue = 5
        ''' <summary>
        ''' 黄
        ''' </summary>
        ''' <remarks></remarks>
        Yellow = 6
        ''' <summary>
        ''' ピンク
        ''' </summary>
        ''' <remarks></remarks>
        Pink = 7
        ''' <summary>
        ''' 水色
        ''' </summary>
        ''' <remarks></remarks>
        Cyan = 8
        ''' <summary>
        ''' 濃い赤
        ''' </summary>
        ''' <remarks></remarks>
        DarkRed = 9
        ''' <summary>
        ''' 緑
        ''' </summary>
        ''' <remarks></remarks>
        Green = 10
        ''' <summary>
        ''' 濃い青
        ''' </summary>
        ''' <remarks></remarks>
        DarkBlue = 11
        ''' <summary>
        ''' 濃い黄
        ''' </summary>
        ''' <remarks></remarks>
        DarkYellow = 12
        ''' <summary>
        ''' 紫
        ''' </summary>
        ''' <remarks></remarks>
        Purple = 13
        ''' <summary>
        ''' 青緑
        ''' </summary>
        ''' <remarks></remarks>
        BlueGreen = 14
        ''' <summary>
        ''' 灰色25%
        ''' </summary>
        ''' <remarks></remarks>
        Gray25 = 15
        ''' <summary>
        ''' 灰色50%
        ''' </summary>
        ''' <remarks></remarks>
        Gray50 = 16
        ''' <summary>
        ''' グレー
        ''' </summary>
        ''' <remarks></remarks>
        Gray = 17
        ''' <summary>
        ''' プラム
        ''' </summary>
        ''' <remarks></remarks>
        Plum = 18
        ''' <summary>
        ''' アイボリー
        ''' </summary>
        ''' <remarks></remarks>
        Ivory = 19
        ''' <summary>
        ''' 薄い水色
        ''' </summary>
        ''' <remarks></remarks>
        ThinCyan = 20
        ''' <summary>
        ''' 濃い紫
        ''' </summary>
        ''' <remarks></remarks>
        DarkPurple = 21
        ''' <summary>
        ''' コーラル
        ''' </summary>
        ''' <remarks></remarks>
        Coral = 22
        ''' <summary>
        ''' オーシャンブルー
        ''' </summary>
        ''' <remarks></remarks>
        OceanBlue = 23
        ''' <summary>
        ''' アイスブルー
        ''' </summary>
        ''' <remarks></remarks>
        IceBlue = 24
        ''' <summary>
        ''' 濃い青
        ''' </summary>
        ''' <remarks></remarks>
        DarkBlue_2 = 25
        ''' <summary>
        ''' ピンク
        ''' </summary>
        ''' <remarks></remarks>
        Pink_2 = 26
        ''' <summary>
        ''' 黄
        ''' </summary>
        ''' <remarks></remarks>
        Yellow_2 = 27
        ''' <summary>
        ''' 水色
        ''' </summary>
        ''' <remarks></remarks>
        Cyan_2 = 28
        ''' <summary>
        ''' 紫
        ''' </summary>
        ''' <remarks></remarks>
        Purple_2 = 29
        ''' <summary>
        ''' 濃い赤
        ''' </summary>
        ''' <remarks></remarks>
        DarkRed_2 = 30
        ''' <summary>
        ''' 青緑
        ''' </summary>
        ''' <remarks></remarks>
        BlueGreen_2 = 31
        ''' <summary>
        ''' 青
        ''' </summary>
        ''' <remarks></remarks>
        Blue_2 = 32
        ''' <summary>
        ''' スカイブルー
        ''' </summary>
        ''' <remarks></remarks>
        SkyBlue = 33
        ''' <summary>
        ''' 薄い水色
        ''' </summary>
        ''' <remarks></remarks>
        ThinCyan_2 = 34
        ''' <summary>
        ''' 薄い緑
        ''' </summary>
        ''' <remarks></remarks>
        ThinGreen = 35
        ''' <summary>
        ''' 薄い黄
        ''' </summary>
        ''' <remarks></remarks>
        ThinYellow = 36
        ''' <summary>
        ''' ペールブルー
        ''' </summary>
        ''' <remarks></remarks>
        PaleBlue = 37
        ''' <summary>
        ''' ローズ
        ''' </summary>
        ''' <remarks></remarks>
        Rose = 38
        ''' <summary>
        ''' ラベンダー
        ''' </summary>
        ''' <remarks></remarks>
        Lavender = 39
        ''' <summary>
        ''' ベージュ
        ''' </summary>
        ''' <remarks></remarks>
        Beige = 40
        ''' <summary>
        ''' 薄い青
        ''' </summary>
        ''' <remarks></remarks>
        ThinBlue = 41
        ''' <summary>
        ''' アクア
        ''' </summary>
        ''' <remarks></remarks>
        Aqua = 42
        ''' <summary>
        ''' ライム
        ''' </summary>
        ''' <remarks></remarks>
        Lime = 43
        ''' <summary>
        ''' ゴールド
        ''' </summary>
        ''' <remarks></remarks>
        Gold = 44
        ''' <summary>
        ''' 薄いオレンジ
        ''' </summary>
        ''' <remarks></remarks>
        ThinOrange = 45
        ''' <summary>
        ''' オレンジ
        ''' </summary>
        ''' <remarks></remarks>
        Orange = 46
        ''' <summary>
        ''' ブルーグレー
        ''' </summary>
        ''' <remarks></remarks>
        BlueGray = 47
        ''' <summary>
        ''' 灰色40%
        ''' </summary>
        ''' <remarks></remarks>
        Gray40 = 48
        ''' <summary>
        ''' 濃い青緑
        ''' </summary>
        ''' <remarks></remarks>
        DarkBlueGreen = 49
        ''' <summary>
        ''' シーグリーン
        ''' </summary>
        ''' <remarks></remarks>
        SeaGreen = 50
        ''' <summary>
        ''' 濃い緑
        ''' </summary>
        ''' <remarks></remarks>
        DarkGreen = 51
        ''' <summary>
        ''' オリーブ
        ''' </summary>
        ''' <remarks></remarks>
        Olive = 52
        ''' <summary>
        ''' 茶
        ''' </summary>
        ''' <remarks></remarks>
        Brown = 53
        ''' <summary>
        ''' プラム
        ''' </summary>
        ''' <remarks></remarks>
        Plum_2 = 54
        ''' <summary>
        ''' インディゴ
        ''' </summary>
        ''' <remarks></remarks>
        Indigo = 55
        ''' <summary>
        ''' 灰色80%
        ''' </summary>
        ''' <remarks></remarks>
        Gray80 = 56
    End Enum

#End Region

End Class
