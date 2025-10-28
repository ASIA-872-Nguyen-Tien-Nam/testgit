'機能概要********************************************************************************************
'*
'*  処理概要：SQL Server操作
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

'****************************************************************************************************
'*  クラス
'****************************************************************************************************
Public Class Utl_RDB

#Region "■Member Value■"

    '************************************************************************************************
    '*  メンバ変数
    '************************************************************************************************
    Private P_CON As SqlConnection = Nothing '接続
    Private P_CFG As String = Nothing        '接続文字列
    Private P_TIM_OUT As Integer = Nothing   'タイムアウト(秒)

#End Region

#Region "■Constructor■"

    ''' <summary>
    ''' コンストラクタ
    ''' </summary>
    ''' <remarks></remarks>
    Public Sub New()
        Try
            P_CFG = ConfigurationManager.AppSettings("SQL_CON_STR")
            P_CON = Nothing
            P_TIM_OUT = 100000000
            '
            Call FNC_GET_CON()
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
    ''' データベース接続
    ''' </summary>
    ''' <returns>True.接続成功 / False.接続失敗</returns>
    ''' <remarks></remarks>
    Public Function FNC_GET_CON() As Boolean
        Dim D_RTN As Boolean = False '戻値
        '
        Try
            If IsNothing(P_CON) Then
                P_CON = New SqlConnection(P_CFG)
            End If
            '
            If P_CON.State = ConnectionState.Closed OrElse P_CON.State = ConnectionState.Broken Then
                P_CON.Open()
            End If
            '
            D_RTN = True
            '
        Catch ex As Exception
            Call Utl_ERR.FNC_ERR_RTN(ex)
        End Try
        '
EXIT_FUNCTION:
        FNC_GET_CON = D_RTN
        Exit Function
    End Function

    ''' <summary>
    ''' データベース切断
    ''' </summary>
    ''' <returns>True.切断成功 / False.切断失敗</returns>
    ''' <remarks></remarks>
    Public Function FNC_CLS_CON() As Boolean
        Dim D_RTN As Boolean = False
        '
        Try
            If Not IsNothing(P_CON) AndAlso _
               Not (P_CON.State = ConnectionState.Closed OrElse P_CON.State = ConnectionState.Broken) Then
                P_CON.Close()
            End If
            '
            D_RTN = True
            '
        Catch ex As Exception
            Call Utl_ERR.FNC_ERR_RTN(ex)
        End Try
        '
EXIT_FUNCTION:
        Return D_RTN
    End Function

    ''' <summary>
    ''' SELECT文実行
    ''' </summary>
    ''' <param name="P1">DataSet (データ取得用：参照渡)</param>
    ''' <param name="P2">SQL文</param>
    ''' <returns>True:実行成功 / False:実行失敗</returns>
    ''' <remarks>実行結果はP1に格納される</remarks>
    Public Function FNC_SQL_EXE( _
        ByRef P1 As DataSet, _
        ByVal P2 As String _
    ) As Boolean
        Dim D_RTN As Boolean = False
        Dim D_CMD As SqlCommand = Nothing
        Dim D_ADP As SqlDataAdapter = Nothing
        Dim D_STS As Integer = 0
        '
        Try
            If IsNothing(P1) Then
                P1 = New DataSet()
            End If
            '
            Cns_Com.D_DAT = P1
            D_CMD = New SqlCommand(P2, P_CON)
            D_CMD.CommandTimeout = P_TIM_OUT
            D_ADP = New SqlDataAdapter(D_CMD)
            D_STS = D_ADP.Fill(P1)
            D_RTN = True
            '
        Catch ex As Exception
            Call Utl_ERR.FNC_ERR_RTN(ex, P2)
            '
        Finally
            If Not IsNothing(D_ADP) Then
                D_ADP.Dispose()
                D_ADP = Nothing
            End If
            If Not IsNothing(D_CMD) Then
                D_CMD.Dispose()
                D_CMD = Nothing
            End If
        End Try
        '
