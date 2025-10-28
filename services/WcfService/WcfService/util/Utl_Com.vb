Imports System.IO
''' 機能概要*****************************************************************************************************
''' <summary>
''' 共通関数
''' </summary>
''' <remarks></remarks>
''' 
''' 作成者  ：山下 2012.12.10
''' 
''' 更新者  ：
''' 更新内容：
''' 
''' *************************************************************************************************************
Public Class Utl_Com

    ''' *************************************************************************************************************
    ''' <summary>
    ''' メンバー変数
    ''' </summary>
    ''' <remarks></remarks>
    ''' *************************************************************************************************************
    Public Shared P_EXC_TBL As New DataTable
    Public Shared P_EXC_DAT As New DataSet
    '
    Public Shared C_USR_PMN As Boolean = False '認証許可
    '
    '事業所情報
    Public Shared C_COM_COD As Integer    '会社コード
    '*ユーザー情報
    Public Shared C_USR_IDS As String   'ユーザーID
    Public Shared C_USR_NAM As String   'ユーザ名

    '*システム設定
    Public Shared C_USR_BAK_IMG As String      'background image type
    Public Shared C_USR_MNU_IMG As String      'menu button image type
    Public Shared C_IMG_MAX_SIZ As Long = 1024      'image file max size(kb)
    '
    '検索データプール処理
    Public Shared P_FND_TBL As New DataTable
    '
    'Public Shared P_KEP_PRM As New Hashtable '検索画面：検索条件保持用

    Public Shared P_FRM_LCN As System.Drawing.Point
    '
    Public Shared P_USE_LVL(3) As String


    ''' *************************************************************************************************************
    ''' <summary>
    ''' Null値置換
    ''' </summary>
    ''' <param name="P1">対象値</param>
    ''' <param name="P2">変換値</param>
    ''' <returns>変換値</returns>
    ''' <remarks></remarks>
    ''' *************************************************************************************************************
    Public Shared Function FNC_CNV_NUL(ByVal P1 As Object, ByVal P2 As Object) As Object
        Dim D_RTN As Object = Nothing
        Try
            If IsDBNull(P1) OrElse IsNothing(P1) Then
                D_RTN = P2
            Else
                D_RTN = P1
                ' D_RTN = Replace(P1, vbTab, "    ")
            End If
        Catch ex As Exception
            Utl_ERR.FNC_ERR_RTN(ex)
        Finally
            '
        End Try
EXIT_FUNCTION:
        FNC_CNV_NUL = D_RTN
        Exit Function
    End Function


    ''' *************************************************************************************************************
    ''' <summary>
    ''' 固定文字数文字列生成
    ''' </summary>
    ''' <param name="P1">対象値</param>
    ''' <param name="P2">詰文字(space(0) or "0")</param>
    ''' <param name="P3">固定文字数</param>
    ''' <param name="P4">処理タイプ(1:後詰　2:前詰)</param>
    ''' <returns>固定長文字列</returns>
    ''' <remarks></remarks>
    ''' *************************************************************************************************************
    Public Shared Function FNC_FIX_LEN(ByVal P1 As Object, ByVal P2 As String, ByVal P3 As Integer, ByVal P4 As Byte) As String
        '
        Dim D_RTN As String = Nothing
        '
        Try
            D_RTN = P1
            '
            '詰文字
            For I = 1 To P3 Step 1
                If P4 = 1 Then
                    D_RTN = D_RTN & P2
                Else
                    D_RTN = P2 & D_RTN
                End If
            Next
            '
            '固定文字数
            If P4 = 1 Then
                D_RTN = Microsoft.VisualBasic.Left(D_RTN, P3)
            Else
                D_RTN = Microsoft.VisualBasic.Right(D_RTN, P3)
            End If
        Catch ex As Exception
            Utl_ERR.FNC_ERR_RTN(ex)
        Finally
            '
        End Try
