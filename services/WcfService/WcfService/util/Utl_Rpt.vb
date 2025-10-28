Imports System.IO

Imports OfficeOpenXml
Imports Microsoft.Office.Interop
Imports Microsoft.Office.Interop.Excel

''' 機能概要*****************************************************************************************************
''' <summary>
''' 出力処理
''' </summary>
''' <remarks></remarks>
''' 
''' 作成者  ：山下 2012.12.14
''' 
''' 更新者  ：
''' 更新内容：
''' 
''' *************************************************************************************************************
Public Class Utl_Rpt

    Private Shared _SynchronizingObject As System.ComponentModel.ISynchronizeInvoke

    Private Shared D_DAT As DataSet
    '
    Private Shared D_APP As Excel.Application
    Private Shared D_EXL_BOK As Excel.Workbook
    Private Shared D_EXL_SHT As Excel.Worksheet
    '
    Const D_FON As String = "ＭＳ Ｐゴシック"

    Public Shared Property SynchronizingObject() As System.ComponentModel.ISynchronizeInvoke
        Get
            Return _SynchronizingObject
        End Get
        Set(ByVal P1 As System.ComponentModel.ISynchronizeInvoke)
            _SynchronizingObject = P1
        End Set
    End Property

    Delegate Function ShowDialogDelegate( _
                                ) As System.Windows.Forms.DialogResult

    Delegate Function MsgBoxDelegate( _
                                ByVal Prompt As Object, _
                                ByVal Buttons As MsgBoxStyle, _
                                ByVal Title As Object _
                                ) As MsgBoxResult

    ''' <summary>
    ''' 納品書 濃色
    ''' </summary>
    ''' <remarks></remarks>
    Public Shared MD_DeliverySlipDarkColor As System.Drawing.Color = System.Drawing.Color.SeaGreen

    ''' <summary>
    ''' 納品書 薄色
    ''' </summary>
    ''' <remarks></remarks>
    Public Shared MD_DeliverySlipLightColor As System.Drawing.Color = System.Drawing.Color.LightGreen

    ''' <summary>
    ''' 請求書 濃色
    ''' </summary>
    ''' <remarks></remarks>
    Public Shared MD_BillDarkColor As System.Drawing.Color = System.Drawing.Color.SteelBlue

    ''' <summary>
    ''' 請求書 薄色
    ''' </summary>
    ''' <remarks></remarks>
    Public Shared MD_BillLightColor As System.Drawing.Color = System.Drawing.Color.LightBlue

    ''' <summary>
    ''' 赤伝 濃色
    ''' </summary>
    ''' <remarks></remarks>
    Public Shared MD_RedSlipDarkColor As System.Drawing.Color = System.Drawing.Color.Red

    ''' <summary>
    ''' 赤伝 薄色
    ''' </summary>
    ''' <remarks></remarks>
    Public Shared MD_RedSlipLightColor As System.Drawing.Color = System.Drawing.Color.LightPink

    ''' <summary>
    ''' 領収書 濃色
    ''' </summary>
    ''' <remarks></remarks>
    Public Shared MD_ReceiptDarkColor As System.Drawing.Color = System.Drawing.Color.DimGray

    ''' <summary>
    ''' 領収書 薄色
    ''' </summary>
    ''' <remarks></remarks>
    Public Shared MD_ReceiptLightColor As System.Drawing.Color = System.Drawing.Color.DarkGray

    ''' *************************************************************************************************************
    ''' <summary>
    ''' CSVファイル作成/保存
    ''' </summary>
    ''' <param name="P1">データテーブル</param>
    ''' <param name="P2">ファイル名</param>
    ''' <param name="P3">既定パス</param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    ''' *************************************************************************************************************
    Public Shared Function FNC_SAV_CSV(ByRef P1 As Data.DataTable, ByVal P2 As String, ByVal P3 As String) As Boolean
        Dim D_RTN As Boolean = False
        Dim I As Integer = 0
        Dim D_DAT_HED As String = ""
        Dim D_DAT_DTL As String = ""
        Try
            If IsNothing(P1) OrElse P1.Rows.Count = 0 Then
                MsgBox(Cns_Com.C_MSG_NOT_OUT_DAT, MsgBoxStyle.Information, Cns_Com.C_MOD_RSL_MSG)
                GoTo EXIT_FUNCTION
            End If
            '
            Dim D_STM As Stream = File.Open(P3, FileMode.Create, FileAccess.ReadWrite, FileShare.None)
            '
            Dim D_STM_WIT As New StreamWriter(D_STM, System.Text.Encoding.UTF8)
            '
            For I = 0 To P1.Columns.Count - 1 Step 1
                D_DAT_HED = D_DAT_HED & """" & P1.Columns(I).Caption & ""","
            Next
            '
            D_STM_WIT.WriteLine(Mid(D_DAT_HED, 1, D_DAT_HED.Length - 1))
            '
            I = 0
            For I = 0 To P1.Rows.Count - 1 Step 1
                For X = 0 To P1.Columns.Count - 1 Step 1
                    Select Case P1.Columns(X).DataType.Name
                        Case "Byte", "Int16", "Int32", "Int64", "SByte", "UInt16", "UInt32", "UInt64", "Decimal", "Double", "Single"
                            D_DAT_DTL = D_DAT_DTL & """" & Format(Utl_Com.FNC_CNV_NUL(P1.Rows(I).Item(X), "0"), "##,###,###,##0.##") & ""","
                        Case "DateTime", "TimeSpan"
                            D_DAT_DTL = D_DAT_DTL & """" & Format(Utl_Com.FNC_CNV_NUL(P1.Rows(I).Item(X), Nothing), "yyyy/MM/dd HH:mm:ss") & ""","
                        Case "Byte[]"
                            '空で出力
                            D_DAT_DTL = D_DAT_DTL & """" & ""","
                        Case Else
                            D_DAT_DTL = D_DAT_DTL & """" & Utl_Com.FNC_CNV_NUL(P1.Rows(I).Item(X), "").Replace("""", """""") & ""","
                    End Select
                Next
                D_STM_WIT.WriteLine(Mid(D_DAT_DTL, 1, D_DAT_DTL.Length - 1))
                D_DAT_DTL = ""
            Next
            '
            D_STM_WIT.Flush()
            D_STM_WIT.Close()
            D_STM = Nothing
            D_STM_WIT = Nothing
            '
            'System.Diagnostics.Process.Start(P3)
            '
            D_RTN = True
        Catch ex As Exception
            Utl_ERR.FNC_ERR_RTN(ex)
        End Try
EXIT_FUNCTION:
        FNC_SAV_CSV = D_RTN
        Exit Function
    End Function

    ''' *************************************************************************************************************
    ''' <summary>
    ''' CSVファイル作成/保存
    ''' </summary>
    ''' <param name="P1">データテーブル</param>
    ''' <param name="P2">ファイル名</param>
    ''' <param name="P3">既定パス</param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    ''' *************************************************************************************************************
    Public Shared Function FNC_SAV_CSV_RC280(ByRef P1 As Data.DataTable, ByVal P2 As String, ByVal P3 As String) As Boolean
        Dim D_RTN As Boolean = False
        Dim I As Integer = 0
        Dim D_DAT_HED As String = ""
        Dim D_DAT_DTL As String = ""
        Try
            If IsNothing(P1) OrElse P1.Rows.Count = 0 Then
                MsgBox(Cns_Com.C_MSG_NOT_OUT_DAT, MsgBoxStyle.Information, Cns_Com.C_MOD_RSL_MSG)
                GoTo EXIT_FUNCTION
            End If
            '
            Dim D_STM As Stream = File.Open(P3, FileMode.Create, FileAccess.ReadWrite, FileShare.None)
            '
            Dim D_STM_WIT As New StreamWriter(D_STM, System.Text.Encoding.UTF8)
            '
            'For I = 0 To P1.Columns.Count - 1 Step 1
            '    D_DAT_HED = D_DAT_HED & """" & P1.Columns(I).Caption & ""","
            'Next
            ''
            'D_STM_WIT.WriteLine(Mid(D_DAT_HED, 1, D_DAT_HED.Length - 1))
            '
            I = 0
            For I = 0 To P1.Rows.Count - 1 Step 1
                For X = 0 To P1.Columns.Count - 1 Step 1
                    Select Case P1.Columns(X).DataType.Name
                        Case "Byte", "Int16", "Int32", "Int64", "SByte", "UInt16", "UInt32", "UInt64", "Decimal", "Double", "Single"
                            D_DAT_DTL = D_DAT_DTL & """" & Utl_Com.FNC_CNV_NUL(P1.Rows(I).Item(X), "0") & ""","
                        Case "DateTime", "TimeSpan"
                            D_DAT_DTL = D_DAT_DTL & """" & Format(Utl_Com.FNC_CNV_NUL(P1.Rows(I).Item(X), Nothing), "yyyy/MM/dd HH:mm:ss") & ""","
                        Case "Byte[]"
                            '空で出力
                            D_DAT_DTL = D_DAT_DTL & """" & ""","
                        Case Else
                            D_DAT_DTL = D_DAT_DTL & """" & Utl_Com.FNC_CNV_NUL(P1.Rows(I).Item(X), "").Replace("""", """""") & ""","
                    End Select
                Next
                D_STM_WIT.WriteLine(Mid(D_DAT_DTL, 1, D_DAT_DTL.Length - 1))
                D_DAT_DTL = ""
            Next
            '
            D_STM_WIT.Flush()
            D_STM_WIT.Close()
            D_STM = Nothing
            D_STM_WIT = Nothing
            '
            'System.Diagnostics.Process.Start(P3)
            '
            D_RTN = True
        Catch ex As Exception
            Utl_ERR.FNC_ERR_RTN(ex)
        End Try