EXIT_FUNCTION:
        FNC_SQL_EXE = D_RTN
        Exit Function
    End Function

    ''' <summary>
    ''' データの有無確認
    ''' </summary>
    ''' <param name="P1">DataSet</param>
    ''' <param name="P2">存在確認インデックス</param>
    ''' <param name="OP1">True:DataTableの行数が0か確認 / False:DataTableの行数が0かは確認しない [デフォルト：False]</param>
    ''' <returns>True:データ有り / False:データ無し</returns>
    ''' <remarks></remarks>
    Public Function FNC_CHK_DAT( _
        ByVal P1 As DataSet, _
        ByVal P2 As Integer, _
        Optional ByVal OP1 As Boolean = False _
    ) As Boolean
        Dim D_RTN As Boolean = False
        '
        Try
            If IsNothing(P2) Then
                'indexがNULL
                GoTo EXIT_FUNCTION
            Else
                If P2 < 0 Then
                    'indexが負
                    GoTo EXIT_FUNCTION
                End If
            End If
            '
            If IsNothing(P1) Then
                'DataSet自体NULL
                GoTo EXIT_FUNCTION
            Else
                If P1.Tables.Count.Equals(CInt(0)) Then
                    'DataSet内にDataTable無し
                    GoTo EXIT_FUNCTION
                Else
                    If P1.Tables.Count < P2 + 1 Then
                        'DataTable数がindexの数分ない
                        GoTo EXIT_FUNCTION
                    Else
                        If IsNothing(P1.Tables(P2)) Then
                            '指定indexのDataTabelがNULL
                            GoTo EXIT_FUNCTION
                        Else
                            If P1.Tables(P2).Columns.Count.Equals(CInt(0)) Then
                                '列が存在しない
                                GoTo EXIT_FUNCTION
                            Else
                                If OP1 Then
                                    'DataTabelの行数も確認
                                    If P1.Tables(P2).Rows.Count.Equals(CInt(0)) Then
                                        'DataTabelが0行
                                        GoTo EXIT_FUNCTION
                                    Else
                                        D_RTN = True
                                    End If
                                Else
                                    D_RTN = True
                                End If
                            End If
                        End If
                    End If
                End If
            End If
            '
        Catch ex As Exception
            Call Utl_ERR.FNC_ERR_RTN(ex)
        End Try
        '
EXIT_FUNCTION:
        FNC_CHK_DAT = D_RTN
        Exit Function
    End Function

    ''' <summary>
    ''' Null値置換
    ''' </summary>
    ''' <param name="P1">対象値</param>
    ''' <param name="P2">変換値</param>
    ''' <returns>変換値</returns>
    ''' <remarks></remarks>
    Public Function FNC_CNV_NUL(ByVal P1 As Object, ByVal P2 As Object) As Object
        Dim D_RTN As Object = P1
        '
        Try
            If IsDBNull(P1) OrElse IsNothing(P1) Then
                D_RTN = P2
            End If
            '
        Catch ex As Exception
            Call Utl_ERR.FNC_ERR_RTN(ex)
        End Try
        '
EXIT_FUNCTION:
        FNC_CNV_NUL = D_RTN
        Exit Function
    End Function

    ''' <summary>
    ''' シングルクォーテーション変換
    ''' </summary>
    ''' <param name="P1">対象文字列</param>
    ''' <param name="OP1">Unicode対応 (True:対応 / False:非対応)</param>
    ''' <returns>変換文字列</returns>
    ''' <remarks></remarks>
    Public Function FNC_SQL_VAL( _
        ByVal P1 As String, _
        Optional ByVal OP1 As Boolean = True _
    ) As String
        Dim D_RTN As String = ""
        '
        Try
            If IsNothing(P1) Then
                P1 = ""
            End If
            '
            D_RTN = P1.Replace("'", "''")
            'Unicode対応
            If OP1 Then
                D_RTN = "N'" & D_RTN & "'"
            Else
                D_RTN = "'" & D_RTN & "'"
            End If
            '
        Catch ex As Exception
            Call Utl_ERR.FNC_ERR_RTN(ex)
            D_RTN = ""
        End Try
        '
EXIT_FUNCTION:
        FNC_SQL_VAL = D_RTN
        Exit Function
    End Function

    ''' *************************************************************************************************************
    ''' <summary>
    ''' データセット取得
    ''' </summary>
    ''' <param name="P1">SQL文</param>
    ''' <returns>データセット</returns>
    ''' <remarks></remarks>
    ''' *************************************************************************************************************
    Public Function FNC_GET_DAT(ByVal P1 As String) As DataSet
        Dim D_RTN As New DataSet
        Dim D_CMD As SqlCommand = Nothing
        Dim D_ADP As SqlDataAdapter = Nothing
        Dim D_STS As Integer = 0
        Try
            'Trace.WriteLine("■SQL：" & P1)          
            D_CMD = New SqlCommand(P1, P_CON)

            D_CMD.CommandTimeout = 100000000
            D_ADP = New SqlDataAdapter(D_CMD)
            D_STS = D_ADP.Fill(D_RTN)
        Catch ex As Exception
            Utl_ERR.FNC_ERR_RTN(ex, P1)
        Finally
            If Not IsNothing(D_ADP) Then
                D_ADP.Dispose() : D_ADP = Nothing
            End If
            If Not IsNothing(D_CMD) Then
                D_CMD.Dispose() : D_CMD = Nothing
            End If
            ' close connection
            FNC_CLS_CON()

        End Try
FNC_EXIT:
        FNC_GET_DAT = D_RTN
        Exit Function
    End Function

#End Region

End Class
