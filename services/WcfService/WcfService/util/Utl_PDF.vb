'機能概要*********************************************************************************************
'*
'*  処理概要：WebService経由帳票PDF作成
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
Imports System.Data.SqlClient
Imports System.Drawing.Printing
Imports System.IO
Imports System.IO.Path
Imports System.Text

'****************************************************************************************************
'*  クラス
'****************************************************************************************************
Public Class Utl_PDF

    '****************************************************************************************************
    '*  デバッグフラグ True:デバッグ用ログ吐き出し / False:デバッグ無し
    '****************************************************************************************************
    Private P_DBG As Boolean = False

#Region "■Common Value■"

    '************************************************************************************************
    '*  メンバ変数
    '************************************************************************************************
    Private P_TOP As Single = Nothing      'PDF上余白(cm単位)
    Private P_BTM As Single = Nothing      'PDF下余白(cm単位)
    Private P_MSG As String = Nothing      'メッセージ
    Private P_DIR As String = Nothing      'Excel / CSVを作成するディレクトリまでのパス
    Private P_PTH As String = Nothing      'パス
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
            'PDF上下余白設定
            P_TOP = 0.5
            P_BTM = 0.0
            '
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
            '
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
    ''' パス取得
    ''' </summary>
    ''' <returns>パス</returns>
    ''' <remarks></remarks>
    Public Function FNC_GET_PTH() As String
        FNC_GET_PTH = P_PTH
    End Function

    ''' <summary>
    ''' パス取得
    ''' </summary>
    ''' <returns>パス</returns>
    ''' <remarks></remarks>
    Public Function FNC_GET_DIR() As String
        FNC_GET_DIR = P_DIR
    End Function

    ''' <summary>
    ''' メッセージ取得
    ''' </summary>
    ''' <returns>メッセージ</returns>
    ''' <remarks></remarks>
    Public Function FNC_GET_MSG() As String
        FNC_GET_MSG = P_MSG
    End Function

#End Region

End Class