EXIT_FUNCTION:
        FNC_SAV_CSV_RC280 = D_RTN
        Exit Function
    End Function

    '    ''' *************************************************************************************************************
    '    ''' <summary>
    '    ''' CSVファイル作成/保存 HungNV Add
    '    ''' </summary>
    '    ''' <param name="P1">データテーブル</param>
    '    ''' <param name="P2">ファイル名</param>
    '    ''' <param name="P3">既定パス</param>
    '    ''' <returns></returns>
    '    ''' <remarks></remarks>
    '    ''' *************************************************************************************************************
    Public Shared Function FNC_SAV_CSV_CUS(ByRef P1 As DataSet, ByVal P2 As String, ByVal P3 As String) As Boolean
        Dim D_RTN As Boolean = False
        Dim I As Integer = 0
        Dim D_DAT_HED As String = ""
        Dim D_DAT_DTL As String = ""
        Try
            '
            If IsNothing(P1) OrElse P1.Tables.Count = 0 Then
                GoTo EXIT_FUNCTION
            End If
            '
            Dim D_STM As Stream = File.Open(P3, FileMode.Create, FileAccess.ReadWrite, FileShare.None)
            '
            Dim enc As System.Text.Encoding = System.Text.Encoding.GetEncoding(932)
            '
            'Dim D_STM_WIT As New StreamWriter(D_STM, New SJIS)
            Dim D_STM_WIT As New StreamWriter(D_STM, enc)
            '
            I = 0
            Dim D_ROW_NUMBER As Integer = 1
            '
            'write header file
            P1.Tables(1).Rows(0).Item(3) = P1.Tables(2).Rows.Count
            D_DAT_DTL = getCSVRow(P1.Tables(1).Rows(0), "00")
            D_STM_WIT.WriteLine(Mid(D_DAT_DTL, 1, D_DAT_DTL.Length - 1))
            D_DAT_DTL = ""

            'write information Tong billing rental (保険/Bao hiem)
            Dim D_TBL_RESULT() As DataRow = Nothing
            Dim D_VIEW As DataView = Nothing

            Dim D_TABL_NEW As Data.DataTable = Nothing
            '
            For D_Y As Integer = 0 To P1.Tables(2).Rows.Count - 1 Step 1

                Dim D_order As String = P1.Tables(2).Rows(D_Y).Item("id_order").ToString()
                '
                D_TABL_NEW = P1.Tables(2).Clone

                D_TABL_NEW.ImportRow(P1.Tables(2).Rows(D_Y))
                '
                Dim D_ITEM_NEW As DataRow = FNC_REMOVE_COLUMN(D_TABL_NEW.Rows(0), D_order)
                '
                D_ROW_NUMBER += 1
                D_ITEM_NEW.Item(1) = D_ROW_NUMBER



                D_DAT_DTL = getCSVRow(D_ITEM_NEW, D_order)
                If ("02".Equals(D_ITEM_NEW.Item("item4"))) Then
                    'only add "," when item4 is 02
                    D_STM_WIT.WriteLine(D_DAT_DTL)
                Else
                    D_STM_WIT.WriteLine(Mid(D_DAT_DTL, 1, D_DAT_DTL.Length - 1))
                End If

                D_DAT_DTL = ""

                D_TABL_NEW.Reset()
            Next

            'write information footer file
            D_DAT_DTL = getCSVRow(P1.Tables(3).Rows(0), "00")
            D_STM_WIT.WriteLine(Mid(D_DAT_DTL, 1, D_DAT_DTL.Length - 1))
            '
            D_STM_WIT.Flush()
            D_STM_WIT.Close()
            D_STM.Dispose()
            D_STM_WIT.Dispose()
            '
            'System.Diagnostics.Process.Start(P3)
            '
            D_RTN = True
        Catch ex As Exception
            Utl_ERR.FNC_ERR_RTN(ex)
        End Try
EXIT_FUNCTION:
        FNC_SAV_CSV_CUS = D_RTN
        Exit Function
    End Function

    Private Shared Function FNC_REMOVE_COLUMN(D_DataRow As DataRow, D_order As String)
        Try
            D_DataRow.Table.Columns.Remove("rental_ym")
            D_DataRow.Table.Columns.Remove("client_cd")
            D_DataRow.Table.Columns.Remove("rental_ym_index")
            D_DataRow.Table.Columns.Remove("id_order")
            D_DataRow.Table.Columns.Remove("id_index")
            Select Case D_order
                Case "02", "03"
                    For D_I As Integer = 15 To 58
                        D_DataRow.Table.Columns.Remove("item" + D_I.ToString)
                    Next
                Case "05"
                    For D_I As Integer = 21 To 58
                        D_DataRow.Table.Columns.Remove("item" + D_I.ToString)
                    Next
                Case "06"
                    For D_I As Integer = 41 To 58
                        D_DataRow.Table.Columns.Remove("item" + D_I.ToString)
                    Next
            End Select
            '
            Return D_DataRow
        Catch ex As Exception
            Utl_ERR.FNC_ERR_RTN(ex)
        End Try
