Imports System.IO
Imports Microsoft.Office.Interop
Imports System.Globalization
Imports System.Drawing
Imports Microsoft.Office.Interop.Excel
Imports OfficeOpenXml.Drawing
'*********************************************************************************************************
'*
'*  処理概要：Function create Excel
'*  評価シート一覧
'*  作成日：	    2018/10/31
'*  作成者：　　 viettd
'*
'*********************************************************************************************************
Imports OfficeOpenXml

Public Class Frm_oI2010
    Public Function FNC_EXL_oI2010(
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
        Dim D_Fill_2 As Integer = 1                    'comment fill
        Dim D_RH As String = ""
        ' Variable from datatable 
        Dim D_sheet_kbn As Integer = 0
        Dim D_file_nm As String = ""
        '
        Dim D_EXL_SHT1 As ExcelWorksheet = Nothing
        Dim D_EXL_SHT2 As ExcelWorksheet = Nothing
        Dim D_EXL_SHT As ExcelWorksheet = Nothing
        Dim D_EXL_SHT_Test As ExcelWorksheet = Nothing
        Dim rowStarts = 0
        Dim rowEnds = 0
        Dim rangeCopys = ""
        Dim rangePastes = ""
        Dim D_last_page As Integer = 0
        Dim target1_use_typ As Integer = 0
        Dim target2_use_typ As Integer = 0
        Dim target3_use_typ As Integer = 0
        Dim comment_use_typ As Integer = 0
        Dim free_question_use_typ As Integer = 0
        Dim member_comment_typ As Integer = 0
        Dim coach_comment1_typ As Integer = 0
        Dim next_action_typ As Integer = 0
        Dim coach_comment2_typ As Integer = 0
        Dim target_col As String = ""
        Dim question_nm As String = "質問"
        Dim answer_nm As String = "回答"
        Dim free_question_nm As String = "自由記入欄"
        Dim member_comment_nm As String = "メンバーコメント"
        Dim coach_comment1_nm As String = "コーチコメント"
        Dim next_action_nm As String = "次回までのアクション(メンバーが記入)"
        Dim coach_comment2_nm As String = "コーチコメント(人事部門のみ閲覧可)"
        Dim target_col_index As Integer = 0
        Dim target_range_copy As String = ""
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
                D_EXL_TML = ConfigurationManager.AppSettings("FIL_TEM_EXL") & "\oI2010_en.xlsx"
                question_nm = "Question"
                answer_nm = "Answer"
                free_question_nm = "Free Entry Field"
                member_comment_nm = "Member Comment"
                coach_comment1_nm = "Coach Comment"
                next_action_nm = "Actions Until Next Time (to be filled out by members)"
                coach_comment2_nm = "Coach Comment (viewable only by the HR department)"
            Else
                D_EXL_TML = ConfigurationManager.AppSettings("FIL_TEM_EXL") & "\oI2010.xlsx"
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
                D_PDF = New Utl_PDF()
                pathFile = D_PDF.FNC_GET_DIR & fileName
                '
                'Copy the excel template to other one               
                FileCopy(D_EXL_TML, pathFile)

                Dim D_where As String = ""
                For D_Y As Integer = 0 To D_DAT.Tables(0).Rows.Count - 1
                    'tao sheet
                    D_EXL_SHT_Test = D_EXL_BOK.Workbook.Worksheets(2)
                    Dim D_Name As String = "times_" & D_DAT.Tables(0).Rows(D_Y).Item("times").ToString
                    D_EXL_BOK.Workbook.Worksheets.Add(D_Name, D_EXL_SHT_Test)
                    D_EXL_SHT = D_EXL_BOK.Workbook.Worksheets(D_Y + 3)   'active sheet'
                    'picture'
                    ' copy image
                    D_file_nm = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(D_Y).Item("remark1"), "")
                    'check file name is eixts 
                    If System.IO.File.Exists(ConfigurationManager.AppSettings("FIL_TEM_IMG") & "\" & D_file_nm) Then
                        Dim img = Image.FromFile(ConfigurationManager.AppSettings("FIL_TEM_IMG") & "\" & D_file_nm)
                        Dim pic = D_EXL_SHT.Drawings.AddPicture("Untitled-1" + D_Y.ToString(), img)
                        pic.SetPosition(7, 0, 36, 0)
                        pic.AdjustPositionAndSize()
                        pic.SetSize(240, 70)
                    End If
                    '
                    'チェックプロセス日時開始を設定
                    D_EXL_SHT.Cells(5, 43).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(D_Y).Item("remark_name"), "")
                    D_EXL_SHT.Cells(5, 50).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(D_Y).Item("oneonone_schedule_date"), "")
                    D_EXL_SHT.Cells(11, 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(D_Y).Item("title"), "")
                    D_EXL_SHT.Cells(11, 14).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(D_Y).Item("interview_nm"), "")
                    D_EXL_SHT.Cells(19, 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(D_Y).Item("coach_nm"), "")
                    D_EXL_SHT.Cells(19, 14).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(D_Y).Item("member_nm"), "")
                    '''WILL - CAN - MUST TABLE
                    Dim D_interview_cd = D_DAT.Tables(0).Rows(D_Y).Item("interview_cd")
                    Dim D_times = D_DAT.Tables(0).Rows(D_Y).Item("times")
                    Dim D_adaption_date = D_DAT.Tables(0).Rows(D_Y).Item("adaption_date")
                    '
                    target1_use_typ = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(D_Y).Item("target1_use_typ"), 0)
                    target2_use_typ = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(D_Y).Item("target2_use_typ"), 0)
                    target3_use_typ = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(D_Y).Item("target3_use_typ"), 0)
                    comment_use_typ = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(D_Y).Item("comment_use_typ"), 0)
                    free_question_use_typ = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(D_Y).Item("free_question_use_typ"), 0)
                    member_comment_typ = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(D_Y).Item("member_comment_typ"), 0)
                    coach_comment1_typ = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(D_Y).Item("coach_comment1_typ"), 0)
                    next_action_typ = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(D_Y).Item("next_action_typ"), 0)
                    coach_comment2_typ = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(D_Y).Item("coach_comment2_typ"), 0)
                    question_nm = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(D_Y).Item("question_nm"), "")
                    answer_nm = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(D_Y).Item("answer_nm"), "")
                    free_question_nm = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(D_Y).Item("free_question_nm"), "")
                    member_comment_nm = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(D_Y).Item("member_comment_nm"), "")
                    coach_comment1_nm = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(D_Y).Item("coach_comment1_nm"), "")
                    next_action_nm = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(D_Y).Item("next_action_nm"), "")
                    coach_comment2_nm = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(D_Y).Item("coach_comment2_nm"), "")
                    '
                    target_col = "B"
                    target_col_index = 2
                    'WILL
                    If target1_use_typ = 1 Then
                        target_range_copy = String.Format("{0}24", target_col)
                        D_EXL_SHT1.Cells("B26:S27").Copy(D_EXL_SHT.Cells(target_range_copy))
                        D_EXL_SHT.Cells(24, target_col_index).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(2).Rows(0).Item("target1_nm"), "")
                        D_EXL_SHT.Cells(25, target_col_index).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(D_Y).Item("target1"), "")
                        target_col = "T"
                    End If
                    'CAN
                    If target2_use_typ = 1 Then
                        target_range_copy = String.Format("{0}24", target_col)
                        D_EXL_SHT1.Cells("T26:AK27").Copy(D_EXL_SHT.Cells(target_range_copy))
                        If target_col.Equals("B") Then
                            target_col = "T"
                        Else
                            target_col_index = target_col_index + 18
                            target_col = "AL"
                        End If
                        D_EXL_SHT.Cells(24, target_col_index).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(2).Rows(0).Item("target2_nm"), "")
                        D_EXL_SHT.Cells(25, target_col_index).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(D_Y).Item("target2"), "")
                    End If
                    'MUST
                    If target3_use_typ = 1 Then
                        target_range_copy = String.Format("{0}24", target_col)
                        D_EXL_SHT1.Cells("AL26:BD27").Copy(D_EXL_SHT.Cells(target_range_copy))
                        If target_col.Equals("AL") Or target_col.Equals("T") Then
                            target_col_index = target_col_index + 18
                        End If
                        D_EXL_SHT.Cells(24, target_col_index).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(2).Rows(0).Item("target3_nm"), "")
                        D_EXL_SHT.Cells(25, target_col_index).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(D_Y).Item("target3"), "")
                    End If
                    'コーチからメンバーへの期待
                    If comment_use_typ = 1 Then
                        D_EXL_SHT1.Cells("B29:BD30").Copy(D_EXL_SHT.Cells("B27"))
                        D_EXL_SHT.Cells(27, 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(2).Rows(0).Item("comment_nm"), "")
                        D_EXL_SHT.Cells(28, 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(D_Y).Item("comment"), "")
                    End If
                    '質問 -回答
                    D_where = "interview_cd = " + IIf(D_interview_cd.ToString <> "", D_interview_cd.ToString, "0") + "and times =" + IIf(D_times.ToString <> "", D_times.ToString, "0")
                    'IIF dung trong truong hop interview_cd is null de khong bi loi va cho ra gia tri bank
                    Dim D_DATA_ROWS() As DataRow = D_DAT.Tables(1).Select(D_where) ' Lay toan bo du lieu trong bang 2 tuong ung voi D_interview_cd
                    '
                    D_ROW_CNT1 = D_DATA_ROWS.Count
                    D_Fill = 35
                    'head table
                    D_EXL_SHT.Cells(34, 2).Value = question_nm
                    D_EXL_SHT.Cells(34, 30).Value = answer_nm
                    '
                    For i = 0 To D_ROW_CNT1 - 1
                        If i <> 0 Then
                            D_EXL_SHT1.Cells("B33:BD33").Copy(D_EXL_SHT.Cells("B" & D_Fill))
                        End If
                        D_EXL_SHT.Cells(D_Fill, 2).Value = IIf(D_interview_cd.ToString <> "", Utl_Com.FNC_CNV_NUL(D_DATA_ROWS(i).Item("question"), ""), "")
                        D_EXL_SHT.Cells(D_Fill, 30).Value = IIf(D_interview_cd.ToString <> "", Utl_Com.FNC_CNV_NUL(D_DATA_ROWS(i).Item("answer"), ""), "")
                        D_EXL_SHT.Row(D_Fill).Height = 17.25
                        D_Fill = D_Fill + 1
                    Next
                    '    'Space between 2 table'
                    D_Fill = D_Fill + 2

                    D_Fill_2 = D_Fill
                    ''
                    rowStarts = 35
                    Dim screen_mode = IIf(D_interview_cd.ToString <> "", Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(D_Y).Item("screen_mode"), ""), 0)
                    If screen_mode < 20 Then
                        rowEnds = 50
                    Else
                        rowEnds = 53
                    End If
                    rangeCopys = String.Format("A{0}:BD{1}", rowStarts, rowEnds)
                    rangePastes = String.Format("A{0}:BD{0}", D_Fill)

                    Utl_Rpt.CopyRowExcell(D_EXL_SHT, D_Fill, D_EXL_SHT1, rowStarts, rowEnds, rangeCopys, rangePastes, False)
                    D_Fill = D_Fill + 1
                    D_EXL_SHT.Row(D_Fill - 1).Height = 17.25
                    D_EXL_SHT.Row(D_Fill).Height = 34.5
                    D_EXL_SHT.Cells(D_Fill - 1, 2).Value = free_question_nm
                    D_EXL_SHT.Cells(D_Fill, 2).Value = IIf(D_interview_cd.ToString <> "", Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(D_Y).Item("free_question"), ""), "")
                    ' space between 2 table
                    D_Fill = D_Fill + 7
                    '
                    D_EXL_SHT.Row(D_Fill - 1).Height = 17.25
                    D_EXL_SHT.Row(D_Fill).Height = 34.5
                    D_EXL_SHT.Cells(D_Fill - 1, 2).Value = member_comment_nm
                    D_EXL_SHT.Cells(D_Fill, 2).Value = IIf(D_interview_cd.ToString <> "", Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(D_Y).Item("member_comment"), ""), "")
                    ' space between 2 table
                    D_Fill = D_Fill + 3
                    D_EXL_SHT.Row(D_Fill - 1).Height = 17.25
                    D_EXL_SHT.Row(D_Fill).Height = 34.5
                    D_EXL_SHT.Cells(D_Fill - 1, 2).Value = coach_comment1_nm
                    D_EXL_SHT.Cells(D_Fill, 2).Value = IIf(D_interview_cd.ToString <> "", Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(D_Y).Item("coach_comment1"), ""), "")
                    ' space between 2 table
                    D_Fill = D_Fill + 3
                    '
                    D_EXL_SHT.Row(D_Fill - 1).Height = 17.25
                    D_EXL_SHT.Row(D_Fill).Height = 34.5
                    D_EXL_SHT.Cells(D_Fill - 1, 2).Value = next_action_nm
                    D_EXL_SHT.Cells(D_Fill, 2).Value = IIf(D_interview_cd.ToString <> "", Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(D_Y).Item("next_action"), ""), "")
                    ' space between 2 table
                    D_Fill = D_Fill + 3
                    '
                    If screen_mode < 20 Then

                        D_EXL_SHT.Cells(D_Fill, 2).Value = ""
                    Else
                        D_EXL_SHT.Row(D_Fill - 1).Height = 17.25
                        D_EXL_SHT.Row(D_Fill).Height = 34.5
                        D_EXL_SHT.Cells(D_Fill - 1, 2).Value = coach_comment2_nm
                        D_EXL_SHT.Cells(D_Fill, 2).Value = IIf(D_interview_cd.ToString <> "", Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(D_Y).Item("coach_comment2"), ""), "")
                    End If
                    'Delete row thua phai xoa tu duoi len de vi tri ko thay doi 
                    'コーチコメント(人事部門のみ閲覧可)
                    If coach_comment2_typ = 0 Then
                        D_EXL_SHT.DeleteRow(D_Fill_2 + 17 - 1, 2)
                    End If
                    '次回までのアクション（メンバーが記入）
                    If next_action_typ = 0 Then
                        D_EXL_SHT.DeleteRow(D_Fill_2 + 14 - 1, 2)
                    End If
                    'コーチコメント
                    If coach_comment1_typ = 0 Then
                        D_EXL_SHT.DeleteRow(D_Fill_2 + 11 - 1, 2)
                    End If
                    'メンバーコメント
                    If member_comment_typ = 0 Then
                        D_EXL_SHT.DeleteRow(D_Fill_2 + 8 - 1, 2)
                    End If
                    '自由記入欄
                    If free_question_use_typ = 0 Then
                        D_EXL_SHT.DeleteRow(D_Fill_2 + 1 - 1, 2)
                    End If
                    'コーチからメンバーへの期待
                    If comment_use_typ = 0 Then
                        D_EXL_SHT.DeleteRow(27, 2)
                    End If
                    'WILL-CAN-MUST
                    If (target1_use_typ + target2_use_typ + target3_use_typ) = 0 Then
                        D_EXL_SHT.DeleteRow(24, 2)
                    End If
                    '
                Next
                D_EXL_BOK.Workbook.Worksheets.Delete(1)
                D_EXL_BOK.Workbook.Worksheets.Delete(1)
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
        FNC_EXL_oI2010 = "{" + """" + "status" + """" + ":" + status + "," + """" + "filename" + """" + ":" + """" + fileName + """," + """" + "message" + """" + ":" + """" + message + """}"
        Exit Function

    End Function

End Class