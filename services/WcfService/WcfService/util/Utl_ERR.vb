'機能概要********************************************************************************************
'*
'*  処理概要：データベース処理
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

'****************************************************************************************************
'*  クラス
'****************************************************************************************************
Public Class Utl_ERR

#Region "■User Function■"

	''' <summary>
	''' エラーログ生成
	''' </summary>
	''' <param name="P1">Exception</param>
	''' <param name="OP1">エラー時のSQL文</param>
	''' <remarks></remarks>
	Public Shared Sub FNC_ERR_RTN( _
		ByRef P1 As System.Exception, _
		Optional ByVal OP1 As String = "" _
	)
		Dim D_PTH As String = ""
		Dim D_FIL As String = ""
		Dim D_PUT As StreamWriter = Nothing
		'
		Try
			D_PTH = ConfigurationManager.AppSettings("ERR_LOG_PTH")
			'D_PTHの末尾を"\"に
			If Not D_PTH.Substring(D_PTH.Length - 1, 1).Equals("\") Then
				D_PTH &= "\"
			End If
			'ファイル名設定
            D_FIL = Now().ToString("yyyyMMdd_HHmmss") & System.Net.Dns.GetHostName & ".log"
			If Not Directory.Exists(D_PTH) Then
				'ファイルを格納するディレクトリ非存在 -> 作成
				Directory.CreateDirectory(D_PTH)
			End If
			'
			D_PUT = New StreamWriter(D_PTH & D_FIL, False, System.Text.Encoding.Default)
			D_PUT.WriteLine("【エラーメッセージ】")
			D_PUT.WriteLine(P1.Message)
			If Not IsNothing(OP1) AndAlso Not OP1.Equals("") Then
				D_PUT.WriteLine("【SQL】")
				D_PUT.WriteLine(OP1)
			End If
			D_PUT.WriteLine("【エラー発生場所】")
			D_PUT.WriteLine(P1.StackTrace)
			D_PUT.WriteLine("【エラー発生日時】")
			D_PUT.WriteLine(Format(Now(), "yyyy/MM/dd HH:mm:ss"))
			'
		Catch ex As Exception
			'
		Finally
			If Not IsNothing(D_PUT) Then
				D_PUT.Close()
			End If
		End Try
		'
EXIT_SUB:
		Exit Sub
	End Sub

	''' <summary>
	''' エラーログ生成
	''' </summary>
	''' <param name="P1">エラー内容</param>
	''' <param name="OP1">エラー時のSQL文</param>
	''' <remarks></remarks>
	''' 
	Public Shared Sub FNC_ERR_RTN( _
		ByRef P1 As String, _
		Optional ByVal OP1 As String = "" _
	)
		Dim D_PTH As String = ""
		Dim D_FIL As String = ""
		Dim D_PUT As StreamWriter = Nothing
		'
		Try
			D_PTH = ConfigurationManager.AppSettings("ERR_LOG_PTH")
			'D_PTHの末尾を"\"に
			If Not D_PTH.Substring(D_PTH.Length - 1, 1).Equals("\") Then
				D_PTH &= "\"
			End If
			'ファイル名設定
            D_FIL = Now().ToString("yyyyMMdd_HHmmss_fffffff_") & System.Net.Dns.GetHostName & ".log"
            D_FIL = Now().ToString("yyyyMMdd") & System.Net.Dns.GetHostName & ".log"
			If Not Directory.Exists(D_PTH) Then
				'ファイルを格納するディレクトリ非存在 -> 作成
				Directory.CreateDirectory(D_PTH)
			End If
			'
            D_PUT = New StreamWriter(D_PTH & D_FIL, False, System.Text.Encoding.UTF8)
            D_PUT.WriteLine("【エラーメッセージ】")
            D_PUT.WriteLine(P1)
            If Not IsNothing(OP1) AndAlso Not OP1.Equals("") Then
                D_PUT.WriteLine("【SQL】")
                D_PUT.WriteLine(OP1)
            End If
            D_PUT.WriteLine("【エラー発生日時】")
            D_PUT.WriteLine(Format(Now(), "yyyy/MM/dd HH:mm:ss"))
            D_PUT.WriteLine("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
			'
		Catch ex As Exception
			'
		Finally
			If Not IsNothing(D_PUT) Then
				D_PUT.Close()
			End If
		End Try
		'
EXIT_SUB:
		Exit Sub
	End Sub

	'*********************************************************************************************************
	'*
	'*  概要：デバッグ用ログ吐き出し
	'*
	'*  引数：1.出力文字
	'*        2.ファイル名
	'*
	'*  戻値：なし
	'*
	'*********************************************************************************************************
	''' <summary>
	''' デバッグ用ログ吐き出し
	''' </summary>
	''' <param name="P1">出力文字</param>
	''' <param name="OP1">ファイル名</param>
	''' <remarks></remarks>
	Public Shared Sub FNC_DBG_WRT( _
		ByVal P1 As String, _
		Optional ByVal OP1 As String = "WebDebug")
		Dim D_PTH As String = ""
		Dim D_FIL As String = ""
		Dim D_PUT As StreamWriter = Nothing
		'
		Try
			D_PTH = ConfigurationManager.AppSettings("DBG_LOG_PTH")
			'D_PTHの末尾を"\"に
			If Not D_PTH.Substring(D_PTH.Length - 1, 1).Equals("\") Then
				D_PTH &= "\"
			End If
			'ファイル名設定
			D_FIL = Now().ToString("yyyyMMdd_") & OP1 & ".log"
			If Not Directory.Exists(D_PTH) Then
				'ファイルを格納するディレクトリ非存在 -> 作成
				Directory.CreateDirectory(D_PTH)
			End If
			'
			D_PUT = New StreamWriter(D_PTH & D_FIL, True, System.Text.Encoding.Default)
			D_PUT.WriteLine("----- " & Now().ToString("yyyy/MM/dd HH:mm:ss") & " -----")
			D_PUT.WriteLine(P1)
			'
		Catch ex As Exception
			Call Utl_ERR.FNC_ERR_RTN(ex)
			'
		Finally
			If Not IsNothing(D_PUT) Then
				D_PUT.Close()
			End If
		End Try
		'
EXIT_SUB:
		Exit Sub
    End Sub
    ''' <summary>
    ''' Write Log File
    ''' </summary>
    ''' <param name="content"></param>
    ''' <remarks></remarks>
    Public Shared Sub WriteLogFile(content As String, Optional ByVal functionName As String = "", Optional ByVal deleteFile As Boolean = False)
        Try
            Dim fileName As String = DateTime.Now.ToString("yyyy_MM_dd") + "_SQL_log.txt"
            Dim logFolder = ConfigurationManager.AppSettings("ERR_LOG_PTH") ' + "\log.txt"
            Dim foderName As String = String.Empty
            If String.IsNullOrEmpty(logFolder) Then
                foderName = AppDomain.CurrentDomain.BaseDirectory + "Logs\" + fileName
            Else
                foderName = logFolder + "\" + fileName
            End If
            Dim fInfo As New FileInfo(foderName)

            Dim dirName As String = fInfo.DirectoryName
            If Not Directory.Exists(dirName) Then
                Directory.CreateDirectory(dirName)
            End If

            'Delete file log
            If deleteFile Then
                If File.Exists(foderName) Then
                    File.Delete(foderName)
                End If
            End If

            Using w As StreamWriter = File.AppendText(foderName)
                w.WriteLine("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
                w.WriteLine(DateTime.Now.ToString("yyyy/MM/dd HH:mm:ss") & " ----> " & functionName)
                w.WriteLine("EXEC " & content)
                 
                'System.IO.StreamWriter file = new System.IO.StreamWriter(userName, true);
                'file.WriteLine(content);
                'file.Close();
            End Using
        Catch ex As Exception
        End Try

    End Sub


    ''' <summary>
    ''' Write Log File Report
    ''' </summary>
    ''' <param name="content"></param>
    ''' <remarks></remarks>
    Public Shared Sub WriteLogReport(content As String, Optional ByVal functionName As String = "", Optional ByVal deleteFile As Boolean = False)
        Try
            Dim fileName As String = DateTime.Now.ToString("yyyy_MM_dd") + "_" + functionName + "_log.txt"
            Dim logFolder = ConfigurationManager.AppSettings("ERR_LOG_PTH") ' + "\log.txt"
            Dim foderName As String = String.Empty
            If String.IsNullOrEmpty(logFolder) Then
                foderName = AppDomain.CurrentDomain.BaseDirectory + "Logs\" + fileName
            Else
                foderName = logFolder + "\" + fileName
            End If
            Dim fInfo As New FileInfo(foderName)

            Dim dirName As String = fInfo.DirectoryName
            If Not Directory.Exists(dirName) Then
                Directory.CreateDirectory(dirName)
            End If

            'Delete file log
            If deleteFile Then
                If File.Exists(foderName) Then
                    File.Delete(foderName)
                End If
            End If

            Using w As StreamWriter = File.AppendText(foderName) 
                w.WriteLine("【エラー発生日時】")
                w.WriteLine(Format(Now(), "yyyy/MM/dd HH:mm:ss"))
                w.WriteLine("【エラーメッセージ】")
                w.WriteLine(content)                
                w.WriteLine("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++") 
            End Using
        Catch ex As Exception
        End Try

    End Sub

    ''' <summary>
    ''' エラーログ作成
    ''' </summary>
    ''' <param name="P_FullPathFileName">フルパスファイル名</param>
    ''' <param name="P_Exception">例外</param>
    ''' <returns>成否</returns>
    ''' <remarks></remarks>
    Public Shared Function M_MakeErrorLog _
    ( _
        ByVal P_FullPathFileName As String _
        , ByVal P_Exception As System.Exception _
    ) _
    As Boolean

        '戻り値
        Dim D_Return As Boolean = False
        'ストリームライター
        Dim D_StreamWriter As System.IO.StreamWriter = Nothing

        Try

            'ストリームライターをインスタンス化
            D_StreamWriter = New System.IO.StreamWriter(P_FullPathFileName, True)
            '書き込み
            D_StreamWriter.WriteLine(P_Exception)

            '戻り値を設定
            D_Return = True

        Catch ex As Exception
            Utl_ERR.FNC_ERR_RTN(ex)
        Finally
            If Not IsNothing(D_StreamWriter) Then
                D_StreamWriter.Close()
                D_StreamWriter.Dispose()
            End If
        End Try

        '戻り値を返す
        Return D_Return

    End Function

#End Region

End Class