EXIT_FUNCTION:
        FNC_REMOVE_COLUMN = D_DataRow
    End Function


    ''' <summary>
    ''' HungNV add
    ''' get csv from row
    ''' </summary>
    ''' <param name="P1">row to get value</param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Shared Function getCSVRow_Header(ByVal P1 As DataRow)
        Dim D_DAT_DTL As String = String.Empty
        For X = 0 To P1.Table.Columns.Count - 1 Step 1
            Select Case P1.Table.Columns(X).DataType.Name
                Case "Byte", "Int16", "Int32", "Int64", "SByte", "UInt16", "UInt32", "UInt64", "Decimal", "Double", "Single"
                    If P1.Item(X).ToString.Equals("1") Then
                        D_DAT_DTL = D_DAT_DTL & P1.Item(X) & ","
                    Else
                        D_DAT_DTL = D_DAT_DTL & """" & Format(Utl_Com.FNC_CNV_NUL(P1.Item(X), "0"), "###0").Trim() & ""","
                    End If
                    'D_DAT_DTL = D_DAT_DTL & """" & Format(Utl_Com.FNC_CNV_NUL(P1.Item(X), "0"), "###0").Trim() & ""","

                Case "DateTime", "TimeSpan"
                    D_DAT_DTL = D_DAT_DTL & """" & Format(Utl_Com.FNC_CNV_NUL(P1.Item(X), Nothing), "yyyy/MM/dd HH:mm:ss") & ""","
                Case "Byte[]"
                    '空で出力
                    D_DAT_DTL = D_DAT_DTL & """" & ""","
                Case Else
                    D_DAT_DTL = D_DAT_DTL & """" & Utl_Com.FNC_CNV_NUL(P1.Item(X), "").Replace("""", """""") & ""","
            End Select
        Next

        Return D_DAT_DTL
    End Function

    ''' <summary>
    ''' HungNV add
    ''' get csv from row
    ''' </summary>
    ''' <param name="P1">row to get value</param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Shared Function getCSVRow(ByVal P1 As DataRow, D_order As String)
        Dim D_DAT_DTL As String = String.Empty
        For X = 0 To P1.Table.Columns.Count - 1 Step 1
            Select Case D_order
                Case "02", "03"
                    If (X = 9 OrElse X = 10 OrElse X = 11 OrElse X = 12 OrElse X = 13) Then
                        D_DAT_DTL = D_DAT_DTL & Format(Convert.ToInt32(Utl_Com.FNC_CNV_NUL(P1.Item(X), "0")), "###0").Trim() & ","
                    Else
                        Select Case P1.Table.Columns(X).DataType.Name
                            Case "Byte", "Int16", "Int32", "Int64", "SByte", "UInt16", "UInt32", "UInt64", "Decimal", "Double", "Single"
                                D_DAT_DTL = D_DAT_DTL & """" & Format(Utl_Com.FNC_CNV_NUL(P1.Item(X), 0), "###0").Trim() & ""","
                            Case "DateTime", "TimeSpan"
                                D_DAT_DTL = D_DAT_DTL & """" & Format(Utl_Com.FNC_CNV_NUL(P1.Item(X), Nothing), "yyyy/MM/dd HH:mm:ss") & ""","
                            Case "Byte[]"
                                '空で出力
                                D_DAT_DTL = D_DAT_DTL & """" & ""","
                            Case Else
                                D_DAT_DTL = D_DAT_DTL & """" & Utl_Com.FNC_CNV_NUL(P1.Item(X), "").Replace("""", """""") & ""","
                        End Select
                    End If
                Case "04"
                    If (X = 27 OrElse X = 28 OrElse X = 30 OrElse X = 31 OrElse X = 32 OrElse X = 33 OrElse X = 34 OrElse X = 35 OrElse X = 36 OrElse X = 40 OrElse X = 41 OrElse _
                        X = 42 OrElse X = 46 OrElse X = 47 OrElse X = 48 OrElse X = 52 OrElse X = 53 OrElse X = 54) Then
                        '
                        D_DAT_DTL = D_DAT_DTL & Format(Convert.ToInt32(Utl_Com.FNC_CNV_NUL(P1.Item(X), 0)), "###0").Trim() & ","
                    Else
                        Select Case P1.Table.Columns(X).DataType.Name
                            Case "Byte", "Int16", "Int32", "Int64", "SByte", "UInt16", "UInt32", "UInt64", "Decimal", "Double", "Single"
                                D_DAT_DTL = D_DAT_DTL & """" & Format(Utl_Com.FNC_CNV_NUL(P1.Item(X), "0"), "###0").Trim() & ""","
                            Case "DateTime", "TimeSpan"
                                D_DAT_DTL = D_DAT_DTL & """" & Format(Utl_Com.FNC_CNV_NUL(P1.Item(X), Nothing), "yyyy/MM/dd HH:mm:ss") & ""","
                            Case "Byte[]"
                                '空で出力
                                D_DAT_DTL = D_DAT_DTL & """" & ""","
                            Case Else
                                D_DAT_DTL = D_DAT_DTL & """" & Utl_Com.FNC_CNV_NUL(P1.Item(X), "").Replace("""", """""") & ""","
                        End Select
                    End If
                Case "05"
                    If (X = 10 OrElse X = 11 OrElse X = 12 OrElse X = 13 OrElse X = 14 OrElse X = 15 OrElse X = 16 OrElse X = 17 OrElse X = 18) Then
                        '
                        D_DAT_DTL = D_DAT_DTL & Format(Convert.ToInt32(Utl_Com.FNC_CNV_NUL(P1.Item(X), 0)), "###0").Trim() & ","
                    Else
                        Select Case P1.Table.Columns(X).DataType.Name
                            Case "Byte", "Int16", "Int32", "Int64", "SByte", "UInt16", "UInt32", "UInt64", "Decimal", "Double", "Single"
                                D_DAT_DTL = D_DAT_DTL & """" & Format(Utl_Com.FNC_CNV_NUL(P1.Item(X), "0"), "###0").Trim() & ""","
                            Case "DateTime", "TimeSpan"
                                D_DAT_DTL = D_DAT_DTL & """" & Format(Utl_Com.FNC_CNV_NUL(P1.Item(X), Nothing), "yyyy/MM/dd HH:mm:ss") & ""","
                            Case "Byte[]"
                                '空で出力
                                D_DAT_DTL = D_DAT_DTL & """" & ""","
                            Case Else
                                D_DAT_DTL = D_DAT_DTL & """" & Utl_Com.FNC_CNV_NUL(P1.Item(X), "").Replace("""", """""") & ""","
                        End Select
                    End If
                Case "06"
                    If (X = 9 OrElse X = 10 OrElse X = 11 OrElse X = 12 OrElse X = 13 OrElse X = 14 OrElse X = 15 OrElse X = 16 OrElse X = 17 OrElse X = 18 OrElse X = 19 OrElse _
                        X = 20 OrElse X = 21 OrElse X = 22 OrElse X = 23 OrElse X = 24 OrElse X = 25 OrElse X = 26 OrElse X = 27 OrElse X = 28 OrElse X = 29 OrElse X = 30 OrElse _
                        X = 31 OrElse X = 32 OrElse X = 33 OrElse X = 34 OrElse X = 35 OrElse X = 36 OrElse X = 37 OrElse X = 38 OrElse X = 39) Then
                        '
                        D_DAT_DTL = D_DAT_DTL & Format(Convert.ToInt32(Utl_Com.FNC_CNV_NUL(P1.Item(X), 0)), "###0").Trim() & ","
                    Else
                        Select Case P1.Table.Columns(X).DataType.Name
                            Case "Byte", "Int16", "Int32", "Int64", "SByte", "UInt16", "UInt32", "UInt64", "Decimal", "Double", "Single"
                                D_DAT_DTL = D_DAT_DTL & """" & Format(Utl_Com.FNC_CNV_NUL(P1.Item(X), "0"), "###0").Trim() & ""","
                            Case "DateTime", "TimeSpan"
                                D_DAT_DTL = D_DAT_DTL & """" & Format(Utl_Com.FNC_CNV_NUL(P1.Item(X), Nothing), "yyyy/MM/dd HH:mm:ss") & ""","
                            Case "Byte[]"
                                '空で出力
                                D_DAT_DTL = D_DAT_DTL & """" & ""","
                            Case Else
                                D_DAT_DTL = D_DAT_DTL & """" & Utl_Com.FNC_CNV_NUL(P1.Item(X), "").Replace("""", """""") & ""","
                        End Select
                    End If
                Case Else
                    Select Case P1.Table.Columns(X).DataType.Name
                        Case "Byte", "Int16", "Int32", "Int64", "SByte", "UInt16", "UInt32", "UInt64", "Decimal", "Double", "Single"
                            D_DAT_DTL = D_DAT_DTL & """" & Format(Utl_Com.FNC_CNV_NUL(P1.Item(X), "0"), "###0").Trim() & ""","
                        Case "DateTime", "TimeSpan"
                            D_DAT_DTL = D_DAT_DTL & """" & Format(Utl_Com.FNC_CNV_NUL(P1.Item(X), Nothing), "yyyy/MM/dd HH:mm:ss") & ""","
                        Case "Byte[]"
                            '空で出力
                            D_DAT_DTL = D_DAT_DTL & """" & ""","
                        Case Else
                            D_DAT_DTL = D_DAT_DTL & """" & Utl_Com.FNC_CNV_NUL(P1.Item(X), "").Replace("""", """""") & ""","
                    End Select
            End Select
        Next

        Return D_DAT_DTL
    End Function

    'This comment, after the merge, delete. Merge end.

    ''' *************************************************************************************************************
    ''' <summary>
    ''' CSVファイル作成/保存
    ''' </summary>
    ''' <param name="P1">データテーブル</param>
    ''' <param name="P2">ファイル名</param>
    ''' <param name="P3">既定パス</param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    ''' *************************************************************************************************************
    Public Shared Function FNC_SAV_CSV2(ByRef P1 As Data.DataTable, ByVal P2 As String, ByVal P3 As String) As Boolean
        Dim D_RTN As Boolean = False
        Dim I As Integer = 0
        Dim D_DAT_HED As String = ""
        Dim D_DAT_DTL As String = ""
        Try
            If IsNothing(P1) OrElse P1.Rows.Count = 0 Then
                MsgBox(Cns_Com.C_MSG_NOT_OUT_DAT, MsgBoxStyle.Information, Cns_Com.C_MOD_RSL_MSG)
                GoTo EXIT_FUNCTION
            End If
            '
            Dim D_STM As Stream = File.Open(P3, FileMode.Create, FileAccess.ReadWrite, FileShare.None)
            '
            Dim D_STM_WIT As New StreamWriter(D_STM, System.Text.Encoding.UTF8)
            '
            For I = 0 To P1.Columns.Count - 1 Step 1
                D_DAT_HED = D_DAT_HED & """" & P1.Columns(I).Caption & ""","
            Next
            '
            D_STM_WIT.WriteLine(Mid(D_DAT_HED, 1, D_DAT_HED.Length - 1))
            '
            I = 0
            For I = 0 To P1.Rows.Count - 1 Step 1
                For X = 0 To P1.Columns.Count - 1 Step 1
                    Select Case P1.Columns(X).DataType.Name
                        Case "Byte", "Int16", "Int32", "Int64", "SByte", "UInt16", "UInt32", "UInt64", "Decimal", "Double", "Single"
                            D_DAT_DTL = D_DAT_DTL & (Utl_Com.FNC_CNV_NUL(P1.Rows(I).Item(X), "")) & ","
                        Case "DateTime", "TimeSpan"
                            D_DAT_DTL = D_DAT_DTL & """" & Format(Utl_Com.FNC_CNV_NUL(P1.Rows(I).Item(X), Nothing), "yyyy/MM/dd") & ""","
                        Case "Byte[]"
                            '空で出力
                            D_DAT_DTL = D_DAT_DTL & """" & ""","
                        Case Else
                            D_DAT_DTL = D_DAT_DTL & """" & Utl_Com.FNC_CNV_NUL(P1.Rows(I).Item(X), "").Replace("""", """""") & ""","
                    End Select
                Next
                D_STM_WIT.WriteLine(Mid(D_DAT_DTL, 1, D_DAT_DTL.Length - 1))
                D_DAT_DTL = ""
            Next
            '
            D_STM_WIT.Flush()
            D_STM_WIT.Close()
            D_STM = Nothing
            D_STM_WIT = Nothing
            '
            'System.Diagnostics.Process.Start(P3)
            '
            D_RTN = True
        Catch ex As Exception
            Utl_ERR.FNC_ERR_RTN(ex)
        End Try