EXIT_FUNCTION:
        FNC_FIX_LEN = D_RTN
        Exit Function
    End Function

    ''' *************************************************************************************************************
    ''' <summary>
    ''' 更新ユーザー情報生成
    ''' </summary>
    ''' <returns>ユーザー情報</returns>
    ''' <remarks></remarks>
    ''' *************************************************************************************************************
    Public Shared Function FNC_UPD_USR() As String
        Dim D_RTN As String = ""
        Try
            D_RTN = "'" & Utl_Com.C_USR_IDS & "','" & FNC_GET_IPS() & "'"
        Catch ex As Exception
            Utl_ERR.FNC_ERR_RTN(ex)
        Finally
            '
        End Try
EXIT_FUNCTION:
        FNC_UPD_USR = D_RTN
        Exit Function
    End Function

    '*********************************************************************************************************
    '*
    '*  処理概要： コンボボックス選択値の検索
    '*
    '*  引数　　： 1.コンボボックス
    '*             ｵﾌﾟｼｮﾝ1.検索ﾀｲﾌﾟ(0.valueから検索、 1.Textから検索)
    '*             ｵﾌﾟｼｮﾝ2.結果ﾀｲﾌﾟ(True.Comboに存在する値のみ表示、False.Comboに存在しない値も表示)
    '*
    '*  戻り値　： 一致index
    '*  User Add : Tran Van Mung
    '*********************************************************************************************************
    Public Shared Sub FNC_SHT_CMB_SET(ByRef P1 As Object)
        Dim I As Integer
        Dim Check As Boolean = False
        Try
            Dim Editor As Object = P1.Editor
            Dim Val_Text As String = P1.Text
            If P1.Value Is Nothing Then
                For I = 0 To Editor.Items.Count - 1 Step 1
                    If Editor.Items(I).Value.ToString().Equals(Val_Text) And Editor.Items(I).Visible = True Then
                        P1.Text = Editor.Items(I).Content
                        Check = True
                        Exit For
                    End If
                Next
                If Not Check Then
                    P1.Text = Nothing
                    P1.Value = Nothing
                End If
            End If
        Catch ex As Exception
            Throw ex
        End Try
FNC_EXIT:
        Exit Sub
    End Sub

    ''' *************************************************************************************************************
    ''' <summary>
    ''' エラー詳細を画面表示
    ''' </summary>
    ''' <param name="P1">エラー</param>
    ''' <param name="OP1">SQLコマンド</param>
    ''' <param name="OP2">メッセージ表示有無</param>
    ''' <remarks></remarks>
    ''' *************************************************************************************************************
    Public Shared Sub FNC_ERR_RTN(ByRef P1 As Exception, Optional ByVal OP1 As String = "", Optional ByVal OP2 As Boolean = False)
        Try
            Select Case P1.GetType.Name
                Case "ThreadAbortException"
                    Throw P1
                Case Else
                    If Not OP2 Then
                        MsgBox("【エラー内容 】" _
                                & Microsoft.VisualBasic.ControlChars.CrLf _
                                & P1.Message _
                                & Microsoft.VisualBasic.ControlChars.CrLf _
                                & Microsoft.VisualBasic.ControlChars.CrLf _
                                & IIf(OP1.Equals(""), "", "【ＳＱＬコマンド 】") _
                                & IIf(OP1.Equals(""), "", Microsoft.VisualBasic.ControlChars.CrLf) _
                                & IIf(OP1.Equals(""), "", OP1) _
                                & IIf(OP1.Equals(""), "", Microsoft.VisualBasic.ControlChars.CrLf) _
                                & IIf(OP1.Equals(""), "", Microsoft.VisualBasic.ControlChars.CrLf) _
                                & "【 発生場所 】" _
                                & Microsoft.VisualBasic.ControlChars.CrLf _
                                & P1.StackTrace _
                                & Microsoft.VisualBasic.ControlChars.CrLf _
                                & Microsoft.VisualBasic.ControlChars.CrLf _
                                & "【 発生日時 】" _
                                & Microsoft.VisualBasic.ControlChars.CrLf _
                                & Format(Now(), "yyyy/MM/dd HH:mm:ss"), _
                                MsgBoxStyle.Critical, _
                                "ｴﾗｰ")
                    End If
                    Call FNC_ERR_LOG(P1, OP1)
            End Select
            '
        Catch ex As Threading.ThreadAbortException
            Throw ex
        Catch ex As Exception
            MsgBox("ｴﾗｰﾀﾞｲﾛｸﾞの表示に失敗しました!!:" & ex.Message, MsgBoxStyle.Critical)
        Finally
            '
        End Try
SUB_EXIT:
        Exit Sub
    End Sub

    ''' *************************************************************************************************************
    ''' <summary>
    ''' エラーをログファイルに登録
    ''' </summary>
    ''' <param name="P1">エラー</param>
    ''' <param name="P2">SQLコマンド</param>
    ''' <remarks></remarks>
    ''' *************************************************************************************************************
    Public Shared Sub FNC_ERR_LOG(ByRef P1 As Exception, ByVal P2 As String)
        Dim D_SQL As String
        Try
            D_SQL = "S_SI999A_ACT001 " & _
                    "'" & Utl_Com.FNC_GET_IPS & "'," & _
                    "'" & Replace(P1.Message(), "'", " ") & "'," & _
                    "'" & Replace(P2, "'", " ") & "'," & _
                    "'" & Replace(P1.StackTrace(), "'", " ") & "'," & _
                    "'" & Format(Now(), "yyyy/MM/dd HH:mm:ss") & "'"
            '
            'Utl_Com.P_EXC_DAT = Utl_Rdb.FNC_GET_DAT(D_SQL)
            ''
        Catch ex As Exception
            MsgBox("ｴﾗｰﾛｸﾞの生成に失敗しました!!:" & ex.Message, MsgBoxStyle.Critical)
        Finally
            '
        End Try
