Imports System.IO
Imports System.Globalization
Imports System.Drawing

'*********************************************************************************************************
'*
'*  処理概要：Function create Excel
'*  目標一覧表
'*  作成日：	    2020/10/12
'*  作成者：　　 namnb
'*
'*********************************************************************************************************
Imports OfficeOpenXml

Public Class Frm_Oq2032
    Public Function FNC_EXL_Oq2032(
       ByVal sql As String,
       ByVal screen As String,
       ByVal fileName As String,
       ByVal pathFile As String
    ) As String
        Dim status As String = "200"
        Dim message As String = "File created success."
        Dim D_DAT As DataSet = Nothing
        Dim D_EXL_TML As String = String.Empty
        Dim D_File_Log As String = ""

        Dim D_PDF As Utl_PDF = Nothing
        Dim D_ROW_CNT As Integer = 0
        Dim D_TABLE1_CNT As Integer = 0
        Dim D_EXL_SHT1 As ExcelWorksheet = Nothing
        Try
            D_DAT = New DataSet
            Dim D_UTL_RDB As Utl_RDB = New Utl_RDB()
            D_DAT = D_UTL_RDB.FNC_GET_DAT(sql)
            D_ROW_CNT = D_DAT.Tables(0).Rows.Count
            '
            If D_ROW_CNT = 0 Then
                status = "203"
                message = "FNC_EXL_Q2032: Data is empty"
                GoTo EXIT_FUNCTION
            End If
            '
            If Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(0).Item("language"), 0) = "en" Then
                D_EXL_TML = ConfigurationManager.AppSettings("FIL_TEM_EXL") & "\Oq2032_en.xlsx"
            Else
                D_EXL_TML = ConfigurationManager.AppSettings("FIL_TEM_EXL") & "\Oq2032.xlsx"
            End If

            D_File_Log = ConfigurationManager.AppSettings("FIL_LOG")
            D_PDF = New Utl_PDF()
            pathFile = D_PDF.FNC_GET_DIR & fileName
            'Copy the excel template to other one               
            FileCopy(D_EXL_TML, pathFile)
            'チェックプロセス日時開始を設定
            Dim newFile = New FileInfo(pathFile)
            Using D_EXL_BOK As New ExcelPackage(newFile)
                D_EXL_SHT1 = D_EXL_BOK.Workbook.Worksheets(1)
                'fill search conditions
                D_EXL_SHT1.Cells(1, 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(1).Rows(0).Item("fiscal_year_nm"), "")
                D_EXL_SHT1.Cells(2, 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(1).Rows(0).Item("submit_nm"), "")
                D_EXL_SHT1.Cells(3, 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(1).Rows(0).Item("target_nm"), "")
                D_EXL_SHT1.Cells(4, 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(1).Rows(0).Item("view_unit_nm"), "")
                D_EXL_SHT1.Cells(5, 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(1).Rows(0).Item("group_cd_1on1_nm"), "")
                D_EXL_SHT1.Cells(6, 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(1).Rows(0).Item("position_nm"), "")
                D_EXL_SHT1.Cells(7, 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(1).Rows(0).Item("job_nm"), "")
                D_EXL_SHT1.Cells(8, 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(1).Rows(0).Item("grade_nm"), "")
                D_EXL_SHT1.Cells(9, 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(1).Rows(0).Item("coach_nm"), "")
                ' fill data
                For i = 0 To D_ROW_CNT - 1
                    If i <> 0 Then
                        D_EXL_SHT1.Cells("A11:M11").Copy(D_EXL_SHT1.Cells("A" & (10 + i) & ":M" & (10 + i)))
                    End If
                    D_EXL_SHT1.Cells(10 + i, 1).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("status_nm"), "")
                    D_EXL_SHT1.Cells(10 + i, 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("month_no1"), "")
                    D_EXL_SHT1.Cells(10 + i, 3).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("month_no2"), "")
                    D_EXL_SHT1.Cells(10 + i, 4).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("month_no3"), "")
                    D_EXL_SHT1.Cells(10 + i, 5).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("month_no4"), "")
                    D_EXL_SHT1.Cells(10 + i, 6).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("month_no5"), "")
                    D_EXL_SHT1.Cells(10 + i, 7).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("month_no6"), "")
                    D_EXL_SHT1.Cells(10 + i, 8).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("month_no7"), "")
                    D_EXL_SHT1.Cells(10 + i, 9).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("month_no8"), "")
                    D_EXL_SHT1.Cells(10 + i, 10).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("month_no9"), "")
                    D_EXL_SHT1.Cells(10 + i, 11).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("month_no11"), "")
                    D_EXL_SHT1.Cells(10 + i, 12).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("month_no12"), "")
                    D_EXL_SHT1.Cells(10 + i, 13).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("annual_average"), "")
                Next
                '
                D_EXL_SHT1.Cells("A" & (9 + D_ROW_CNT) & ":M" & (9 + D_ROW_CNT)).Style.Font.Bold = True
ACTIVE:
                'Save file
                D_EXL_BOK.Save()
            End Using
        Catch ex As Exception
            Utl_ERR.WriteLogReport(ex.ToString(), "Oq2032")
            message = "FNC_EXL_Oq2032: " & ex.ToString()
            status = "201"
        Finally
            D_DAT.Clear()
            '
        End Try
EXIT_FUNCTION:
        FNC_EXL_Oq2032 = "{" + """" + "status" + """" + ":" + status + "," + """" + "filename" + """" + ":" + """" + fileName + """," + """" + "message" + """" + ":" + """" + message + """}"
        Exit Function

    End Function

End Class