EXIT_FUNCTION:
        FNC_SAV_CSV2 = D_RTN
        Exit Function
    End Function

    '*********************************************************************************************************
    '*
    '*  処理概要：OUTPUT EXCEL (XLX)
    '*
    '*  引数　　: 1.type
    '*            2.SQL sentence
    '*            3.file name?
    '*            4.file name?
    '*            5.file name?
    '*
    '*  戻り値　：：1.status
    '*        　  2.temporary file name
    '*
    '*********************************************************************************************************
    Public Shared Function FNC_OUP_EXEL( _
        ByVal P_Type As String(), _
        ByVal P_SQL As String(), _
        ByVal P_Name As String(), _
        ByVal P_Name_TEM As String, _
        ByVal P_Name_SAVE As String
    ) As String
        Dim D_PDF As Utl_PDF = Nothing
        Dim D_UTL_RDB As Utl_RDB = Nothing

        Dim D_Return As Boolean = False
        Dim D_ROW_CNT As Integer = 0
        Dim i As Integer = 0
        Dim D_FullName As String = ""
        Dim D_File_Name As String = ""
        Dim D_EXL_TML As String = ""
        Dim D_Row As Integer = 0
        Dim D_Name As String = ""
        Dim D_status As String = "200"
        Dim D_clum_cnt As Integer = 0
        '
        Dim D_File_Log As String = ""
        '
        Try
            '
            D_UTL_RDB = New Utl_RDB()
            D_PDF = New Utl_PDF()
            '
            Dim D_SQL As String = P_SQL(0).ToString '& ",'" & P4 & "'"
            '
            D_DAT = New DataSet
            D_DAT = D_UTL_RDB.FNC_GET_DAT(D_SQL)
            '
            If D_DAT Is Nothing Then
                GoTo EXIT_FUNCTION
            End If
            '
            If D_DAT.Tables(0).Rows.Count = 0 Then
                '
                GoTo EXIT_FUNCTION
            End If
            '
            D_EXL_TML = ConfigurationManager.AppSettings("FIL_TEM_EXL") & P_Name_TEM
            D_File_Log = ConfigurationManager.AppSettings("FIL_LOG")
            '
            D_Name = P_Name_SAVE & System.Guid.NewGuid.ToString() & Format(Date.Now, "yyyyMMddHHmmss")
            '
            D_File_Name = D_Name & ".xls"
            '
            D_FullName = D_PDF.FNC_GET_DIR & D_File_Name
            '
            'Copy the excel template to other one               
            FileCopy(D_EXL_TML, D_FullName)
            '
            D_APP = New Excel.Application 'ApplicationClass
            D_APP.DisplayAlerts = False
            '
            D_EXL_BOK = D_APP.Workbooks.Open(D_FullName)

            D_EXL_SHT = D_EXL_BOK.Sheets(1)
            '
            'Excel セルコレクションを設定
            D_EXL_SHT.Cells.Font.Name = D_FON
            '
            'GoTo EXIT_FUNCTION
            D_ROW_CNT = D_DAT.Tables(0).Rows.Count
            '
            'Header
            For i = 0 To D_ROW_CNT - 1
                '
                'DETAIL
                D_clum_cnt = D_DAT.Tables(0).Columns.Count

                For j = 0 To D_clum_cnt - 1

                    D_EXL_SHT.Cells(D_Row + 2, j + 1) = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item(j), "")
                Next
                '
                'Copy row
                D_EXL_SHT.Rows("2").Copy()
                D_EXL_SHT.Rows(D_Row + 3).Insert()
                D_EXL_SHT.Rows(D_Row + 3).Select()
                D_EXL_SHT.Paste()
                '
                D_Row += 1

            Next
            '
            D_EXL_SHT.Rows(D_Row + 2).Delete()
            '
            D_EXL_SHT.Cells(1, 1).Activate()
            ' D_EXL_SHT()
            D_EXL_SHT.Columns.AutoFit()

            ''Save file
            If Not D_APP Is Nothing Then
                D_EXL_BOK.SaveAs(D_FullName)
                D_EXL_BOK.Activate()
                D_EXL_BOK.Close()
                D_APP.Quit()
            End If
            D_Return = True
            '
        Catch ex As Exception

            Utl_ERR.FNC_ERR_RTN(ex)
            D_status = "201"
        Finally
            D_DAT.Clear()
            '
            If Not D_EXL_SHT Is Nothing Then
                System.Runtime.InteropServices.Marshal.ReleaseComObject(D_EXL_SHT)
            End If
            If Not D_EXL_BOK Is Nothing Then
                System.Runtime.InteropServices.Marshal.ReleaseComObject(D_EXL_BOK)
            End If
            If Not D_APP Is Nothing Then
                System.Runtime.InteropServices.Marshal.ReleaseComObject(D_APP)
            End If
        End Try
