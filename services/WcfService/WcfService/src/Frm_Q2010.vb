Imports System.IO
Imports System.Globalization
Imports System.Drawing
Imports Newtonsoft.Json
'*********************************************************************************************************
'*
'*  処理概要：Function create Excel
'*  評価シート一覧
'*  作成日：	    2018/10/31
'*  作成者：　　 viettd
'*
'*********************************************************************************************************
Imports OfficeOpenXml

Public Class Frm_Q2010
    Public Function FNC_EXL_Q2010(
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
        Dim D_ROW_CNT1 As Integer = 0
        Dim i As Integer = 0
        Dim D_Row As Integer = 1                    ' sheet 1
        Dim D_Fill As Integer = 1                    ' detail fill
        'Dim D_page As Integer = 0
        Dim D_RH_OLD As String = ""
        Dim D_RH As String = ""
        ' Variable from datatable 
        Dim D_data_interview_text As Newtonsoft.Json.Linq.JArray
        Dim D_data_point_kinds_text As Newtonsoft.Json.Linq.JArray
        Dim D_sheet_kbn As Integer = 0
        '
        Dim D_EXL_SHT1 As ExcelWorksheet = Nothing
        Dim D_EXL_SHT2 As ExcelWorksheet = Nothing
        Dim D_EXL_SHT3 As ExcelWorksheet = Nothing
        Dim rowStarts = 0
        Dim rowEnds = 0
        Dim rangeCopys = ""
        Dim rangePastes = ""
        Dim D_last_page As Integer = 0
        'Dim D_i As Integer = 0
        Try
            D_DAT = New DataSet
            Dim D_UTL_RDB As Utl_RDB = New Utl_RDB()
            D_DAT = D_UTL_RDB.FNC_GET_DAT(sql)
            D_ROW_CNT = D_DAT.Tables(0).Rows.Count
            D_ROW_CNT1 = D_DAT.Tables(1).Rows.Count
            '
            If D_ROW_CNT = 0 Then
                status = "203"
                message = "FNC_EXL_PL_Q2010: Data is empty"
                GoTo EXIT_FUNCTION
            End If
            '
            If Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(0).Item("language"), 0) = "en" Then
                D_EXL_TML = ConfigurationManager.AppSettings("FIL_TEM_EXL") & "\Q2010_en.xlsx"
            Else
                D_EXL_TML = ConfigurationManager.AppSettings("FIL_TEM_EXL") & "\Q2010.xlsx"
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
                D_EXL_SHT3 = D_EXL_BOK.Workbook.Worksheets(3)
                ' get detail
                For i = 0 To D_ROW_CNT - 1
                    If i > 0 Then
                        D_RH_OLD = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i - 1).Item("RH"), 0)
                    End If
                    D_RH = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("RH"), 0)
                    ' Get data from datatable
                    D_last_page = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("last_page"), 0)
                    D_sheet_kbn = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("sheet_kbn"), 0)
                    'Set varibale default
                    rowStarts = 0
                    rowEnds = 0
                    rangeCopys = ""
                    rangePastes = ""
                    ' Paging
                    If D_RH <> D_RH_OLD Then
                        ' Kiểm tra giá trị index của fill detail
                        D_Fill = D_Row + 14
                        ' Nếu có chứa 面談記録
                        If D_last_page = 1 Then
                            ' Copy Range
                            rowStarts = 1
                            rowEnds = 126
                            rangeCopys = String.Format("A{0}:CK{1}", rowStarts, rowEnds)
                            rangePastes = String.Format("A{0}:CK{0}", D_Row)
                            ' check D_sheet_kbn = 1 or 2
                            If D_sheet_kbn = 1 Then
                                Utl_Rpt.CopyRowExcell(D_EXL_SHT1, D_Row, D_EXL_SHT2, rowStarts, rowEnds, rangeCopys, rangePastes, False)
                            ElseIf D_sheet_kbn = 2 Then
                                Utl_Rpt.CopyRowExcell(D_EXL_SHT1, D_Row, D_EXL_SHT3, rowStarts, rowEnds, rangeCopys, rangePastes, False)
                            End If
                            ' Fil data trang đầu tiên
                            ' fill data ヘッダー項目
                            D_EXL_SHT1.Cells(D_Row + 2, 1).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("fiscal_year"), 0)
                            D_EXL_SHT1.Cells(D_Row + 2, 4).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("employee_cd"), "")
                            D_EXL_SHT1.Cells(D_Row + 2, 9).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("employee_nm"), "")
                            D_EXL_SHT1.Cells(D_Row + 2, 18).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("grade_nm"), "")
                            D_EXL_SHT1.Cells(D_Row + 2, 23).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("position_nm"), "")
                            D_EXL_SHT1.Cells(D_Row + 2, 29).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("job_nm"), "")
                            D_EXL_SHT1.Cells(D_Row + 2, 35).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("rater_employee_cd_1"), "")
                            D_EXL_SHT1.Cells(D_Row + 2, 42).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("rater_employee_cd_2"), "")
                            D_EXL_SHT1.Cells(D_Row + 2, 49).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("rater_employee_cd_3"), "")
                            D_EXL_SHT1.Cells(D_Row + 2, 56).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("rater_employee_cd_4"), "")
                            D_EXL_SHT1.Cells(D_Row + 1, 81).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("sheet_nm"), "")
                            D_EXL_SHT1.Cells(D_Row + 2, 64).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("confirm_status"), "")
                            '■■■■■■■■■■■■■■■■■■■  fill data 汎用コメント ■■■■■■■■■■■■■■■■■■■
                            D_EXL_SHT1.Cells(D_Row + 5, 1).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("generic_comment_title_1"), "")
                            D_EXL_SHT1.Cells(D_Row + 5, 11).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("generic_comment_title_2"), "")
                            D_EXL_SHT1.Cells(D_Row + 5, 22).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("generic_comment_title_3"), "")
                            D_EXL_SHT1.Cells(D_Row + 5, 34).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("generic_comment_title_4"), "")
                            D_EXL_SHT1.Cells(D_Row + 5, 45).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("generic_comment_title_5"), "")
                            D_EXL_SHT1.Cells(D_Row + 5, 56).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("generic_comment_title_6"), "")
                            D_EXL_SHT1.Cells(D_Row + 5, 68).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("generic_comment_title_7"), "")
                            D_EXL_SHT1.Cells(D_Row + 5, 80).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("generic_comment_title_8"), "")

                            D_EXL_SHT1.Cells(D_Row + 6, 1).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("generic_comment_1"), "")
                            D_EXL_SHT1.Cells(D_Row + 6, 11).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("generic_comment_2"), "")
                            D_EXL_SHT1.Cells(D_Row + 6, 22).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("generic_comment_3"), "")
                            D_EXL_SHT1.Cells(D_Row + 6, 34).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("generic_comment_4"), "")
                            D_EXL_SHT1.Cells(D_Row + 6, 45).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("generic_comment_5"), "")
                            D_EXL_SHT1.Cells(D_Row + 6, 56).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("generic_comment_6"), "")
                            D_EXL_SHT1.Cells(D_Row + 6, 68).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("generic_comment_7"), "")
                            D_EXL_SHT1.Cells(D_Row + 6, 80).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("generic_comment_8"), "")
                            'evalutation_label
                            D_EXL_SHT1.Cells(D_Row + 11, 1).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("evalutation_label"), "")
                            '■■■■■■■■■■■■■■■■■■■  fill data 評価基準 ■■■■■■■■■■■■■■■■■■■
                            If D_DAT.Tables(0).Rows(i)("point_kinds_text") <> "" Then
                                D_data_point_kinds_text = JsonConvert.DeserializeObject(D_DAT.Tables(0).Rows(i)("point_kinds_text"))
                                Dim j As Integer = 0
                                For j = 0 To D_data_point_kinds_text.Count - 1
                                    D_EXL_SHT1.Cells(D_Row + 47 + j, 1).Value = D_data_point_kinds_text(j)("point_nm").ToString()
                                    D_EXL_SHT1.Cells(D_Row + 47 + j, 4).Value = D_data_point_kinds_text(j)("point_criteria").ToString()
                                Next
                            End If
                            '■■■■■■■■■■■■■■■■■■■  fill data 難易度名称 ■■■■■■■■■■■■■■■■■■■
                            If D_sheet_kbn = 1 Then
                                Dim k As Integer = 0
                                For k = 0 To D_ROW_CNT1 - 1
                                    D_EXL_SHT1.Cells(D_Row + 46 + k, 23).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(1).Rows(k).Item("challenge_level_nm"), "")
                                    D_EXL_SHT1.Cells(D_Row + 46 + k, 33).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(1).Rows(k).Item("betting_rate"), "")
                                Next
                            End If
                            '■■■■■■■■■■■■■■■■■■■  fill data ■目標管理 ■■■■■■■■■■■■■■■■■■■
                            'title
                            D_EXL_SHT1.Cells(D_Row + 12, 3).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("item_title_title"), "") 'add by viettd 2020/10/09
                            D_EXL_SHT1.Cells(D_Row + 12, 11).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("item_title_1"), "")
                            D_EXL_SHT1.Cells(D_Row + 12, 20).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("item_title_2"), "")
                            D_EXL_SHT1.Cells(D_Row + 12, 29).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("item_title_3"), "")
                            D_EXL_SHT1.Cells(D_Row + 12, 38).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("item_title_4"), "")
                            D_EXL_SHT1.Cells(D_Row + 12, 46).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("item_title_5"), "")  ' edited by viettd 2019/06/12
                            D_EXL_SHT1.Cells(D_Row + 12, 53).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("weight_title"), "")  ' edited by viettd 2020/05/25
                            '■■■■■■■■■■■■■■■■■■■  fill data ■評価コメント ■■■■■■■■■■■■■■■■■■■
                            D_EXL_SHT1.Cells(D_Row + 50, 39).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("evaluation_comment_0"), "")
                            D_EXL_SHT1.Cells(D_Row + 50, 56).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("evaluation_comment_1"), "")
                            D_EXL_SHT1.Cells(D_Row + 50, 73).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("evaluation_comment_2"), "")
                            D_EXL_SHT1.Cells(D_Row + 56, 56).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("evaluation_comment_3"), "")
                            D_EXL_SHT1.Cells(D_Row + 56, 73).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("evaluation_comment_4"), "")
                            '■■■■■■■■■■■■■■■■■■■  fill data ■評価コメント ■■■■■■■■■■■■■■■■■■■
                            If D_last_page = 1 Then
                                D_EXL_SHT1.Cells(D_Row + 44, 80).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("point_sum0"), "")
                                D_EXL_SHT1.Cells(D_Row + 44, 82).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("point_sum1"), "")
                                D_EXL_SHT1.Cells(D_Row + 44, 84).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("point_sum2"), "")
                                D_EXL_SHT1.Cells(D_Row + 44, 86).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("point_sum3"), "")
                                D_EXL_SHT1.Cells(D_Row + 44, 88).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("point_sum4"), "")
                            End If
                            '■■■■■■■■■■■■■■■■■■■  fill data ■面談記録 ■■■■■■■■■■■■■■■■■■■
                            ' fill data ヘッダー項目
                            D_EXL_SHT1.Cells(D_Row + 65, 1).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("fiscal_year"), 0)
                            D_EXL_SHT1.Cells(D_Row + 65, 4).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("employee_cd"), "")
                            D_EXL_SHT1.Cells(D_Row + 65, 9).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("employee_nm"), "")
                            D_EXL_SHT1.Cells(D_Row + 65, 18).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("grade_nm"), "")
                            D_EXL_SHT1.Cells(D_Row + 65, 23).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("position_nm"), "")
                            D_EXL_SHT1.Cells(D_Row + 65, 29).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("job_nm"), "")
                            D_EXL_SHT1.Cells(D_Row + 65, 35).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("rater_employee_cd_1"), "")
                            D_EXL_SHT1.Cells(D_Row + 65, 42).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("rater_employee_cd_2"), "")
                            D_EXL_SHT1.Cells(D_Row + 65, 49).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("rater_employee_cd_3"), "")
                            D_EXL_SHT1.Cells(D_Row + 65, 56).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("rater_employee_cd_4"), "")
                            D_EXL_SHT1.Cells(D_Row + 64, 81).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("sheet_nm"), "")
                            D_EXL_SHT1.Cells(D_Row + 65, 64).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("confirm_status"), "")
                            ' Fil data to 面談記録
                            'add vietdt 2021/12/07  add 面談記録
                            D_EXL_SHT1.Cells(D_Row + 69, 47).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("header_interview_2"), "")
                            D_EXL_SHT1.Cells(D_Row + 69, 62).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("header_interview_3"), "")
                            D_EXL_SHT1.Cells(D_Row + 69, 77).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("header_interview_4"), "")
                            'add vietdt 2021/12/07
                            If D_DAT.Tables(0).Rows(i)("interview_text") <> "" Then
                                D_data_interview_text = JsonConvert.DeserializeObject(D_DAT.Tables(0).Rows(i)("interview_text"))
                                Dim n As Integer = 0
                                For n = 0 To D_data_interview_text.Count - 1
                                    D_EXL_SHT1.Cells(D_Row + 70 + n * 4, 1).Value = D_data_interview_text(n)("interview_nm").ToString()
                                    D_EXL_SHT1.Cells(D_Row + 70 + n * 4, 11).Value = D_data_interview_text(n)("interview_date").ToString()
                                    D_EXL_SHT1.Cells(D_Row + 70 + n * 4, 18).Value = D_data_interview_text(n)("interview_comment_self").ToString()
                                    D_EXL_SHT1.Cells(D_Row + 70 + n * 4, 32).Value = D_data_interview_text(n)("interview_comment_rater").ToString()
                                    'add vietdt 2021/12/07  add 面談記録
                                    If Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("header_interview_2"), "") <> "-" Then
                                        D_EXL_SHT1.Cells(D_Row + 70 + n * 4, 47).Value = D_data_interview_text(n)("interview_comment_rater2").ToString()
                                    Else
                                        D_EXL_SHT1.Cells(D_Row + 70 + n * 4, 47).Value = "-"
                                    End If

                                    If Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("header_interview_3"), "") <> "-" Then
                                        D_EXL_SHT1.Cells(D_Row + 70 + n * 4, 62).Value = D_data_interview_text(n)("interview_comment_rater3").ToString()
                                    Else
                                        D_EXL_SHT1.Cells(D_Row + 70 + n * 4, 62).Value = "-"
                                    End If

                                    If Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("header_interview_4"), "") <> "-" Then
                                        D_EXL_SHT1.Cells(D_Row + 70 + n * 4, 77).Value = D_data_interview_text(n)("interview_comment_rater4").ToString()
                                    Else
                                        D_EXL_SHT1.Cells(D_Row + 70 + n * 4, 77).Value = "-"
                                    End If
                                    'add vietdt 2021/12/07 
                                Next
                            End If
                            '
                            D_Row = D_Row + 126
                        Else
                            ' Nếu không có 面談記録
                            ' Copy Range
                            rowStarts = 1
                            rowEnds = 63
                            rangeCopys = String.Format("A{0}:CK{1}", rowStarts, rowEnds)
                            rangePastes = String.Format("A{0}:CK{0}", D_Row)
                            ' check D_sheet_kbn = 1 or 2
                            If D_sheet_kbn = 1 Then
                                Utl_Rpt.CopyRowExcell(D_EXL_SHT1, D_Row, D_EXL_SHT2, rowStarts, rowEnds, rangeCopys, rangePastes, False)
                            ElseIf D_sheet_kbn = 2 Then
                                Utl_Rpt.CopyRowExcell(D_EXL_SHT1, D_Row, D_EXL_SHT3, rowStarts, rowEnds, rangeCopys, rangePastes, False)
                            End If
                            ' Fil data trang đầu tiên
                            ' fill data ヘッダー項目
                            D_EXL_SHT1.Cells(D_Row + 2, 1).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("fiscal_year"), 0)
                            D_EXL_SHT1.Cells(D_Row + 2, 4).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("employee_cd"), "")
                            D_EXL_SHT1.Cells(D_Row + 2, 9).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("employee_nm"), "")
                            D_EXL_SHT1.Cells(D_Row + 2, 18).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("grade_nm"), "")
                            D_EXL_SHT1.Cells(D_Row + 2, 23).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("position_nm"), "")
                            D_EXL_SHT1.Cells(D_Row + 2, 29).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("job_nm"), "")
                            D_EXL_SHT1.Cells(D_Row + 2, 35).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("rater_employee_cd_1"), "")
                            D_EXL_SHT1.Cells(D_Row + 2, 42).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("rater_employee_cd_2"), "")
                            D_EXL_SHT1.Cells(D_Row + 2, 49).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("rater_employee_cd_3"), "")
                            D_EXL_SHT1.Cells(D_Row + 2, 56).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("rater_employee_cd_4"), "")
                            D_EXL_SHT1.Cells(D_Row + 1, 81).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("sheet_nm"), "")
                            D_EXL_SHT1.Cells(D_Row + 2, 64).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("confirm_status"), "")

                            '■■■■■■■■■■■■■■■■■■■  fill data 汎用コメント ■■■■■■■■■■■■■■■■■■■
                            D_EXL_SHT1.Cells(D_Row + 5, 1).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("generic_comment_title_1"), "")
                            D_EXL_SHT1.Cells(D_Row + 5, 11).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("generic_comment_title_2"), "")
                            D_EXL_SHT1.Cells(D_Row + 5, 22).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("generic_comment_title_3"), "")
                            D_EXL_SHT1.Cells(D_Row + 5, 34).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("generic_comment_title_4"), "")
                            D_EXL_SHT1.Cells(D_Row + 5, 45).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("generic_comment_title_5"), "")
                            D_EXL_SHT1.Cells(D_Row + 5, 56).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("generic_comment_title_6"), "")
                            D_EXL_SHT1.Cells(D_Row + 5, 68).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("generic_comment_title_7"), "")
                            D_EXL_SHT1.Cells(D_Row + 5, 80).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("generic_comment_title_8"), "")

                            D_EXL_SHT1.Cells(D_Row + 6, 1).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("generic_comment_1"), "")
                            D_EXL_SHT1.Cells(D_Row + 6, 11).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("generic_comment_2"), "")
                            D_EXL_SHT1.Cells(D_Row + 6, 22).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("generic_comment_3"), "")
                            D_EXL_SHT1.Cells(D_Row + 6, 34).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("generic_comment_4"), "")
                            D_EXL_SHT1.Cells(D_Row + 6, 45).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("generic_comment_5"), "")
                            D_EXL_SHT1.Cells(D_Row + 6, 56).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("generic_comment_6"), "")
                            D_EXL_SHT1.Cells(D_Row + 6, 68).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("generic_comment_7"), "")
                            D_EXL_SHT1.Cells(D_Row + 6, 80).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("generic_comment_8"), "")
                            'evalutation_label
                            D_EXL_SHT1.Cells(D_Row + 11, 1).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("evalutation_label"), "")
                            '■■■■■■■■■■■■■■■■■■■  fill data 評価基準 ■■■■■■■■■■■■■■■■■■■
                            If D_DAT.Tables(0).Rows(i)("point_kinds_text") <> "" Then
                                D_data_point_kinds_text = JsonConvert.DeserializeObject(D_DAT.Tables(0).Rows(i)("point_kinds_text"))
                                Dim j As Integer = 0
                                For j = 0 To D_data_point_kinds_text.Count - 1
                                    D_EXL_SHT1.Cells(D_Row + 47 + j, 1).Value = D_data_point_kinds_text(j)("point_nm").ToString()
                                    D_EXL_SHT1.Cells(D_Row + 47 + j, 4).Value = D_data_point_kinds_text(j)("point_criteria").ToString()
                                Next
                            End If
                            '■■■■■■■■■■■■■■■■■■■  fill data 難易度名称 ■■■■■■■■■■■■■■■■■■■
                            If D_sheet_kbn = 1 Then
                                Dim k As Integer = 0
                                For k = 0 To D_ROW_CNT1 - 1
                                    D_EXL_SHT1.Cells(D_Row + 46 + k, 23).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(1).Rows(k).Item("challenge_level_nm"), "")
                                    D_EXL_SHT1.Cells(D_Row + 46 + k, 33).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(1).Rows(k).Item("betting_rate"), "")
                                Next
                            End If
                            '■■■■■■■■■■■■■■■■■■■  fill data ■目標管理 ■■■■■■■■■■■■■■■■■■■
                            'title
                            D_EXL_SHT1.Cells(D_Row + 12, 3).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("item_title_title"), "") 'add by viettd 2020/10/09
                            D_EXL_SHT1.Cells(D_Row + 12, 11).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("item_title_1"), "")
                            D_EXL_SHT1.Cells(D_Row + 12, 20).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("item_title_2"), "")
                            D_EXL_SHT1.Cells(D_Row + 12, 29).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("item_title_3"), "")
                            D_EXL_SHT1.Cells(D_Row + 12, 38).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("item_title_4"), "")
                            D_EXL_SHT1.Cells(D_Row + 12, 46).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("item_title_5"), "")  ' edited by viettd 2019/06/12
                            D_EXL_SHT1.Cells(D_Row + 12, 53).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("weight_title"), "")  ' edited by viettd 2020/05/25
                            '■■■■■■■■■■■■■■■■■■■  fill data ■評価コメント ■■■■■■■■■■■■■■■■■■■
                            D_EXL_SHT1.Cells(D_Row + 50, 39).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("evaluation_comment_0"), "")
                            D_EXL_SHT1.Cells(D_Row + 50, 56).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("evaluation_comment_1"), "")
                            D_EXL_SHT1.Cells(D_Row + 50, 73).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("evaluation_comment_2"), "")
                            D_EXL_SHT1.Cells(D_Row + 56, 56).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("evaluation_comment_3"), "")
                            D_EXL_SHT1.Cells(D_Row + 56, 73).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("evaluation_comment_4"), "")
                            '■■■■■■■■■■■■■■■■■■■  fill data ■評価コメント ■■■■■■■■■■■■■■■■■■■
                            If D_last_page = 1 Then
                                D_EXL_SHT1.Cells(D_Row + 44, 80).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("point_sum0"), "")
                                D_EXL_SHT1.Cells(D_Row + 44, 82).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("point_sum1"), "")
                                D_EXL_SHT1.Cells(D_Row + 44, 84).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("point_sum2"), "")
                                D_EXL_SHT1.Cells(D_Row + 44, 86).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("point_sum3"), "")
                                D_EXL_SHT1.Cells(D_Row + 44, 88).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("point_sum4"), "")
                            End If
                            '
                            D_Row = D_Row + 63
                        End If
                    End If
                    ' Fill data to body
                    D_EXL_SHT1.Cells(D_Fill, 1).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("row_item_count"), 0)
                    D_EXL_SHT1.Cells(D_Fill, 3).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("item_title"), "")
                    D_EXL_SHT1.Cells(D_Fill, 11).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("item_1"), "")
                    D_EXL_SHT1.Cells(D_Fill, 20).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("item_2"), "")
                    D_EXL_SHT1.Cells(D_Fill, 29).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("item_3"), "")
                    D_EXL_SHT1.Cells(D_Fill, 38).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("item_4"), "")
                    D_EXL_SHT1.Cells(D_Fill, 46).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("item_5"), "")
                    D_EXL_SHT1.Cells(D_Fill, 53).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("weight"), "")
                    D_EXL_SHT1.Cells(D_Fill, 56).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("challenge_level_nm"), "")
                    D_EXL_SHT1.Cells(D_Fill, 59).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("evaluation_comment_detail_0"), "")
                    D_EXL_SHT1.Cells(D_Fill, 69).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("evaluation_comment_detail_1"), "")
                    D_EXL_SHT1.Cells(D_Fill, 80).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("point_nm_0"), "")
                    D_EXL_SHT1.Cells(D_Fill, 82).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("point_nm_1"), "")
                    D_EXL_SHT1.Cells(D_Fill, 84).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("point_nm_2"), "")
                    D_EXL_SHT1.Cells(D_Fill, 86).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("point_nm_3"), "")
                    D_EXL_SHT1.Cells(D_Fill, 88).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("point_nm_4"), "")
                    '
                    D_Fill = D_Fill + 5
                Next
                'D_EXL_BOK.Sheets(2).Delete()
                D_EXL_BOK.Workbook.Worksheets.Delete(3)
                D_EXL_BOK.Workbook.Worksheets.Delete(2)
ACTIVE:
                'Save file
                D_EXL_BOK.Save()
            End Using
        Catch ex As Exception
            Utl_ERR.WriteLogReport(ex.ToString(), "Q2010")
            message = "FNC_EXL_Q2010: " & ex.ToString()
            status = "201"
        Finally
            D_DAT.Clear()
            '
        End Try
EXIT_FUNCTION:
        FNC_EXL_Q2010 = "{" + """" + "status" + """" + ":" + status + "," + """" + "filename" + """" + ":" + """" + fileName + """," + """" + "message" + """" + ":" + """" + message + """}"
        Exit Function

    End Function

End Class