SUB_EXIT:
        Exit Sub
    End Sub

    ''' *************************************************************************************************************
    ''' <summary>
    ''' 端末IPアドレス取得
    ''' </summary>
    ''' <returns>IPアドレス</returns>
    ''' <remarks></remarks>
    ''' *************************************************************************************************************
    Public Shared Function FNC_GET_IPS() As String
        Dim D_RTN As String = Nothing
        Try
            'ホスト名を取得
            Dim D_HostName As String = System.Net.Dns.GetHostName
            '
            'IPアドレス等の情報を取得
            Dim D_HostInfo As Net.IPHostEntry = System.Net.Dns.GetHostEntry(D_HostName)
            '
            '複数取れるのでループして表示
            For i As Integer = 0 To D_HostInfo.AddressList.Length - 1
                '
                Dim str1 As String = i.ToString + vbCrLf
                'IPアドレス
                Dim Address As Net.IPAddress = D_HostInfo.AddressList(i)
                '
                'AddressFamilyで区別
                Select Case Address.AddressFamily
                    Case Net.Sockets.AddressFamily.InterNetwork
                        'IP4 (環境によってIP4のアドレスが複数取れる場合があるので注意)
                        str1 += Address.ToString
                        str1 = D_HostInfo.AddressList(i).ToString()
                        '
                        If D_RTN = "" Then
                            D_RTN = str1
                            Exit For
                        End If
                    Case Net.Sockets.AddressFamily.InterNetworkV6
                        'IP6
                        str1 += "ScopeId = " + Address.ScopeId.ToString
                        str1 += ", " + Address.ToString
                    Case Else
                        'その他
                        str1 += "AddressFamily = " + Address.AddressFamily.ToString
                        str1 += ", " + Address.ToString
                End Select
            Next
            '
            If D_RTN = "" Then
                '
                Dim D_IPS As System.Net.IPHostEntry = System.Net.Dns.GetHostEntry(System.Net.Dns.GetHostName())
                D_RTN = D_IPS.AddressList(0).ToString()
            End If
            '
        Catch ex As Exception
            Utl_ERR.FNC_ERR_RTN(ex)
        Finally
            '
        End Try
EXIT_FUNCTION:
        FNC_GET_IPS = D_RTN
        Exit Function
    End Function

    ''' *************************************************************************************************************
    ''' <summary>
    ''' ファイル名編集(ファイル名 + 日時)
    ''' </summary>
    ''' <param name="P1">ファイル名</param>
    ''' <returns>ファイル名</returns>
    ''' <remarks></remarks>
    ''' *************************************************************************************************************
    Public Shared Function FNC_CNV_FIL_NAM(ByVal P1 As String) As String
        '
        Dim D_RTN As String = Nothing
        '
        Try
            P1 = P1.Substring(0, P1.IndexOf(" ["))
            '
            D_RTN = P1 & "_" & Format(Now(), "yyMMdd_HHmmss")
            '
        Catch ex As Exception
            Utl_ERR.FNC_ERR_RTN(ex)
        Finally
            '
        End Try
SUB_EXIT:
        FNC_CNV_FIL_NAM = D_RTN
        Exit Function
    End Function

   
    Private Shared Sub FNC_CONVERT_ROW(ByVal P_row_source As DataRow, ByRef P_row_Result As DataRow)
        For Each col As DataColumn In P_row_source.Table.Columns
            P_row_Result(col.ColumnName) = P_row_source(col.ColumnName)
        Next
    End Sub
    Private Shared Sub FNC_CONVERT_ROW(ByVal P_row_source As DataRow, ByRef P_row_Result As DataRow, ByVal P_detail_Field As List(Of String))
        For Each col As DataColumn In P_row_source.Table.Columns

            If Not P_detail_Field.Contains(col.ColumnName) Then

                P_row_Result(col.ColumnName) = P_row_source(col.ColumnName)
            End If

        Next
    End Sub 
    ''' <summary>
    ''' 指定開始位置から指定バイト数分の文字列を取得
    ''' VB6のMidBの代替
    ''' </summary>
    ''' <param name="P_TargetValue">
    ''' 対象値
    ''' </param>
    ''' <param name="P_StartPosition">
    ''' 指定開始位置
    ''' </param>
    ''' <param name="P_ByteCount">
    ''' 指定バイト数
    ''' </param>
    ''' <returns>
    ''' 編集値
    ''' </returns>
    ''' <remarks></remarks>
    Public Shared Function FNC_VB_MidB _
    ( _
        ByVal P_TargetValue As String _
        , ByVal P_StartPosition As Integer _
        , ByVal P_ByteCount As Integer _
    ) _
    As String

        '戻り値
        Dim D_ReturnValue As String = String.Empty
        'エンコーディング
        Dim D_Encoding As System.Text.Encoding
        'バイト文字
        Dim D_Bytes As Byte()
        '調整文字列
        Dim D_AdjustString As String
        '先頭文字
        Dim D_FirstChar As Char
        '末尾文字
        Dim D_LastChar As Char

        Try

            'エンコーディングを設定
            D_Encoding = System.Text.Encoding.GetEncoding("Shift_JIS")

            '無効値を変換
            P_TargetValue = Utl_Com.FNC_CNV_NUL(P_TargetValue, String.Empty)

            'バイト文字を設定
            D_Bytes = D_Encoding.GetBytes(P_TargetValue)

            '引数.指定開始位置が最大バイト数より後ろだった場合、空文字を戻す
            If P_StartPosition.CompareTo(D_Bytes.Length) > 0 Then
                Exit Try
            End If

            '引数.指定バイト数が最大バイト数を超えないように調整
            If ((P_StartPosition - 1) + P_ByteCount).CompareTo(D_Bytes.Length) > 0 Then
                P_ByteCount = D_Bytes.Length - (P_StartPosition - 1)
            End If

            '指定バイト数取りだし
            D_ReturnValue = D_Encoding.GetString(D_Bytes, P_StartPosition - 1, P_ByteCount)

            '最初の文字が全角の途中で切れていた場合はカット
            D_AdjustString = D_Encoding.GetString(D_Bytes, 0, P_StartPosition)
            D_FirstChar = P_TargetValue(D_AdjustString.Length - 1)
            If Not D_ReturnValue.Equals(String.Empty) _
            AndAlso Not D_FirstChar.Equals(D_ReturnValue(0)) Then
                D_ReturnValue = D_ReturnValue.Substring(1)
            End If

            '最後の文字が全角の途中で切れていた場合はカット
            D_AdjustString = D_Encoding.GetString(D_Bytes, 0, (P_StartPosition - 1) + P_ByteCount)
            D_LastChar = P_TargetValue(D_AdjustString.Length - 1)
            If Not D_ReturnValue.Equals(String.Empty) _
            AndAlso Not D_LastChar.Equals(D_ReturnValue(D_ReturnValue.Length - 1)) Then
                D_ReturnValue = D_ReturnValue.Substring(0, D_ReturnValue.Length - 1)
            End If

        Catch ex As Exception
            Utl_ERR.FNC_ERR_RTN(ex)
        Finally
        End Try

        '戻り値を返す
        Return D_ReturnValue

    End Function

   ''' <summary>
    ''' バイト数の取得
    ''' VB6のLenBの代替
    ''' </summary>
    ''' <param name="P_TargetValue">
    ''' 対象値
    ''' </param>
    ''' <returns>
    ''' バイト数
    ''' </returns>
    ''' <remarks></remarks>
    Public Shared Function FNC_VB_LenB _
    ( _
        ByVal P_TargetValue As String _
    ) _
    As Integer

        '戻り値
        Dim D_ReturnValue As Integer = 0
        'エンコーディング
        Dim D_Encoding As System.Text.Encoding

        Try

            'エンコーディングを設定
            D_Encoding = System.Text.Encoding.GetEncoding("Shift_JIS")

            'バイト数の取得
            P_TargetValue = Utl_Com.FNC_CNV_NUL(P_TargetValue, String.Empty)
            D_ReturnValue = D_Encoding.GetByteCount(P_TargetValue)

        Catch ex As Exception
            Utl_ERR.FNC_ERR_RTN(ex)
        Finally
        End Try

        '戻り値を返す
        Return D_ReturnValue

    End Function

    ''' <summary>
    ''' フォントサイズ調整
    ''' </summary>
    ''' <param name="P_Pattern">
    ''' パターン 必要に応じて拡張して下さい。
    ''' ▼パターン1:下記を基準とした場合。
    ''' フォント種類:等幅太字(= 標準包括)フォント | フォントサイズ:9.75(= 10)pt | 1行表示バイト数:100バイト
    ''' ▼パターン2:下記を基準とした場合。
    ''' フォント種類:等幅太字(= 標準包括)フォント | フォントサイズ:9.75(= 10)pt | 1行表示バイト数:70バイト
    ''' ▼パターン3:下記を基準とした場合。
    ''' フォント種類:等幅太字(= 標準包括)フォント | フォントサイズ:9.75(= 10)pt | 1行表示バイト数:50バイト
    ''' ▼パターン4:下記を基準とした場合。
    ''' フォント種類:等幅太字(= 標準包括)フォント | フォントサイズ:9.75(= 10)pt | 1行表示バイト数:30バイト
    ''' </param>
    ''' <param name="P_TargetFont">
    ''' 対象フォント
    ''' </param>
    ''' <param name="P_TargetValue">
    ''' 対象値
    ''' </param>
    ''' <param name="P_MinFontSize">
    ''' 最小フォントサイズ
    ''' 指定値より小さいフォントサイズにしない。
    ''' 基本的には、その領域を1行で表す場合、文字を識別出来るフォントサイズ。
    ''' </param>
    ''' <param name="P_MaxFontSize">
    ''' 最大フォントサイズ
    ''' 指定値より大きいフォントサイズにしない。
    ''' 基本的には、その領域を1行で表す場合、文字が欠けないフォントサイズ。
    ''' </param>
    ''' <returns>
    ''' フォント
    ''' </returns>
    ''' <remarks>
    ''' 念の為、フォントサイズは下記にする。
    ''' 等幅フォントで半角:全角の比を1:2で保つ為、フォントサイズは1.5で割り切れる値にする。
    ''' </remarks>
    Public Shared Function FNC_AdjustFontSize _
    ( _
        ByVal P_Pattern As Integer _
        , ByVal P_TargetFont As System.Drawing.Font _
        , ByVal P_TargetValue As String _
        , ByVal P_MinFontSize As Single _
        , ByVal P_MaxFontSize As Single _
    ) _
    As System.Drawing.Font

        '戻り値
        Dim D_ReturnValue As System.Drawing.Font = P_TargetFont
        'バイト数
        Dim D_ByteCount As Integer
        'フォントサイズ
        Dim D_FontSize As Single

        Try

            'バイト数を設定
            D_ByteCount = Utl_Com.FNC_VB_LenB(P_TargetValue)

            'フォントサイズを設定
            Select Case P_Pattern
                Case 1
                    'パターン1
                    Select Case D_ByteCount
                        Case Is <= 42
                            '24pt
                            D_FontSize = 24.0F
                        Case 43 To 44
                            '23.25(= 23)pt
                            D_FontSize = 23.25F
                        Case 45 To 46
                            '21.75(= 22)pt
                            D_FontSize = 21.75F
                        Case 47 To 48
                            '21pt
                            D_FontSize = 21.0F
                        Case 49 To 50
                            '20.25(= 20)pt
                            D_FontSize = 20.25F
                        Case 51 To 54
                            '18.75(= 19)pt
                            D_FontSize = 18.75F
                        Case 55 To 56
                            '18pt
                            D_FontSize = 18.0F
                        Case 57 To 58
                            '17.25(= 17)pt
                            D_FontSize = 17.25F
                        Case 59 To 64
                            '15.75(= 16)pt
                            D_FontSize = 15.75F
                        Case 65 To 66
                            '15pt
                            D_FontSize = 15.0F
                        Case 67 To 70
                            '14.25(= 14)pt
                            D_FontSize = 14.25F
                        Case 71 To 80
                            '12.75(= 13)pt
                            D_FontSize = 12.75F
                        Case 81 To 84
                            '12pt
                            D_FontSize = 12.0F
                        Case 85 To 90
                            '11.25(= 11)pt
                            D_FontSize = 11.25F
                        Case 91 To 100
                            '9.75(= 10)pt
                            D_FontSize = 9.75F
                        Case 101 To 110
                            '9pt
                            D_FontSize = 9.0F
                        Case 111 To 120
                            '8.25(= 8)pt
                            D_FontSize = 8.25F
                        Case 121 To 150
                            '6.75(= 7)pt
                            D_FontSize = 6.75F
                        Case Is >= 151
                            '6pt
                            D_FontSize = 6.0F
                    End Select
                Case 2
                    'パターン2
                    Select Case D_ByteCount
                        Case Is <= 30
                            '24pt
                            D_FontSize = 24.0F
                        Case 31 To 31
                            '23.25(= 23)pt
                            D_FontSize = 23.25F
                        Case 32 To 33
                            '21.75(= 22)pt
                            D_FontSize = 21.75F
                        Case 34 To 34
                            '21pt
                            D_FontSize = 21.0F
                        Case 35 To 35
                            '20.25(= 20)pt
                            D_FontSize = 20.25F
                        Case 36 To 38
                            '18.75(= 19)pt
                            D_FontSize = 18.75F
                        Case 39 To 40
                            '18pt
                            D_FontSize = 18.0F
                        Case 41 To 42
                            '17.25(= 17)pt
                            D_FontSize = 17.25F
                        Case 43 To 46
                            '15.75(= 16)pt
                            D_FontSize = 15.75F
                        Case 47 To 48
                            '15pt
                            D_FontSize = 15.0F
                        Case 49 To 50
                            '14.25(= 14)pt
                            D_FontSize = 14.25F
                        Case 51 To 56
                            '12.75(= 13)pt
                            D_FontSize = 12.75F
                        Case 57 To 60
                            '12pt
                            D_FontSize = 12.0F
                        Case 61 To 64
                            '11.25(= 11)pt
                            D_FontSize = 11.25F
                        Case 65 To 74
                            '9.75(= 10)pt
                            D_FontSize = 9.75F
                        Case 75 To 80
                            '9pt
                            D_FontSize = 9.0F
                        Case 81 To 87
                            '8.25(= 8)pt
                            D_FontSize = 8.25F
                        Case 88 To 107
                            '6.75(= 7)pt
                            D_FontSize = 6.75F
                        Case Is >= 108
                            '6pt
                            D_FontSize = 6.0F
                    End Select
                Case 3
                    'パターン3
                    Select Case D_ByteCount
                        Case Is <= 20
                            '24pt
                            D_FontSize = 24.0F
                        Case 21 To 22
                            '23.25(= 23)pt
                            D_FontSize = 23.25F
                        Case 23 To 23
                            '21.75(= 22)pt
                            D_FontSize = 21.75F
                        Case 24 To 24
                            '21pt
                            D_FontSize = 21.0F
                        Case 25 To 25
                            '20.25(= 20)pt
                            D_FontSize = 20.25F
                        Case 26 To 27
                            '18.75(= 19)pt
                            D_FontSize = 18.75F
                        Case 28 To 28
                            '18pt
                            D_FontSize = 18.0F
                        Case 29 To 29
                            '17.25(= 17)pt
                            D_FontSize = 17.25F
                        Case 30 To 32
                            '15.75(= 16)pt
                            D_FontSize = 15.75F
                        Case 33 To 34
                            '15pt
                            D_FontSize = 15.0F
                        Case 35 To 36
                            '14.25(= 14)pt
                            D_FontSize = 14.25F
                        Case 37 To 40
                            '12.75(= 13)pt
                            D_FontSize = 12.75F
                        Case 41 To 43
                            '12pt
                            D_FontSize = 12.0F
                        Case 44 To 45
                            '11.25(= 11)pt
                            D_FontSize = 11.25F
                        Case 46 To 50
                            '9.75(= 10)pt
                            D_FontSize = 9.75F
                        Case 51 To 57
                            '9pt
                            D_FontSize = 9.0F
                        Case 58 To 62
                            '8.25(= 8)pt
                            D_FontSize = 8.25F
                        Case 63 To 76
                            '6.75(= 7)pt
                            D_FontSize = 6.75F
                        Case Is >= 77
                            '6pt
                            D_FontSize = 6.0F
                    End Select
                Case 4
                    'パターン4
                    Select Case D_ByteCount
                        Case Is <= 12
                            '24pt
                            D_FontSize = 24.0F
                        Case 13 To 13
                            '23.25(= 23)pt
                            D_FontSize = 23.25F
                        Case 14 To 14
                            '21.75(= 22)pt
                            D_FontSize = 21.75F
                        Case 14 To 14
                            '21pt
                            D_FontSize = 21.0F
                        Case 15 To 15
                            '20.25(= 20)pt
                            D_FontSize = 20.25F
                        Case 16 To 16
                            '18.75(= 19)pt
                            D_FontSize = 18.75F
                        Case 17 To 17
                            '18pt
                            D_FontSize = 18.0F
                        Case 17 To 17
                            '17.25(= 17)pt
                            D_FontSize = 17.25F
                        Case 18 To 19
                            '15.75(= 16)pt
                            D_FontSize = 15.75F
                        Case 20 To 20
                            '15pt
                            D_FontSize = 15.0F
                        Case 21 To 21
                            '14.25(= 14)pt
                            D_FontSize = 14.25F
                        Case 22 To 24
                            '12.75(= 13)pt
                            D_FontSize = 12.75F
                        Case 25 To 25
                            '12pt
                            D_FontSize = 12.0F
                        Case 26 To 27
                            '11.25(= 11)pt
                            D_FontSize = 11.25F
                        Case 28 To 30
                            '9.75(= 10)pt
                            D_FontSize = 9.75F
                        Case 31 To 34
                            '9pt
                            D_FontSize = 9.0F
                        Case 35 To 37
                            '8.25(= 8)pt
                            D_FontSize = 8.25F
                        Case 38 To 45
                            '6.75(= 7)pt
                            D_FontSize = 6.75F
                        Case Is >= 46
                            '6pt
                            D_FontSize = 6.0F
                    End Select
            End Select

            If D_FontSize.CompareTo(P_MinFontSize) < 0 Then
                '最小フォントサイズより小さい場合
                '最小フォントサイズにする
                D_FontSize = P_MinFontSize
            ElseIf D_FontSize.CompareTo(P_MaxFontSize) > 0 Then
                '最大フォントサイズより大きい場合
                '最大フォントサイズにする
                D_FontSize = P_MaxFontSize
            End If

            '戻り値を設定
            D_ReturnValue = _
            New System.Drawing.Font _
            ( _
                P_TargetFont.FontFamily.Name _
                , D_FontSize _
            )

        Catch ex As Exception
            Utl_ERR.FNC_ERR_RTN(ex)
        Finally
        End Try

        '戻り値を返す
        Return D_ReturnValue

    End Function
    'This comment, after the merge, delete. Merge end.

    ''' <summary>
    ''' データ存在判定
    ''' </summary>
    ''' <param name="P_DataSet">
    ''' データ存在判定用データセット
    ''' </param>
    ''' <returns>
    ''' 有無
    ''' </returns>
    ''' <remarks></remarks>
    Public Shared Function M_ExistsData _
    ( _
        ByVal P_DataSet As System.Data.DataSet _
    ) _
    As Boolean

        '戻り値
        Dim D_Return As Boolean = False

        Try

            'データ存在判定
            If Not IsNothing(P_DataSet) _
            AndAlso P_DataSet.Tables.Count.CompareTo(0) > 0 _
            AndAlso Utl_Com.M_ExistsData(P_DataSet.Tables(0)) Then
                D_Return = True
            End If

        Catch ex As Exception
            Utl_ERR.FNC_ERR_RTN(ex)
        Finally
        End Try

        '戻り値を返す
        Return D_Return

    End Function

    ''' <summary>
    ''' データ存在判定
    ''' </summary>
    ''' <param name="P_DataTable">
    ''' データ存在判定用データテーブル
    ''' </param>
    ''' <returns>
    ''' 有無
    ''' </returns>
    ''' <remarks></remarks>
    Public Shared Function M_ExistsData _
    ( _
        ByVal P_DataTable As System.Data.DataTable _
    ) _
    As Boolean

        '戻り値
        Dim D_Return As Boolean = False

        Try

            'データ存在判定
            If Not IsNothing(P_DataTable) _
            AndAlso P_DataTable.Rows.Count.CompareTo(0) > 0 Then
                D_Return = True
            End If

        Catch ex As Exception
            Utl_ERR.FNC_ERR_RTN(ex)
        Finally
        End Try

        '戻り値を返す
        Return D_Return

    End Function

    ''' <summary>
    ''' データテーブル絞込
    ''' </summary>
    ''' <param name="P_DataTable">
    ''' フィルター用データテーブル
    ''' </param>
    ''' <param name="P_Filter">
    ''' フィルター
    ''' </param>
    ''' <param name="P_Sort">
    ''' ソート
    ''' 不要の場合は、"Nothing"を指定。
    ''' </param>
    ''' <returns>
    ''' データテーブル
    ''' </returns>
    ''' <remarks></remarks>
    Public Shared Function M_FilterDataTable _
    ( _
        ByVal P_DataTable As System.Data.DataTable _
        , ByVal P_Filter As String _
        , ByVal P_Sort As String _
    ) _
    As System.Data.DataTable

        '戻り値
        Dim D_Return As System.Data.DataTable = Nothing
        'データロー
        Dim D_DataRows() As System.Data.DataRow = Nothing

        Try

            If Not IsNothing(P_Sort) Then
                'フィルター＆ソート
                D_DataRows = P_DataTable.Select(P_Filter, P_Sort)
            Else
                'フィルター
                D_DataRows = P_DataTable.Select(P_Filter)
            End If

            If D_DataRows.Count.CompareTo(0) > 0 Then
                'データ有り
                D_Return = D_DataRows.CopyToDataTable()
            Else
                'データ無し
                D_Return = P_DataTable.Clone()
            End If

        Catch ex As Exception
            Utl_ERR.FNC_ERR_RTN(ex)
        Finally
            If Not IsNothing(D_DataRows) Then
                D_DataRows = Nothing
            End If
        End Try

        '戻り値を返す
        Return D_Return

    End Function

    ''' <summary>
    ''' 色等価判定
    ''' </summary>
    ''' <param name="P_Color1">
    ''' 色1
    ''' </param>
    ''' <param name="P_Color2">
    ''' 色2
    ''' </param>
    ''' <returns>
    ''' 判定値
    ''' </returns>
    ''' <remarks></remarks>
    Public Shared Function M_IsEqualsColor _
    ( _
        ByVal P_Color1 As System.Drawing.Color _
        , ByVal P_Color2 As System.Drawing.Color _
    ) _
    As Boolean

        '戻り値
        Dim D_Return As Boolean = False

        Try

            '色等価判定
            D_Return = P_Color1.ToArgb.Equals(P_Color2.ToArgb)

        Catch ex As Exception
            Utl_ERR.FNC_ERR_RTN(ex)
        Finally
        End Try

        '戻り値を返す
        Return D_Return

    End Function

    ''' <summary>
    ''' 1次元配列を2次元配列化
    ''' </summary>
    ''' <param name="P_1Array">
    ''' 1次元配列
    ''' </param>
    ''' <param name="P_SetDimensionNo">
    ''' 設定次元番号
    ''' 1:1番目の次元
    ''' 2:2番目の次元
    ''' </param>
    ''' <returns>
    ''' 2次元配列
    ''' </returns>
    ''' <remarks></remarks>
    Public Shared Function M_1ArrayTo2Array _
    ( _
        ByVal P_1Array() As Object _
        , ByVal P_SetDimensionNo As Integer _
    ) _
    As Object(,)

        '戻り値
        Dim D_Return(,) As Object = Nothing
        'ループ1カウンタ
        Dim D_Loop1 As Integer
        'ループ1開始
        Dim D_Loop1From As Integer
        'ループ1終了
        Dim D_Loop1To As Integer

        Try

            'ループ1を設定
            D_Loop1From = 0
            D_Loop1To = P_1Array.Count - 1

            '1次元配列を2次元配列化
            Select Case P_SetDimensionNo
                Case 1
                    '1番目の次元に設定
                    ReDim D_Return(D_Loop1To, 0)
                    For D_Loop1 = D_Loop1From To D_Loop1To
                        D_Return(D_Loop1, 0) = P_1Array(D_Loop1)
                    Next
                Case 2
                    '2番目の次元に設定
                    ReDim D_Return(0, D_Loop1To)
                    For D_Loop1 = D_Loop1From To D_Loop1To
                        D_Return(0, D_Loop1) = P_1Array(D_Loop1)
                    Next
            End Select

        Catch ex As Exception
            Utl_ERR.FNC_ERR_RTN(ex)
        Finally
        End Try

        '戻り値を返す
        Return D_Return

    End Function

    ''' <summary>
    ''' データ2次元配列化
    ''' </summary>
    ''' <param name="P_DataTable">
    ''' データテーブル
    ''' </param>
    ''' <param name="P_ReplaceCrLf">
    ''' 改行置換
    ''' 不要の場合は、"Nothing"を指定。
    ''' </param>
    ''' <param name="P_IsMakeHeader">
    ''' ヘッダー作成フラグ
    ''' </param>
    ''' <returns>
    ''' 2次元配列
    ''' </returns>
    ''' <remarks></remarks>
    Public Shared Function M_DataTo2Array _
    ( _
        ByVal P_DataTable As System.Data.DataTable _
        , ByVal P_ReplaceCrLf As String _
        , ByVal P_IsMakeHeader As Boolean _
    ) _
    As Object(,)

        '戻り値
        Dim D_Return(,) As Object = Nothing

        Try

            'データ2次元配列化
            D_Return = _
            Utl_Com.M_DataTo2Array _
            ( _
                P_DataTable _
                , P_ReplaceCrLf _
                , P_IsMakeHeader _
                , 0 _
                , P_DataTable.Rows.Count - 1 _
                , 0 _
                , P_DataTable.Columns.Count - 1 _
            )

        Catch ex As Exception
            Utl_ERR.FNC_ERR_RTN(ex)
        Finally
        End Try

        '戻り値を返す
        Return D_Return

    End Function

    ''' <summary>
    ''' データ2次元配列化
    ''' </summary>
    ''' <param name="P_DataTable">
    ''' データテーブル
    ''' </param>
    ''' <param name="P_ReplaceCrLf">
    ''' 改行置換
    ''' 不要の場合は、"Nothing"を指定。
    ''' </param>
    ''' <param name="P_IsMakeHeader">
    ''' ヘッダー作成フラグ
    ''' </param>
    ''' <param name="P_RowIndexFrom">
    ''' 行インデックス開始
    ''' </param>
    ''' <param name="P_RowIndexTo">
    ''' 行インデックス終了
    ''' </param>
    ''' <param name="P_ColumnNameFrom">
    ''' 列名開始
    ''' </param>
    ''' <param name="P_ColumnNameTo">
    ''' 列名終了
    ''' </param>
    ''' <returns>
    ''' 2次元配列
    ''' </returns>
    ''' <remarks>
    ''' From～To通りに設定する。
    ''' </remarks>
    Public Shared Function M_DataTo2Array _
    ( _
        ByVal P_DataTable As System.Data.DataTable _
        , ByVal P_ReplaceCrLf As String _
        , ByVal P_IsMakeHeader As Boolean _
        , ByVal P_RowIndexFrom As Integer _
        , ByVal P_RowIndexTo As Integer _
        , ByVal P_ColumnNameFrom As String _
        , ByVal P_ColumnNameTo As String _
    ) _
    As Object(,)

        '戻り値
        Dim D_Return(,) As Object = Nothing
        '列名
        Dim D_ColumnNames() As String
        '列インデックス開始
        Dim D_ColumnIndexFrom As Integer
        '列インデックス終了
        Dim D_ColumnIndexTo As Integer

        Try

            '列名を設定
            D_ColumnNames = _
            ( _
                From D_Item In P_DataTable.Columns _
                Select CType(D_Item, System.Data.DataColumn).ColumnName _
            ) _
            .ToArray()

            '列インデックスを設定
            D_ColumnIndexFrom = System.Array.IndexOf(D_ColumnNames, P_ColumnNameFrom)
            D_ColumnIndexTo = System.Array.IndexOf(D_ColumnNames, P_ColumnNameTo)

            'データ2次元配列化
            D_Return = _
            Utl_Com.M_DataTo2Array _
            ( _
                P_DataTable _
                , P_ReplaceCrLf _
                , P_IsMakeHeader _
                , P_RowIndexFrom _
                , P_RowIndexTo _
                , D_ColumnIndexFrom _
                , D_ColumnIndexTo _
            )

        Catch ex As Exception
            Utl_ERR.FNC_ERR_RTN(ex)
        Finally
        End Try

        '戻り値を返す
        Return D_Return

    End Function

    ''' <summary>
    ''' データ2次元配列化
    ''' </summary>
    ''' <param name="P_DataTable">
    ''' データテーブル
    ''' </param>
    ''' <param name="P_ReplaceCrLf">
    ''' 改行置換
    ''' 不要の場合は、"Nothing"を指定。
    ''' </param>
    ''' <param name="P_IsMakeHeader">
    ''' ヘッダー作成フラグ
    ''' </param>
    ''' <param name="P_RowIndexFrom">
    ''' 行インデックス開始
    ''' </param>
    ''' <param name="P_RowIndexTo">
    ''' 行インデックス終了
    ''' </param>
    ''' <param name="P_ColumnIndexFrom">
    ''' 列インデックス開始
    ''' </param>
    ''' <param name="P_ColumnIndexTo">
    ''' 列インデックス終了
    ''' </param>
    ''' <returns>
    ''' 2次元配列
    ''' </returns>
    ''' <remarks>
    ''' From～To通りに設定する。
    ''' </remarks>
    Public Shared Function M_DataTo2Array _
    ( _
        ByVal P_DataTable As System.Data.DataTable _
        , ByVal P_ReplaceCrLf As String _
        , ByVal P_IsMakeHeader As Boolean _
        , ByVal P_RowIndexFrom As Integer _
        , ByVal P_RowIndexTo As Integer _
        , ByVal P_ColumnIndexFrom As Integer _
        , ByVal P_ColumnIndexTo As Integer _
    ) _
    As Object(,)

        '戻り値
        Dim D_Return(,) As Object = Nothing
        'ヘッダー行数
        Dim D_HeaderRowCount As Integer
        'セット行インデックス
        Dim D_SetRowIndex As Integer
        'セット列インデックス
        Dim D_SetColumnIndex As Integer
        '行インデックス
        Dim D_RowIndex As Integer
        '行数
        Dim D_RowCount As Integer
        '列インデックス
        Dim D_ColumnIndex As Integer
        '列数
        Dim D_ColumnCount As Integer
        '値
        Dim D_Value As Object

        Try

            'ヘッダー行数を設定
            If P_IsMakeHeader Then
                D_HeaderRowCount = 1
            Else
                D_HeaderRowCount = 0
            End If

            '行数を設定
            D_RowCount = (P_RowIndexTo - P_RowIndexFrom) + 1

            '列数を設定
            D_ColumnCount = (P_ColumnIndexTo - P_ColumnIndexFrom) + 1

            'サイズを設定
            ReDim D_Return(D_HeaderRowCount + D_RowCount - 1, D_ColumnCount - 1)

            If P_IsMakeHeader Then
                'ヘッダー作成フラグが有効の場合

                'ヘッダー
                D_SetColumnIndex = -1
                For D_ColumnIndex = P_ColumnIndexFrom To P_ColumnIndexTo
                    D_SetColumnIndex += 1
                    D_Value = P_DataTable.Columns.Item(D_ColumnIndex).ColumnName
                    D_Return(0, D_SetColumnIndex) = D_Value
                Next
            End If

            '明細
            D_SetRowIndex = -1
            For D_RowIndex = P_RowIndexFrom To P_RowIndexTo
                D_SetRowIndex += 1
                D_SetColumnIndex = -1
                For D_ColumnIndex = P_ColumnIndexFrom To P_ColumnIndexTo
                    D_SetColumnIndex += 1

                    '値を設定
                    D_Value = P_DataTable.Rows.Item(D_RowIndex).Item(D_ColumnIndex)

                    '列の型の判定
                    Select Case P_DataTable.Columns.Item(D_ColumnIndex).DataType.FullName
                        Case "System.Char", "System.String"
                            '文字型
                            If Not IsNothing(P_ReplaceCrLf) Then
                                '改行を置換
                                D_Value = D_Value.ToString.Replace(ControlChars.CrLf, P_ReplaceCrLf)
                                D_Value = D_Value.ToString.Replace(ControlChars.Cr, P_ReplaceCrLf)
                                D_Value = D_Value.ToString.Replace(ControlChars.Lf, P_ReplaceCrLf)
                            End If
                    End Select
                    D_Return(D_HeaderRowCount + D_SetRowIndex, D_SetColumnIndex) = D_Value
                Next
            Next

        Catch ex As Exception
            Utl_ERR.FNC_ERR_RTN(ex)
        Finally
        End Try

        '戻り値を返す
        Return D_Return

    End Function

    ''' <summary>
    ''' プロセス強制終了
    ''' </summary>
    ''' <param name="P_ProcessName">プロセス名</param>
    ''' <param name="P_CheckProcessTimeFrom">チェックプロセス日時開始</param>
    ''' <param name="P_CheckProcessTimeTo">チェックプロセス日時終了</param>
    ''' <remarks></remarks>
    Public Shared Sub M_KillProcess _
    ( _
        ByVal P_ProcessName As String _
        , ByVal P_CheckProcessTimeFrom As Date _
        , ByVal P_CheckProcessTimeTo As Date _
    )

        'プロセス
        Dim D_Processes As System.Diagnostics.Process()
        'プロセス
        Dim D_Process As System.Diagnostics.Process

        Try

            'プロセスを取得
            D_Processes = System.Diagnostics.Process.GetProcessesByName(P_ProcessName)

            If Not IsNothing(D_Processes) _
            AndAlso D_Processes.Count > 0 Then
                'プロセスが存在する場合
                '最新1件のみに限定
                D_Process =
                (
                    From D_Item In D_Processes
                    Where (D_Item.StartTime >= P_CheckProcessTimeFrom) _
                    AndAlso (D_Item.StartTime <= P_CheckProcessTimeTo)
                    Order By D_Item.StartTime Descending
                ) _
                .First()
                If Not IsNothing(D_Process) Then
                    'プロセスが存在する場合
                    'プロセス強制終了
                    D_Process.Kill()
                    D_Process.Close()
                    D_Process.Dispose()
                    D_Process = Nothing
                End If
            End If

        Catch ex As Exception

            Utl_ERR.FNC_ERR_RTN(ex)
        Finally
        End Try

    End Sub
End Class