EXIT_FUNCTION:
        FNC_OUP_EXEL = "{" + """" + "status" + """" + ":" + D_status + "," + """" + "filename" + """" + ":" + """" + D_FullName + """" + "}"
        Exit Function

    End Function
    '*********************************************************************************************************
    '*
    '*  処理概要：OUTPUT EXCEL (XLSX)
    '*
    '*  引数　　: 1.type
    '*            2.SQL sentence
    '*            3.file name?
    '*            4.file name?
    '*            5.file name?
    '*
    '*  戻り値　：：1.status
    '*        　  2.temporary file name
    '*
    '*********************************************************************************************************

    Public Shared Function FNC_OUP_EXEL_XLSX( _
        ByVal P_Type As String(), _
        ByVal P_SQL As String(), _
        ByVal P_Name As String(), _
        ByVal P_Name_TEM As String, _
        ByVal P_Name_SAVE As String
    ) As String
        Dim D_PDF As Utl_PDF = Nothing
        Dim D_UTL_RDB As Utl_RDB = Nothing

        Dim D_Return As Boolean = False
        Dim D_ROW_CNT As Integer = 0
        Dim i As Integer = 0
        Dim D_FullName As String = ""
        Dim D_File_Name As String = ""
        Dim D_EXL_TML As String = ""
        Dim D_Row As Integer = 0
        Dim D_Name As String = ""
        Dim D_status As String = "200"
        Dim D_clum_cnt As Integer = 0
        '
        Dim D_File_Log As String = ""
        '
        Try
            '
            D_UTL_RDB = New Utl_RDB()
            D_PDF = New Utl_PDF()
            '
            Dim D_SQL As String = P_SQL(0).ToString '& ",'" & P4 & "'"
            '
            D_DAT = New DataSet
            D_DAT = D_UTL_RDB.FNC_GET_DAT(D_SQL)
            '
            If D_DAT Is Nothing Then
                GoTo EXIT_FUNCTION
            End If
            '
            If D_DAT.Tables(0).Rows.Count = 0 Then
                '
                GoTo EXIT_FUNCTION
            End If
            '
            D_EXL_TML = ConfigurationManager.AppSettings("FIL_TEM_EXL") & P_Name_TEM
            D_File_Log = ConfigurationManager.AppSettings("FIL_LOG")
            '
            D_Name = P_Name_SAVE & System.Guid.NewGuid.ToString() & Format(Date.Now, "yyyyMMddHHmmss")
            '
            D_File_Name = D_Name & ".xlsx"
            '
            D_FullName = D_PDF.FNC_GET_DIR & D_File_Name
            '
            'Copy the excel template to other one               
            FileCopy(D_EXL_TML, D_FullName)
            '
            D_APP = New Excel.Application 'ApplicationClass
            D_APP.DisplayAlerts = False
            '
            D_EXL_BOK = D_APP.Workbooks.Open(D_FullName)

            D_EXL_SHT = D_EXL_BOK.Sheets(1)
            '
            'Excel セルコレクションを設定
            D_EXL_SHT.Cells.Font.Name = D_FON
            '
            'GoTo EXIT_FUNCTION
            D_ROW_CNT = D_DAT.Tables(0).Rows.Count
            '
            'Header
            For i = 0 To D_ROW_CNT - 1
                '
                'DETAIL
                D_clum_cnt = D_DAT.Tables(0).Columns.Count

                For j = 0 To D_clum_cnt - 1
                    D_EXL_SHT.Cells(D_Row + 2, j + 1) = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item(j), "")
                Next
                '
                'Copy row
                D_EXL_SHT.Rows("2").Copy()
                D_EXL_SHT.Rows(D_Row + 3).Insert()
                D_EXL_SHT.Rows(D_Row + 3).Select()
                D_EXL_SHT.Paste()
                '
                D_Row += 1
            Next
            '
            D_EXL_SHT.Rows(D_Row + 2).Delete()
            '
            D_EXL_SHT.Cells(1, 1).Activate()
            ' D_EXL_SHT()
            D_EXL_SHT.Columns.AutoFit()

            ''Save file
            If Not D_APP Is Nothing Then
                D_EXL_BOK.SaveAs(D_FullName)
                D_EXL_BOK.Activate()
                D_EXL_BOK.Close()
                D_APP.Quit()
            End If
            '
            D_Return = True
            '
        Catch ex As Exception
            Utl_ERR.FNC_ERR_RTN(ex)
            D_status = "201"
            '
        Finally
            D_DAT.Clear()
            '
            If Not D_EXL_SHT Is Nothing Then
                System.Runtime.InteropServices.Marshal.ReleaseComObject(D_EXL_SHT)
            End If
            If Not D_EXL_BOK Is Nothing Then
                System.Runtime.InteropServices.Marshal.ReleaseComObject(D_EXL_BOK)
            End If
            If Not D_APP Is Nothing Then
                System.Runtime.InteropServices.Marshal.ReleaseComObject(D_APP)
            End If
        End Try
EXIT_FUNCTION:
        FNC_OUP_EXEL_XLSX = "{" + """" + "status" + """" + ":" + D_status + "," + """" + "filename" + """" + ":" + """" + D_FullName + """" + "}"
        Exit Function

    End Function

    '*********************************************************************************************************
    '*
    '*  処理概要：OUTPUT EXCEL2(batch copy)
    '*
    '*  引数　　：1.type
    '*            2.SQL sentence
    '*            3.file name?
    '*            4.file name?
    '*            5.file name?
    '*
    '*  戻り値　：1.status
    '*        　  2.temporary file name
    '*
    '*  参考　　：http://www.wednesdaymoon.net/kzweb/articles/vbnet/article.aspx?articleid=81
    '*
    '*********************************************************************************************************
    Public Shared Function FNC_OUP_EXEL2 _
    ( _
        ByVal P_Type As String(), _
        ByVal P_SQL As String(), _
        ByVal P_Name As String(), _
        ByVal P_Name_TEM As String, _
        ByVal P_Name_SAVE As String
    ) _
    As String

        Dim D_PDF As Utl_PDF = Nothing
        Dim D_UTL_RDB As Utl_RDB = Nothing

        Dim D_Return As Boolean = False
        Dim D_ROW_CNT As Integer = 0
        Dim i As Integer = 0
        Dim D_FullName As String = ""
        Dim D_File_Name As String = ""
        Dim D_EXL_TML As String = ""
        Dim D_Row As Integer = 0
        Dim D_Name As String = ""
        Dim D_status As String = "200"
        Dim D_CLM_CNT As Integer = 0

        Dim D_APP As Excel.Application = Nothing
        Dim D_EXL_BOOKS As Excel.Workbooks = Nothing
        Dim D_EXL_BOK As Excel.Workbook = Nothing
        Dim D_EXL_SHEETS As Excel.Sheets = Nothing
        Dim D_EXL_SHT As Excel.Worksheet = Nothing
        Dim D_EXL_CELLS As Excel.Range = Nothing

        '
        Dim D_RNG As Excel.Range = Nothing
        Dim D_RNG_STT As Excel.Range = Nothing
        Dim D_RNG_END As Excel.Range = Nothing

        Dim D_EXL_FONT As Excel.Font = Nothing
        '
        Dim D_File_Log As String = ""

        '---------- ↓プロセス関連↓ ----------
        'チェックプロセス日時開始
        Dim D_CheckProcessTimeFrom As Date
        'チェックプロセス日時終了
        Dim D_CheckProcessTimeTo As Date
        '---------- ↑プロセス関連↑ ----------

        '
        Try
            '
            D_UTL_RDB = New Utl_RDB()
            D_PDF = New Utl_PDF()
            '
            Dim D_SQL As String = P_SQL(0).ToString '& ",'" & P4 & "'"
            '
            'Trace Log SQL
            Utl_ERR.WriteLogFile(D_SQL, P_Name(0).ToString(), False)
            ' End Trace
            D_DAT = New DataSet
            D_DAT = D_UTL_RDB.FNC_GET_DAT(D_SQL)
            '
            If D_DAT Is Nothing Then
                GoTo EXIT_FUNCTION
            End If
            '
            If D_DAT.Tables(0).Rows.Count = 0 Then
                D_status = "203"
                '
                GoTo EXIT_FUNCTION
            End If
            '
            D_EXL_TML = ConfigurationManager.AppSettings("FIL_TEM_EXL") & P_Name_TEM
            D_File_Log = ConfigurationManager.AppSettings("FIL_LOG")
            '
            D_Name = P_Name_SAVE & System.Guid.NewGuid.ToString() & Format(Date.Now, "yyyyMMddHHmmss")
            '
            D_File_Name = D_Name & ".xlsx"
            '
            D_FullName = D_PDF.FNC_GET_DIR & D_File_Name
            '
            'Copy the excel template to other one               
            FileCopy(D_EXL_TML, D_FullName)
            '
            'チェックプロセス日時開始を設定
            D_CheckProcessTimeFrom = Now
            D_APP = New Excel.Application
            'チェックプロセス日時終了を設定
            D_CheckProcessTimeTo = Now
            D_APP.DisplayAlerts = False
            '
            D_EXL_BOOKS = D_APP.Workbooks
            D_EXL_BOK = D_EXL_BOOKS.Open(D_FullName)
            '
            D_EXL_SHEETS = D_EXL_BOK.Worksheets
            D_EXL_SHT = D_EXL_SHEETS.Item(1)
            '
            'Excel セルコレクションを設定
            D_EXL_CELLS = D_EXL_SHT.Cells
            '
            D_EXL_FONT = D_EXL_CELLS.Font
            D_EXL_FONT.Name = D_FON
            '
            D_ROW_CNT = D_DAT.Tables(0).Rows.Count
            D_CLM_CNT = D_DAT.Tables(0).Columns.Count
            '
            Dim D_TMP_DAT(D_ROW_CNT - 1, D_CLM_CNT - 1) 'As String
            '
            For i = 0 To D_ROW_CNT - 1
                For j = 0 To D_CLM_CNT - 1
                    D_TMP_DAT(i, j) = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item(j), "")
                Next
            Next

            '
            D_RNG_STT = DirectCast(D_EXL_CELLS.Item(2, 1), Excel.Range)
            D_RNG_END = DirectCast(D_EXL_CELLS.Item(D_ROW_CNT + 1, D_CLM_CNT), Excel.Range)
            '
            D_RNG = D_EXL_SHT.Range(D_RNG_STT, D_RNG_END)
            D_RNG.Value = D_TMP_DAT
            Utl_Rpt.FNC_ReleaseCOMObject(D_RNG)
            '
            D_RNG = D_EXL_CELLS.Item(1, 1)
            D_RNG.Activate()
            Utl_Rpt.FNC_ReleaseCOMObject(D_RNG)

            ' D_EXL_SHT()
            D_RNG = D_EXL_SHT.Columns
            D_RNG.AutoFit()
            Utl_Rpt.FNC_ReleaseCOMObject(D_RNG)

            Select Case P_Type(0)
                Case "MS091"
                    D_RNG = D_EXL_SHT.Range("AG1")
                    D_RNG.ColumnWidth = 12
                Case "MS151"
                    D_RNG = D_EXL_SHT.Range("F1")
                    D_RNG.ColumnWidth = 12
                Case "MS341"
                    D_RNG = D_EXL_SHT.Range("C1")
                    D_RNG.ColumnWidth = 12
                Case "MS131"
                    D_RNG = D_EXL_SHT.Range("C1")
                    D_RNG.ColumnWidth = 12
                Case "ST140"
                    D_RNG = D_EXL_SHT.Range("C1")
                    D_RNG.ColumnWidth = 12
                Case "CS010"
                    D_RNG = D_EXL_SHT.Range("E1")
                    D_RNG.ColumnWidth = 12
            End Select
            Utl_Rpt.FNC_ReleaseCOMObject(D_RNG)

            ''Save file
            If Not D_APP Is Nothing Then
                D_EXL_BOK.SaveAs(D_FullName)
                D_EXL_BOK.Activate()
            End If

            '
            D_Return = True
            '
        Catch ex As Exception
            Utl_ERR.FNC_ERR_RTN(ex)
            D_status = "201"
            '
        Finally
            D_DAT.Clear()
            '
            Utl_Rpt.FNC_ReleaseCOMObject(D_EXL_FONT)
            Utl_Rpt.FNC_ReleaseCOMObject(D_RNG)
            Utl_Rpt.FNC_ReleaseCOMObject(D_RNG_STT)
            Utl_Rpt.FNC_ReleaseCOMObject(D_RNG_END)
            Utl_Rpt.FNC_ReleaseCOMObject(D_EXL_CELLS)
            Utl_Rpt.FNC_ReleaseCOMObject(D_EXL_SHT)
            Utl_Rpt.FNC_ReleaseCOMObject(D_EXL_SHEETS)
            If Not D_EXL_BOK Is Nothing Then
                D_EXL_BOK.Close()
                Utl_Rpt.FNC_ReleaseCOMObject(D_EXL_BOK)
            End If
            Utl_Rpt.FNC_ReleaseCOMObject(D_EXL_BOOKS)
            If Not D_APP Is Nothing Then
                D_APP.Quit()
                Utl_Rpt.FNC_ReleaseCOMObject(D_APP)
            End If
            'プロセス強制終了
            Utl_Com.M_KillProcess("EXCEL", D_CheckProcessTimeFrom, D_CheckProcessTimeTo)
        End Try
