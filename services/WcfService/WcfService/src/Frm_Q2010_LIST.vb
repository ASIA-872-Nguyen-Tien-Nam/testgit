Imports System.IO
Imports System.Globalization
Imports System.Drawing

'*********************************************************************************************************
'*
'*  処理概要：Function create Excel
'*  評価シート一覧
'*  作成日：	    2018/10/31
'*  作成者：　　 viettd
'*
'*********************************************************************************************************
Imports OfficeOpenXml

Public Class Frm_Q2010_LIST
    Public Function FNC_EXL_Q2010_LIST(
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
        Dim D_Fill As Integer = 7
        Dim D_EXL_SHT1 As ExcelWorksheet = Nothing
        Dim D_EXL_SHT2 As ExcelWorksheet = Nothing
        'variable form data
        Dim D_sheet_khn As Integer = 0
        Dim D_target_self_assessment_typ As Integer = 0
        Dim D_target_evaluation_typ_1 As Integer = 0
        Dim D_target_evaluation_typ_2 As Integer = 0
        Dim D_target_evaluation_typ_3 As Integer = 0
        Dim D_target_evaluation_typ_4 As Integer = 0
        Dim D_evaluation_self_assessment_typ As Integer = 0
        Dim D_evaluation_typ_1 As Integer = 0
        Dim D_evaluation_typ_2 As Integer = 0
        Dim D_evaluation_typ_3 As Integer = 0
        Dim D_evaluation_typ_4 As Integer = 0
        '
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
            D_M0022_CNT = D_DAT.Tables(3).Rows.Count
            '
            If D_ROW_CNT = 0 Then
                status = "203"
                message = "FNC_EXL_PL_I0030: Data is empty"
                GoTo EXIT_FUNCTION
            End If
            '
            If Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(0).Item("language"), 0) = "en" Then
                D_EXL_TML = ConfigurationManager.AppSettings("FIL_TEM_EXL") & "\Q2010_list_en.xlsx"
            Else
                D_EXL_TML = ConfigurationManager.AppSettings("FIL_TEM_EXL") & "\Q2010_list.xlsx"
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
                D_EXL_SHT2 = D_EXL_BOK.Workbook.Worksheets(2)
                ' fill data
                D_EXL_SHT1.Cells(2, 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(0).Item("cre_user"), "")
                D_EXL_SHT1.Cells(3, 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(0).Item("cre_time"), "")
                D_EXL_SHT1.Cells(4, 4).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(0).Item("fiscal_year_nm"), "")
                '
                For j = 0 To D_M0022_CNT - 1
                    D_EXL_SHT1.Cells(6, 5 + j).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(3).Rows(j).Item("organization_group_nm"), "")
                Next
                ' get data
                D_sheet_khn = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(2).Rows(0).Item("sheet_khn"), 0)
                D_target_self_assessment_typ = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(2).Rows(0).Item("target_self_assessment_typ"), 0)
                D_target_evaluation_typ_1 = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(2).Rows(0).Item("target_evaluation_typ_1"), 0)
                D_target_evaluation_typ_2 = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(2).Rows(0).Item("target_evaluation_typ_2"), 0)
                D_target_evaluation_typ_3 = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(2).Rows(0).Item("target_evaluation_typ_3"), 0)
                D_target_evaluation_typ_4 = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(2).Rows(0).Item("target_evaluation_typ_4"), 0)
                '
                D_evaluation_self_assessment_typ = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(2).Rows(0).Item("evaluation_self_assessment_typ"), 0)
                D_evaluation_typ_1 = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(2).Rows(0).Item("evaluation_typ_1"), 0)
                D_evaluation_typ_2 = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(2).Rows(0).Item("evaluation_typ_2"), 0)
                D_evaluation_typ_3 = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(2).Rows(0).Item("evaluation_typ_3"), 0)
                D_evaluation_typ_4 = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(2).Rows(0).Item("evaluation_typ_4"), 0)

                D_organization_step1 = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(3).Rows(0).Item("use_typ"), 0)
                D_organization_step2 = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(3).Rows(1).Item("use_typ"), 0)
                D_organization_step3 = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(3).Rows(2).Item("use_typ"), 0)
                D_organization_step4 = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(3).Rows(3).Item("use_typ"), 0)
                D_organization_step5 = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(3).Rows(4).Item("use_typ"), 0)
                ' fill data to detail
                For i = 0 To D_ROW_CNT - 1
                    'Copy row
                    D_EXL_SHT2.Cells(String.Format("A{0}:T{0}", 7)).Copy(D_EXL_SHT1.Cells(String.Format("A{0}:T{0}", D_Fill)))
                    'Fill data to row
                    D_EXL_SHT1.Cells(D_Fill, 1).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("fiscal_year"), "")
                    D_EXL_SHT1.Cells(D_Fill, 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("employee_cd"), "")
                    D_EXL_SHT1.Cells(D_Fill, 3).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("employee_nm"), "")
                    D_EXL_SHT1.Cells(D_Fill, 4).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("employee_typ_nm"), "")
                    D_EXL_SHT1.Cells(D_Fill, 5).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("belong_nm_1"), "")
                    D_EXL_SHT1.Cells(D_Fill, 6).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("belong_nm_2"), "")
                    D_EXL_SHT1.Cells(D_Fill, 7).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("belong_nm_3"), "")
                    D_EXL_SHT1.Cells(D_Fill, 8).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("belong_nm_4"), "")
                    D_EXL_SHT1.Cells(D_Fill, 9).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("belong_nm_5"), "")
                    D_EXL_SHT1.Cells(D_Fill, 10).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("job_nm"), "")
                    D_EXL_SHT1.Cells(D_Fill, 11).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("position_nm"), "")
                    D_EXL_SHT1.Cells(D_Fill, 12).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("grade_nm"), "")
                    D_EXL_SHT1.Cells(D_Fill, 13).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("sheet_kbn_nm"), "")
                    D_EXL_SHT1.Cells(D_Fill, 14).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("sheet_nm"), "")
                    D_EXL_SHT1.Cells(D_Fill, 15).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("status_nm"), "")
                    D_EXL_SHT1.Cells(D_Fill, 16).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("point_sum_0"), "")
                    D_EXL_SHT1.Cells(D_Fill, 17).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("point_sum_1"), "")
                    D_EXL_SHT1.Cells(D_Fill, 18).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("point_sum_2"), "")
                    D_EXL_SHT1.Cells(D_Fill, 19).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("point_sum_3"), "")
                    D_EXL_SHT1.Cells(D_Fill, 20).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("point_sum_4"), "")
                    '
                    D_Fill = D_Fill + 1
                Next
                ' delete cols
                If D_sheet_khn = 2 Then
                    If D_evaluation_typ_4 = 0 Then
                        D_EXL_SHT1.DeleteColumn(20)
                    End If
                    If D_evaluation_typ_3 = 0 Then
                        D_EXL_SHT1.DeleteColumn(19)
                    End If
                    If D_evaluation_typ_2 = 0 Then
                        D_EXL_SHT1.DeleteColumn(18)
                    End If
                    If D_evaluation_typ_1 = 0 Then
                        D_EXL_SHT1.DeleteColumn(17)
                    End If
                    If D_evaluation_self_assessment_typ = 0 Then
                        D_EXL_SHT1.DeleteColumn(16)
                    End If
                    '
                ElseIf D_sheet_khn = 1 Then
                    If D_target_evaluation_typ_4 = 0 Then
                        D_EXL_SHT1.DeleteColumn(20)
                    End If
                    If D_target_evaluation_typ_3 = 0 Then
                        D_EXL_SHT1.DeleteColumn(19)
                    End If
                    If D_target_evaluation_typ_2 = 0 Then
                        D_EXL_SHT1.DeleteColumn(18)
                    End If
                    If D_target_evaluation_typ_1 = 0 Then
                        D_EXL_SHT1.DeleteColumn(17)
                    End If
                    If D_target_self_assessment_typ = 0 Then
                        D_EXL_SHT1.DeleteColumn(16)
                    End If
                End If
                ' delete 組織
                If D_organization_step5 = 0 Then
                    D_EXL_SHT1.DeleteColumn(9)
                End If
                If D_organization_step4 = 0 Then
                    D_EXL_SHT1.DeleteColumn(8)
                End If
                If D_organization_step3 = 0 Then
                    D_EXL_SHT1.DeleteColumn(7)
                End If
                If D_organization_step2 = 0 Then
                    D_EXL_SHT1.DeleteColumn(6)
                End If
                If D_organization_step1 = 0 Then
                    D_EXL_SHT1.DeleteColumn(5)
                End If
                'D_EXL_BOK.Sheets(2).Delete()
                D_EXL_BOK.Workbook.Worksheets.Delete(2)
                '
ACTIVE:
                'DELETE SHEET 2 
                'Save file
                D_EXL_BOK.Save()
            End Using
        Catch ex As Exception
            Utl_ERR.WriteLogReport(ex.ToString(), "Q2010_LIST")
            message = "FNC_EXL_Q2010_LIST: " & ex.ToString()
            status = "201"
        Finally
            D_DAT.Clear()
            '
        End Try
EXIT_FUNCTION:
        FNC_EXL_Q2010_LIST = "{" + """" + "status" + """" + ":" + status + "," + """" + "filename" + """" + ":" + """" + fileName + """," + """" + "message" + """" + ":" + """" + message + """}"
        Exit Function

    End Function

End Class