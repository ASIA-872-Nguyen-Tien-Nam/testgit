Imports System.IO
Imports System.Globalization
Imports System.Drawing
'*********************************************************************************************************
'*
'*  処理概要：Function create Excel
'*  アンケート一覧
'*  作成日：	    2020/12/02
'*  作成者：　　 nghianm
'*
'*********************************************************************************************************
Imports OfficeOpenXml
Imports Microsoft.Office.Interop.Excel
Imports Microsoft.Office.Interop

Public Class Frm_OQ3020_LIST
    Public Function FNC_EXL_OQ3020_LIST(
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
        Dim D_M0022_CNT As Integer = 0
        Dim i As Integer = 0
        Dim D_Fill As Integer = 2
        Dim D_EXL_SHT As ExcelWorksheet = Nothing
        Dim D_EXL_SHT2 As ExcelWorksheet = Nothing
        Dim range = Nothing
        'variable form data
        Dim D_organization_step1 As Integer = 0
        Dim D_organization_step2 As Integer = 0
        Dim D_organization_step3 As Integer = 0
        Dim D_organization_step4 As Integer = 0
        Dim D_organization_step5 As Integer = 0

        Try
            D_DAT = New DataSet
            Dim D_UTL_RDB As Utl_RDB = New Utl_RDB()
            D_DAT = D_UTL_RDB.FNC_GET_DAT(sql)
            D_ROW_CNT = D_DAT.Tables(0).Rows.Count
            D_M0022_CNT = D_DAT.Tables(2).Rows.Count
            '
            If D_ROW_CNT = 0 Then
                status = "203"
                message = "FNC_EXL_PL_I0030: Data is empty"
                GoTo EXIT_FUNCTION
            End If
            '
            If Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(0).Item("language"), 0) = "en" Then
                D_EXL_TML = ConfigurationManager.AppSettings("FIL_TEM_EXL") & "\OQ3020_list_en.xlsx"
            Else
                D_EXL_TML = ConfigurationManager.AppSettings("FIL_TEM_EXL") & "\OQ3020_list.xlsx"
            End If
            '
            D_File_Log = ConfigurationManager.AppSettings("FIL_LOG")
            D_PDF = New Utl_PDF()
            pathFile = D_PDF.FNC_GET_DIR & fileName
            'Copy the excel template to other one               
            FileCopy(D_EXL_TML, pathFile)
            'チェックプロセス日時開始を設定
            Dim newFile = New FileInfo(pathFile)
            Using D_EXL_BOK As New ExcelPackage(newFile)
                D_EXL_SHT = D_EXL_BOK.Workbook.Worksheets(1)
                D_EXL_SHT2 = D_EXL_BOK.Workbook.Worksheets(2)
                Dim D_N As Integer = 1 ' Number of row in answer_no
                Dim D_M As Integer = 1 ' Save value of D_N before change
                'fill Data
                For j = 0 To D_M0022_CNT - 1
                    D_EXL_SHT.Cells(1, 7 + j).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(2).Rows(j).Item("organization_group_nm"), "")
                Next

                D_organization_step1 = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(2).Rows(0).Item("use_typ"), 0)
                D_organization_step2 = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(2).Rows(1).Item("use_typ"), 0)
                D_organization_step3 = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(2).Rows(2).Item("use_typ"), 0)
                D_organization_step4 = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(2).Rows(3).Item("use_typ"), 0)
                D_organization_step5 = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(2).Rows(4).Item("use_typ"), 0)
                ''
                D_EXL_SHT.Cells(D_Fill, 1).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(0).Item("employee_cd"), "")
                D_EXL_SHT.Cells(D_Fill, 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(0).Item("employee_nm"), "")
                D_EXL_SHT.Cells(D_Fill, 3).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(0).Item("group_nm"), "")
                D_EXL_SHT.Cells(D_Fill, 4).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(0).Item("group_title"), "")
                D_EXL_SHT.Cells(D_Fill, 5).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(0).Item("gender"), "")
                D_EXL_SHT.Cells(D_Fill, 6).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(0).Item("age"), "")
                D_EXL_SHT.Cells(D_Fill, 7).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(0).Item("belong_nm_1"), "")
                D_EXL_SHT.Cells(D_Fill, 8).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(0).Item("belong_nm_2"), "")
                D_EXL_SHT.Cells(D_Fill, 9).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(0).Item("belong_nm_3"), "")
                D_EXL_SHT.Cells(D_Fill, 10).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(0).Item("belong_nm_4"), "")
                D_EXL_SHT.Cells(D_Fill, 11).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(0).Item("belong_nm_5"), "")
                D_EXL_SHT.Cells(D_Fill, 12).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(0).Item("position_nm"), "")
                D_EXL_SHT.Cells(D_Fill, 13).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(0).Item("grade_nm"), "")
                D_EXL_SHT.Cells(D_Fill, 14).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(0).Item("questionnaire_nm"), "")
                D_EXL_SHT.Cells(D_Fill, 15).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(0).Item("question"), "")
                D_EXL_SHT.Cells(D_Fill, 16).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(0).Item("sentence_answer"), "")
                D_EXL_SHT.Cells(D_Fill, 17).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(0).Item("points_answer"), "")
                D_EXL_SHT.Cells(D_Fill, 18).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(0).Item("comment"), "")
                D_Fill = D_Fill + 1
                ' fill data to detail
                For i = 0 To D_ROW_CNT - 2
                    'Fill data to row
                    D_EXL_SHT2.Cells("A2:R2").Copy(D_EXL_SHT.Cells("A" & (3 + i) & ":R" & (3 + i)))
                    If ((D_DAT.Tables(0).Rows(i).Item("company_cd") <> D_DAT.Tables(0).Rows(i + 1).Item("company_cd")) Or (D_DAT.Tables(0).Rows(i).Item("fiscal_year") <> D_DAT.Tables(0).Rows(i + 1).Item("fiscal_year")) Or (Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("employee_cd"), "") <> Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i + 1).Item("employee_cd"), "")) Or (D_DAT.Tables(0).Rows(i).Item("times") <> D_DAT.Tables(0).Rows(i + 1).Item("times")) Or (D_DAT.Tables(0).Rows(i).Item("questionnaire_cd") <> D_DAT.Tables(0).Rows(i + 1).Item("questionnaire_cd")) Or (D_DAT.Tables(0).Rows(i).Item("answer_no") <> D_DAT.Tables(0).Rows(i + 1).Item("answer_no"))) Then
                        D_EXL_SHT.Cells("A" + (i + 2).ToString + ":" + "R" + (i + 2).ToString).Style.Border.Bottom.Style = OfficeOpenXml.Style.ExcelBorderStyle.Thin
                        D_EXL_SHT.Cells(D_Fill, 1).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i + 1).Item("employee_cd"), "")
                        D_EXL_SHT.Cells(D_Fill, 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i + 1).Item("employee_nm"), "")
                        D_EXL_SHT.Cells(D_Fill, 3).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i + 1).Item("group_nm"), "")
                        D_EXL_SHT.Cells(D_Fill, 4).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i + 1).Item("group_title"), "")
                        D_EXL_SHT.Cells(D_Fill, 5).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i + 1).Item("gender"), "")
                        D_EXL_SHT.Cells(D_Fill, 6).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i + 1).Item("age"), "")
                        D_EXL_SHT.Cells(D_Fill, 7).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i + 1).Item("belong_nm_1"), "")
                        D_EXL_SHT.Cells(D_Fill, 8).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i + 1).Item("belong_nm_2"), "")
                        D_EXL_SHT.Cells(D_Fill, 9).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i + 1).Item("belong_nm_3"), "")
                        D_EXL_SHT.Cells(D_Fill, 10).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i + 1).Item("belong_nm_4"), "")
                        D_EXL_SHT.Cells(D_Fill, 11).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i + 1).Item("belong_nm_5"), "")
                        D_EXL_SHT.Cells(D_Fill, 12).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i + 1).Item("position_nm"), "")
                        D_EXL_SHT.Cells(D_Fill, 13).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i + 1).Item("grade_nm"), "")
                        D_EXL_SHT.Cells(D_Fill, 14).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i + 1).Item("questionnaire_nm"), "")
                        D_EXL_SHT.Cells(D_Fill, 18).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i + 1).Item("comment"), "")
                        D_N = 0
                    End If
                    D_EXL_SHT.Cells(D_Fill, 15).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i + 1).Item("question"), "")
                    D_EXL_SHT.Cells(D_Fill, 16).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i + 1).Item("sentence_answer"), "")
                    D_EXL_SHT.Cells(D_Fill, 17).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i + 1).Item("points_answer"), "")
                    '
                    'Complete 1 employee-time data
                    If D_N = 0 Then
                        D_EXL_SHT.Cells("R" & (D_Fill - D_M) & ":R" & (D_Fill - 1)).Merge = True
                    End If
                    'end of data
                    If i = D_ROW_CNT - 2 Then
                        D_EXL_SHT.Cells("R" & (D_Fill - D_M) & ":R" & (D_Fill)).Merge = True
                    End If
                    D_N = D_N + 1
                    D_M = D_N
                    D_Fill = D_Fill + 1
                Next
                ' delete 組織
                If D_organization_step5 = 0 Then
                    D_EXL_SHT.DeleteColumn(11)

                    'D_EXL_BOK.Workbook.Worksheets(1)
                End If
                If D_organization_step4 = 0 Then
                    D_EXL_SHT.DeleteColumn(10)
                End If
                If D_organization_step3 = 0 Then
                    D_EXL_SHT.DeleteColumn(9)
                End If
                If D_organization_step2 = 0 Then
                    D_EXL_SHT.DeleteColumn(8)
                End If
                If D_organization_step1 = 0 Then
                    D_EXL_SHT.DeleteColumn(7)
                End If
                D_EXL_BOK.Workbook.Worksheets.Delete(2)
ACTIVE:
                'DELETE SHEET 2 
                'Save file
                D_EXL_BOK.Save()
            End Using
        Catch ex As Exception
            Utl_ERR.WriteLogReport(ex.ToString(), "OQ3020_LIST")
            message = "FNC_EXL_OQ3020_LIST: " & ex.ToString()
            status = "201"
        Finally
            D_DAT.Clear()
            '
        End Try
EXIT_FUNCTION:
        FNC_EXL_OQ3020_LIST = "{" + """" + "status" + """" + ":" + status + "," + """" + "filename" + """" + ":" + """" + fileName + """," + """" + "message" + """" + ":" + """" + message + """}"
        Exit Function
    End Function

End Class