EXIT_FUNCTION:
        FNC_OUP_EXEL2 = "{" + """" + "status" + """" + ":" + D_status + "," + """" + "filename" + """" + ":" + """" + D_FullName + """" + "}"
        Exit Function

    End Function

    '*********************************************************************************************************
    '*
    '*  処理概要：OUTPUT EXCEL3(batch copy per row)
    '*
    '*  引数　　：1.type
    '*            2.SQL sentence
    '*            3.file name?
    '*            4.file name?
    '*            5.file name?
    '*
    '*  戻り値　：1.status
    '*        　  2.temporary file name
    '*
    '*  参考　　：http://www.wednesdaymoon.net/kzweb/articles/vbnet/article.aspx?articleid=81
    '*
    '*********************************************************************************************************
    Public Shared Function FNC_OUP_EXEL3( _
        ByVal P_Type As String(), _
        ByVal P_SQL As String(), _
        ByVal P_Name As String(), _
        ByVal P_Name_TEM As String, _
        ByVal P_Name_SAVE As String
    ) As String
        Dim D_PDF As Utl_PDF = Nothing
        Dim D_UTL_RDB As Utl_RDB = Nothing

        Dim D_Return As Boolean = False
        Dim D_ROW_CNT As Integer = 0
        Dim i As Integer = 0
        Dim D_FullName As String = ""
        Dim D_File_Name As String = ""
        Dim D_EXL_TML As String = ""
        Dim D_Row As Integer = 0
        Dim D_Name As String = ""
        Dim D_status As String = "200"
        Dim D_CLM_CNT As Integer = 0
        '
        Dim D_RNG As Excel.Range = Nothing
        Dim D_RNG_STT As Excel.Range = Nothing
        Dim D_RNG_END As Excel.Range = Nothing
        '
        Dim D_File_Log As String = ""
        '
        Try
            '
            D_UTL_RDB = New Utl_RDB()
            D_PDF = New Utl_PDF()
            '
            Dim D_SQL As String = P_SQL(0).ToString '& ",'" & P4 & "'"
            '
            D_DAT = New DataSet
            D_DAT = D_UTL_RDB.FNC_GET_DAT(D_SQL)
            '
            If D_DAT Is Nothing Then
                GoTo EXIT_FUNCTION
            End If
            '
            If D_DAT.Tables(0).Rows.Count = 0 Then
                '
                GoTo EXIT_FUNCTION
            End If
            '
            D_EXL_TML = ConfigurationManager.AppSettings("FIL_TEM_EXL") & P_Name_TEM
            D_File_Log = ConfigurationManager.AppSettings("FIL_LOG")
            '
            D_Name = P_Name_SAVE & System.Guid.NewGuid.ToString() & Format(Date.Now, "yyyyMMddHHmmss")
            '
            D_File_Name = D_Name & ".xls"
            '
            D_FullName = D_PDF.FNC_GET_DIR & D_File_Name
            '
            'Copy the excel template to other one               
            FileCopy(D_EXL_TML, D_FullName)
            '
            D_APP = New Excel.Application 'ApplicationClass
            D_APP.DisplayAlerts = False
            '
            D_EXL_BOK = D_APP.Workbooks.Open(D_FullName)

            D_EXL_SHT = D_EXL_BOK.Sheets(1)
            '
            'Excel セルコレクションを設定
            D_EXL_SHT.Cells.Font.Name = D_FON
            '
            D_ROW_CNT = D_DAT.Tables(0).Rows.Count
            D_CLM_CNT = D_DAT.Tables(0).Columns.Count
            '
            Dim D_TMP_DAT(D_CLM_CNT - 1) As String
            '
            For i = 0 To D_ROW_CNT - 1
                For j = 0 To D_CLM_CNT - 1
                    D_TMP_DAT(j) = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item(j), "")
                Next
                '
                D_RNG_STT = DirectCast(D_EXL_SHT.Cells(i + 2, 1), Excel.Range)
                D_RNG_END = DirectCast(D_EXL_SHT.Cells(i + 2, D_CLM_CNT), Excel.Range)
                '
                D_RNG = D_EXL_SHT.Range(D_RNG_STT, D_RNG_END)
                D_RNG.Value = D_TMP_DAT
            Next
            '
            D_EXL_SHT.Cells(1, 1).Activate()
            ' D_EXL_SHT()
            D_EXL_SHT.Columns.AutoFit()

            ''Save file
            If Not D_APP Is Nothing Then
                D_EXL_BOK.SaveAs(D_FullName)
                D_EXL_BOK.Activate()
                D_EXL_BOK.Close()
                D_APP.Quit()
            End If
            '
            D_Return = True
            '
        Catch ex As Exception
            Utl_ERR.FNC_ERR_RTN(ex)
            D_status = "201"
        Finally
            D_DAT.Clear()
            '
            If Not D_RNG Is Nothing Then
                System.Runtime.InteropServices.Marshal.ReleaseComObject(D_RNG)
            End If
            If Not D_RNG_STT Is Nothing Then
                System.Runtime.InteropServices.Marshal.ReleaseComObject(D_RNG_STT)
            End If
            If Not D_RNG_END Is Nothing Then
                System.Runtime.InteropServices.Marshal.ReleaseComObject(D_RNG_END)
            End If
            If Not D_EXL_SHT Is Nothing Then
                System.Runtime.InteropServices.Marshal.ReleaseComObject(D_EXL_SHT)
            End If
            If Not D_EXL_BOK Is Nothing Then
                System.Runtime.InteropServices.Marshal.ReleaseComObject(D_EXL_BOK)
            End If
            If Not D_APP Is Nothing Then
                System.Runtime.InteropServices.Marshal.ReleaseComObject(D_APP)
            End If
        End Try
EXIT_FUNCTION:
        FNC_OUP_EXEL3 = "{" + """" + "status" + """" + ":" + D_status + "," + """" + "filename" + """" + ":" + """" + D_FullName + """" + "}"
        Exit Function

    End Function

    '*********************************************************************************************************
    '*
    '*  処理概要：Release object
    '*
    '*  引数　　：QuynhNT
    '*
    '*  戻り値　：2015/05/10
    '*
    '*********************************************************************************************************
    Private Shared Sub FNC_REL_OBJ()
        Try
            System.Runtime.InteropServices.Marshal.ReleaseComObject(D_APP)
            System.Runtime.InteropServices.Marshal.ReleaseComObject(D_EXL_BOK)
            System.Runtime.InteropServices.Marshal.ReleaseComObject(D_EXL_SHT)
            '
            D_APP = Nothing
        Catch ex As Exception
            '
            Call Utl_ERR.FNC_ERR_RTN(ex)
        Finally
            GC.Collect()
            GC.WaitForPendingFinalizers()
        End Try
EXIT_SUB:
        Exit Sub
    End Sub

    '*********************************************************************************************************
    '*
    '*  処理概要：OUTPUT CSV
    '*
    '*  引数　　：TuanNQ
    '*
    '*  戻り値　：2015/06/17
    '*
    '*********************************************************************************************************
    ''' <summary>
    ''' FUNCTION：OUTPUT CSV
    ''' Author　　：BaoNC
    ''' Date　：2015/06/17
    ''' </summary>
    ''' <param name="P_SQL">SQL</param>
    ''' <param name="P_Name">Name file</param>
    ''' <param name="P_Dir">Directory save file</param>
    ''' <returns></returns>
    Public Shared Function FNC_OUP_CSV(ByVal P_SQL As String, ByVal P_Name As String, Optional P_Dir As String = "") As String
        Dim D_Return As Boolean = False
        Dim D_UTL_RDB As Utl_RDB = Nothing 'データベースクラス
        Dim D_Path_Csv As String = ""
        Dim D_status As String = "200"
        '
        Try
            '
            'Trace Log SQL                 
            Utl_ERR.WriteLogFile(P_SQL, P_Name, False)
            ' End Trace

            D_UTL_RDB = New Utl_RDB()
            '
            D_DAT = New DataSet
            D_DAT = D_UTL_RDB.FNC_GET_DAT(P_SQL)

            If D_DAT.Tables(0).Rows.Count = 0 Then
                D_status = "203"
                GoTo EXIT_FUNCTION
            End If
            '
            Dim columns As DataColumnCollection = D_DAT.Tables(0).Columns
            '
            '
            If String.IsNullOrEmpty(P_Dir) Then
                P_Dir = ConfigurationManager.AppSettings("FIL_SAV_PTH")
            End If

            ' check exit folder
            If (Not System.IO.Directory.Exists(P_Dir)) Then
                System.IO.Directory.CreateDirectory(P_Dir)
            End If
            ' end check

            D_Path_Csv = P_Dir & "\" & P_Name & ".csv"

            Utl_Rpt.FNC_SAV_CSV(D_DAT.Tables(0), P_Name, D_Path_Csv)
            '
            D_Return = True
            '
        Catch ex As Exception
            Utl_ERR.FNC_ERR_RTN(ex)
            D_status = 201
        End Try
EXIT_FUNCTION:
        FNC_OUP_CSV = "{" + """" + "status" + """" + ":" + D_status + "," + """" + "filename" + """" + ":" + """" + D_Path_Csv + """" + "}"
        Exit Function
    End Function


    Public Shared Function FNC_CREATE_CSV(ByRef P1 As Data.DataTable, ByVal filename As String, Optional ByVal isHeader As Boolean = True) As Boolean
        Dim D_RTN As Boolean = False
        Dim I As Integer = 0
        Dim D_DAT_HED As String = ""
        Dim D_DAT_DTL As String = ""
        Try
            If IsNothing(P1) OrElse P1.Rows.Count = 0 Then
                'MsgBox(Cns_Com.C_MSG_NOT_OUT_DAT, MsgBoxStyle.Information, Cns_Com.C_MOD_RSL_MSG)
                GoTo EXIT_FUNCTION
            End If


            Dim sw As StreamWriter = New StreamWriter(filename, False, System.Text.Encoding.GetEncoding(932))
            '        MessageBox(sw.Encoding.EncodingName())  => RETURNS SHIFT-JIS
            'database having nchars column)
            '
            '        MessageBox(sw.Encoding.EncodingName())  => RETURNS SHIFT-JIS
            '
            If isHeader Then
                For I = 0 To P1.Columns.Count - 1 Step 1
                    D_DAT_HED = D_DAT_HED & """" & P1.Columns(I).Caption & ""","
                Next
                sw.WriteLine(Mid(D_DAT_HED, 1, D_DAT_HED.Length - 1))
            End If

            '
            I = 0
            For I = 0 To P1.Rows.Count - 1 Step 1
                For X = 0 To P1.Columns.Count - 1 Step 1
                    Select Case P1.Columns(X).DataType.Name
                        Case "Byte", "Int16", "Int32", "Int64", "SByte", "UInt16", "UInt32", "UInt64", "Decimal", "Double", "Single"
                            D_DAT_DTL = D_DAT_DTL & """" & Format(Utl_Com.FNC_CNV_NUL(P1.Rows(I).Item(X), "0"), "##,###,###,##0.##") & ""","
                        Case "DateTime", "TimeSpan"
                            D_DAT_DTL = D_DAT_DTL & """" & Format(Utl_Com.FNC_CNV_NUL(P1.Rows(I).Item(X), Nothing), "yyyy/MM/dd HH:mm:ss") & ""","
                        Case "Byte[]"
                            '空で出力
                            D_DAT_DTL = D_DAT_DTL & """" & ""","
                        Case Else
                            Dim strMyString = Utl_Com.FNC_CNV_NUL(P1.Rows(I).Item(X), "")
                            If strMyString.Contains(",") Then
                                '[Put Code Here]
                                strMyString = """" & strMyString & """"
                            Else

                            End If

                            D_DAT_DTL = D_DAT_DTL & strMyString & ","

                    End Select
                Next
                sw.WriteLine(Mid(D_DAT_DTL, 1, D_DAT_DTL.Length - 1))
                D_DAT_DTL = ""
            Next
            '
            sw.Close()
            '
            'System.Diagnostics.Process.Start(P3)
            '
            D_RTN = True
        Catch ex As Exception
            Console.WriteLine(ex.ToString())
        End Try
EXIT_FUNCTION:
        FNC_CREATE_CSV = D_RTN
        Exit Function
    End Function





    '*********************************************************************************************************
    ''' <summary>
    ''' FUNCTION：OUTPUT CSV custom
    ''' Author　　：HungNV
    ''' Date　：2016/01/13
    ''' </summary>
    ''' <param name="P_SQL">SQL</param>
    ''' <param name="P_Name">Name file</param>
    ''' <param name="P_Dir">Directory save file</param>
    ''' <returns></returns>
    Public Shared Function FNC_OUP_CSV_CUS(ByVal P_SQL As String, ByVal P_Name As String, Optional P_Dir As String = "") As String
        Dim D_Return As Boolean = False
        Dim D_UTL_RDB As Utl_RDB = Nothing 'データベースクラス
        Dim D_Path_Csv As String = ""
        Dim D_status As String = "200"
        '
        Try
            '
            'Trace Log SQL                 
            Utl_ERR.WriteLogFile(P_SQL, P_Name, False)
            ' End Trace

            D_UTL_RDB = New Utl_RDB()
            '
            D_DAT = New DataSet
            D_DAT = D_UTL_RDB.FNC_GET_DAT(P_SQL)

            'because table 0 store information about error in store so i will check like this
            If D_DAT.Tables(0).Rows.Count > 0 Then
                D_status = "209"
                GoTo EXIT_FUNCTION
            Else
                Dim D_param As String() = P_SQL.Split(",")
                Dim D_sender As String = D_param(D_param.Length - 3)
                'truong  hop thuc hien tai extract
                If "N'2'".Equals(D_sender.Trim()) Then
                    D_status = "205"
                    GoTo EXIT_FUNCTION
                End If
            End If
            '
            If String.IsNullOrEmpty(P_Dir) Then
                P_Dir = ConfigurationManager.AppSettings("FIL_SAV_PTH")
            End If

            ' check exit folder
            If (Not System.IO.Directory.Exists(P_Dir)) Then
                System.IO.Directory.CreateDirectory(P_Dir)
            End If
            ' end check

            D_Path_Csv = P_Dir & "\" & P_Name & ".csv"

            Utl_Rpt.FNC_SAV_CSV_CUS(D_DAT, P_Name, D_Path_Csv)
            '
            D_Return = True
            '
        Catch ex As Exception
            Utl_ERR.FNC_ERR_RTN(ex)
            D_status = 201
        End Try
EXIT_FUNCTION:
        FNC_OUP_CSV_CUS = "{" + """" + "status" + """" + ":" + D_status + "," + """" + "filename" + """" + ":" + """" + D_Path_Csv + """" + "}"
        Exit Function
    End Function

    ''' <summary>
    ''' データテーブル行追加
    ''' </summary>
    ''' <param name="P1">データテーブル</param>
    ''' <param name="P2">値初期化列名</param>
    ''' <param name="P3">ページブレーク列名</param>
    ''' <param name="P4">ページ行数</param>
    ''' <returns>データテーブル</returns>
    ''' <remarks></remarks>
    Public Shared Function SUB_ADD_ROW(ByVal P1 As Data.DataTable, ByVal P2() As String, ByVal P3() As String, ByVal P4 As Integer) As Data.DataTable

        'データテーブル
        Dim D_DataTable As Data.DataTable = New Data.DataTable
        '行数
        Dim D_RowCount As Integer = 0
        'データロー
        Dim D_DataRow As DataRow = Nothing
        '作業行数
        Dim D_WorkRowCount As Integer = 0
        '追加行数
        Dim D_AddRowCount As Integer = 0
        '列数
        Dim D_ColumnCount As Integer = 0
        '列インデックス
        Dim D_ColumnIndex As Integer = 0
        '列名
        Dim D_ColumnNames() As String
        'ページ数
        Dim D_PageCount As Integer = 0

        Try
            '
            D_DataRow = P1.Copy.Rows(0)
            '
            D_DataTable = P1.Copy()
            D_RowCount = P1.Rows.Count
            '
            D_WorkRowCount = D_RowCount Mod P4
            If D_WorkRowCount > 0 Then
                D_AddRowCount = P4 - D_WorkRowCount
            End If
            '
            D_ColumnCount = D_DataRow.Table.Columns.Count
            ReDim D_ColumnNames(D_ColumnCount - 1)
            For I As Integer = 0 To D_ColumnCount - 1
                D_ColumnNames(I) = D_DataRow.Table.Columns.Item(I).ColumnName
            Next
            '
            D_DataRow.BeginEdit()
            '
            If (Not IsNothing(P2)) _
            AndAlso P2.Count > 0 Then
                For I As Integer = 0 To P2.Count - 1
                    D_ColumnIndex = System.Array.IndexOf(D_ColumnNames, P2(I))
                    If D_ColumnIndex > -1 Then
                        '値初期化
                        D_DataRow.Item(D_ColumnIndex) = Nothing
                    End If
                Next
            End If
            '
            D_DataRow.EndEdit()
            '
            For I As Integer = 1 To D_AddRowCount Step 1
                'データテーブル行追加
                D_DataTable.ImportRow(D_DataRow)
            Next
            '
            If (Not IsNothing(P3)) _
            AndAlso P3.Count > 0 Then
                For I As Integer = 0 To P3.Count - 1
                    D_ColumnIndex = System.Array.IndexOf(D_ColumnNames, P3(I))
                    If D_ColumnIndex > -1 Then
                        For J As Integer = 0 To D_DataTable.Rows.Count - 1 Step 1
                            If ((J + 1) Mod P4 = 1) Then
                                D_PageCount += 1
                            End If
                            'ページブレーク設定
                            D_DataTable.Rows(J).Item(D_ColumnIndex) &= "|" & D_PageCount.ToString()
                        Next
                    End If
                Next
            End If

        Catch ex As Exception
            Throw ex
        End Try
SUB_EXIT:
        SUB_ADD_ROW = D_DataTable
        Exit Function
    End Function

    ''' <summary>
    ''' COMオブジェクトの解放
    ''' </summary>
    ''' <param name="P_COMObject">
    ''' COMオブジェクト
    ''' </param>
    ''' <remarks></remarks>
    Public Shared Sub FNC_ReleaseCOMObject(ByRef P_COMObject As Object)
        Try
            If Not P_COMObject Is Nothing Then
                System.Runtime.InteropServices.Marshal.ReleaseComObject(P_COMObject)
                P_COMObject = Nothing
            End If

            '
            GC.Collect()
            GC.WaitForPendingFinalizers()

        Catch ex As Exception
            Utl_ERR.FNC_ERR_RTN(ex)
        Finally
        End Try

    End Sub
    ''' <summary>
    ''' FNC_KillCOMObject : Kill backgroup process in windows
    ''' </summary>
    ''' <remarks></remarks>
    Public Shared Sub FNC_KillCOMObject(ByRef P_COMObject As Object)
        Try
            Dim xlp() As Process = Process.GetProcessesByName(P_COMObject)
            'For Each process As Process In xlp
            '    process.Kill()
            '    If process.GetProcessesByName(P_COMObject).Count = 0 Then
            '        Exit For
            '    End If
            'Next



        Catch ex As Exception
            Utl_ERR.FNC_ERR_RTN(ex)
        Finally
        End Try

    End Sub



    Public Shared Sub CopyRowExcell(ByRef mainSheet As ExcelWorksheet, ByVal indexRowCopy As Integer, ByRef tempSheet As ExcelWorksheet, ByVal formRowTemp As Integer, ByVal toRowTemp As Integer, ByVal rangeCopy As String, ByVal rangePaste As String, Optional ByVal options As Boolean = True)
        Try
            tempSheet.Cells(rangeCopy).Copy(mainSheet.Cells(rangePaste))
            If options Then
                SetHightRow(mainSheet, formRowTemp, toRowTemp, tempSheet, indexRowCopy)
            End If
        Catch ex As Exception
            Utl_ERR.FNC_ERR_RTN(ex)
        Finally
        End Try
    End Sub

    Public Shared Sub SetHightRow(ByRef mainSheet As ExcelWorksheet, ByVal startInt As Integer, ByVal endInt As Integer, ByRef tempSheet As ExcelWorksheet, ByVal startCopyInt As Integer)
        Try
            For i As Integer = startInt To endInt
                Dim rowexcel = tempSheet.Row(i)
                Dim height = rowexcel.Height
                mainSheet.Row(startCopyInt).Height = height

                mainSheet.Row(startCopyInt).StyleID = tempSheet.Row(i).StyleID
                startCopyInt = startCopyInt + 1
            Next

        Catch ex As Exception
            Utl_ERR.FNC_ERR_RTN(ex)
        Finally
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="D_FullName"></param>
    ''' <param name="D_fileNamelocalPDF"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>

    Public Shared Function FNC_CreatePdf(ByVal D_FullName As String, ByVal D_fileNamelocalPDF As String, Optional ScreenID As String = "") As String
        Dim result As String = String.Empty
        Dim D_EXL_BOOKS As Excel.Workbooks = Nothing
        Try
            If (String.IsNullOrEmpty(D_FullName) OrElse Not File.Exists(D_FullName)) Then
                Return result
            End If

            D_APP = New Excel.Application
            D_APP.DisplayAlerts = False
            '
            D_EXL_BOOKS = D_APP.Workbooks
            D_EXL_BOK = D_EXL_BOOKS.Open(D_FullName)

            'Save file
            If Not D_APP Is Nothing Then
                D_EXL_BOK.Activate()
                D_EXL_BOK.ExportAsFixedFormat(XlFixedFormatType.xlTypePDF, D_fileNamelocalPDF, XlFixedFormatQuality.xlQualityStandard, OpenAfterPublish:=False)

            End If
            result = D_fileNamelocalPDF

            'File.Delete(D_FullName)

        Catch ex As Exception
            Utl_ERR.FNC_ERR_RTN(ex, ScreenID)
        Finally
            If Not D_EXL_BOK Is Nothing Then
                D_EXL_BOK.Close()
                Utl_Rpt.FNC_ReleaseCOMObject(D_EXL_BOK)
            End If
            Utl_Rpt.FNC_ReleaseCOMObject(D_EXL_BOOKS)
            If Not D_APP Is Nothing Then
                D_APP.Quit()
                Utl_Rpt.FNC_ReleaseCOMObject(D_APP)
            End If

        End Try
        DeleteFile(D_FullName, ScreenID)

        Return result
    End Function

    Public Shared Sub DeleteFile(ByVal D_FullName As String, Optional ScreenID As String = "")
        Try
            If String.IsNullOrEmpty(D_FullName) Then
                Return
            End If
            File.Delete(D_FullName)
        Catch ex As Exception
            Utl_ERR.FNC_ERR_RTN(ex, ScreenID)
        End Try
    End Sub


End Class
Class Page
    Public Property NumberPage As Integer
    Public Property PositionPage As Integer

    Public Property SheetName As ExcelWorksheet

End Class