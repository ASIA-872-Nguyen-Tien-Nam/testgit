Imports System.IO
Imports System.Globalization
Imports System.Drawing

'*********************************************************************************************************
'*
'*  処理概要：Function create Excel
'*  目標一覧表
'*  作成日：	    2024/04/15
'*  作成者：　　 namnb
'*
'*********************************************************************************************************
Imports OfficeOpenXml
Imports Newtonsoft.Json
Imports OfficeOpenXml.Style

Public Class Frm_eQ0101
    Public Function FNC_EXL_eQ0101(
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
        Dim D_CELL_CNT As Integer = 0
        Dim D_TABLE1_CNT As Integer = 0
        Dim D_EXL_SHT1 As ExcelWorksheet = Nothing

        Try
            D_DAT = New DataSet
            Dim D_UTL_RDB As Utl_RDB = New Utl_RDB()
            D_DAT = D_UTL_RDB.FNC_GET_DAT(sql)


            If Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(0).Item("language"), "") = "en" Then
                D_EXL_TML = ConfigurationManager.AppSettings("FIL_TEM_EXL") & "\eQ0101_en.xlsx"
            Else
                D_EXL_TML = ConfigurationManager.AppSettings("FIL_TEM_EXL") & "\eQ0101.xlsx"
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
                Dim add_rows As Integer = 0
                Dim del_rows As Integer = 0
                Dim sampleRow As Integer = 39
                Dim sampleRowHeight As Double = D_EXL_SHT1.Row(sampleRow).Height
                Dim sampleRowHeader As Integer = 1
                Dim sampleRowSmall As Integer = 3
                Dim sampleRowHeightHeader As Double = D_EXL_SHT1.Row(sampleRowHeader).Height
                Dim sampleRowHeightSmall As Double = D_EXL_SHT1.Row(sampleRowSmall).Height
                'fill employee
                If D_DAT.Tables(1).Rows.Count > 0 Then
                    Dim D_cl As Integer = 0
                    Dim imageDirectory As String = ConfigurationManager.AppSettings("FIL_AVATAR_IMG")
                    Dim D_file_nm = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(1).Rows(0).Item("picture"), "")
                    If File.Exists(Path.Combine(imageDirectory & "\" & D_file_nm)) Then
                        Dim img = Image.FromFile(imageDirectory & "\" & D_file_nm)


                        Dim pic = D_EXL_SHT1.Drawings.AddPicture("Untitled-1" + D_cl.ToString(), img)
                        pic.SetPosition(3, 0, 12, 0)
                        pic.AdjustPositionAndSize()
                        pic.SetSize(310, 120)
                        img = Nothing
                    End If
                    D_EXL_SHT1.Cells(2, 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(1).Rows(0).Item("employee_nm"), "")
                    D_EXL_SHT1.Cells(4, 4).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(1).Rows(0).Item("employee_cd"), "")
                    D_EXL_SHT1.Cells(4, 8).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(1).Rows(0).Item("furigana"), "")
                    D_EXL_SHT1.Cells(5, 8).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(1).Rows(0).Item("employee_nm"), "")
                    D_EXL_SHT1.Cells(6, 4).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(1).Rows(0).Item("company_in_dt"), "")
                    D_EXL_SHT1.Cells(6, 8).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(1).Rows(0).Item("period_date"), "")
                    D_EXL_SHT1.Cells(6, 12).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(1).Rows(0).Item("gender"), "")
                    D_EXL_SHT1.Cells(7, 4).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(1).Rows(0).Item("birth_date"), "")
                    D_EXL_SHT1.Cells(7, 8).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(1).Rows(0).Item("year_old"), "")
                    D_EXL_SHT1.Cells(8, 4).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(1).Rows(0).Item("mail"), "")
                    D_EXL_SHT1.Cells(9, 4).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(1).Rows(0).Item("company_mobile_number"), "")
                    D_EXL_SHT1.Cells(9, 10).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(1).Rows(0).Item("extension_number"), "")
                    D_EXL_SHT1.Cells(10, 4).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(1).Rows(0).Item("company_out_dt"), "")
                    D_EXL_SHT1.Cells(10, 8).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(1).Rows(0).Item("retirement_reason"), "")
                    D_EXL_SHT1.Cells(16, 12).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(1).Rows(0).Item("salary_grade"), "")

                    D_cl = Nothing
                    imageDirectory = Nothing
                    D_file_nm = Nothing
                End If
                If D_DAT.Tables(2).Rows.Count > 0 Then
                    D_EXL_SHT1.Cells(11, 7).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(2).Rows(0).Item("organization_cd_1"), "")
                    D_EXL_SHT1.Cells(11, 12).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(2).Rows(0).Item("organization_cd_2"), "")
                    D_EXL_SHT1.Cells(12, 7).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(2).Rows(0).Item("organization_cd_3"), "")
                    D_EXL_SHT1.Cells(12, 12).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(2).Rows(0).Item("organization_cd_4"), "")
                    D_EXL_SHT1.Cells(13, 7).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(2).Rows(0).Item("organization_cd_5"), "")
                    D_EXL_SHT1.Cells(12, 3).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(2).Rows(0).Item("application_date"), "")
                    D_EXL_SHT1.Cells(14, 7).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(2).Rows(0).Item("position_nm"), "")
                    D_EXL_SHT1.Cells(14, 12).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(2).Rows(0).Item("job_nm"), "")
                    D_EXL_SHT1.Cells(15, 7).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(2).Rows(0).Item("office_nm"), "")
                    D_EXL_SHT1.Cells(15, 12).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(2).Rows(0).Item("employee_typ_nm"), "")
                    D_EXL_SHT1.Cells(16, 7).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(2).Rows(0).Item("grade_nm"), "")


                End If

                If D_DAT.Tables(3).Rows.Count > 0 Then
                    D_EXL_SHT1.Cells(17, 7).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(3).Rows(0).Item("organization_cd_1"), "")
                    D_EXL_SHT1.Cells(17, 12).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(3).Rows(0).Item("organization_cd_2"), "")
                    D_EXL_SHT1.Cells(18, 7).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(3).Rows(0).Item("organization_cd_3"), "")
                    D_EXL_SHT1.Cells(18, 12).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(3).Rows(0).Item("organization_cd_4"), "")
                    D_EXL_SHT1.Cells(19, 7).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(3).Rows(0).Item("organization_cd_5"), "")
                    D_EXL_SHT1.Cells(20, 7).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(3).Rows(0).Item("position_nm"), "")
                End If
                If D_DAT.Tables(3).Rows.Count > 1 Then
                    D_EXL_SHT1.Cells(21, 7).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(3).Rows(1).Item("organization_cd_1"), "")
                    D_EXL_SHT1.Cells(21, 12).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(3).Rows(1).Item("organization_cd_2"), "")
                    D_EXL_SHT1.Cells(22, 7).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(3).Rows(1).Item("organization_cd_3"), "")
                    D_EXL_SHT1.Cells(22, 12).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(3).Rows(1).Item("organization_cd_4"), "")
                    D_EXL_SHT1.Cells(23, 7).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(3).Rows(1).Item("organization_cd_5"), "")
                    D_EXL_SHT1.Cells(24, 7).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(3).Rows(1).Item("position_nm"), "")
                End If
                If D_DAT.Tables(3).Rows.Count > 2 Then
                    D_EXL_SHT1.Cells(25, 7).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(3).Rows(2).Item("organization_cd_1"), "")
                    D_EXL_SHT1.Cells(25, 12).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(3).Rows(2).Item("organization_cd_2"), "")
                    D_EXL_SHT1.Cells(26, 7).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(3).Rows(2).Item("organization_cd_3"), "")
                    D_EXL_SHT1.Cells(26, 12).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(3).Rows(2).Item("organization_cd_4"), "")
                    D_EXL_SHT1.Cells(27, 7).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(3).Rows(2).Item("organization_cd_5"), "")
                    D_EXL_SHT1.Cells(28, 7).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(3).Rows(2).Item("position_nm"), "")
                End If

                If D_DAT.Tables(4).Rows.Count > 0 Then
                    D_EXL_SHT1.Cells(30, 3).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(4).Rows(0).Item("application_date"), "")
                    D_EXL_SHT1.Cells(29, 7).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(4).Rows(0).Item("belong_cd1_nm"), "")
                    D_EXL_SHT1.Cells(29, 12).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(4).Rows(0).Item("belong_cd2_nm"), "")
                    D_EXL_SHT1.Cells(30, 7).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(4).Rows(0).Item("belong_cd3_nm"), "")
                    D_EXL_SHT1.Cells(30, 12).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(4).Rows(0).Item("belong_cd4_nm"), "")
                    D_EXL_SHT1.Cells(31, 7).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(4).Rows(0).Item("belong_cd5_nm"), "")
                    D_EXL_SHT1.Cells(32, 7).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(4).Rows(0).Item("position_nm"), "")
                    D_EXL_SHT1.Cells(32, 12).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(4).Rows(0).Item("job_nm"), "")
                    D_EXL_SHT1.Cells(33, 7).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(4).Rows(0).Item("office_nm"), "")
                    D_EXL_SHT1.Cells(33, 12).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(4).Rows(0).Item("employee_typ_nm"), "")
                    D_EXL_SHT1.Cells(34, 7).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(4).Rows(0).Item("grade_nm"), "")
                End If

                If D_DAT.Tables(5).Rows.Count > 0 Then
                    D_EXL_SHT1.Cells(35, 7).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(5).Rows(0).Item("belong_cd1_nm"), "")
                    D_EXL_SHT1.Cells(35, 12).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(5).Rows(0).Item("belong_cd2_nm"), "")
                    D_EXL_SHT1.Cells(36, 7).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(5).Rows(0).Item("belong_cd3_nm"), "")
                    D_EXL_SHT1.Cells(36, 12).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(5).Rows(0).Item("belong_cd4_nm"), "")
                    D_EXL_SHT1.Cells(37, 7).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(5).Rows(0).Item("belong_cd5_nm"), "")
                    D_EXL_SHT1.Cells(38, 7).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(5).Rows(0).Item("position_nm"), "")
                End If

                If D_DAT.Tables(4).Rows.Count > 1 Then
                    D_EXL_SHT1.Cells(40, 3).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(4).Rows(1).Item("application_date"), "")
                    D_EXL_SHT1.Cells(39, 7).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(4).Rows(1).Item("belong_cd1_nm"), "")
                    D_EXL_SHT1.Cells(39, 12).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(4).Rows(1).Item("belong_cd2_nm"), "")
                    D_EXL_SHT1.Cells(40, 7).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(4).Rows(1).Item("belong_cd3_nm"), "")
                    D_EXL_SHT1.Cells(40, 12).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(4).Rows(1).Item("belong_cd4_nm"), "")
                    D_EXL_SHT1.Cells(41, 7).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(4).Rows(1).Item("belong_cd5_nm"), "")
                    D_EXL_SHT1.Cells(42, 7).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(4).Rows(1).Item("position_nm"), "")
                    D_EXL_SHT1.Cells(42, 12).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(4).Rows(1).Item("job_nm"), "")
                    D_EXL_SHT1.Cells(43, 7).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(4).Rows(1).Item("office_nm"), "")
                    D_EXL_SHT1.Cells(43, 12).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(4).Rows(1).Item("employee_typ_nm"), "")
                    D_EXL_SHT1.Cells(44, 7).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(4).Rows(1).Item("grade_nm"), "")
                End If

                If D_DAT.Tables(5).Rows.Count > 1 Then
                    D_EXL_SHT1.Cells(45, 7).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(5).Rows(1).Item("belong_cd1_nm"), "")
                    D_EXL_SHT1.Cells(45, 12).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(5).Rows(1).Item("belong_cd2_nm"), "")
                    D_EXL_SHT1.Cells(46, 7).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(5).Rows(1).Item("belong_cd3_nm"), "")
                    D_EXL_SHT1.Cells(46, 12).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(5).Rows(1).Item("belong_cd4_nm"), "")
                    D_EXL_SHT1.Cells(47, 7).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(5).Rows(1).Item("belong_cd5_nm"), "")
                    D_EXL_SHT1.Cells(48, 7).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(5).Rows(1).Item("position_nm"), "")
                End If

                If D_DAT.Tables(6).Rows.Count > 0 Then
                    D_EXL_SHT1.Cells(11, 5).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(6).Rows(0).Item("1"), "")
                    D_EXL_SHT1.Cells(17, 5).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(6).Rows(0).Item("1"), "")
                    D_EXL_SHT1.Cells(21, 5).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(6).Rows(0).Item("1"), "")
                    D_EXL_SHT1.Cells(25, 5).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(6).Rows(0).Item("1"), "")
                    D_EXL_SHT1.Cells(29, 5).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(6).Rows(0).Item("1"), "")
                    D_EXL_SHT1.Cells(35, 5).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(6).Rows(0).Item("1"), "")
                    D_EXL_SHT1.Cells(39, 5).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(6).Rows(0).Item("1"), "")
                    D_EXL_SHT1.Cells(45, 5).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(6).Rows(0).Item("1"), "")

                    D_EXL_SHT1.Cells(11, 10).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(6).Rows(0).Item("2"), "")
                    D_EXL_SHT1.Cells(17, 10).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(6).Rows(0).Item("2"), "")
                    D_EXL_SHT1.Cells(21, 10).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(6).Rows(0).Item("2"), "")
                    D_EXL_SHT1.Cells(25, 10).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(6).Rows(0).Item("2"), "")
                    D_EXL_SHT1.Cells(29, 10).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(6).Rows(0).Item("2"), "")
                    D_EXL_SHT1.Cells(35, 10).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(6).Rows(0).Item("2"), "")
                    D_EXL_SHT1.Cells(39, 10).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(6).Rows(0).Item("2"), "")
                    D_EXL_SHT1.Cells(45, 10).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(6).Rows(0).Item("2"), "")

                    D_EXL_SHT1.Cells(12, 5).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(6).Rows(0).Item("3"), "")
                    D_EXL_SHT1.Cells(18, 5).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(6).Rows(0).Item("3"), "")
                    D_EXL_SHT1.Cells(22, 5).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(6).Rows(0).Item("3"), "")
                    D_EXL_SHT1.Cells(26, 5).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(6).Rows(0).Item("3"), "")
                    D_EXL_SHT1.Cells(30, 5).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(6).Rows(0).Item("3"), "")
                    D_EXL_SHT1.Cells(36, 5).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(6).Rows(0).Item("3"), "")
                    D_EXL_SHT1.Cells(40, 5).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(6).Rows(0).Item("3"), "")
                    D_EXL_SHT1.Cells(46, 5).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(6).Rows(0).Item("3"), "")

                    D_EXL_SHT1.Cells(12, 10).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(6).Rows(0).Item("4"), "")
                    D_EXL_SHT1.Cells(18, 10).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(6).Rows(0).Item("4"), "")
                    D_EXL_SHT1.Cells(22, 10).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(6).Rows(0).Item("4"), "")
                    D_EXL_SHT1.Cells(26, 10).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(6).Rows(0).Item("4"), "")
                    D_EXL_SHT1.Cells(30, 10).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(6).Rows(0).Item("4"), "")
                    D_EXL_SHT1.Cells(36, 10).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(6).Rows(0).Item("4"), "")
                    D_EXL_SHT1.Cells(40, 10).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(6).Rows(0).Item("4"), "")
                    D_EXL_SHT1.Cells(46, 10).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(6).Rows(0).Item("4"), "")

                    D_EXL_SHT1.Cells(13, 5).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(6).Rows(0).Item("5"), "")
                    D_EXL_SHT1.Cells(19, 5).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(6).Rows(0).Item("5"), "")
                    D_EXL_SHT1.Cells(23, 5).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(6).Rows(0).Item("5"), "")
                    D_EXL_SHT1.Cells(27, 5).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(6).Rows(0).Item("5"), "")
                    D_EXL_SHT1.Cells(31, 5).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(6).Rows(0).Item("5"), "")
                    D_EXL_SHT1.Cells(37, 5).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(6).Rows(0).Item("5"), "")
                    D_EXL_SHT1.Cells(41, 5).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(6).Rows(0).Item("5"), "")
                    D_EXL_SHT1.Cells(47, 5).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(6).Rows(0).Item("5"), "")

                End If

                'fill その他社員情報
                Dim delTab1 As Integer = 0
                Dim D_ROW_CNT_TAB1 = D_DAT.Tables(7).Rows.Count
                If D_ROW_CNT_TAB1 > 0 Then
                    D_EXL_SHT1.Cells(51, 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(1).Rows(0).Item("employee_nm"), "")
                    D_EXL_SHT1.Cells(53, 4).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(7).Rows(0).Item("blood_type"), "")
                    D_EXL_SHT1.Cells(54, 5).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(7).Rows(0).Item("headquarters_prefectures"), "")
                    D_EXL_SHT1.Cells(54, 9).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(7).Rows(0).Item("headquarters_other"), "")
                    D_EXL_SHT1.Cells(54, 14).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(7).Rows(0).Item("possibility_transfer"), "")
                    D_EXL_SHT1.Cells(55, 4).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(7).Rows(0).Item("nationality"), "")
                    D_EXL_SHT1.Cells(55, 8).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(7).Rows(0).Item("status_residence"), "")
                    D_EXL_SHT1.Cells(56, 4).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(7).Rows(0).Item("expiry_date"), "")
                    D_EXL_SHT1.Cells(56, 8).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(7).Rows(0).Item("permission_activities"), "")
                    D_EXL_SHT1.Cells(57, 4).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(7).Rows(0).Item("disability_classification"), "")
                    D_EXL_SHT1.Cells(57, 8).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(7).Rows(0).Item("disability_recognition_date"), "")
                    D_EXL_SHT1.Cells(58, 4).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(7).Rows(0).Item("disability_content"), "")
                    D_EXL_SHT1.Cells(59, 4).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(7).Rows(0).Item("common_name_furigana"), "")
                    D_EXL_SHT1.Cells(60, 4).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(7).Rows(0).Item("common_name"), "")
                    D_EXL_SHT1.Cells(61, 4).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(7).Rows(0).Item("maiden_name_furigana"), "")
                    D_EXL_SHT1.Cells(62, 4).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(7).Rows(0).Item("maiden_name"), "")
                    D_EXL_SHT1.Cells(63, 4).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(7).Rows(0).Item("business_name_furigana"), "")
                    D_EXL_SHT1.Cells(64, 4).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(7).Rows(0).Item("business_name"), "")
                    'MARCO POLO分析
                    D_EXL_SHT1.Cells(66, 5).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(7).Rows(0).Item("base_style"), "")
                    D_EXL_SHT1.Cells(66, 12).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(7).Rows(0).Item("sub_style"), "")
                    D_EXL_SHT1.Cells(67, 5).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(7).Rows(0).Item("driver_point"), "")
                    D_EXL_SHT1.Cells(67, 12).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(7).Rows(0).Item("analytical_point"), "")
                    D_EXL_SHT1.Cells(68, 5).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(7).Rows(0).Item("expressive_point"), "")
                    D_EXL_SHT1.Cells(68, 12).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(7).Rows(0).Item("amiable_point"), "")
                Else
                    delTab1 = 50
                End If


                'fill 資格
                Dim sourceValue As Object = D_EXL_SHT1.Cells(2, 2).Value
                Dim delTab2 As Integer = 0
                Dim D_ROW_CNT_TAB2 = D_DAT.Tables(8).Rows.Count
                If D_ROW_CNT_TAB2 > 0 Then
                    Dim countPage As Integer = Math.Ceiling(D_ROW_CNT_TAB2 / 44.0)

                    D_EXL_SHT1.InsertRow(148 + add_rows, 49 * (countPage - 1))
                    For h As Integer = 0 To 49 * (countPage - 1) - 1
                        D_EXL_SHT1.Row(148 + add_rows + h).Height = sampleRowHeight
                    Next
                    D_EXL_SHT1.Cells(100 + add_rows, 2).Value = sourceValue
                    If countPage <> 0 Then
                        For i = 0 To countPage - 1
                            If i <> 0 Then
                                Dim sourceRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (99 + add_rows) & ":O" & (103 + add_rows))
                                Dim destinationRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (99 + add_rows + i * 49) & ":O" & (103 + add_rows + i * 49))
                                sourceRange.Copy(destinationRange)

                                D_EXL_SHT1.Row(99 + i * 49 + add_rows).Height = sampleRowHeightHeader
                                D_EXL_SHT1.Row(101 + i * 49 + add_rows).Height = sampleRowHeightSmall
                            End If

                        Next
                    End If

                    Dim page As Integer = 0
                    For j = 0 To D_ROW_CNT_TAB2 - 1
                        If countPage <> 0 Then
                            If j Mod 44 = 0 And j <> 0 Then
                                page += 5
                            End If
                        End If
                        D_EXL_SHT1.Cells("B" & (104 + add_rows) & ":N" & (104 + add_rows)).Copy(D_EXL_SHT1.Cells("B" & (104 + j + add_rows + page) & ":N" & (104 + j + add_rows + page)))
                        D_EXL_SHT1.Cells(104 + j + add_rows + page, 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(8).Rows(j).Item("id"), "")
                        D_EXL_SHT1.Cells(104 + j + add_rows + page, 3).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(8).Rows(j).Item("qualification_nm"), "")
                        D_EXL_SHT1.Cells(104 + j + add_rows + page, 6).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(8).Rows(j).Item("qualification_typ_nm"), "")
                        D_EXL_SHT1.Cells(104 + j + add_rows + page, 8).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(8).Rows(j).Item("headquarters_other"), "")
                        D_EXL_SHT1.Cells(104 + j + add_rows + page, 10).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(8).Rows(j).Item("possibility_transfer"), "")
                        D_EXL_SHT1.Cells(104 + j + add_rows + page, 12).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(8).Rows(j).Item("remarks"), "")
                    Next
                    add_rows += 49 * (countPage - 1)

                Else
                    delTab2 = 99
                End If
                'fill 人事評価
                Dim delTab3 As Integer = 0
                Dim treatment_applications_no As Integer = 0
                Dim D_ROW_CNT_TAB3_2 = D_DAT.Tables(10).Rows.Count
                If D_ROW_CNT_TAB3_2 > 0 Then
                    Dim D_ROW_CNT_TAB3_1 = D_DAT.Tables(9).Rows.Count
                    Dim countPage As Integer = D_DAT.Tables(10).Rows.Count / 45 - 0.5
                    D_EXL_SHT1.InsertRow(196 + add_rows, 49 * countPage)
                    For h As Integer = 0 To 49 * countPage - 1
                        D_EXL_SHT1.Row(196 + add_rows + h).Height = sampleRowHeight
                    Next
                    D_EXL_SHT1.Cells(149 + add_rows, 2).Value = sourceValue
                    Dim page As Integer = 0
                    For i = 0 To D_ROW_CNT_TAB3_2 - 1
                        If countPage <> 0 Then
                            If i Mod 45 = 0 And i <> 0 Then
                                page += 5
                            End If
                        End If
                        D_EXL_SHT1.Cells("B" & (152 + add_rows) & ":N" & (152 + add_rows)).Copy(D_EXL_SHT1.Cells("B" & (152 + i + add_rows + page) & ":N" & (152 + i + add_rows + page)))
                        D_EXL_SHT1.Cells(152 + i + add_rows + page, 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(10).Rows(i).Item("treatment_applications_nm"), "")
                        treatment_applications_no += 1
                    Next

                    If D_ROW_CNT_TAB3_1 > 0 Then
                        For i = 0 To treatment_applications_no - 1
                            For j = 0 To D_ROW_CNT_TAB3_1 - 1
                                D_EXL_SHT1.Cells(151 + add_rows, 5 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(9).Rows(j).Item("fiscal_year"), "")
                                D_EXL_SHT1.Cells(152 + i + add_rows, j * 2 + 5).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(9).Rows(j).Item(i + 1), "")
                            Next
                        Next
                    End If
                Else
                    delTab3 = 148 + add_rows
                End If


                'fill 研修受講履歴
                Dim delTab4 As Integer = 0
                Dim D_ROW_CNT_TAB4 = D_DAT.Tables(11).Rows.Count

                If D_ROW_CNT_TAB4 > 0 Then
                    Dim countPage As Integer = Math.Ceiling(D_ROW_CNT_TAB4 / 7.0)
                    D_EXL_SHT1.InsertRow(245 + add_rows, 49 * (countPage - 1))
                    For h As Integer = 0 To 49 * (countPage - 1) - 1
                        D_EXL_SHT1.Row(245 + add_rows + h).Height = sampleRowHeight
                    Next
                    D_EXL_SHT1.Cells(198 + add_rows, 2).Value = sourceValue

                    For y = 0 To countPage - 1
                        'copy header
                        D_EXL_SHT1.Cells("A" & (197 + add_rows) & ":O" & (199 + add_rows)).Copy(D_EXL_SHT1.Cells("A" & (197 + 49 * y + add_rows) & ":O" & (199 + 49 * y + add_rows)))
                        D_EXL_SHT1.Row(197 + 49 * y + add_rows).Height = sampleRowHeightHeader
                        D_EXL_SHT1.Row(199 + 49 * y + add_rows).Height = sampleRowHeightSmall
                    Next

                    Dim page As Integer = 0
                    For i = 0 To D_ROW_CNT_TAB4 - 1
                        If countPage <> 0 Then
                            If i Mod 7 = 0 And i <> 0 Then
                                page += 7
                            End If
                        End If
                   
                        'copy boder and fill data
                        D_EXL_SHT1.Cells("B" & (200 + add_rows) & ":B" & (205 + add_rows)).Copy(D_EXL_SHT1.Cells("B" & (200 + i * 6 + add_rows + page)))
                        Dim mergeRange As ExcelRange = D_EXL_SHT1.Cells("B" & (200 + i * 6 + add_rows + page) & ":B" & (205 + i * 6 + add_rows + page))
                        mergeRange.Merge = True
                        D_EXL_SHT1.Cells("C" & (200 + add_rows) & ":N" & (205 + add_rows)).Copy(D_EXL_SHT1.Cells("C" & (200 + i * 6 + add_rows + page) & ":N" & (205 + i * 6 + add_rows + page)))
                        D_EXL_SHT1.Cells(200 + i * 6 + add_rows + page, 2).Value = i + 1
                        D_EXL_SHT1.Cells(201 + i * 6 + add_rows + page, 3).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(11).Rows(i).Item("training_cd"), "")
                        D_EXL_SHT1.Cells(201 + i * 6 + add_rows + page, 5).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(11).Rows(i).Item("training_nm"), "")
                        D_EXL_SHT1.Cells(201 + i * 6 + add_rows + page, 9).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(11).Rows(i).Item("training_category_cd"), "")
                        D_EXL_SHT1.Cells(201 + i * 6 + add_rows + page, 12).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(11).Rows(i).Item("training_course_format_cd"), "")
                        D_EXL_SHT1.Cells(203 + i * 6 + add_rows + page, 3).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(11).Rows(i).Item("lecturer_name"), "")
                        D_EXL_SHT1.Cells(203 + i * 6 + add_rows + page, 7).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(11).Rows(i).Item("training_date_from"), "")
                        D_EXL_SHT1.Cells(203 + i * 6 + add_rows + page, 9).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(11).Rows(i).Item("training_date_to"), "")
                        D_EXL_SHT1.Cells(203 + i * 6 + add_rows + page, 11).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(11).Rows(i).Item("training_status"), "")
                        D_EXL_SHT1.Cells(203 + i * 6 + add_rows + page, 13).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(11).Rows(i).Item("passing_date"), "")
                        D_EXL_SHT1.Cells(204 + i * 6 + add_rows + page, 5).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(11).Rows(i).Item("report_submission"), "")
                        D_EXL_SHT1.Cells(205 + i * 6 + add_rows + page, 5).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(11).Rows(i).Item("report_submission_date"), "")
                        D_EXL_SHT1.Cells(204 + i * 6 + add_rows + page, 9).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(11).Rows(i).Item("report_storage_location"), "")
                        D_EXL_SHT1.Cells(205 + i * 6 + add_rows + page, 9).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(11).Rows(i).Item("nationality"), "")
                    Next
                    add_rows += 49 * (countPage - 1)
                Else
                    delTab4 = 197 + add_rows
                End If

                'fill 業務経歴
                Dim D_ROW_CNT_TAB5_1 = D_DAT.Tables(12).Rows.Count
                Dim D_ROW_CNT_TAB5_2 = D_DAT.Tables(13).Rows.Count
                Dim count As Integer = 0
                Dim count2 As Integer = 0
                Dim countChange As Integer = 0
                Dim countChange2 As Integer = 0
                Dim countLine As Integer = 0
                Dim countLine2 As Integer = 0
                Dim lineDetail As Integer = 0
                Dim lineDetailMax As Integer = 0
                Dim quantityDetail As Integer = 0
                Dim addRows As Integer = 0
                Dim addLine As Integer = 0
                Dim lineP1 As Integer = 1
                Dim lineP2 As Integer = 0
                Dim del9 As Integer = 0
                Dim del9P1 As Integer = 0
                Dim del10 As Integer = 0
                Dim del910 As Integer = 0
                Dim del40Rows As Integer = 0
                Dim delRows0 As Integer = 0 'delete if lineDetailMax = 0
                Dim rowsStart40P2 As Integer = 0
                Dim rowsStart40P1 As Integer = 0
                Dim rowsHeader1 As Integer = 246 + add_rows
                Dim rowsHeader2 As Integer = 248 + add_rows
                Dim checkPageP2 As Integer = 1
                D_EXL_SHT1.Cells(247 + add_rows, 2).Value = sourceValue

                If D_ROW_CNT_TAB5_1 > 0 Then
                    If CInt(D_DAT.Tables(12).Rows(0).Item("detail_no")) > 0 Then
                        Dim page As Integer = 0
                        Dim d As Integer = 0
                        Dim a As Integer = CInt(D_DAT.Tables(12).Rows(0).Item("detail_no")) * 10 + CInt(D_DAT.Tables(12).Rows(0).Item("item_arrangement_line"))

                        countLine = CInt(D_DAT.Tables(12).Rows(0).Item("count_line")) * 2

                        Dim countPage1 As Integer = Math.Ceiling(countLine / 45.0)


                        'insert rows p1
                        For i = 0 To D_ROW_CNT_TAB5_1 - 1
                            If i < D_ROW_CNT_TAB5_1 - 1 Then
                                If CInt(D_DAT.Tables(12).Rows(i).Item("item_id")) = CInt(D_DAT.Tables(12).Rows(i + 1).Item("item_id")) Then
                                    lineDetail = CInt(D_DAT.Tables(12).Rows(i).Item("max_item_line")) * 2   '8
                                    quantityDetail = 45 \ lineDetail
                                    lineDetailMax = quantityDetail * lineDetail
                                    addLine = 45 - lineDetailMax

                                    If CInt(D_DAT.Tables(12).Rows(i).Item("detail_no1")) <> CInt(D_DAT.Tables(12).Rows(i + 1).Item("detail_no1")) Then
                                        d += 1
                                    End If
                                    If countPage1 <> 0 Then
                                        If d = quantityDetail Then
                                            d = 0
                                            page += addLine + 4
                                        End If
                                    End If
                                    If i = D_ROW_CNT_TAB5_1 - 2 Then
                                        D_EXL_SHT1.InsertRow(252 + add_rows, countLine - 2 + page)
                                        For h As Integer = 0 To (countLine - 2 + page) - 1
                                            D_EXL_SHT1.Row(252 + add_rows + h).Height = sampleRowHeight
                                        Next
                                    End If
                                Else
                                    If i > 0 Then
                                        lineDetail = CInt(D_DAT.Tables(12).Rows(i).Item("max_item_line")) * 2   '8
                                        quantityDetail = 45 \ lineDetail
                                        lineDetailMax = quantityDetail * lineDetail
                                        addLine = 45 - lineDetailMax

                                        If CInt(D_DAT.Tables(12).Rows(i).Item("detail_no1")) <> CInt(D_DAT.Tables(12).Rows(i + 1).Item("detail_no1")) Then
                                            d += 1
                                        End If
                                        If countPage1 <> 0 Then
                                            If d = quantityDetail Then
                                                d = 0
                                                page += addLine + 4
                                            End If
                                        End If
                                        If i = D_ROW_CNT_TAB5_1 - 2 Then
                                            D_EXL_SHT1.InsertRow(252 + add_rows, countLine - 2 + page)
                                            For h As Integer = 0 To (countLine - 2 + page) - 1
                                                D_EXL_SHT1.Row(252 + add_rows + h).Height = sampleRowHeight
                                            Next
                                        End If
                                    End If
                                End If
                                
                            End If
                        Next
                        page = 0
                        d = 0
                        'fill border
                        For i = 0 To D_ROW_CNT_TAB5_1 - 1
                            Dim b As Integer = CInt(D_DAT.Tables(12).Rows(i).Item("detail_no")) * 10 + CInt(D_DAT.Tables(12).Rows(i).Item("item_arrangement_line"))
                            If b <> a Then
                                count += 1
                                lineP1 += 1

                                D_EXL_SHT1.Cells("B" & (250 + add_rows) & ":B" & (251 + add_rows)).Copy(D_EXL_SHT1.Cells("B" & (250 + count * 2 + add_rows + page)))

                                D_EXL_SHT1.Cells("C" & (250 + add_rows) & ":N" & (250 + add_rows)).Copy(D_EXL_SHT1.Cells("C" & (250 + count * 2 + add_rows + page) & ":N" & (250 + count * 2 + add_rows + page)))
                                D_EXL_SHT1.Cells("C" & (251 + add_rows) & ":N" & (251 + add_rows)).Copy(D_EXL_SHT1.Cells("C" & (251 + count * 2 + add_rows + page) & ":N" & (251 + count * 2 + add_rows + page)))
                            End If



                            If i < D_ROW_CNT_TAB5_1 - 1 AndAlso CInt(D_DAT.Tables(12).Rows(i).Item("detail_no1")) <> CInt(D_DAT.Tables(12).Rows(i + 1).Item("detail_no1")) Then
                                If i > 0 And CInt(D_DAT.Tables(12).Rows(i).Item("item_arrangement_line")) <> CInt(D_DAT.Tables(12).Rows(i + 1).Item("item_arrangement_line")) Then
                                    D_EXL_SHT1.Cells("B" & (250 + add_rows + countChange + page)).Value = CInt(D_DAT.Tables(12).Rows(i - 1).Item("detail_no1"))
                                    Dim mergeRange As ExcelRange = D_EXL_SHT1.Cells("B" & (250 + add_rows + countChange + page) & ":B" & (250 + count * 2 + 1 + add_rows + page))
                                    mergeRange.Merge = True
                                    countChange = count * 2 + 2
                                Else
                                    D_EXL_SHT1.Cells("B" & (250 + add_rows + countChange + page)).Value = CInt(D_DAT.Tables(12).Rows(i).Item("detail_no1"))
                                    Dim mergeRange As ExcelRange = D_EXL_SHT1.Cells("B" & (250 + add_rows + countChange + page) & ":B" & (251 + count * 2 + add_rows + page))
                                    mergeRange.Merge = True
                                    countChange = count * 2 + 2
                                End If
                            End If

                            If i = D_ROW_CNT_TAB5_1 - 1 Then

                                count += 1
                                'lineP1 += 1
                                D_EXL_SHT1.Cells("B" & (250 + add_rows + countChange + page)).Value = CInt(D_DAT.Tables(12).Rows(i).Item("detail_no1"))
                                Dim mergeRange As ExcelRange = D_EXL_SHT1.Cells("B" & (250 + add_rows + countChange + page) & ":B" & (250 + count * 2 - 1 + add_rows + page))
                                mergeRange.Merge = True
                                countChange = count * 2 + 2
                            End If

                            a = CInt(D_DAT.Tables(12).Rows(i).Item("detail_no")) * 10 + CInt(D_DAT.Tables(12).Rows(i).Item("item_arrangement_line"))
                            If i < D_ROW_CNT_TAB5_1 - 1 Then
                                If CInt(D_DAT.Tables(12).Rows(i).Item("item_id")) = CInt(D_DAT.Tables(12).Rows(i + 1).Item("item_id")) Then
                                    lineDetail = CInt(D_DAT.Tables(12).Rows(i).Item("max_item_line")) * 2   '8
                                    quantityDetail = 45 \ lineDetail
                                    lineDetailMax = quantityDetail * lineDetail
                                    addLine = 45 - lineDetailMax

                                    If CInt(D_DAT.Tables(12).Rows(i).Item("detail_no1")) <> CInt(D_DAT.Tables(12).Rows(i + 1).Item("detail_no1")) Then
                                        d += 1
                                    End If
                                    If countPage1 <> 0 Then

                                        If d = quantityDetail Then
                                            d = 0
                                            page += addLine + 4
                                            lineP1 = 0

                                            D_EXL_SHT1.Row(248 + count * 2 + add_rows + page).Height = sampleRowHeightHeader
                                            D_EXL_SHT1.Row(250 + count * 2 + add_rows + page).Height = sampleRowHeightSmall

                                            D_EXL_SHT1.Cells("A" & (247 + add_rows) & ":O" & (249 + add_rows)).Copy(D_EXL_SHT1.Cells("A" & (249 + count * 2 + add_rows + page) & ":O" & (251 + count * 2 + add_rows + page)))

                                            D_EXL_SHT1.Cells("A" & (246 + add_rows)).Copy(D_EXL_SHT1.Cells("A" & (248 + count * 2 + add_rows + page)))
                                            Dim mergeRange As ExcelRange = D_EXL_SHT1.Cells("A" & (248 + count * 2 + add_rows + page) & ":O" & (248 + count * 2 + add_rows + page))
                                            mergeRange.Merge = True
                                        End If
                                    End If
                                Else
                                    If i > 0 Then
                                        lineDetail = CInt(D_DAT.Tables(12).Rows(i).Item("max_item_line")) * 2   '8
                                        quantityDetail = 45 \ lineDetail
                                        lineDetailMax = quantityDetail * lineDetail
                                        addLine = 45 - lineDetailMax

                                        If CInt(D_DAT.Tables(12).Rows(i).Item("detail_no1")) <> CInt(D_DAT.Tables(12).Rows(i + 1).Item("detail_no1")) Then
                                            d += 1
                                        End If
                                        If countPage1 <> 0 Then

                                            If d = quantityDetail Then
                                                d = 0
                                                page += addLine + 4
                                                lineP1 = 0

                                                D_EXL_SHT1.Row(248 + count * 2 + add_rows + page).Height = sampleRowHeightHeader
                                                D_EXL_SHT1.Row(250 + count * 2 + add_rows + page).Height = sampleRowHeightSmall

                                                D_EXL_SHT1.Cells("A" & (247 + add_rows) & ":O" & (249 + add_rows)).Copy(D_EXL_SHT1.Cells("A" & (249 + count * 2 + add_rows + page) & ":O" & (251 + count * 2 + add_rows + page)))

                                                D_EXL_SHT1.Cells("A" & (246 + add_rows)).Copy(D_EXL_SHT1.Cells("A" & (248 + count * 2 + add_rows + page)))
                                                Dim mergeRange As ExcelRange = D_EXL_SHT1.Cells("A" & (248 + count * 2 + add_rows + page) & ":O" & (248 + count * 2 + add_rows + page))
                                                mergeRange.Merge = True
                                            End If

                                        End If
                                    End If
                                End If



                            End If

                        Next


                        Dim z As Integer = 0
                        d = 0
                        page = 0
                        a = CInt(D_DAT.Tables(12).Rows(0).Item("detail_no")) * 10 + CInt(D_DAT.Tables(12).Rows(0).Item("item_arrangement_line"))
                        For i = 0 To D_ROW_CNT_TAB5_1 - 1
                            'fill  現職情報
                            Dim y As Integer = CInt(D_DAT.Tables(12).Rows(i).Item("item_arrangement_line"))
                            Dim b As Integer = CInt(D_DAT.Tables(12).Rows(i).Item("detail_no")) * 10 + CInt(D_DAT.Tables(12).Rows(i).Item("item_arrangement_line"))
                            If i > 0 Then
                                If a <> b Then
                                    z += 1
                                End If
                            End If
                            a = CInt(D_DAT.Tables(12).Rows(i).Item("detail_no")) * 10 + CInt(D_DAT.Tables(12).Rows(i).Item("item_arrangement_line"))
                            If i > 0 And i < D_ROW_CNT_TAB5_1 - 1 Then

                                lineDetail = CInt(D_DAT.Tables(12).Rows(i).Item("max_item_line")) * 2   '8
                                quantityDetail = 45 \ lineDetail
                                lineDetailMax = quantityDetail * lineDetail
                                addLine = 45 - lineDetailMax


                                If CInt(D_DAT.Tables(12).Rows(i).Item("detail_no1")) <> CInt(D_DAT.Tables(12).Rows(i - 1).Item("detail_no1")) Then
                                    d += 1
                                End If
                                If countPage1 <> 0 Then

                                    If d = quantityDetail Then
                                        d = 0
                                        page += addLine + 4

                                    End If

                                End If

                            End If
                            If y = 1 Then

                                For j As Integer = 1 To 6
                                    If CInt(D_DAT.Tables(12).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value2")) = 1 Then
                                        D_EXL_SHT1.Cells(250 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("item_title").ToString(), "") 'fill tile
                                        Select Case CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value1"))    'check fill data
                                            Case 2
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("text_item").ToString(), "")
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                            Case 5
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("selected_items_nm").ToString(), "")
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                            Case 6
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("number_item").ToString(), "")
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right 'align right
                                        End Select
                                    End If
                                    If CInt(D_DAT.Tables(12).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value2")) = 2 Then
                                        Dim mergerange As ExcelRange = D_EXL_SHT1.Cells(250 + z * 2 + add_rows + page, 1 + j * 2, 250 + z * 2 + add_rows + page, 4 + j * 2)
                                        mergerange.Merge = True
                                        mergerange.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("item_title").ToString(), "")
                                        If CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value1")) = 1 Then
                                            D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("date_from").ToString(), "")
                                            D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 3 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("date_to").ToString(), "")
                                        End If
                                        If CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value1")) = 3 Then
                                            Dim mergerangeData As ExcelRange = D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2, 251 + z * 2 + add_rows + page, 4 + j * 2)
                                            mergerangeData.Merge = True
                                            mergerangeData.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("text_item").ToString(), "")
                                            mergerangeData.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                        End If
                                    End If
                                    If CInt(D_DAT.Tables(12).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value2")) = 6 Then
                                        Dim mergerange As ExcelRange = D_EXL_SHT1.Cells(250 + z * 2 + add_rows + page, 3, 250 + z * 2 + add_rows + page, 14)
                                        mergerange.Merge = True
                                        mergerange.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("item_title").ToString(), "")
                                        If CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value1")) = 4 Then
                                            Dim mergerangeData As ExcelRange = D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 3, 251 + z * 2 + add_rows + page, 14)
                                            mergerangeData.Merge = True
                                            mergerangeData.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("text_item").ToString(), "")
                                            mergerangeData.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                        End If
                                    End If
                                Next
                            End If
                            If y = 2 Then

                                For j As Integer = 1 To 6
                                    If CInt(D_DAT.Tables(12).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value2")) = 1 Then
                                        D_EXL_SHT1.Cells(250 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("item_title").ToString(), "") 'fill tile
                                        Select Case CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value1"))    'check fill data
                                            Case 2
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("text_item").ToString(), "")
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                            Case 5
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("selected_items_nm").ToString(), "")
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                            Case 6
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("number_item").ToString(), "")
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right 'align right
                                        End Select
                                    End If
                                    If CInt(D_DAT.Tables(12).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value2")) = 2 Then
                                        Dim mergerange As ExcelRange = D_EXL_SHT1.Cells(250 + z * 2 + add_rows + page, 1 + j * 2, 250 + z * 2 + add_rows + page, 4 + j * 2)
                                        mergerange.Merge = True
                                        mergerange.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("item_title").ToString(), "")
                                        If CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value1")) = 1 Then
                                            D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("date_from").ToString(), "")
                                            D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 3 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("date_to").ToString(), "")
                                        End If
                                        If CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value1")) = 3 Then
                                            Dim mergerangeData As ExcelRange = D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2, 251 + z * 2 + add_rows + page, 4 + j * 2)
                                            mergerangeData.Merge = True
                                            mergerangeData.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("text_item").ToString(), "")
                                            mergerangeData.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                        End If
                                    End If
                                    If CInt(D_DAT.Tables(12).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value2")) = 6 Then
                                        Dim mergerange As ExcelRange = D_EXL_SHT1.Cells(250 + z * 2 + add_rows + page, 3, 250 + z * 2 + add_rows + page, 14)
                                        mergerange.Merge = True
                                        mergerange.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("item_title").ToString(), "")
                                        If CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value1")) = 4 Then
                                            Dim mergerangeData As ExcelRange = D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 3, 251 + z * 2 + add_rows + page, 14)
                                            mergerangeData.Merge = True
                                            mergerangeData.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("text_item").ToString(), "")
                                            mergerangeData.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                        End If
                                    End If
                                Next
                            End If
                            If y = 3 Then

                                For j As Integer = 1 To 6
                                    If CInt(D_DAT.Tables(12).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value2")) = 1 Then
                                        D_EXL_SHT1.Cells(250 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("item_title").ToString(), "") 'fill tile
                                        Select Case CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value1"))    'check fill data
                                            Case 2
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("text_item").ToString(), "")
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                            Case 5
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("selected_items_nm").ToString(), "")
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                            Case 6
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("number_item").ToString(), "")
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right 'align right
                                        End Select
                                    End If
                                    If CInt(D_DAT.Tables(12).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value2")) = 2 Then
                                        Dim mergerange As ExcelRange = D_EXL_SHT1.Cells(250 + z * 2 + add_rows + page, 1 + j * 2, 250 + z * 2 + add_rows + page, 4 + j * 2)
                                        mergerange.Merge = True
                                        mergerange.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("item_title").ToString(), "")
                                        If CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value1")) = 1 Then
                                            D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("date_from").ToString(), "")
                                            D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 3 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("date_to").ToString(), "")
                                        End If
                                        If CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value1")) = 3 Then
                                            Dim mergerangeData As ExcelRange = D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2, 251 + z * 2 + add_rows + page, 4 + j * 2)
                                            mergerangeData.Merge = True
                                            mergerangeData.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("text_item").ToString(), "")
                                            mergerangeData.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                        End If
                                    End If
                                    If CInt(D_DAT.Tables(12).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value2")) = 6 Then
                                        Dim mergerange As ExcelRange = D_EXL_SHT1.Cells(250 + z * 2 + add_rows + page, 3, 250 + z * 2 + add_rows + page, 14)
                                        mergerange.Merge = True
                                        mergerange.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("item_title").ToString(), "")
                                        If CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value1")) = 4 Then
                                            Dim mergerangeData As ExcelRange = D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 3, 251 + z * 2 + add_rows + page, 14)
                                            mergerangeData.Merge = True
                                            mergerangeData.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("text_item").ToString(), "")
                                            mergerangeData.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                        End If
                                    End If
                                Next
                            End If
                            If y = 4 Then

                                For j As Integer = 1 To 6
                                    If CInt(D_DAT.Tables(12).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value2")) = 1 Then
                                        D_EXL_SHT1.Cells(250 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("item_title").ToString(), "") 'fill tile
                                        Select Case CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value1"))    'check fill data
                                            Case 2
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("text_item").ToString(), "")
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                            Case 5
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("selected_items_nm").ToString(), "")
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                            Case 6
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("number_item").ToString(), "")
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right 'align right
                                        End Select
                                    End If
                                    If CInt(D_DAT.Tables(12).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value2")) = 2 Then
                                        Dim mergerange As ExcelRange = D_EXL_SHT1.Cells(250 + z * 2 + add_rows + page, 1 + j * 2, 250 + z * 2 + add_rows + page, 4 + j * 2)
                                        mergerange.Merge = True
                                        mergerange.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("item_title").ToString(), "")
                                        If CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value1")) = 1 Then
                                            D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("date_from").ToString(), "")
                                            D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 3 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("date_to").ToString(), "")
                                        End If
                                        If CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value1")) = 3 Then
                                            Dim mergerangeData As ExcelRange = D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2, 251 + z * 2 + add_rows + page, 4 + j * 2)
                                            mergerangeData.Merge = True
                                            mergerangeData.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("text_item").ToString(), "")
                                            mergerangeData.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                        End If
                                    End If
                                    If CInt(D_DAT.Tables(12).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value2")) = 6 Then
                                        Dim mergerange As ExcelRange = D_EXL_SHT1.Cells(250 + z * 2 + add_rows + page, 3, 250 + z * 2 + add_rows + page, 14)
                                        mergerange.Merge = True
                                        mergerange.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("item_title").ToString(), "")
                                        If CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value1")) = 4 Then
                                            Dim mergerangeData As ExcelRange = D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 3, 251 + z * 2 + add_rows + page, 14)
                                            mergerangeData.Merge = True
                                            mergerangeData.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("text_item").ToString(), "")
                                            mergerangeData.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                        End If
                                    End If
                                Next
                            End If
                            If y = 5 Then

                                For j As Integer = 1 To 6
                                    If CInt(D_DAT.Tables(12).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value2")) = 1 Then
                                        D_EXL_SHT1.Cells(250 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("item_title").ToString(), "") 'fill tile
                                        Select Case CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value1"))    'check fill data
                                            Case 2
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("text_item").ToString(), "")
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                            Case 5
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("selected_items_nm").ToString(), "")
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                            Case 6
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("number_item").ToString(), "")
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right 'align right
                                        End Select
                                    End If
                                    If CInt(D_DAT.Tables(12).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value2")) = 2 Then
                                        Dim mergerange As ExcelRange = D_EXL_SHT1.Cells(250 + z * 2 + add_rows + page, 1 + j * 2, 250 + z * 2 + add_rows + page, 4 + j * 2)
                                        mergerange.Merge = True
                                        mergerange.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("item_title").ToString(), "")
                                        If CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value1")) = 1 Then
                                            D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("date_from").ToString(), "")
                                            D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 3 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("date_to").ToString(), "")
                                        End If
                                        If CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value1")) = 3 Then
                                            Dim mergerangeData As ExcelRange = D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2, 251 + z * 2 + add_rows + page, 4 + j * 2)
                                            mergerangeData.Merge = True
                                            mergerangeData.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("text_item").ToString(), "")
                                            mergerangeData.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                        End If
                                    End If
                                    If CInt(D_DAT.Tables(12).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value2")) = 6 Then
                                        Dim mergerange As ExcelRange = D_EXL_SHT1.Cells(250 + z * 2 + add_rows + page, 3, 250 + z * 2 + add_rows + page, 14)
                                        mergerange.Merge = True
                                        mergerange.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("item_title").ToString(), "")
                                        If CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value1")) = 4 Then
                                            Dim mergerangeData As ExcelRange = D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 3, 251 + z * 2 + add_rows + page, 14)
                                            mergerangeData.Merge = True
                                            mergerangeData.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("text_item").ToString(), "")
                                            mergerangeData.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                        End If
                                    End If
                                Next
                            End If
                            If y = 6 Then

                                For j As Integer = 1 To 6
                                    If CInt(D_DAT.Tables(12).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value2")) = 1 Then
                                        D_EXL_SHT1.Cells(250 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("item_title").ToString(), "") 'fill tile
                                        Select Case CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value1"))    'check fill data
                                            Case 2
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("text_item").ToString(), "")
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                            Case 5
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("selected_items_nm").ToString(), "")
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                            Case 6
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("number_item").ToString(), "")
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right 'align right
                                        End Select
                                    End If
                                    If CInt(D_DAT.Tables(12).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value2")) = 2 Then
                                        Dim mergerange As ExcelRange = D_EXL_SHT1.Cells(250 + z * 2 + add_rows + page, 1 + j * 2, 250 + z * 2 + add_rows + page, 4 + j * 2)
                                        mergerange.Merge = True
                                        mergerange.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("item_title").ToString(), "")
                                        If CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value1")) = 1 Then
                                            D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("date_from").ToString(), "")
                                            D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 3 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("date_to").ToString(), "")
                                        End If
                                        If CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value1")) = 3 Then
                                            Dim mergerangeData As ExcelRange = D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2, 251 + z * 2 + add_rows + page, 4 + j * 2)
                                            mergerangeData.Merge = True
                                            mergerangeData.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("text_item").ToString(), "")
                                            mergerangeData.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                        End If
                                    End If
                                    If CInt(D_DAT.Tables(12).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value2")) = 6 Then
                                        Dim mergerange As ExcelRange = D_EXL_SHT1.Cells(250 + z * 2 + add_rows + page, 3, 250 + z * 2 + add_rows + page, 14)
                                        mergerange.Merge = True
                                        mergerange.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("item_title").ToString(), "")
                                        If CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value1")) = 4 Then
                                            Dim mergerangeData As ExcelRange = D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 3, 251 + z * 2 + add_rows + page, 14)
                                            mergerangeData.Merge = True
                                            mergerangeData.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("text_item").ToString(), "")
                                            mergerangeData.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                        End If
                                    End If
                                Next
                            End If
                            If y = 7 Then

                                For j As Integer = 1 To 6
                                    If CInt(D_DAT.Tables(12).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value2")) = 1 Then
                                        D_EXL_SHT1.Cells(250 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("item_title").ToString(), "") 'fill tile
                                        Select Case CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value1"))    'check fill data
                                            Case 2
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("text_item").ToString(), "")
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                            Case 5
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("selected_items_nm").ToString(), "")
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                            Case 6
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("number_item").ToString(), "")
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right 'align right
                                        End Select
                                    End If
                                    If CInt(D_DAT.Tables(12).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value2")) = 2 Then
                                        Dim mergerange As ExcelRange = D_EXL_SHT1.Cells(250 + z * 2 + add_rows + page, 1 + j * 2, 250 + z * 2 + add_rows + page, 4 + j * 2)
                                        mergerange.Merge = True
                                        mergerange.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("item_title").ToString(), "")
                                        If CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value1")) = 1 Then
                                            D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("date_from").ToString(), "")
                                            D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 3 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("date_to").ToString(), "")
                                        End If
                                        If CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value1")) = 3 Then
                                            Dim mergerangeData As ExcelRange = D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2, 251 + z * 2 + add_rows + page, 4 + j * 2)
                                            mergerangeData.Merge = True
                                            mergerangeData.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("text_item").ToString(), "")
                                            mergerangeData.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                        End If
                                    End If
                                    If CInt(D_DAT.Tables(12).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value2")) = 6 Then
                                        Dim mergerange As ExcelRange = D_EXL_SHT1.Cells(250 + z * 2 + add_rows + page, 3, 250 + z * 2 + add_rows + page, 14)
                                        mergerange.Merge = True
                                        mergerange.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("item_title").ToString(), "")
                                        If CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value1")) = 4 Then
                                            Dim mergerangeData As ExcelRange = D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 3, 251 + z * 2 + add_rows + page, 14)
                                            mergerangeData.Merge = True
                                            mergerangeData.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("text_item").ToString(), "")
                                            mergerangeData.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                        End If
                                    End If
                                Next
                            End If

                            If y = 8 Then

                                For j As Integer = 1 To 6
                                    If CInt(D_DAT.Tables(12).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value2")) = 1 Then
                                        D_EXL_SHT1.Cells(250 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("item_title").ToString(), "") 'fill tile
                                        Select Case CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value1"))    'check fill data
                                            Case 2
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("text_item").ToString(), "")
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                            Case 5
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("selected_items_nm").ToString(), "")
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                            Case 6
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("number_item").ToString(), "")
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right 'align right
                                        End Select
                                    End If
                                    If CInt(D_DAT.Tables(12).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value2")) = 2 Then
                                        Dim mergerange As ExcelRange = D_EXL_SHT1.Cells(250 + z * 2 + add_rows + page, 1 + j * 2, 250 + z * 2 + add_rows + page, 4 + j * 2)
                                        mergerange.Merge = True
                                        mergerange.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("item_title").ToString(), "")
                                        If CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value1")) = 1 Then
                                            D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("date_from").ToString(), "")
                                            D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 3 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("date_to").ToString(), "")
                                        End If
                                        If CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value1")) = 3 Then
                                            Dim mergerangeData As ExcelRange = D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2, 251 + z * 2 + add_rows + page, 4 + j * 2)
                                            mergerangeData.Merge = True
                                            mergerangeData.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("text_item").ToString(), "")
                                            mergerangeData.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                        End If
                                    End If
                                    If CInt(D_DAT.Tables(12).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value2")) = 6 Then
                                        Dim mergerange As ExcelRange = D_EXL_SHT1.Cells(250 + z * 2 + add_rows + page, 3, 250 + z * 2 + add_rows + page, 14)
                                        mergerange.Merge = True
                                        mergerange.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("item_title").ToString(), "")
                                        If CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value1")) = 4 Then
                                            Dim mergerangeData As ExcelRange = D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 3, 251 + z * 2 + add_rows + page, 14)
                                            mergerangeData.Merge = True
                                            mergerangeData.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("text_item").ToString(), "")
                                            mergerangeData.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                        End If
                                    End If
                                Next
                            End If
                            If y = 9 Then

                                For j As Integer = 1 To 6
                                    If CInt(D_DAT.Tables(12).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value2")) = 1 Then
                                        D_EXL_SHT1.Cells(250 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("item_title").ToString(), "") 'fill tile
                                        Select Case CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value1"))    'check fill data
                                            Case 2
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("text_item").ToString(), "")
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                            Case 5
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("selected_items_nm").ToString(), "")
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                            Case 6
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("number_item").ToString(), "")
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right 'align right
                                        End Select
                                    End If
                                    If CInt(D_DAT.Tables(12).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value2")) = 2 Then
                                        Dim mergerange As ExcelRange = D_EXL_SHT1.Cells(250 + z * 2 + add_rows + page, 1 + j * 2, 250 + z * 2 + add_rows + page, 4 + j * 2)
                                        mergerange.Merge = True
                                        mergerange.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("item_title").ToString(), "")
                                        If CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value1")) = 1 Then
                                            D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("date_from").ToString(), "")
                                            D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 3 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("date_to").ToString(), "")
                                        End If
                                        If CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value1")) = 3 Then
                                            Dim mergerangeData As ExcelRange = D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2, 251 + z * 2 + add_rows + page, 4 + j * 2)
                                            mergerangeData.Merge = True
                                            mergerangeData.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("text_item").ToString(), "")
                                            mergerangeData.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                        End If
                                    End If
                                    If CInt(D_DAT.Tables(12).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value2")) = 6 Then
                                        Dim mergerange As ExcelRange = D_EXL_SHT1.Cells(250 + z * 2 + add_rows + page, 3, 250 + z * 2 + add_rows + page, 14)
                                        mergerange.Merge = True
                                        mergerange.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("item_title").ToString(), "")
                                        If CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value1")) = 4 Then
                                            Dim mergerangeData As ExcelRange = D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 3, 251 + z * 2 + add_rows + page, 14)
                                            mergerangeData.Merge = True
                                            mergerangeData.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("text_item").ToString(), "")
                                            mergerangeData.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                        End If
                                    End If
                                Next
                            End If
                            If y = 10 Then

                                For j As Integer = 1 To 6
                                    If CInt(D_DAT.Tables(12).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value2")) = 1 Then
                                        D_EXL_SHT1.Cells(250 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("item_title").ToString(), "") 'fill tile
                                        Select Case CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value1"))    'check fill data
                                            Case 2
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("text_item").ToString(), "")
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                            Case 5
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("selected_items_nm").ToString(), "")
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                            Case 6
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("number_item").ToString(), "")
                                                D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right 'align right
                                        End Select
                                    End If
                                    If CInt(D_DAT.Tables(12).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value2")) = 2 Then
                                        Dim mergerange As ExcelRange = D_EXL_SHT1.Cells(250 + z * 2 + add_rows + page, 1 + j * 2, 250 + z * 2 + add_rows + page, 4 + j * 2)
                                        mergerange.Merge = True
                                        mergerange.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("item_title").ToString(), "")
                                        If CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value1")) = 1 Then
                                            D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("date_from").ToString(), "")
                                            D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 3 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("date_to").ToString(), "")
                                        End If
                                        If CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value1")) = 3 Then
                                            Dim mergerangeData As ExcelRange = D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 1 + j * 2, 251 + z * 2 + add_rows + page, 4 + j * 2)
                                            mergerangeData.Merge = True
                                            mergerangeData.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("text_item").ToString(), "")
                                            mergerangeData.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                        End If
                                    End If
                                    If CInt(D_DAT.Tables(12).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value2")) = 6 Then
                                        Dim mergerange As ExcelRange = D_EXL_SHT1.Cells(250 + z * 2 + add_rows + page, 3, 250 + z * 2 + add_rows + page, 14)
                                        mergerange.Merge = True
                                        mergerange.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("item_title").ToString(), "")
                                        If CInt(D_DAT.Tables(12).Rows(i).Item("numeric_value1")) = 4 Then
                                            Dim mergerangeData As ExcelRange = D_EXL_SHT1.Cells(251 + z * 2 + add_rows + page, 3, 251 + z * 2 + add_rows + page, 14)
                                            mergerangeData.Merge = True
                                            mergerangeData.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(12).Rows(i).Item("text_item").ToString(), "")
                                            mergerangeData.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                        End If
                                    End If
                                Next
                            End If
                        Next

                        rowsStart40P1 = 252 + add_rows + countLine - 2 + page
                        
                        add_rows += countLine - 2 + page
                    Else
                        del9 = 249 + add_rows
                    End If
                Else
                    del9 = 249 + add_rows
                End If

                Dim lineP1Data As Integer = lineP1
                Dim lineP1Border As Integer = lineP1
                
                Dim PositionInforIsZero As Integer = 0
                If D_ROW_CNT_TAB5_1 = 0 Then
                    PositionInforIsZero = lineP1Border * 2 + 1
                End If
                'fill 入社前情報           
                If D_ROW_CNT_TAB5_2 > 0 Then
                    If CInt(D_DAT.Tables(13).Rows(0).Item("detail_no")) > 0 Then
                        Dim d As Integer = 0
                        Dim a As Integer = CInt(D_DAT.Tables(13).Rows(0).Item("detail_no")) * 10 + CInt(D_DAT.Tables(13).Rows(0).Item("item_arrangement_line"))
                        countLine2 = CInt(D_DAT.Tables(13).Rows(0).Item("count_line")) * 2

                        Dim countPage2 As Integer = 0
                        If D_ROW_CNT_TAB5_2 <> 0 Then
                            countPage2 = Math.Ceiling(countLine2 + lineP1 * 2 / 45.0)
                        Else
                            countPage2 = Math.Ceiling(countLine2 / 45.0)
                        End If
                        Dim page As Integer = 0

                        'insert rows p2
                        For i = 0 To D_ROW_CNT_TAB5_2 - 1
                            If i < D_ROW_CNT_TAB5_2 - 1 Then
                                If CInt(D_DAT.Tables(13).Rows(i).Item("item_id")) = CInt(D_DAT.Tables(13).Rows(i + 1).Item("item_id")) Then
                                    lineDetail = CInt(D_DAT.Tables(13).Rows(i).Item("max_item_line")) * 2   '6
                                    If lineP1 = 0 Then
                                        quantityDetail = 45 \ lineDetail
                                        lineDetailMax = quantityDetail * lineDetail
                                        addLine = 45 - lineDetailMax
                                    Else
                                        quantityDetail = (45 - (lineP1 * 2 + 1) + PositionInforIsZero) \ lineDetail
                                        lineDetailMax = quantityDetail * lineDetail
                                        addLine = (45 - (lineP1 * 2 + 1) + PositionInforIsZero) - lineDetailMax
                                        If lineDetailMax = 0 Then
                                            D_EXL_SHT1.InsertRow(rowsStart40P1, addLine + 4)
                                            For h = 0 To addLine + 3
                                                D_EXL_SHT1.Row(rowsStart40P1 + h).Height = sampleRowHeight
                                            Next
                                            add_rows += addLine + 4
                                            delRows0 = addLine + 4
                                        End If
                                    End If

                                    If CInt(D_DAT.Tables(13).Rows(i).Item("detail_no2")) <> CInt(D_DAT.Tables(13).Rows(i + 1).Item("detail_no2")) Then
                                        d += 1
                                    End If
                                    If countPage2 <> 1 Then
                                        If d = quantityDetail Then
                                            d = 0
                                            page += addLine + 4
                                            lineP1 = 0
                                        End If
                                    End If
                                    If i = D_ROW_CNT_TAB5_2 - 2 Then

                                        If D_ROW_CNT_TAB5_1 <> 0 Then
                                            D_EXL_SHT1.InsertRow(255 + add_rows, countLine2 - 2 + page)
                                            For h = 0 To (countLine2 - 2 + page) - 1
                                                D_EXL_SHT1.Row(255 + add_rows + h).Height = sampleRowHeight
                                            Next
                                        Else
                                            D_EXL_SHT1.InsertRow(255 + add_rows, countLine2 - 2 + page)
                                            For h = 0 To countLine2 + page - 1
                                                D_EXL_SHT1.Row(255 + add_rows + h).Height = sampleRowHeight
                                            Next
                                        End If
                                    End If
                                Else
                                    If i > 0 Then
                                        lineDetail = CInt(D_DAT.Tables(13).Rows(i).Item("max_item_line")) * 2   '6
                                        If lineP1 = 0 Then
                                            quantityDetail = 45 \ lineDetail
                                            lineDetailMax = quantityDetail * lineDetail
                                            addLine = 45 - lineDetailMax
                                        Else
                                            quantityDetail = (45 - (lineP1 * 2 + 1) + PositionInforIsZero) \ lineDetail
                                            lineDetailMax = quantityDetail * lineDetail
                                            addLine = (45 - (lineP1 * 2 + 1) + PositionInforIsZero) - lineDetailMax
                                            If lineDetailMax = 0 Then
                                                D_EXL_SHT1.InsertRow(rowsStart40P1, addLine + 4)
                                                For h = 0 To addLine + 3
                                                    D_EXL_SHT1.Row(rowsStart40P1 + h).Height = sampleRowHeight
                                                Next
                                                add_rows += addLine + 4
                                                delRows0 = addLine + 4
                                            End If
                                        End If

                                        If CInt(D_DAT.Tables(13).Rows(i).Item("detail_no2")) <> CInt(D_DAT.Tables(13).Rows(i + 1).Item("detail_no2")) Then
                                            d += 1
                                        End If
                                       

                                        If countPage2 <> 1 Then
                                            If d = quantityDetail Then
                                                d = 0
                                                If CInt(D_DAT.Tables(12).Rows(0).Item("detail_no")) = 0 Then
                                                    page += addLine + 4 + 3
                                                Else
                                                    page += addLine + 4
                                                End If
                                                lineP1 = 0
                                            End If
                                        End If
                                        If i = D_ROW_CNT_TAB5_2 - 2 Then

                                            If D_ROW_CNT_TAB5_1 <> 0 Then
                                                D_EXL_SHT1.InsertRow(255 + add_rows, countLine2 - 2 + page)
                                                For h = 0 To (countLine2 - 2 + page) - 1
                                                    D_EXL_SHT1.Row(255 + add_rows + h).Height = sampleRowHeight
                                                Next
                                            Else
                                                D_EXL_SHT1.InsertRow(255 + add_rows, countLine2 - 2 + page)
                                                For h = 0 To countLine2 + page - 1
                                                    D_EXL_SHT1.Row(255 + add_rows + h).Height = sampleRowHeight
                                                Next
                                            End If
                                        End If
                                    End If
                                End If

                            End If
                        Next

                        'fill 入社前情報
                        page = 0
                        d = 0

                        For i = 0 To D_ROW_CNT_TAB5_2 - 1
                            Dim b As Integer = CInt(D_DAT.Tables(13).Rows(i).Item("detail_no")) * 10 + CInt(D_DAT.Tables(13).Rows(i).Item("item_arrangement_line"))
                            'fill border 入社前情報
                            If b <> a Then
                                count2 += 1
                                lineP2 += 1
                                D_EXL_SHT1.Cells("B" & (253 + add_rows) & ":B" & (254 + add_rows)).Copy(D_EXL_SHT1.Cells("B" & (253 + count2 * 2 + add_rows + page)))

                                D_EXL_SHT1.Cells("C" & (253 + add_rows) & ":N" & (253 + add_rows)).Copy(D_EXL_SHT1.Cells("C" & (253 + count2 * 2 + add_rows + page) & ":N" & (253 + count2 * 2 + add_rows + page)))
                                D_EXL_SHT1.Cells("C" & (254 + add_rows) & ":N" & (254 + add_rows)).Copy(D_EXL_SHT1.Cells("C" & (254 + count2 * 2 + add_rows + page) & ":N" & (254 + count2 * 2 + add_rows + page)))
                            End If
                            If i < D_ROW_CNT_TAB5_2 - 1 AndAlso CInt(D_DAT.Tables(13).Rows(i).Item("detail_no2")) <> CInt(D_DAT.Tables(13).Rows(i + 1).Item("detail_no2")) Then
                                If i > 0 And CInt(D_DAT.Tables(13).Rows(i).Item("item_arrangement_line")) <> CInt(D_DAT.Tables(13).Rows(i + 1).Item("item_arrangement_line")) Then
                                    ' Thực hiện các thao tác chỉ khi điều kiện được thỏa mãn
                                    D_EXL_SHT1.Cells("B" & (253 + add_rows + countChange2 + page)).Value = CInt(D_DAT.Tables(13).Rows(i - 1).Item("detail_no2"))
                                    Dim mergeRange As ExcelRange = D_EXL_SHT1.Cells("B" & (253 + add_rows + countChange2 + page) & ":B" & (253 + count2 * 2 + 1 + add_rows + page))
                                    mergeRange.Merge = True
                                    countChange2 = count2 * 2 + 2
                                Else
                                    D_EXL_SHT1.Cells("B" & (253 + add_rows + countChange2 + page)).Value = CInt(D_DAT.Tables(13).Rows(i).Item("detail_no2"))
                                    Dim mergeRange As ExcelRange = D_EXL_SHT1.Cells("B" & (253 + add_rows + countChange2 + page) & ":B" & (254 + count2 * 2 + add_rows + page))
                                    mergeRange.Merge = True
                                    countChange2 = count2 * 2 + 2
                                End If
                            End If

                            If i = D_ROW_CNT_TAB5_2 - 1 Then
                                count2 += 1
                                D_EXL_SHT1.Cells("B" & (253 + add_rows + countChange2 + page)).Value = CInt(D_DAT.Tables(13).Rows(i).Item("detail_no2"))
                                Dim mergeRange As ExcelRange = D_EXL_SHT1.Cells("B" & (253 + add_rows + countChange2 + page) & ":B" & (253 + count2 * 2 - 1 + add_rows + page))
                                mergeRange.Merge = True
                                countChange2 = count2 * 2 + 2
                            End If

                            a = CInt(D_DAT.Tables(13).Rows(i).Item("detail_no")) * 10 + CInt(D_DAT.Tables(13).Rows(i).Item("item_arrangement_line"))
                            If i < D_ROW_CNT_TAB5_2 - 1 Then
                                If CInt(D_DAT.Tables(13).Rows(i).Item("item_id")) = CInt(D_DAT.Tables(13).Rows(i + 1).Item("item_id")) Then

                                    lineDetail = CInt(D_DAT.Tables(13).Rows(i).Item("max_item_line")) * 2   '6
                                    If lineP1Border = 0 Then
                                        quantityDetail = 45 \ lineDetail
                                        lineDetailMax = quantityDetail * lineDetail
                                        addLine = 45 - lineDetailMax
                                    Else
                                        quantityDetail = (45 - (lineP1Border * 2 + 1) + PositionInforIsZero) \ lineDetail
                                        lineDetailMax = quantityDetail * lineDetail
                                        addLine = (45 - (lineP1Border * 2 + 1) + PositionInforIsZero) - lineDetailMax
                                        If lineDetailMax = 0 Then
                                            D_EXL_SHT1.Row(rowsStart40P1 + addLine + 1).Height = sampleRowHeightHeader
                                            D_EXL_SHT1.Row(rowsStart40P1 + addLine + 3).Height = sampleRowHeightSmall

                                            D_EXL_SHT1.Cells("A" & (rowsHeader1) & ":O" & (rowsHeader2)).Copy(D_EXL_SHT1.Cells("A" & (rowsStart40P1 + addLine + 1) & ":O" & (rowsStart40P1 + addLine + 3)))
                                            quantityDetail = 45 \ lineDetail
                                            lineDetailMax = quantityDetail * lineDetail
                                            addLine = 45 - lineDetailMax


                                        End If
                                    End If

                                    If CInt(D_DAT.Tables(13).Rows(i).Item("detail_no2")) <> CInt(D_DAT.Tables(13).Rows(i + 1).Item("detail_no2")) Then
                                        d += 1
                                    End If
                                    If countPage2 <> 1 AndAlso lineDetailMax <> 0 Then
                                        If d = quantityDetail Then
                                            page += addLine + 4
                                            d = 0
                                            checkPageP2 += 1
                                            lineP1Border = 0
                                            lineP2 = 0
                                            D_EXL_SHT1.Row(251 + count2 * 2 + add_rows + page).Height = sampleRowHeightHeader
                                            D_EXL_SHT1.Row(253 + count2 * 2 + add_rows + page).Height = sampleRowHeightSmall

                                            D_EXL_SHT1.Cells("A" & (rowsHeader1) & ":O" & (rowsHeader2)).Copy(D_EXL_SHT1.Cells("A" & (251 + count2 * 2 + add_rows + page) & ":O" & (253 + count2 * 2 + add_rows + page)))


                                            If Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(0).Item("language"), "") = "en" Then
                                                D_EXL_SHT1.Cells("B" & (254 + count2 * 2 + add_rows + page)).Value = "■Pre-joining information"
                                            Else
                                                D_EXL_SHT1.Cells("B" & (254 + count2 * 2 + add_rows + page)).Value = "■入社前情報"
                                            End If
                                            D_EXL_SHT1.Cells("B" & (254 + count2 * 2 + add_rows + page)).Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left

                                        End If
                                    End If

                                Else
                                    If i > 0 Then
                                        lineDetail = CInt(D_DAT.Tables(13).Rows(i).Item("max_item_line")) * 2   '6
                                        If lineP1Border = 0 Then
                                            quantityDetail = 45 \ lineDetail
                                            lineDetailMax = quantityDetail * lineDetail
                                            addLine = 45 - lineDetailMax
                                        Else

                                            quantityDetail = (45 - (lineP1Border * 2 + 1) + PositionInforIsZero) \ lineDetail
                                            lineDetailMax = quantityDetail * lineDetail
                                            addLine = (45 - (lineP1Border * 2 + 1) + PositionInforIsZero) - lineDetailMax
                                            If lineDetailMax = 0 Then
                                                D_EXL_SHT1.Row(rowsStart40P1 + addLine + 1).Height = sampleRowHeightHeader
                                                D_EXL_SHT1.Row(rowsStart40P1 + addLine + 3).Height = sampleRowHeightSmall

                                                D_EXL_SHT1.Cells("A" & (rowsHeader1) & ":O" & (rowsHeader2)).Copy(D_EXL_SHT1.Cells("A" & (rowsStart40P1 + addLine + 1) & ":O" & (rowsStart40P1 + addLine + 3)))
                                                quantityDetail = 45 \ lineDetail
                                                lineDetailMax = quantityDetail * lineDetail
                                                addLine = 45 - lineDetailMax


                                            End If
                                        End If

                                        If CInt(D_DAT.Tables(13).Rows(i).Item("detail_no2")) <> CInt(D_DAT.Tables(13).Rows(i + 1).Item("detail_no2")) Then
                                            d += 1
                                        End If
                                        If countPage2 <> 1 AndAlso lineDetailMax <> 0 Then
                                            If d = quantityDetail Then
                                                If CInt(D_DAT.Tables(12).Rows(0).Item("detail_no")) = 0 Then
                                                    page += addLine + 4 + 3
                                                Else
                                                    page += addLine + 4
                                                End If
                                                d = 0
                                                checkPageP2 += 1
                                                lineP1Border = 0
                                                lineP2 = 0
                                                D_EXL_SHT1.Row(251 + count2 * 2 + add_rows + page).Height = sampleRowHeightHeader
                                                D_EXL_SHT1.Row(253 + count2 * 2 + add_rows + page).Height = sampleRowHeightSmall

                                                D_EXL_SHT1.Cells("A" & (rowsHeader1) & ":O" & (rowsHeader2)).Copy(D_EXL_SHT1.Cells("A" & (251 + count2 * 2 + add_rows + page) & ":O" & (253 + count2 * 2 + add_rows + page)))


                                                If Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(0).Item("language"), "") = "en" Then
                                                    D_EXL_SHT1.Cells("B" & (254 + count2 * 2 + add_rows + page)).Value = "■Pre-joining information"
                                                Else
                                                    D_EXL_SHT1.Cells("B" & (254 + count2 * 2 + add_rows + page)).Value = "■入社前情報"
                                                End If
                                                D_EXL_SHT1.Cells("B" & (254 + count2 * 2 + add_rows + page)).Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left

                                            End If
                                        End If
                                    End If
                                End If


                            End If
                            rowsStart40P2 = 255 + add_rows + countLine2 - 2 + page

                        Next

                        Dim z As Integer = 0
                        d = 0
                        page = 0
                        a = CInt(D_DAT.Tables(13).Rows(0).Item("detail_no")) * 10 + CInt(D_DAT.Tables(13).Rows(0).Item("item_arrangement_line"))
                        For i = 0 To D_ROW_CNT_TAB5_2 - 1
                            Dim b As Integer = CInt(D_DAT.Tables(13).Rows(i).Item("detail_no")) * 10 + CInt(D_DAT.Tables(13).Rows(i).Item("item_arrangement_line"))
                            Dim y As Integer = CInt(D_DAT.Tables(13).Rows(i).Item("item_arrangement_line"))
                            If i > 0 Then
                                If CInt(D_DAT.Tables(13).Rows(i).Item("item_arrangement_line")) <> CInt(D_DAT.Tables(13).Rows(i - 1).Item("item_arrangement_line")) Then
                                    z += 1
                                ElseIf CInt(D_DAT.Tables(13).Rows(i).Item("detail_no2")) <> CInt(D_DAT.Tables(13).Rows(i - 1).Item("detail_no2")) Then
                                    z += 1
                                End If
                            End If
                            a = CInt(D_DAT.Tables(13).Rows(i).Item("detail_no")) * 10 + CInt(D_DAT.Tables(13).Rows(i).Item("item_arrangement_line"))


                            If y = 1 Then

                                For j As Integer = 1 To 6
                                    If CInt(D_DAT.Tables(13).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value2")) = 1 Then
                                        D_EXL_SHT1.Cells(253 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("item_title").ToString(), "") 'fill tile
                                        Select Case CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value1"))    'check fill data
                                            Case 2
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("text_item").ToString(), "")
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                            Case 5
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("selected_items_nm").ToString(), "")
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                            Case 6
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("number_item").ToString(), "")
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right 'align right
                                        End Select
                                    End If
                                    If CInt(D_DAT.Tables(13).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value2")) = 2 Then
                                        Dim mergerange As ExcelRange = D_EXL_SHT1.Cells(253 + z * 2 + add_rows + page, 1 + j * 2, 253 + z * 2 + add_rows + page, 4 + j * 2)
                                        mergerange.Merge = True
                                        mergerange.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("item_title").ToString(), "")
                                        If CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value1")) = 1 Then
                                            D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("date_from").ToString(), "")
                                            D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 3 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("date_to").ToString(), "")
                                        End If
                                        If CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value1")) = 3 Then
                                            Dim mergerangeData As ExcelRange = D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2, 254 + z * 2 + add_rows + page, 4 + j * 2)
                                            mergerangeData.Merge = True
                                            mergerangeData.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("text_item").ToString(), "")
                                            mergerangeData.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                        End If
                                    End If
                                    If CInt(D_DAT.Tables(13).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value2")) = 6 Then
                                        Dim mergerange As ExcelRange = D_EXL_SHT1.Cells(253 + z * 2 + add_rows + page, 3, 253 + z * 2 + add_rows + page, 14)
                                        mergerange.Merge = True
                                        mergerange.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("item_title").ToString(), "")
                                        If CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value1")) = 4 Then
                                            Dim mergerangeData As ExcelRange = D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 3, 254 + z * 2 + add_rows + page, 14)
                                            mergerangeData.Merge = True
                                            mergerangeData.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("text_item").ToString(), "")
                                            mergerangeData.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                        End If
                                    End If
                                Next
                            End If
                            If y = 2 Then

                                For j As Integer = 1 To 6
                                    If CInt(D_DAT.Tables(13).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value2")) = 1 Then
                                        D_EXL_SHT1.Cells(253 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("item_title").ToString(), "") 'fill tile
                                        Select Case CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value1"))    'check fill data
                                            Case 2
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("text_item").ToString(), "")
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                            Case 5
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("selected_items_nm").ToString(), "")
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                            Case 6
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("number_item").ToString(), "")
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right 'align right
                                        End Select
                                    End If
                                    If CInt(D_DAT.Tables(13).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value2")) = 2 Then
                                        Dim mergerange As ExcelRange = D_EXL_SHT1.Cells(253 + z * 2 + add_rows + page, 1 + j * 2, 253 + z * 2 + add_rows + page, 4 + j * 2)
                                        mergerange.Merge = True
                                        mergerange.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("item_title").ToString(), "")
                                        If CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value1")) = 1 Then
                                            D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("date_from").ToString(), "")
                                            D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 3 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("date_to").ToString(), "")
                                        End If
                                        If CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value1")) = 3 Then
                                            Dim mergerangeData As ExcelRange = D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2, 254 + z * 2 + add_rows + page, 4 + j * 2)
                                            mergerangeData.Merge = True
                                            mergerangeData.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("text_item").ToString(), "")
                                            mergerangeData.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                        End If
                                    End If
                                    If CInt(D_DAT.Tables(13).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value2")) = 6 Then
                                        Dim mergerange As ExcelRange = D_EXL_SHT1.Cells(253 + z * 2 + add_rows + page, 3, 253 + z * 2 + add_rows + page, 14)
                                        mergerange.Merge = True
                                        mergerange.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("item_title").ToString(), "")
                                        If CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value1")) = 4 Then
                                            Dim mergerangeData As ExcelRange = D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 3, 254 + z * 2 + add_rows + page, 14)
                                            mergerangeData.Merge = True
                                            mergerangeData.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("text_item").ToString(), "")
                                            mergerangeData.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                        End If
                                    End If
                                Next
                            End If
                            If y = 3 Then

                                For j As Integer = 1 To 6
                                    If CInt(D_DAT.Tables(13).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value2")) = 1 Then
                                        D_EXL_SHT1.Cells(253 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("item_title").ToString(), "") 'fill tile
                                        Select Case CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value1"))    'check fill data
                                            Case 2
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("text_item").ToString(), "")
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                            Case 5
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("selected_items_nm").ToString(), "")
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                            Case 6
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("number_item").ToString(), "")
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right 'align right
                                        End Select
                                    End If
                                    If CInt(D_DAT.Tables(13).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value2")) = 2 Then
                                        Dim mergerange As ExcelRange = D_EXL_SHT1.Cells(253 + z * 2 + add_rows + page, 1 + j * 2, 253 + z * 2 + add_rows + page, 4 + j * 2)
                                        mergerange.Merge = True
                                        mergerange.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("item_title").ToString(), "")
                                        If CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value1")) = 1 Then
                                            D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("date_from").ToString(), "")
                                            D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 3 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("date_to").ToString(), "")
                                        End If
                                        If CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value1")) = 3 Then
                                            Dim mergerangeData As ExcelRange = D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2, 254 + z * 2 + add_rows + page, 4 + j * 2)
                                            mergerangeData.Merge = True
                                            mergerangeData.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("text_item").ToString(), "")
                                            mergerangeData.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                        End If
                                    End If
                                    If CInt(D_DAT.Tables(13).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value2")) = 6 Then
                                        Dim mergerange As ExcelRange = D_EXL_SHT1.Cells(253 + z * 2 + add_rows + page, 3, 253 + z * 2 + add_rows + page, 14)
                                        mergerange.Merge = True
                                        mergerange.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("item_title").ToString(), "")
                                        If CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value1")) = 4 Then
                                            Dim mergerangeData As ExcelRange = D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 3, 254 + z * 2 + add_rows + page, 14)
                                            mergerangeData.Merge = True
                                            mergerangeData.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("text_item").ToString(), "")
                                            mergerangeData.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                        End If
                                    End If
                                Next
                            End If
                            If y = 4 Then

                                For j As Integer = 1 To 6
                                    If CInt(D_DAT.Tables(13).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value2")) = 1 Then
                                        D_EXL_SHT1.Cells(253 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("item_title").ToString(), "") 'fill tile
                                        Select Case CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value1"))    'check fill data
                                            Case 2
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("text_item").ToString(), "")
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                            Case 5
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("selected_items_nm").ToString(), "")
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                            Case 6
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("number_item").ToString(), "")
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right 'align right
                                        End Select
                                    End If
                                    If CInt(D_DAT.Tables(13).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value2")) = 2 Then
                                        Dim mergerange As ExcelRange = D_EXL_SHT1.Cells(253 + z * 2 + add_rows + page, 1 + j * 2, 253 + z * 2 + add_rows + page, 4 + j * 2)
                                        mergerange.Merge = True
                                        mergerange.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("item_title").ToString(), "")
                                        If CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value1")) = 1 Then
                                            D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("date_from").ToString(), "")
                                            D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 3 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("date_to").ToString(), "")
                                        End If
                                        If CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value1")) = 3 Then
                                            Dim mergerangeData As ExcelRange = D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2, 254 + z * 2 + add_rows + page, 4 + j * 2)
                                            mergerangeData.Merge = True
                                            mergerangeData.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("text_item").ToString(), "")
                                            mergerangeData.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                        End If
                                    End If
                                    If CInt(D_DAT.Tables(13).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value2")) = 6 Then
                                        Dim mergerange As ExcelRange = D_EXL_SHT1.Cells(253 + z * 2 + add_rows + page, 3, 253 + z * 2 + add_rows + page, 14)
                                        mergerange.Merge = True
                                        mergerange.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("item_title").ToString(), "")
                                        If CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value1")) = 4 Then
                                            Dim mergerangeData As ExcelRange = D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 3, 254 + z * 2 + add_rows + page, 14)
                                            mergerangeData.Merge = True
                                            mergerangeData.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("text_item").ToString(), "")
                                            mergerangeData.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                        End If
                                    End If
                                Next
                            End If
                            If y = 5 Then

                                For j As Integer = 1 To 6
                                    If CInt(D_DAT.Tables(13).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value2")) = 1 Then
                                        D_EXL_SHT1.Cells(253 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("item_title").ToString(), "") 'fill tile
                                        Select Case CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value1"))    'check fill data
                                            Case 2
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("text_item").ToString(), "")
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                            Case 5
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("selected_items_nm").ToString(), "")
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                            Case 6
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("number_item").ToString(), "")
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right 'align right
                                        End Select
                                    End If
                                    If CInt(D_DAT.Tables(13).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value2")) = 2 Then
                                        Dim mergerange As ExcelRange = D_EXL_SHT1.Cells(253 + z * 2 + add_rows + page, 1 + j * 2, 253 + z * 2 + add_rows + page, 4 + j * 2)
                                        mergerange.Merge = True
                                        mergerange.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("item_title").ToString(), "")
                                        If CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value1")) = 1 Then
                                            D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("date_from").ToString(), "")
                                            D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 3 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("date_to").ToString(), "")
                                        End If
                                        If CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value1")) = 3 Then
                                            Dim mergerangeData As ExcelRange = D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2, 254 + z * 2 + add_rows + page, 4 + j * 2)
                                            mergerangeData.Merge = True
                                            mergerangeData.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("text_item").ToString(), "")
                                            mergerangeData.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                        End If
                                    End If
                                    If CInt(D_DAT.Tables(13).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value2")) = 6 Then
                                        Dim mergerange As ExcelRange = D_EXL_SHT1.Cells(253 + z * 2 + add_rows + page, 3, 253 + z * 2 + add_rows + page, 14)
                                        mergerange.Merge = True
                                        mergerange.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("item_title").ToString(), "")
                                        If CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value1")) = 4 Then
                                            Dim mergerangeData As ExcelRange = D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 3, 254 + z * 2 + add_rows + page, 14)
                                            mergerangeData.Merge = True
                                            mergerangeData.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("text_item").ToString(), "")
                                            mergerangeData.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                        End If
                                    End If
                                Next
                            End If
                            If y = 6 Then

                                For j As Integer = 1 To 6
                                    If CInt(D_DAT.Tables(13).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value2")) = 1 Then
                                        D_EXL_SHT1.Cells(253 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("item_title").ToString(), "") 'fill tile
                                        Select Case CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value1"))    'check fill data
                                            Case 2
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("text_item").ToString(), "")
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                            Case 5
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("selected_items_nm").ToString(), "")
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                            Case 6
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("number_item").ToString(), "")
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right 'align right
                                        End Select
                                    End If
                                    If CInt(D_DAT.Tables(13).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value2")) = 2 Then
                                        Dim mergerange As ExcelRange = D_EXL_SHT1.Cells(253 + z * 2 + add_rows + page, 1 + j * 2, 253 + z * 2 + add_rows + page, 4 + j * 2)
                                        mergerange.Merge = True
                                        mergerange.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("item_title").ToString(), "")
                                        If CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value1")) = 1 Then
                                            D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("date_from").ToString(), "")
                                            D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 3 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("date_to").ToString(), "")
                                        End If
                                        If CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value1")) = 3 Then
                                            Dim mergerangeData As ExcelRange = D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2, 254 + z * 2 + add_rows + page, 4 + j * 2)
                                            mergerangeData.Merge = True
                                            mergerangeData.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("text_item").ToString(), "")
                                            mergerangeData.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                        End If
                                    End If
                                    If CInt(D_DAT.Tables(13).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value2")) = 6 Then
                                        Dim mergerange As ExcelRange = D_EXL_SHT1.Cells(253 + z * 2 + add_rows + page, 3, 253 + z * 2 + add_rows + page, 14)
                                        mergerange.Merge = True
                                        mergerange.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("item_title").ToString(), "")
                                        If CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value1")) = 4 Then
                                            Dim mergerangeData As ExcelRange = D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 3, 254 + z * 2 + add_rows + page, 14)
                                            mergerangeData.Merge = True
                                            mergerangeData.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("text_item").ToString(), "")
                                            mergerangeData.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                        End If
                                    End If
                                Next

                            End If
                            If y = 7 Then

                                For j As Integer = 1 To 6
                                    If CInt(D_DAT.Tables(13).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value2")) = 1 Then
                                        D_EXL_SHT1.Cells(253 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("item_title").ToString(), "") 'fill tile
                                        Select Case CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value1"))    'check fill data
                                            Case 2
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("text_item").ToString(), "")
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                            Case 5
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("selected_items_nm").ToString(), "")
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                            Case 6
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("number_item").ToString(), "")
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right 'align right
                                        End Select
                                    End If
                                    If CInt(D_DAT.Tables(13).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value2")) = 2 Then
                                        Dim mergerange As ExcelRange = D_EXL_SHT1.Cells(253 + z * 2 + add_rows + page, 1 + j * 2, 253 + z * 2 + add_rows + page, 4 + j * 2)
                                        mergerange.Merge = True
                                        mergerange.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("item_title").ToString(), "")
                                        If CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value1")) = 1 Then
                                            D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("date_from").ToString(), "")
                                            D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 3 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("date_to").ToString(), "")
                                        End If
                                        If CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value1")) = 3 Then
                                            Dim mergerangeData As ExcelRange = D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2, 254 + z * 2 + add_rows + page, 4 + j * 2)
                                            mergerangeData.Merge = True
                                            mergerangeData.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("text_item").ToString(), "")
                                            mergerangeData.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                        End If
                                    End If
                                    If CInt(D_DAT.Tables(13).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value2")) = 6 Then
                                        Dim mergerange As ExcelRange = D_EXL_SHT1.Cells(253 + z * 2 + add_rows + page, 3, 253 + z * 2 + add_rows + page, 14)
                                        mergerange.Merge = True
                                        mergerange.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("item_title").ToString(), "")
                                        If CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value1")) = 4 Then
                                            Dim mergerangeData As ExcelRange = D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 3, 254 + z * 2 + add_rows + page, 14)
                                            mergerangeData.Merge = True
                                            mergerangeData.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("text_item").ToString(), "")
                                            mergerangeData.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                        End If
                                    End If
                                Next
                            End If

                            If y = 8 Then

                                For j As Integer = 1 To 6
                                    If CInt(D_DAT.Tables(13).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value2")) = 1 Then
                                        D_EXL_SHT1.Cells(253 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("item_title").ToString(), "") 'fill tile
                                        Select Case CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value1"))    'check fill data
                                            Case 2
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("text_item").ToString(), "")
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                            Case 5
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("selected_items_nm").ToString(), "")
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                            Case 6
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("number_item").ToString(), "")
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right 'align right
                                        End Select
                                    End If
                                    If CInt(D_DAT.Tables(13).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value2")) = 2 Then
                                        Dim mergerange As ExcelRange = D_EXL_SHT1.Cells(253 + z * 2 + add_rows + page, 1 + j * 2, 253 + z * 2 + add_rows + page, 4 + j * 2)
                                        mergerange.Merge = True
                                        mergerange.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("item_title").ToString(), "")
                                        If CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value1")) = 1 Then
                                            D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("date_from").ToString(), "")
                                            D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 3 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("date_to").ToString(), "")
                                        End If
                                        If CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value1")) = 3 Then
                                            Dim mergerangeData As ExcelRange = D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2, 254 + z * 2 + add_rows + page, 4 + j * 2)
                                            mergerangeData.Merge = True
                                            mergerangeData.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("text_item").ToString(), "")
                                            mergerangeData.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                        End If
                                    End If
                                    If CInt(D_DAT.Tables(13).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value2")) = 6 Then
                                        Dim mergerange As ExcelRange = D_EXL_SHT1.Cells(253 + z * 2 + add_rows + page, 3, 253 + z * 2 + add_rows + page, 14)
                                        mergerange.Merge = True
                                        mergerange.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("item_title").ToString(), "")
                                        If CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value1")) = 4 Then
                                            Dim mergerangeData As ExcelRange = D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 3, 254 + z * 2 + add_rows + page, 14)
                                            mergerangeData.Merge = True
                                            mergerangeData.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("text_item").ToString(), "")
                                            mergerangeData.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                        End If
                                    End If
                                Next
                            End If

                            If y = 9 Then

                                For j As Integer = 1 To 6
                                    If CInt(D_DAT.Tables(13).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value2")) = 1 Then
                                        D_EXL_SHT1.Cells(253 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("item_title").ToString(), "") 'fill tile
                                        Select Case CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value1"))    'check fill data
                                            Case 2
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("text_item").ToString(), "")
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                            Case 5
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("selected_items_nm").ToString(), "")
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                            Case 6
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("number_item").ToString(), "")
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right 'align right
                                        End Select
                                    End If
                                    If CInt(D_DAT.Tables(13).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value2")) = 2 Then
                                        Dim mergerange As ExcelRange = D_EXL_SHT1.Cells(253 + z * 2 + add_rows + page, 1 + j * 2, 253 + z * 2 + add_rows + page, 4 + j * 2)
                                        mergerange.Merge = True
                                        mergerange.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("item_title").ToString(), "")
                                        If CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value1")) = 1 Then
                                            D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("date_from").ToString(), "")
                                            D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 3 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("date_to").ToString(), "")
                                        End If
                                        If CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value1")) = 3 Then
                                            Dim mergerangeData As ExcelRange = D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2, 254 + z * 2 + add_rows + page, 4 + j * 2)
                                            mergerangeData.Merge = True
                                            mergerangeData.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("text_item").ToString(), "")
                                            mergerangeData.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                        End If
                                    End If
                                    If CInt(D_DAT.Tables(13).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value2")) = 6 Then
                                        Dim mergerange As ExcelRange = D_EXL_SHT1.Cells(253 + z * 2 + add_rows + page, 3, 253 + z * 2 + add_rows + page, 14)
                                        mergerange.Merge = True
                                        mergerange.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("item_title").ToString(), "")
                                        If CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value1")) = 4 Then
                                            Dim mergerangeData As ExcelRange = D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 3, 254 + z * 2 + add_rows + page, 14)
                                            mergerangeData.Merge = True
                                            mergerangeData.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("text_item").ToString(), "")
                                            mergerangeData.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                        End If
                                    End If
                                Next
                            End If

                            If y = 10 Then

                                For j As Integer = 1 To 6
                                    If CInt(D_DAT.Tables(13).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value2")) = 1 Then
                                        D_EXL_SHT1.Cells(253 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("item_title").ToString(), "") 'fill tile
                                        Select Case CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value1"))    'check fill data
                                            Case 2
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("text_item").ToString(), "")
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                            Case 5
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("selected_items_nm").ToString(), "")
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                            Case 6
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("number_item").ToString(), "")
                                                D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right 'align right
                                        End Select
                                    End If
                                    If CInt(D_DAT.Tables(13).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value2")) = 2 Then
                                        Dim mergerange As ExcelRange = D_EXL_SHT1.Cells(253 + z * 2 + add_rows + page, 1 + j * 2, 253 + z * 2 + add_rows + page, 4 + j * 2)
                                        mergerange.Merge = True
                                        mergerange.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("item_title").ToString(), "")
                                        If CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value1")) = 1 Then
                                            D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("date_from").ToString(), "")
                                            D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 3 + j * 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("date_to").ToString(), "")
                                        End If
                                        If CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value1")) = 3 Then
                                            Dim mergerangeData As ExcelRange = D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 1 + j * 2, 254 + z * 2 + add_rows + page, 4 + j * 2)
                                            mergerangeData.Merge = True
                                            mergerangeData.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("text_item").ToString(), "")
                                            mergerangeData.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                        End If
                                    End If
                                    If CInt(D_DAT.Tables(13).Rows(i).Item("item_arrangement_column")) = j And CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value2")) = 6 Then
                                        Dim mergerange As ExcelRange = D_EXL_SHT1.Cells(253 + z * 2 + add_rows + page, 3, 253 + z * 2 + add_rows + page, 14)
                                        mergerange.Merge = True
                                        mergerange.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("item_title").ToString(), "")
                                        If CInt(D_DAT.Tables(13).Rows(i).Item("numeric_value1")) = 4 Then
                                            Dim mergerangeData As ExcelRange = D_EXL_SHT1.Cells(254 + z * 2 + add_rows + page, 3, 254 + z * 2 + add_rows + page, 14)
                                            mergerangeData.Merge = True
                                            mergerangeData.Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(13).Rows(i).Item("text_item").ToString(), "")
                                            mergerangeData.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left 'align left
                                        End If
                                    End If
                                Next
                            End If
                            '
                            If i < D_ROW_CNT_TAB5_2 - 1 Then
                                If CInt(D_DAT.Tables(13).Rows(i).Item("item_id")) = CInt(D_DAT.Tables(13).Rows(i + 1).Item("item_id")) Then
                                    lineDetail = CInt(D_DAT.Tables(13).Rows(i).Item("max_item_line")) * 2   '6
                                    If lineP1Data = 0 Then
                                        quantityDetail = 45 \ lineDetail
                                        lineDetailMax = quantityDetail * lineDetail
                                        addLine = 45 - lineDetailMax
                                    Else
                                        quantityDetail = (45 - (lineP1Data * 2 + 1) + PositionInforIsZero) \ lineDetail
                                        lineDetailMax = quantityDetail * lineDetail
                                        addLine = (45 - (lineP1Data * 2 + 1) + PositionInforIsZero) - lineDetailMax
                                        If lineDetailMax = 0 Then
                                            quantityDetail = 45 \ lineDetail
                                            lineDetailMax = quantityDetail * lineDetail
                                            addLine = 45 - lineDetailMax
                                        End If
                                    End If


                                    If CInt(D_DAT.Tables(13).Rows(i).Item("detail_no2")) <> CInt(D_DAT.Tables(13).Rows(i + 1).Item("detail_no2")) Then
                                        d += 1
                                    End If
                                    If countPage2 <> 1 AndAlso lineDetailMax <> 0 Then

                                        If d = quantityDetail Then
                                            page += addLine + 4
                                            d = 0

                                            lineP1Data = 0

                                        End If

                                    End If
                                Else
                                    If i > 0 Then
                                        lineDetail = CInt(D_DAT.Tables(13).Rows(i).Item("max_item_line")) * 2   '6
                                        If lineP1Data = 0 Then
                                            quantityDetail = 45 \ lineDetail
                                            lineDetailMax = quantityDetail * lineDetail
                                            addLine = 45 - lineDetailMax
                                        Else
                                            quantityDetail = (45 - (lineP1Data * 2 + 1) + PositionInforIsZero) \ lineDetail
                                            lineDetailMax = quantityDetail * lineDetail
                                            addLine = (45 - (lineP1Data * 2 + 1) + PositionInforIsZero) - lineDetailMax
                                            If lineDetailMax = 0 Then
                                                quantityDetail = 45 \ lineDetail
                                                lineDetailMax = quantityDetail * lineDetail
                                                addLine = 45 - lineDetailMax
                                            End If
                                        End If


                                        If CInt(D_DAT.Tables(13).Rows(i).Item("detail_no2")) <> CInt(D_DAT.Tables(13).Rows(i + 1).Item("detail_no2")) Then
                                            d += 1
                                        End If
                                        If countPage2 <> 1 AndAlso lineDetailMax <> 0 Then

                                            If d = quantityDetail Then
                                                If CInt(D_DAT.Tables(12).Rows(0).Item("detail_no")) = 0 Then
                                                    page += addLine + 4 + 3
                                                Else
                                                    page += addLine + 4
                                                End If
                                                d = 0

                                                lineP1Data = 0

                                            End If

                                        End If
                                    End If
                                End If


                            End If
                        Next

                        add_rows += countLine2 - 2 + page


                    Else
                        del10 = 252 + add_rows
                    End If
                Else
                    del10 = 252 + add_rows
                End If

                'calculate row late

                If D_ROW_CNT_TAB5_1 <> 0 And D_ROW_CNT_TAB5_2 <> 0 Then
                    If CInt(D_DAT.Tables(12).Rows(0).Item("detail_no")) > 0 And CInt(D_DAT.Tables(13).Rows(0).Item("detail_no")) > 0 AndAlso lineDetailMax <> 0 Then
                        Dim x1 As Integer = Math.Ceiling((CInt(D_DAT.Tables(12).Rows(0).Item("count_line")) * 2) / 45.0)

                        If x1 > 1 And checkPageP2 = 1 Then

                            D_EXL_SHT1.InsertRow(rowsStart40P2, 49 - (lineP1 * 2 + (lineP2 + 1) * 2 + 5))

                            For h = 0 To 49 - (lineP1 * 2 + (lineP2 + 1) * 2 + 5)
                                D_EXL_SHT1.Row(rowsStart40P2 + h).Height = sampleRowHeight
                            Next
                            del40Rows = rowsStart40P2 + 49 - (lineP1 * 2 + (lineP2 + 1) * 2 + 5)
                            add_rows += 49 - (lineP1 * 2 + (lineP2 + 1) * 2 + 5)
                        ElseIf x1 = 1 And checkPageP2 > 1 Then
                            D_EXL_SHT1.InsertRow(rowsStart40P2, 49 - (lineP2 * 2 + 4))

                            For h = 0 To 49 - (lineP2 * 2 + 4)
                                D_EXL_SHT1.Row(rowsStart40P2 + h).Height = sampleRowHeight
                            Next
                            del40Rows = rowsStart40P2 + 49 - (lineP2 * 2 + 4)
                            add_rows += 49 - (lineP2 * 2 + 4)
                        ElseIf x1 > 1 And checkPageP2 > 1 Then
                            D_EXL_SHT1.InsertRow(rowsStart40P2, 49 - (lineP2 * 2 + 4))

                            For h = 0 To 49 - (lineP2 * 2 + 4)
                                D_EXL_SHT1.Row(rowsStart40P2 + h).Height = sampleRowHeight
                            Next
                            del40Rows = rowsStart40P2 + 49 - (lineP2 * 2 + 4)
                            add_rows += 49 - (lineP2 * 2 + 4)
                        ElseIf x1 = 1 And checkPageP2 = 1 Then
                            D_EXL_SHT1.InsertRow(rowsStart40P2, 49 - (lineP1 * 2 + (lineP2 + 1) * 2 + 4))

                            For h = 0 To 49 - (lineP1 * 2 + (lineP2 + 1) * 2 + 4)
                                D_EXL_SHT1.Row(rowsStart40P2 + h).Height = sampleRowHeight
                            Next
                            del40Rows = rowsStart40P2 + 49 - (lineP1 * 2 + (lineP2 + 1) * 2 + 4)
                            add_rows += 49 - (lineP1 * 2 + (lineP2 + 1) * 2 + 4)
                        End If
                    End If

                    If CInt(D_DAT.Tables(13).Rows(0).Item("detail_no")) = 0 And CInt(D_DAT.Tables(12).Rows(0).Item("detail_no")) > 0 Then

                        D_EXL_SHT1.InsertRow(rowsStart40P1, 49 - (lineP1 * 2 + 4))
                        For h = 0 To 49 - (lineP1 * 2 + 4)
                            D_EXL_SHT1.Row(rowsStart40P1 + h).Height = sampleRowHeight
                        Next
                        del40Rows = rowsStart40P1 + 49 - (lineP1 * 2 + 4)
                        add_rows += 49 - (lineP1 * 2 + 4)
                    End If

                    If CInt(D_DAT.Tables(12).Rows(0).Item("detail_no")) = 0 And CInt(D_DAT.Tables(13).Rows(0).Item("detail_no")) > 0 Then

                        D_EXL_SHT1.InsertRow(rowsStart40P2, 49 - (lineP2 * 2 + 4))
                        For h = 0 To 49 - (lineP2 * 2 + 4)
                            D_EXL_SHT1.Row(rowsStart40P2 + h).Height = sampleRowHeight
                        Next
                        del40Rows = rowsStart40P2 + 49 - (lineP2 * 2 + 4)
                        add_rows += 49 - (lineP2 * 2 + 4)
                    End If

                    If CInt(D_DAT.Tables(12).Rows(0).Item("detail_no")) = 0 And CInt(D_DAT.Tables(13).Rows(0).Item("detail_no")) = 0 Then
                        del910 = 246 + add_rows
                    End If

                End If

                If D_ROW_CNT_TAB5_1 = 0 And checkPageP2 < 2 And D_ROW_CNT_TAB5_2 <> 0 Then
                    If CInt(D_DAT.Tables(13).Rows(0).Item("detail_no")) > 0 Then

                        D_EXL_SHT1.InsertRow(rowsStart40P2, 49 - ((lineP2 + 1) * 2 + 4))
                        For h = 0 To 49 - ((lineP2 + 1) * 2 + 4)
                            D_EXL_SHT1.Row(rowsStart40P2 + h).Height = sampleRowHeight
                        Next
                        del40Rows = rowsStart40P2 + 49 - ((lineP2 + 1) * 2 + 4)
                        add_rows += 49 - ((lineP2 + 1) * 2 + 4)
                    End If

                End If
                If D_ROW_CNT_TAB5_1 = 0 And checkPageP2 > 1 And D_ROW_CNT_TAB5_2 <> 0 Then
                    If CInt(D_DAT.Tables(13).Rows(0).Item("detail_no")) > 0 Then

                        D_EXL_SHT1.InsertRow(rowsStart40P2, 49 - (lineP2 * 2 + 4))
                        For h = 0 To 49 - (lineP2 * 2 + 4)
                            D_EXL_SHT1.Row(rowsStart40P2 + h).Height = sampleRowHeight
                        Next
                        del40Rows = rowsStart40P2 + 49 - (lineP2 * 2 + 4)
                        add_rows += 49 - (lineP2 * 2 + 4)
                    End If

                End If

                If D_ROW_CNT_TAB5_2 = 0 And D_ROW_CNT_TAB5_1 > 0 Then
                    If CInt(D_DAT.Tables(12).Rows(0).Item("detail_no")) > 0 Then

                        D_EXL_SHT1.InsertRow(rowsStart40P1, 49 - (lineP1 * 2 + 4))
                        For h = 0 To 49 - (lineP1 * 2 + 4)
                            D_EXL_SHT1.Row(rowsStart40P1 + h).Height = sampleRowHeight
                        Next
                        del40Rows = rowsStart40P1 + 49 - (lineP1 * 2 + 4)
                        add_rows += 49 - (lineP1 * 2 + 4)
                    End If
                End If

                If D_ROW_CNT_TAB5_2 = 0 And D_ROW_CNT_TAB5_1 = 0 Then
                    del910 = 246 + add_rows
                End If
                add_rows += delRows0

                'fill 学歴
                '■最終学歴
                Dim delTab6 As Integer = 0
                Dim D_ROW_CNT_TAB6 As Integer = D_DAT.Tables(15).Rows.Count
                If D_DAT.Tables(14).Rows.Count > 0 Then

                    D_EXL_SHT1.Cells(299 + add_rows, 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(14).Rows(0).Item("final_education_kbn_nm"), "")
                    D_EXL_SHT1.Cells(299 + add_rows, 7).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(14).Rows(0).Item("final_education_other"), "")
                    D_EXL_SHT1.Cells(300 + add_rows, 4).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(14).Rows(0).Item("graduation_year"), "")
                    D_EXL_SHT1.Cells(300 + add_rows, 9).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(14).Rows(0).Item("school_name"), "")
                    D_EXL_SHT1.Cells(301 + add_rows, 4).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(14).Rows(0).Item("faculty"), "")
                    D_EXL_SHT1.Cells(301 + add_rows, 9).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(14).Rows(0).Item("major"), "")
                    D_EXL_SHT1.Cells(296 + add_rows, 2).Value = sourceValue

                    '■その他学歴
                    If D_ROW_CNT_TAB6 > 0 Then
                        Dim countPage As Integer = 0
                        If D_ROW_CNT_TAB6 <= 20 Then
                            countPage = 1
                        Else
                            countPage = 1 + Math.Ceiling((D_ROW_CNT_TAB6 - 20) / 22.0)
                        End If
                        D_EXL_SHT1.InsertRow(343 + add_rows, 49 * (countPage - 1))
                        For h As Integer = 0 To 49 * (countPage - 1) - 1
                            D_EXL_SHT1.Row(343 + add_rows + h).Height = sampleRowHeight
                        Next

                        For y = 0 To countPage - 1
                            'copy header

                            D_EXL_SHT1.Cells("A" & (295 + add_rows) & ":O" & (297 + add_rows)).Copy(D_EXL_SHT1.Cells("A" & (295 + 49 * y + add_rows) & ":O" & (297 + 49 * y + add_rows)))
                            D_EXL_SHT1.Row(295 + 49 * y + add_rows).Height = sampleRowHeightHeader
                            D_EXL_SHT1.Row(297 + 49 * y + add_rows).Height = sampleRowHeightSmall
                            If y <> 0 Then

                                D_EXL_SHT1.Cells("B" & (302 + add_rows)).Copy(D_EXL_SHT1.Cells("B" & (298 + 49 * y + add_rows)))
                            End If
                        Next
                        Dim page As Integer = 0
                        For i = 0 To D_ROW_CNT_TAB6 - 1
                            If countPage <> 0 Then
                                If i <= 20 Then

                                    If i Mod 20 = 0 And i <> 0 Then
                                        page += 5
                                    End If
                                Else

                                    If (i - 20) Mod 22 = 0 And (i - 20) <> 0 Then
                                        page += 5
                                    End If
                                End If

                            End If


                            'fill data 
                            D_EXL_SHT1.Cells("B" & (303 + add_rows) & ":N" & (304 + add_rows)).Copy(D_EXL_SHT1.Cells("B" & (303 + i * 2 + add_rows + page) & ":N" & (304 + i * 2 + add_rows + page)))

                            D_EXL_SHT1.Cells(303 + i * 2 + add_rows + page, 4).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(15).Rows(i).Item("graduation_year"), "")
                            D_EXL_SHT1.Cells(303 + i * 2 + add_rows + page, 9).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(15).Rows(i).Item("school_name"), "")
                            D_EXL_SHT1.Cells(304 + i * 2 + add_rows + page, 4).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(15).Rows(i).Item("faculty"), "")
                            D_EXL_SHT1.Cells(304 + i * 2 + add_rows + page, 9).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(15).Rows(i).Item("major"), "")
                        Next
                        add_rows += 49 * (countPage - 1)

                    End If
                Else
                    delTab6 = 295 + add_rows
                End If

                'fill 連絡先
                Dim delTab7 As Integer = 0
                Dim D_ROW_CNT_TAB7 As Integer = D_DAT.Tables(16).Rows.Count
                If D_ROW_CNT_TAB7 > 0 Then
                    Dim CHECK_OHK = D_DAT.Tables(16).Rows(0).Item("head_household")
                    D_EXL_SHT1.Cells(345 + add_rows, 2).Value = sourceValue
                    If CHECK_OHK = 1 Then
                        D_EXL_SHT1.Cells(347 + add_rows, 8).Value = "☑"
                    Else
                        D_EXL_SHT1.Cells(347 + add_rows, 8).Value = "☐"
                    End If
                    D_EXL_SHT1.Cells(347 + add_rows, 4).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(16).Rows(0).Item("owning_house_kbn"), "")
                    D_EXL_SHT1.Cells(349 + add_rows, 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(16).Rows(0).Item("post_code"), "")
                    D_EXL_SHT1.Cells(349 + add_rows, 4).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(16).Rows(0).Item("address1"), "")
                    D_EXL_SHT1.Cells(349 + add_rows, 6).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(16).Rows(0).Item("address2"), "")
                    D_EXL_SHT1.Cells(350 + add_rows, 4).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(16).Rows(0).Item("home_phone_number"), "")
                    D_EXL_SHT1.Cells(350 + add_rows, 8).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(16).Rows(0).Item("personal_phone_number"), "")
                    D_EXL_SHT1.Cells(350 + add_rows, 12).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(16).Rows(0).Item("personal_email_address"), "")
                    D_EXL_SHT1.Cells(351 + add_rows, 6).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(16).Rows(0).Item("emergency_contact_name"), "")
                    D_EXL_SHT1.Cells(352 + add_rows, 6).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(16).Rows(0).Item("emergency_contact_relationship"), "")
                    D_EXL_SHT1.Cells(353 + add_rows, 6).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(16).Rows(0).Item("emergency_contact_birthday"), "")
                    D_EXL_SHT1.Cells(353 + add_rows, 11).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(16).Rows(0).Item("year_old"), "")
                    D_EXL_SHT1.Cells(354 + add_rows, 6).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(16).Rows(0).Item("emergency_contact_post_code"), "")
                    D_EXL_SHT1.Cells(354 + add_rows, 11).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(16).Rows(0).Item("emergency_contact_addres1"), "")
                    D_EXL_SHT1.Cells(355 + add_rows, 6).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(16).Rows(0).Item("emergency_contact_addres2"), "")
                    D_EXL_SHT1.Cells(356 + add_rows, 6).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(16).Rows(0).Item("emergency_contact_phone_number"), "")
                Else
                    delTab7 = 344 + add_rows
                End If

                'fill 通勤
                If D_DAT.Tables(18).Rows.Count > 0 Then
                    D_EXL_SHT1.Cells(396 + add_rows, 5).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(18).Rows(0).Item("total_expenses"), "")
                End If
                Dim dateValue As DateTime
                Dim dateFormat As String = "yyyy/MM/dd"
                Dim delTab8 As Integer = 0
                Dim D_ROW_CNT_TAB8 = D_DAT.Tables(17).Rows.Count
                If D_ROW_CNT_TAB8 > 0 Then
                    Dim countPage As Integer = 0
                    If D_ROW_CNT_TAB8 <= 22 Then
                        countPage = 1
                    Else
                        countPage = 1 + Math.Ceiling((D_ROW_CNT_TAB8 - 22) / 23.0)
                    End If
                    D_EXL_SHT1.InsertRow(441 + add_rows, 49 * (countPage - 1))
                    For h As Integer = 0 To 49 * (countPage - 1) - 1
                        D_EXL_SHT1.Row(441 + add_rows + h).Height = sampleRowHeight
                    Next
                    D_EXL_SHT1.Cells(394 + add_rows, 2).Value = sourceValue
                    For y = 0 To countPage - 1
                        'copy header
                        D_EXL_SHT1.Cells("A" & (393 + add_rows) & ":O" & (395 + add_rows)).Copy(D_EXL_SHT1.Cells("A" & (393 + 49 * y + add_rows) & ":O" & (395 + 49 * y + add_rows)))
                        D_EXL_SHT1.Row(393 + 49 * y + add_rows).Height = sampleRowHeightHeader
                        D_EXL_SHT1.Row(395 + 49 * y + add_rows).Height = sampleRowHeightSmall
                    Next


                    Dim page As Integer = 0
                    For i = 0 To D_ROW_CNT_TAB8 - 1
                        If countPage <> 0 Then
                            'If i Mod 22 = 0 And i <> 0 Then
                            '    page += 4
                            'End If
                            If i < 23 Then

                                If i Mod 22 = 0 And i <> 0 Then
                                    page += 4
                                End If
                            Else

                                If (i - 22) Mod 23 = 0 And (i - 22) <> 0 Then
                                    page += 3
                                End If
                            End If
                        End If

                        'merge col
                        D_EXL_SHT1.Cells("B" & (397 + add_rows) & ":B" & (398 + add_rows)).Copy(D_EXL_SHT1.Cells("B" & (397 + i * 2 + add_rows + page)))
                        Dim mergeRange As ExcelRange = D_EXL_SHT1.Cells("B" & (397 + i * 2 + add_rows + page) & ":B" & (398 + i * 2 + add_rows + page))
                        mergeRange.Merge = True
                        D_EXL_SHT1.Cells(397 + i * 2 + add_rows + page, 2).Value = i + 1
                        'header
                        D_EXL_SHT1.Cells("C" & (397 + add_rows) & ":N" & (397 + add_rows)).Copy(D_EXL_SHT1.Cells("C" & (397 + i * 2 + add_rows + page) & ":N" & (397 + i * 2 + add_rows + page))) 'copy rows
                        D_EXL_SHT1.Cells(397 + i * 2 + add_rows + page, 3).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(17).Rows(i).Item("head_1"), "")
                        D_EXL_SHT1.Cells(397 + i * 2 + add_rows + page, 5).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(17).Rows(i).Item("head_2"), "")
                        D_EXL_SHT1.Cells(397 + i * 2 + add_rows + page, 8).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(17).Rows(i).Item("head_3"), "")
                        D_EXL_SHT1.Cells(397 + i * 2 + add_rows + page, 11).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(17).Rows(i).Item("head_4"), "")
                        D_EXL_SHT1.Cells(397 + i * 2 + add_rows + page, 13).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(17).Rows(i).Item("head_5"), "")
                        'data      
                        D_EXL_SHT1.Cells("C" & (398 + add_rows) & ":N" & (398 + add_rows)).Copy(D_EXL_SHT1.Cells("C" & (398 + i * 2 + add_rows + page) & ":N" & (398 + i * 2 + add_rows + page))) 'copy rows
                        Dim data2 As String = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(17).Rows(i).Item("data_2"), "")
                        Dim data3 As String = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(17).Rows(i).Item("data_3"), "")
                        Dim data4 As String = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(17).Rows(i).Item("data_4"), "")
                        Dim data5 As String = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(17).Rows(i).Item("data_5"), "")


                        D_EXL_SHT1.Cells(398 + i * 2 + add_rows + page, 3).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(17).Rows(i).Item("commuting_method_name"), "")
                        D_EXL_SHT1.Cells(398 + i * 2 + add_rows + page, 5).Value = data2
                        D_EXL_SHT1.Cells(398 + i * 2 + add_rows + page, 8).Value = data3
                        D_EXL_SHT1.Cells(398 + i * 2 + add_rows + page, 11).Value = data4
                        D_EXL_SHT1.Cells(398 + i * 2 + add_rows + page, 13).Value = data5
                        If IsNumeric(data2) Then
                            Dim numericValue As Double
                            If Double.TryParse(data2, numericValue) Then
                                D_EXL_SHT1.Cells(398 + i * 2 + add_rows + page, 5).Value = numericValue
                                D_EXL_SHT1.Cells(398 + i * 2 + add_rows + page, 5).Style.Numberformat.Format = "0.0" ' Ensure at least one decimal place is shown
                            End If
                            D_EXL_SHT1.Cells(398 + i * 2 + add_rows + page, 5).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right
                        ElseIf Regex.IsMatch(data2, "\p{IsCJKUnifiedIdeographs}|\p{IsHiragana}|\p{IsKatakana}") Then
                            D_EXL_SHT1.Cells(398 + i * 2 + add_rows + page, 5).Style.HorizontalAlignment = ExcelHorizontalAlignment.Left
                        ElseIf DateTime.TryParseExact(data2, dateFormat, Nothing, Globalization.DateTimeStyles.None, dateValue) Then
                            D_EXL_SHT1.Cells(398 + i * 2 + add_rows + page, 5).Style.HorizontalAlignment = ExcelHorizontalAlignment.Center
                        End If

                        If IsNumeric(data3) Then
                            Dim numericValue As Double
                            If Double.TryParse(data3, numericValue) Then
                                D_EXL_SHT1.Cells(398 + i * 2 + add_rows + page, 8).Value = numericValue
                                D_EXL_SHT1.Cells(398 + i * 2 + add_rows + page, 8).Style.Numberformat.Format = "0.0"
                            End If
                            D_EXL_SHT1.Cells(398 + i * 2 + add_rows + page, 8).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right
                        ElseIf Regex.IsMatch(data3, "\p{IsCJKUnifiedIdeographs}|\p{IsHiragana}|\p{IsKatakana}") Then
                            D_EXL_SHT1.Cells(398 + i * 2 + add_rows + page, 8).Style.HorizontalAlignment = ExcelHorizontalAlignment.Left
                        ElseIf DateTime.TryParseExact(data3, dateFormat, Nothing, Globalization.DateTimeStyles.None, dateValue) Then
                            D_EXL_SHT1.Cells(398 + i * 2 + add_rows + page, 8).Style.HorizontalAlignment = ExcelHorizontalAlignment.Center
                        End If

                        If IsNumeric(data4) Then
                            Dim numericValue As Double
                            If Double.TryParse(data4, numericValue) Then
                                D_EXL_SHT1.Cells(398 + i * 2 + add_rows + page, 11).Value = numericValue
                                D_EXL_SHT1.Cells(398 + i * 2 + add_rows + page, 11).Style.Numberformat.Format = "0.0"
                            End If
                            D_EXL_SHT1.Cells(398 + i * 2 + add_rows + page, 11).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right
                        ElseIf Regex.IsMatch(data4, "\p{IsCJKUnifiedIdeographs}|\p{IsHiragana}|\p{IsKatakana}") Then
                            D_EXL_SHT1.Cells(398 + i * 2 + add_rows + page, 11).Style.HorizontalAlignment = ExcelHorizontalAlignment.Left
                        ElseIf DateTime.TryParseExact(data4, dateFormat, Nothing, Globalization.DateTimeStyles.None, dateValue) Then
                            D_EXL_SHT1.Cells(398 + i * 2 + add_rows + page, 11).Style.HorizontalAlignment = ExcelHorizontalAlignment.Center
                        End If

                        If IsNumeric(data5) Then
                            Dim numericValue As Double
                            If Double.TryParse(data5, numericValue) Then
                                D_EXL_SHT1.Cells(398 + i * 2 + add_rows + page, 13).Value = numericValue
                                D_EXL_SHT1.Cells(398 + i * 2 + add_rows + page, 13).Style.Numberformat.Format = "0.0"
                            End If
                            D_EXL_SHT1.Cells(398 + i * 2 + add_rows + page, 13).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right
                        ElseIf Regex.IsMatch(data5, "\p{IsCJKUnifiedIdeographs}|\p{IsHiragana}|\p{IsKatakana}") Then
                            D_EXL_SHT1.Cells(398 + i * 2 + add_rows + page, 13).Style.HorizontalAlignment = ExcelHorizontalAlignment.Left
                        ElseIf DateTime.TryParseExact(data5, dateFormat, Nothing, Globalization.DateTimeStyles.None, dateValue) Then
                            D_EXL_SHT1.Cells(398 + i * 2 + add_rows + page, 13).Style.HorizontalAlignment = ExcelHorizontalAlignment.Center
                        End If

                    Next
                    add_rows += 49 * (countPage - 1)
                Else
                    delTab8 = 393 + add_rows
                End If


                'fill 家族
                Dim delTab9 As Integer = 0
                Dim D_ROW_CNT_TAB9 = D_DAT.Tables(19).Rows.Count
                If D_ROW_CNT_TAB9 > 0 Then
                    D_EXL_SHT1.Cells(445 + add_rows, 4).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(19).Rows(0).Item("marital_status"), "")
                    D_EXL_SHT1.Cells(443 + add_rows, 2).Value = sourceValue

                    Dim countPage As Integer = Math.Ceiling(D_ROW_CNT_TAB9 / 15.0)
                    D_EXL_SHT1.InsertRow(490 + add_rows, 49 * (countPage - 1))

                    For h As Integer = 0 To 49 * (countPage - 1) - 1
                        D_EXL_SHT1.Row(490 + add_rows + h).Height = sampleRowHeight
                    Next
                    Dim page As Integer = 0
                    For y = 0 To countPage - 1
                        'copy header
                        D_EXL_SHT1.Cells("A" & (442 + add_rows) & ":O" & (445 + add_rows)).Copy(D_EXL_SHT1.Cells("A" & (442 + 49 * y + add_rows) & ":O" & (445 + 49 * y + add_rows)))
                        D_EXL_SHT1.Row(442 + 49 * y + add_rows).Height = sampleRowHeightHeader
                        D_EXL_SHT1.Row(444 + 49 * y + add_rows).Height = sampleRowHeightSmall
                    Next
                    For i = 0 To D_ROW_CNT_TAB9 - 1
                        If countPage <> 0 Then
                            If i Mod 15 = 0 And i <> 0 Then
                                page += 4
                            End If
                        End If

                        'fill data
                        D_EXL_SHT1.Cells("B" & (446 + add_rows) & ":B" & (448 + add_rows)).Copy(D_EXL_SHT1.Cells("B" & (446 + i * 3 + add_rows + page)))
                        Dim mergeRange As ExcelRange = D_EXL_SHT1.Cells("B" & (446 + i * 3 + add_rows + page) & ":B" & (448 + i * 3 + add_rows + page))
                        mergeRange.Merge = True

                        D_EXL_SHT1.Cells("C" & (446 + add_rows) & ":N" & (448 + add_rows)).Copy(D_EXL_SHT1.Cells("C" & (446 + i * 3 + add_rows + page) & ":N" & (448 + i * 3 + add_rows + page)))

                        D_EXL_SHT1.Cells(446 + i * 3 + add_rows + page, 2).Value = i + 1

                        D_EXL_SHT1.Cells(446 + i * 3 + add_rows + page, 5).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(19).Rows(i).Item("full_name_furigana"), "")
                        D_EXL_SHT1.Cells(447 + i * 3 + add_rows + page, 5).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(19).Rows(i).Item("full_name"), "")
                        D_EXL_SHT1.Cells(446 + i * 3 + add_rows + page, 11).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(19).Rows(i).Item("relationship"), "")
                        D_EXL_SHT1.Cells(448 + i * 3 + add_rows + page, 5).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(19).Rows(i).Item("gender"), "")
                        D_EXL_SHT1.Cells(448 + i * 3 + add_rows + page, 9).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(19).Rows(i).Item("birthday"), "")
                        D_EXL_SHT1.Cells(448 + i * 3 + add_rows + page, 13).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(19).Rows(i).Item("residential_classification"), "")
                        D_EXL_SHT1.Cells(447 + i * 3 + add_rows + page, 11).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(19).Rows(i).Item("profession"), "")
                    Next
                    add_rows += 49 * (countPage - 1)
                Else
                    delTab9 = 442 + add_rows
                End If


                'fill 休職
                Dim delTab10 As Integer = 0
                Dim D_ROW_CNT_TAB10 = D_DAT.Tables(20).Rows.Count
                If D_ROW_CNT_TAB10 > 0 Then
                    Dim countPage As Integer = Math.Ceiling(D_ROW_CNT_TAB10 / 45.0)
                    D_EXL_SHT1.InsertRow(539 + add_rows, 49 * (countPage - 1))
                    For h As Integer = 0 To 49 * (countPage - 1) - 1
                        D_EXL_SHT1.Row(539 + add_rows + h).Height = sampleRowHeight
                    Next
                    D_EXL_SHT1.Cells(492 + add_rows, 2).Value = sourceValue
                    If countPage <> 0 Then
                        For i = 0 To countPage - 1
                            If i <> 0 Then
                                Dim sourceRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (491 + add_rows) & ":O" & (494 + add_rows))
                                Dim destinationRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (491 + i * 49 + add_rows) & ":O" & (494 + i * 49 + add_rows))
                                sourceRange.Copy(destinationRange)
                                D_EXL_SHT1.Row(491 + i * 49 + add_rows).Height = sampleRowHeightHeader
                                D_EXL_SHT1.Row(493 + i * 49 + add_rows).Height = sampleRowHeightSmall
                            End If
                        Next
                    End If

                    Dim page As Integer = 0
                    For j = 0 To D_ROW_CNT_TAB10 - 1
                        If countPage <> 0 Then
                            If j Mod 45 = 0 And j <> 0 Then
                                page += 4
                            End If
                        End If
                        D_EXL_SHT1.Cells("B" & (495 + add_rows) & ":N" & (495 + add_rows)).Copy(D_EXL_SHT1.Cells("B" & (495 + j + add_rows + page) & ":N" & (495 + j + add_rows + page)))
                        D_EXL_SHT1.Cells(495 + j + add_rows + page, 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(20).Rows(j).Item("id"), "")
                        D_EXL_SHT1.Cells(495 + j + add_rows + page, 3).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(20).Rows(j).Item("leave_absence_startdate"), "")
                        D_EXL_SHT1.Cells(495 + j + add_rows + page, 5).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(20).Rows(j).Item("leave_absence_enddate"), "")
                        D_EXL_SHT1.Cells(495 + j + add_rows + page, 7).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(20).Rows(j).Item("remarks"), "")
                    Next
                    add_rows += 49 * (countPage - 1)
                Else
                    delTab10 = 491 + add_rows
                End If

                'fill 有期雇用契約

                Dim delTab11 As Integer = 0
                Dim del44Rows As Integer = 0
                Dim startDelRows As Integer = 0
                Dim D_ROW_CNT_TAB11 = D_DAT.Tables(21).Rows.Count
                Dim flagPage As Integer = 0
                Dim countPageTab11 As Integer = 0
                Dim rowPageHeaderLate As Integer = 0
                If D_ROW_CNT_TAB11 > 0 Then
                    Dim y As Integer = 0
                    Dim spaceContract As Integer = 0
                    Dim footer As Integer = 0 'coordinates footer        
                    Dim page As Integer = 0
                    D_EXL_SHT1.Cells(541 + add_rows, 2).Value = sourceValue
                    'add rows
                    For i = 0 To D_ROW_CNT_TAB11 - 1
                        flagPage += 1
                        'header
                        If i > 0 Then
                            If CInt(D_DAT.Tables(21).Rows(i).Item("stt_detail_no")) = 1 Then
                                y += 1
                                If flagPage = 45 Then
                                    page += 4
                                    flagPage = 0
                                End If
                                If flagPage <> 1 Then
                                    flagPage += 1
                                End If
                            End If
                        End If
                        'footer
                        If CInt(D_DAT.Tables(21).Rows(i).Item("check_footer")) = 1 Then
                            y += 1
                            If flagPage = 45 Then
                                page += 4
                                flagPage = 0
                            End If
                            flagPage += 1
                            If flagPage = 45 And i <> D_ROW_CNT_TAB11 - 1 Then
                                page += 3
                                flagPage = 0
                            End If
                        End If
                        If CInt(D_DAT.Tables(21).Rows(i).Item("stt_detail_no")) <> 1 And CInt(D_DAT.Tables(21).Rows(i).Item("check_footer")) <> 1 Then
                            If flagPage = 45 Then
                                page += 4
                                flagPage = 0
                            End If
                        End If

                        If i = D_ROW_CNT_TAB11 - 1 Then
                            D_EXL_SHT1.InsertRow(545 + add_rows, D_ROW_CNT_TAB11 - 1 + page + y)
                            For h As Integer = 0 To (D_ROW_CNT_TAB11 - 1 + page + y) - 1
                                D_EXL_SHT1.Row(545 + add_rows + h).Height = sampleRowHeight
                            Next
                            countPageTab11 = Math.Ceiling((D_ROW_CNT_TAB11 + page + y) / 49.0)
                        End If
                    Next
                    footer = D_ROW_CNT_TAB11 + page + y - 1
                    flagPage = 0
                    page = 0
                    y = 0
                    For i = 0 To D_ROW_CNT_TAB11 - 1
                        flagPage += 1
                        'header
                        If i > 0 Then
                            If CInt(D_DAT.Tables(21).Rows(i).Item("stt_detail_no")) = 1 Then
                                y += 1
                                If flagPage = 45 Then
                                    page += 4
                                    flagPage = 0
                                    Dim sourceRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (540 + add_rows) & ":O" & (543 + add_rows))
                                    Dim destinationRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (540 + i + add_rows + page + y) & ":O" & (543 + i + add_rows + page + y))
                                    sourceRange.Copy(destinationRange)
                                    D_EXL_SHT1.Row(540 + i + add_rows + page + y).Height = sampleRowHeightHeader
                                    D_EXL_SHT1.Row(542 + i + add_rows + page + y).Height = sampleRowHeightSmall
                                End If
                                D_EXL_SHT1.Cells("B" & (543 + add_rows) & ":N" & (543 + add_rows)).Copy(D_EXL_SHT1.Cells("B" & (543 + i + add_rows + page + y) & ":N" & (543 + i + add_rows + page + y)))
                                If flagPage <> 1 Then
                                    flagPage += 1
                                End If
                            End If
                        End If
                        D_EXL_SHT1.Cells("B" & (544 + add_rows) & ":N" & (544 + add_rows)).Copy(D_EXL_SHT1.Cells("B" & (544 + i + add_rows + page + y) & ":N" & (544 + i + add_rows + page + y)))

                        If CInt(D_DAT.Tables(21).Rows(i).Item("check_footer")) = 1 Then
                            y += 1
                            If flagPage = 45 Then
                                page += 4
                                flagPage = 0
                                Dim sourceRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (540 + add_rows) & ":O" & (543 + add_rows))
                                Dim destinationRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (540 + i + add_rows + page + y) & ":O" & (543 + i + add_rows + page + y))
                                sourceRange.Copy(destinationRange)
                                D_EXL_SHT1.Row(540 + i + add_rows + page + y).Height = sampleRowHeightHeader
                                D_EXL_SHT1.Row(542 + i + add_rows + page + y).Height = sampleRowHeightSmall
                            End If
                            D_EXL_SHT1.Cells("B" & (545 + add_rows + footer) & ":N" & (545 + add_rows + footer)).Copy(D_EXL_SHT1.Cells("B" & (544 + i + add_rows + page + y) & ":N" & (544 + i + add_rows + page + y)))
                            flagPage += 1
                            If flagPage = 45 And i <> D_ROW_CNT_TAB11 - 1 Then
                                page += 3
                                flagPage = 0
                                Dim sourceRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (540 + add_rows) & ":O" & (543 + add_rows))
                                Dim destinationRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (540 + i + add_rows + page + y + 2) & ":O" & (542 + i + add_rows + page + y + 2))
                                sourceRange.Copy(destinationRange)
                                D_EXL_SHT1.Row(540 + i + add_rows + page + y + 2).Height = sampleRowHeightHeader
                                D_EXL_SHT1.Row(542 + i + add_rows + page + y + 2).Height = sampleRowHeightSmall
                            End If
                        End If
                        If CInt(D_DAT.Tables(21).Rows(i).Item("stt_detail_no")) <> 1 And CInt(D_DAT.Tables(21).Rows(i).Item("check_footer")) <> 1 Then
                            If flagPage = 45 Then
                                page += 4
                                flagPage = 0
                                Dim sourceRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (540 + add_rows) & ":O" & (543 + add_rows))
                                Dim destinationRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (540 + i + add_rows + page + y + 1) & ":O" & (543 + i + add_rows + page + y + 1))
                                sourceRange.Copy(destinationRange)
                                D_EXL_SHT1.Row(540 + i + add_rows + page + y + 1).Height = sampleRowHeightHeader
                                D_EXL_SHT1.Row(542 + i + add_rows + page + y + 1).Height = sampleRowHeightSmall
                            End If
                        End If
                    Next
                    'fill data
                    flagPage = 0
                    page = 0
                    y = 0
                    For i = 0 To D_ROW_CNT_TAB11 - 1
                        flagPage += 1
                        If i > 0 Then
                            If CInt(D_DAT.Tables(21).Rows(i).Item("stt_detail_no")) = 1 Then
                                y += 1
                                If flagPage = 45 Then
                                    page += 4
                                    flagPage = 0
                                End If
                                If flagPage <> 1 Then
                                    flagPage += 1
                                End If
                            End If
                        End If
                        D_EXL_SHT1.Cells(544 + i + add_rows + page + y, 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(21).Rows(i)("stt_detail_no").ToString(), "")
                        D_EXL_SHT1.Cells(544 + i + add_rows + page + y, 3).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(21).Rows(i)("start_date").ToString(), "")
                        D_EXL_SHT1.Cells(544 + i + add_rows + page + y, 5).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(21).Rows(i)("expiration_date").ToString(), "")
                        D_EXL_SHT1.Cells(544 + i + add_rows + page + y, 7).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(21).Rows(i)("contract_renewal_kbn").ToString(), "")
                        D_EXL_SHT1.Cells(544 + i + add_rows + page + y, 9).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(21).Rows(i)("reason_resignation").ToString(), "")
                        D_EXL_SHT1.Cells(544 + i + add_rows + page + y, 12).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(21).Rows(i)("remarks").ToString(), "")
                        If CInt(D_DAT.Tables(21).Rows(i).Item("check_footer")) = 1 Then
                            y += 1
                            If flagPage = 45 Then
                                page += 4
                                flagPage = 0
                            End If
                            D_EXL_SHT1.Cells(544 + i + add_rows + page + y, 5).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(21).Rows(i)("total_contract_period").ToString(), "")
                            D_EXL_SHT1.Cells(544 + i + add_rows + page + y, 9).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(21).Rows(i)("number_of_contract_renewals").ToString(), "")
                            flagPage += 1
                            If flagPage = 45 And i <> D_ROW_CNT_TAB11 - 1 Then
                                page += 3
                                flagPage = 0
                            End If
                        End If

                        If CInt(D_DAT.Tables(21).Rows(i).Item("stt_detail_no")) <> 1 And CInt(D_DAT.Tables(21).Rows(i).Item("check_footer")) <> 1 Then
                            If flagPage = 45 Then
                                page += 4
                                flagPage = 0

                            End If
                        End If
                    Next
                    startDelRows = 544 + add_rows + D_ROW_CNT_TAB11 + page + y
                    rowPageHeaderLate = 540 + add_rows + 49 * (countPageTab11 - 1)
                    add_rows += D_ROW_CNT_TAB11 - 1 + page + y
                Else
                    delTab11 = 540 + add_rows
                End If
                'del 43 rows and add row for more page
                If D_ROW_CNT_TAB11 > 0 Then
                    If startDelRows <> rowPageHeaderLate Then

                        D_EXL_SHT1.InsertRow(startDelRows, 49 - (startDelRows - rowPageHeaderLate))


                        For h = 0 To (49 - (startDelRows - rowPageHeaderLate)) - 1
                            D_EXL_SHT1.Row(startDelRows + h).Height = sampleRowHeight
                        Next
                        del44Rows = startDelRows + (49 - (startDelRows - rowPageHeaderLate))
                        add_rows += 49 - (startDelRows - rowPageHeaderLate)
                    Else
                        del44Rows = startDelRows
                    End If
                End If

                'fill 社会保険
                Dim D_ROW_CNT_TAB12 = D_DAT.Tables(22).Rows.Count
                If D_ROW_CNT_TAB12 > 0 Then
                    D_EXL_SHT1.Cells(590 + add_rows, 2).Value = sourceValue
                    D_EXL_SHT1.Cells(592 + add_rows, 5).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(22).Rows(0).Item("employment_insurance_no"), "")
                    D_EXL_SHT1.Cells(592 + add_rows, 11).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(22).Rows(0).Item("basic_pension_no"), "")
                    D_EXL_SHT1.Cells(593 + add_rows, 6).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(22).Rows(0).Item("employment_insurance_status"), "")
                    D_EXL_SHT1.Cells(596 + add_rows, 6).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(22).Rows(0).Item("health_insurance_status"), "")
                    D_EXL_SHT1.Cells(596 + add_rows, 11).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(22).Rows(0).Item("health_insurance_reference_no"), "")
                    D_EXL_SHT1.Cells(599 + add_rows, 6).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(22).Rows(0).Item("employees_pension_insurance_status"), "")
                    D_EXL_SHT1.Cells(599 + add_rows, 11).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(22).Rows(0).Item("employees_pension_reference_no"), "")
                    D_EXL_SHT1.Cells(602 + add_rows, 6).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(22).Rows(0).Item("welfare_pension_status"), "")
                    D_EXL_SHT1.Cells(602 + add_rows, 11).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(22).Rows(0).Item("employees_pension_member_no"), "")
                End If
                'fill 20
                Dim D_ROW_CNT_TAB12_1 = D_DAT.Tables(23).Rows.Count
                Dim D_ROW_CNT_TAB12_2 = D_DAT.Tables(24).Rows.Count
                Dim D_ROW_CNT_TAB12_3 = D_DAT.Tables(25).Rows.Count
                Dim D_ROW_CNT_TAB12_4 = D_DAT.Tables(26).Rows.Count
                Dim flagPageTab12 As Integer = 0
                Dim flagPageAddRowsTab12 As Integer = 0
                Dim pageTab12 As Integer = 0
                Dim pageTab12_2 As Integer = 0
                Dim addRowsTab12 As Integer = add_rows
                Dim rowsHeader As Integer = 2
                Dim rowsDelHeader As Integer = 0
                Dim del33Rows As Integer = 0
                Dim delStart33Rows As Integer = 0
                Dim delTab12_1 As Integer = 0
                Dim delTab12_2 As Integer = 0
                Dim delTab12_3 As Integer = 0
                Dim delTab12_4 As Integer = 0
                Dim countPageTab12 As Integer = 0
                Dim rowHeader As Integer = 589 + add_rows
                '20
                'add rows
                If D_ROW_CNT_TAB12_1 > 0 Then
                    For i = 0 To D_ROW_CNT_TAB12_1 - 1
                        flagPageAddRowsTab12 += 1

                        If D_ROW_CNT_TAB12_1 = 41 Then
                            If flagPageAddRowsTab12 = 41 Then
                                pageTab12 += 6
                                flagPageAddRowsTab12 = 0
                            End If
                        ElseIf D_ROW_CNT_TAB12_1 = 42 Then
                            If flagPageAddRowsTab12 = 42 Then
                                pageTab12 += 5
                                flagPageAddRowsTab12 = 0
                            End If
                        ElseIf D_ROW_CNT_TAB12_1 = 43 Then
                            If flagPageAddRowsTab12 = 43 Then
                                pageTab12 += 4
                                flagPageAddRowsTab12 = 0
                            End If
                        Else
                            If flagPageAddRowsTab12 = 43 Then
                                pageTab12 += 6
                                flagPageAddRowsTab12 = 0
                                rowsDelHeader += 2
                            End If
                        End If

                        If i = D_ROW_CNT_TAB12_1 - 1 Then
                            D_EXL_SHT1.InsertRow(596 + add_rows, D_ROW_CNT_TAB12_1 - 1 + pageTab12)
                            For h As Integer = 0 To D_ROW_CNT_TAB12_1 + pageTab12 - 2
                                D_EXL_SHT1.Row(596 + add_rows + h).Height = sampleRowHeight
                            Next
                        End If
                    Next
                    addRowsTab12 += D_ROW_CNT_TAB12_1 - 1 + pageTab12
                Else
                    delTab12_1 = 594 + add_rows
                    rowsDelHeader -= 2
                End If
                '21
                pageTab12 = 0
                If flagPageAddRowsTab12 = 0 Then
                    flagPageAddRowsTab12 = 0

                Else
                    flagPageAddRowsTab12 += 2
                End If

                If D_ROW_CNT_TAB12_2 > 0 Then
                    For i = 0 To D_ROW_CNT_TAB12_2 - 1
                        flagPageAddRowsTab12 += 1


                        If D_ROW_CNT_TAB12_2 >= 41 And D_ROW_CNT_TAB12_2 <= 42 Then
                            If i = D_ROW_CNT_TAB12_2 - 1 Then
                                If flagPageAddRowsTab12 = 41 Then
                                    pageTab12 += 6
                                    flagPageAddRowsTab12 = 0
                                ElseIf flagPageAddRowsTab12 = 42 Then
                                    pageTab12 += 5
                                    flagPageAddRowsTab12 = 0
                                ElseIf flagPageAddRowsTab12 = 43 Then
                                    pageTab12 += 4
                                    flagPageAddRowsTab12 = 0
                                End If

                            Else
                                If flagPageAddRowsTab12 = 43 Then
                                    pageTab12 += 6
                                    flagPageAddRowsTab12 = 0
                                    rowsDelHeader += 2
                                End If
                            End If
                        Else
                            If i = D_ROW_CNT_TAB12_2 - 1 Then
                                If flagPageAddRowsTab12 = 41 Then
                                    pageTab12 += 6
                                    flagPageAddRowsTab12 = 0
                                ElseIf flagPageAddRowsTab12 = 42 Then
                                    pageTab12 += 5
                                    flagPageAddRowsTab12 = 0
                                ElseIf flagPageAddRowsTab12 = 43 Then
                                    pageTab12 += 4
                                    flagPageAddRowsTab12 = 0
                                End If

                            Else
                                If flagPageAddRowsTab12 = 43 Then
                                    pageTab12 += 6
                                    flagPageAddRowsTab12 = 0
                                    rowsDelHeader += 2
                                End If
                            End If
                        End If

                        If i = D_ROW_CNT_TAB12_2 - 1 Then
                            D_EXL_SHT1.InsertRow(599 + addRowsTab12, D_ROW_CNT_TAB12_2 - 1 + pageTab12)
                            For h As Integer = 0 To D_ROW_CNT_TAB12_2 - 1 + pageTab12 - 1
                                D_EXL_SHT1.Row(599 + addRowsTab12 + h).Height = sampleRowHeight
                            Next
                        End If
                    Next
                    addRowsTab12 += D_ROW_CNT_TAB12_2 - 1 + pageTab12
                Else
                    delTab12_2 = 597 + addRowsTab12
                    rowsDelHeader -= 2
                End If
                '22
                pageTab12 = 0
                If flagPageAddRowsTab12 = 0 Then
                    flagPageAddRowsTab12 = 0
                Else
                    flagPageAddRowsTab12 += 2
                End If

                If D_ROW_CNT_TAB12_3 > 0 Then

                    For i = 0 To D_ROW_CNT_TAB12_3 - 1

                        flagPageAddRowsTab12 += 1

                        If D_ROW_CNT_TAB12_3 >= 41 And D_ROW_CNT_TAB12_3 <= 42 Then
                            If i = D_ROW_CNT_TAB12_3 - 1 Then
                                If flagPageAddRowsTab12 = 41 Then
                                    pageTab12 += 6
                                    flagPageAddRowsTab12 = 0
                                ElseIf flagPageAddRowsTab12 = 42 Then
                                    pageTab12 += 5
                                    flagPageAddRowsTab12 = 0
                                ElseIf flagPageAddRowsTab12 = 43 Then
                                    pageTab12 += 4
                                    flagPageAddRowsTab12 = 0
                                End If

                            Else
                                If flagPageAddRowsTab12 = 43 Then
                                    pageTab12 += 6
                                    flagPageAddRowsTab12 = 0
                                    rowsDelHeader += 2
                                End If
                            End If
                        Else
                            If i = D_ROW_CNT_TAB12_3 - 1 Then
                                If flagPageAddRowsTab12 = 41 Then
                                    pageTab12 += 6
                                    flagPageAddRowsTab12 = 0
                                ElseIf flagPageAddRowsTab12 = 42 Then
                                    pageTab12 += 5
                                    flagPageAddRowsTab12 = 0
                                ElseIf flagPageAddRowsTab12 = 43 Then
                                    pageTab12 += 4
                                    flagPageAddRowsTab12 = 0
                                End If

                            Else
                                If flagPageAddRowsTab12 = 43 Then
                                    pageTab12 += 6
                                    flagPageAddRowsTab12 = 0
                                    rowsDelHeader += 2
                                End If
                            End If
                        End If



                        If i = D_ROW_CNT_TAB12_3 - 1 Then
                            D_EXL_SHT1.InsertRow(602 + addRowsTab12, D_ROW_CNT_TAB12_3 - 1 + pageTab12)
                            For h As Integer = 0 To D_ROW_CNT_TAB12_3 - 1 + pageTab12 - 1
                                D_EXL_SHT1.Row(602 + addRowsTab12 + h).Height = sampleRowHeight
                            Next
                        End If
                    Next
                    addRowsTab12 += D_ROW_CNT_TAB12_3 - 1 + pageTab12
                Else
                    delTab12_3 = 600 + addRowsTab12
                    rowsDelHeader -= 2
                End If
                '23
                pageTab12 = 0
                If flagPageAddRowsTab12 = 0 Then
                    flagPageAddRowsTab12 = 0
                Else
                    flagPageAddRowsTab12 += 2
                End If

                If D_ROW_CNT_TAB12_4 > 0 Then

                    For i = 0 To D_ROW_CNT_TAB12_4 - 1
                        flagPageAddRowsTab12 += 1

                        If D_ROW_CNT_TAB12_4 >= 41 And D_ROW_CNT_TAB12_4 <= 42 Then
                            If i = D_ROW_CNT_TAB12_4 - 1 Then
                                If flagPageAddRowsTab12 = 41 Then
                                    pageTab12 += 6
                                    flagPageAddRowsTab12 = 0
                                ElseIf flagPageAddRowsTab12 = 42 Then
                                    pageTab12 += 5
                                    flagPageAddRowsTab12 = 0
                                ElseIf flagPageAddRowsTab12 = 43 Then
                                    pageTab12 += 4
                                    flagPageAddRowsTab12 = 0
                                End If

                            Else
                                If flagPageAddRowsTab12 = 43 Then
                                    pageTab12 += 6
                                    flagPageAddRowsTab12 = 0
                                    rowsDelHeader += 2
                                End If
                            End If
                        Else
                            If i = D_ROW_CNT_TAB12_4 - 1 Then
                                If flagPageAddRowsTab12 = 41 Then
                                    pageTab12 += 6
                                    flagPageAddRowsTab12 = 0
                                ElseIf flagPageAddRowsTab12 = 42 Then
                                    pageTab12 += 5
                                    flagPageAddRowsTab12 = 0
                                ElseIf flagPageAddRowsTab12 = 43 And i <> D_ROW_CNT_TAB12_4 - 1 Then
                                    pageTab12 += 4
                                    flagPageAddRowsTab12 = 0
                                End If

                            Else
                                If flagPageAddRowsTab12 = 43 Then
                                    pageTab12 += 6
                                    flagPageAddRowsTab12 = 0
                                    rowsDelHeader += 2
                                End If
                            End If
                        End If

                        If i = D_ROW_CNT_TAB12_4 - 1 Then
                            D_EXL_SHT1.InsertRow(605 + addRowsTab12, D_ROW_CNT_TAB12_4 - 1 + pageTab12)
                            For h As Integer = 0 To D_ROW_CNT_TAB12_4 - 1 + pageTab12 - 1
                                D_EXL_SHT1.Row(605 + addRowsTab12 + h).Height = sampleRowHeight
                            Next
                        End If
                    Next
                    addRowsTab12 += D_ROW_CNT_TAB12_4 - 1 + pageTab12
                Else
                    delTab12_4 = 603 + addRowsTab12
                    rowsDelHeader -= 2
                End If
                If D_ROW_CNT_TAB12_1 + D_ROW_CNT_TAB12_2 + D_ROW_CNT_TAB12_3 + D_ROW_CNT_TAB12_4 <= 49 Then
                    rowsDelHeader = (D_ROW_CNT_TAB12_1 - 1) + (D_ROW_CNT_TAB12_2 - 1) + (D_ROW_CNT_TAB12_3 - 1) + (D_ROW_CNT_TAB12_4 - 1) + 16
                End If

                'fill boder
                '20
                pageTab12 = 0
                flagPageTab12 = 0
                addRowsTab12 = add_rows
                If D_ROW_CNT_TAB12_1 > 0 Then
                    For i = 0 To D_ROW_CNT_TAB12_1 - 1
                        D_EXL_SHT1.Cells("B" & (595 + addRowsTab12) & ":N" & (595 + addRowsTab12)).Copy(D_EXL_SHT1.Cells("B" & (595 + i + addRowsTab12 + pageTab12) & ":N" & (595 + i + addRowsTab12 + pageTab12)))

                        flagPageTab12 += 1
                        If D_ROW_CNT_TAB12_1 = 41 Then
                            If flagPageTab12 = 41 Then
                                pageTab12 += 6
                                Dim sourceRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (589 + add_rows) & ":O" & (592 + add_rows))
                                Dim destinationRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (590 + i + addRowsTab12 + pageTab12 + rowsHeader) & ":O" & (593 + i + addRowsTab12 + pageTab12 + rowsHeader))
                                sourceRange.Copy(destinationRange)
                                D_EXL_SHT1.Row(590 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightHeader
                                D_EXL_SHT1.Row(592 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightSmall
                                flagPageTab12 = 0
                            End If
                        ElseIf D_ROW_CNT_TAB12_1 = 42 Then
                            If flagPageTab12 = 42 Then
                                pageTab12 += 5
                                Dim sourceRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (589 + add_rows) & ":O" & (592 + add_rows))
                                Dim destinationRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (590 + i + addRowsTab12 + pageTab12 + rowsHeader) & ":O" & (593 + i + addRowsTab12 + pageTab12 + rowsHeader))
                                sourceRange.Copy(destinationRange)
                                D_EXL_SHT1.Row(590 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightHeader
                                D_EXL_SHT1.Row(592 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightSmall
                                flagPageTab12 = 0
                            End If
                        ElseIf D_ROW_CNT_TAB12_1 = 43 Then
                            If flagPageTab12 = 43 Then
                                pageTab12 += 4
                                Dim sourceRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (589 + add_rows) & ":O" & (592 + add_rows))
                                Dim destinationRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (590 + i + addRowsTab12 + pageTab12 + rowsHeader) & ":O" & (593 + i + addRowsTab12 + pageTab12 + rowsHeader))
                                sourceRange.Copy(destinationRange)
                                D_EXL_SHT1.Row(590 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightHeader
                                D_EXL_SHT1.Row(592 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightSmall
                                flagPageTab12 = 0
                            End If
                        Else
                            If flagPageTab12 = 43 Then
                                pageTab12 += 6
                                Dim sourceRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (589 + add_rows) & ":O" & (592 + add_rows))
                                Dim destinationRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (588 + i + addRowsTab12 + pageTab12 + rowsHeader) & ":O" & (591 + i + addRowsTab12 + pageTab12 + rowsHeader))
                                sourceRange.Copy(destinationRange)
                                D_EXL_SHT1.Row(588 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightHeader
                                D_EXL_SHT1.Row(590 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightSmall
                                Dim sourceRange20 As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (593 + addRowsTab12) & ":O" & (594 + addRowsTab12))
                                Dim destinationRange20 As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (594 + i + addRowsTab12 + pageTab12) & ":O" & (595 + i + addRowsTab12 + pageTab12))
                                sourceRange20.Copy(destinationRange20)
                                flagPageTab12 = 0
                            End If
                        End If

                    Next
                    addRowsTab12 += D_ROW_CNT_TAB12_1 - 1 + pageTab12
                End If
                '21  
                pageTab12 = 0

                If flagPageTab12 = 0 Then
                    flagPageTab12 = 0
                Else
                    flagPageTab12 += 2
                End If

                If D_ROW_CNT_TAB12_2 > 0 Then
                    For i = 0 To D_ROW_CNT_TAB12_2 - 1
                        flagPageTab12 += 1

                        D_EXL_SHT1.Cells("B" & (598 + addRowsTab12) & ":N" & (598 + addRowsTab12)).Copy(D_EXL_SHT1.Cells("B" & (598 + i + addRowsTab12 + pageTab12) & ":N" & (598 + i + addRowsTab12 + pageTab12)))

                        If D_ROW_CNT_TAB12_2 >= 41 And D_ROW_CNT_TAB12_2 <= 42 Then
                            If i = D_ROW_CNT_TAB12_2 - 1 Then
                                If flagPageTab12 = 41 Then
                                    pageTab12 += 6
                                    Dim sourceRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (589 + add_rows) & ":O" & (592 + add_rows))
                                    Dim destinationRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (593 + i + addRowsTab12 + pageTab12 + rowsHeader) & ":O" & (596 + i + addRowsTab12 + pageTab12 + rowsHeader))
                                    sourceRange.Copy(destinationRange)
                                    D_EXL_SHT1.Row(593 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightHeader
                                    D_EXL_SHT1.Row(595 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightSmall
                                    flagPageTab12 = 0
                                ElseIf flagPageTab12 = 42 Then
                                    pageTab12 += 5
                                    Dim sourceRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (589 + add_rows) & ":O" & (592 + add_rows))
                                    Dim destinationRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (593 + i + addRowsTab12 + pageTab12 + rowsHeader) & ":O" & (596 + i + addRowsTab12 + pageTab12 + rowsHeader))
                                    sourceRange.Copy(destinationRange)
                                    D_EXL_SHT1.Row(593 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightHeader
                                    D_EXL_SHT1.Row(595 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightSmall
                                    flagPageTab12 = 0
                                ElseIf flagPageTab12 = 43 Then
                                    pageTab12 += 4
                                    Dim sourceRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (589 + add_rows) & ":O" & (592 + add_rows))
                                    Dim destinationRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (593 + i + addRowsTab12 + pageTab12 + rowsHeader) & ":O" & (596 + i + addRowsTab12 + pageTab12 + rowsHeader))
                                    sourceRange.Copy(destinationRange)
                                    D_EXL_SHT1.Row(593 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightHeader
                                    D_EXL_SHT1.Row(595 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightSmall
                                    flagPageTab12 = 0
                                End If

                            Else
                                If flagPageTab12 = 43 Then
                                    pageTab12 += 6
                                    Dim sourceRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (589 + add_rows) & ":O" & (591 + add_rows))
                                    Dim destinationRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (591 + i + addRowsTab12 + pageTab12 + rowsHeader) & ":O" & (594 + i + addRowsTab12 + pageTab12 + rowsHeader))
                                    sourceRange.Copy(destinationRange)
                                    D_EXL_SHT1.Row(591 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightHeader
                                    D_EXL_SHT1.Row(593 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightSmall
                                    Dim sourceRange21 As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (596 + addRowsTab12) & ":O" & (597 + addRowsTab12))
                                    Dim destinationRange21 As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (597 + i + addRowsTab12 + pageTab12) & ":O" & (598 + i + addRowsTab12 + pageTab12))
                                    sourceRange21.Copy(destinationRange21)
                                    flagPageTab12 = 0
                                End If
                            End If
                        Else
                            If i = D_ROW_CNT_TAB12_2 - 1 Then
                                If flagPageTab12 = 41 Then
                                    pageTab12 += 6
                                    Dim sourceRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (589 + add_rows) & ":O" & (592 + add_rows))
                                    Dim destinationRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (593 + i + addRowsTab12 + pageTab12 + rowsHeader) & ":O" & (596 + i + addRowsTab12 + pageTab12 + rowsHeader))
                                    sourceRange.Copy(destinationRange)
                                    D_EXL_SHT1.Row(593 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightHeader
                                    D_EXL_SHT1.Row(595 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightSmall
                                    flagPageTab12 = 0
                                ElseIf flagPageTab12 = 42 Then
                                    pageTab12 += 5
                                    Dim sourceRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (589 + add_rows) & ":O" & (592 + add_rows))
                                    Dim destinationRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (593 + i + addRowsTab12 + pageTab12 + rowsHeader) & ":O" & (596 + i + addRowsTab12 + pageTab12 + rowsHeader))
                                    sourceRange.Copy(destinationRange)
                                    D_EXL_SHT1.Row(593 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightHeader
                                    D_EXL_SHT1.Row(595 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightSmall
                                    flagPageTab12 = 0
                                ElseIf flagPageTab12 = 43 Then
                                    pageTab12 += 4
                                    Dim sourceRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (589 + add_rows) & ":O" & (592 + add_rows))
                                    Dim destinationRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (593 + i + addRowsTab12 + pageTab12 + rowsHeader) & ":O" & (596 + i + addRowsTab12 + pageTab12 + rowsHeader))
                                    sourceRange.Copy(destinationRange)
                                    D_EXL_SHT1.Row(593 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightHeader
                                    D_EXL_SHT1.Row(595 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightSmall
                                    flagPageTab12 = 0
                                End If
                            Else
                                If flagPageTab12 = 43 Then
                                    pageTab12 += 6
                                    Dim sourceRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (589 + add_rows) & ":O" & (592 + add_rows))
                                    Dim destinationRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (591 + i + addRowsTab12 + pageTab12 + rowsHeader) & ":O" & (594 + i + addRowsTab12 + pageTab12 + rowsHeader))
                                    sourceRange.Copy(destinationRange)
                                    D_EXL_SHT1.Row(591 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightHeader
                                    D_EXL_SHT1.Row(593 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightSmall
                                    Dim sourceRange21 As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (596 + addRowsTab12) & ":O" & (597 + addRowsTab12))
                                    Dim destinationRange21 As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (597 + i + addRowsTab12 + pageTab12) & ":O" & (598 + i + addRowsTab12 + pageTab12))
                                    sourceRange21.Copy(destinationRange21)
                                    flagPageTab12 = 0
                                End If
                            End If
                        End If
                    Next
                    addRowsTab12 += D_ROW_CNT_TAB12_2 - 1 + pageTab12
                End If
                '22
                pageTab12 = 0
                If flagPageTab12 = 0 Then
                    flagPageTab12 = 0
                Else
                    flagPageTab12 += 2
                End If
                If D_ROW_CNT_TAB12_3 > 0 Then
                    For i = 0 To D_ROW_CNT_TAB12_3 - 1
                        flagPageTab12 += 1
                        D_EXL_SHT1.Cells("B" & (601 + addRowsTab12) & ":N" & (601 + addRowsTab12)).Copy(D_EXL_SHT1.Cells("B" & (601 + i + addRowsTab12 + pageTab12) & ":N" & (601 + i + addRowsTab12 + pageTab12)))

                        If D_ROW_CNT_TAB12_3 >= 41 And D_ROW_CNT_TAB12_3 <= 42 Then
                            If i = D_ROW_CNT_TAB12_3 - 1 Then
                                If flagPageTab12 = 41 Then
                                    pageTab12 += 6
                                    Dim sourceRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (589 + add_rows) & ":O" & (592 + add_rows))
                                    Dim destinationRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (596 + i + addRowsTab12 + pageTab12 + rowsHeader) & ":O" & (599 + i + addRowsTab12 + pageTab12 + rowsHeader))
                                    sourceRange.Copy(destinationRange)
                                    D_EXL_SHT1.Row(596 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightHeader
                                    D_EXL_SHT1.Row(598 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightSmall
                                    flagPageTab12 = 0
                                ElseIf flagPageTab12 = 42 Then
                                    pageTab12 += 5
                                    Dim sourceRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (589 + add_rows) & ":O" & (592 + add_rows))
                                    Dim destinationRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (596 + i + addRowsTab12 + pageTab12 + rowsHeader) & ":O" & (599 + i + addRowsTab12 + pageTab12 + rowsHeader))
                                    sourceRange.Copy(destinationRange)
                                    D_EXL_SHT1.Row(596 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightHeader
                                    D_EXL_SHT1.Row(598 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightSmall
                                    flagPageTab12 = 0
                                ElseIf flagPageTab12 = 43 Then
                                    pageTab12 += 4
                                    Dim sourceRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (589 + add_rows) & ":O" & (592 + add_rows))
                                    Dim destinationRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (596 + i + addRowsTab12 + pageTab12 + rowsHeader) & ":O" & (599 + i + addRowsTab12 + pageTab12 + rowsHeader))
                                    sourceRange.Copy(destinationRange)
                                    D_EXL_SHT1.Row(596 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightHeader
                                    D_EXL_SHT1.Row(598 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightSmall
                                    flagPageTab12 = 0
                                End If

                            Else
                                If flagPageTab12 = 43 Then
                                    pageTab12 += 6
                                    Dim sourceRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (589 + add_rows) & ":O" & (591 + add_rows))
                                    Dim destinationRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (594 + i + addRowsTab12 + pageTab12 + rowsHeader) & ":O" & (597 + i + addRowsTab12 + pageTab12 + rowsHeader))
                                    sourceRange.Copy(destinationRange)
                                    D_EXL_SHT1.Row(594 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightHeader
                                    D_EXL_SHT1.Row(596 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightSmall
                                    Dim sourceRange22 As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (599 + addRowsTab12) & ":O" & (600 + addRowsTab12))
                                    Dim destinationRange22 As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (600 + i + addRowsTab12 + pageTab12) & ":O" & (601 + i + addRowsTab12 + pageTab12))
                                    sourceRange22.Copy(destinationRange22)
                                    flagPageTab12 = 0
                                End If
                            End If
                        Else
                            If i = D_ROW_CNT_TAB12_3 - 1 Then
                                If flagPageTab12 = 41 Then
                                    pageTab12 += 6
                                    Dim sourceRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (589 + add_rows) & ":O" & (592 + add_rows))
                                    Dim destinationRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (596 + i + addRowsTab12 + pageTab12 + rowsHeader) & ":O" & (599 + i + addRowsTab12 + pageTab12 + rowsHeader))
                                    sourceRange.Copy(destinationRange)
                                    D_EXL_SHT1.Row(596 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightHeader
                                    D_EXL_SHT1.Row(598 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightSmall
                                    flagPageTab12 = 0
                                ElseIf flagPageTab12 = 42 Then
                                    pageTab12 += 5
                                    Dim sourceRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (589 + add_rows) & ":O" & (592 + add_rows))
                                    Dim destinationRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (596 + i + addRowsTab12 + pageTab12 + rowsHeader) & ":O" & (599 + i + addRowsTab12 + pageTab12 + rowsHeader))
                                    sourceRange.Copy(destinationRange)
                                    D_EXL_SHT1.Row(596 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightHeader
                                    D_EXL_SHT1.Row(598 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightSmall
                                    flagPageTab12 = 0
                                ElseIf flagPageTab12 = 43 Then
                                    pageTab12 += 4
                                    Dim sourceRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (589 + add_rows) & ":O" & (592 + add_rows))
                                    Dim destinationRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (596 + i + addRowsTab12 + pageTab12 + rowsHeader) & ":O" & (599 + i + addRowsTab12 + pageTab12 + rowsHeader))
                                    sourceRange.Copy(destinationRange)
                                    D_EXL_SHT1.Row(596 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightHeader
                                    D_EXL_SHT1.Row(598 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightSmall
                                    flagPageTab12 = 0
                                End If
                            Else

                                If flagPageTab12 = 43 Then
                                    pageTab12 += 6
                                    Dim sourceRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (589 + add_rows) & ":O" & (592 + add_rows))
                                    Dim destinationRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (594 + i + addRowsTab12 + pageTab12 + rowsHeader) & ":O" & (597 + i + addRowsTab12 + pageTab12 + rowsHeader))
                                    sourceRange.Copy(destinationRange)
                                    D_EXL_SHT1.Row(594 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightHeader
                                    D_EXL_SHT1.Row(596 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightSmall
                                    Dim sourceRange22 As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (599 + addRowsTab12) & ":O" & (600 + addRowsTab12))
                                    Dim destinationRange22 As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (600 + i + addRowsTab12 + pageTab12) & ":O" & (601 + i + addRowsTab12 + pageTab12))
                                    sourceRange22.Copy(destinationRange22)
                                    flagPageTab12 = 0
                                End If
                            End If
                        End If


                    Next
                    addRowsTab12 += D_ROW_CNT_TAB12_3 - 1 + pageTab12
                End If
                '23
                If flagPageTab12 = 0 Then
                    flagPageTab12 = 0
                Else
                    flagPageTab12 += 2
                End If
                pageTab12 = 0
                If D_ROW_CNT_TAB12_4 > 0 Then

                    For i = 0 To D_ROW_CNT_TAB12_4 - 1
                        D_EXL_SHT1.Cells("B" & (604 + addRowsTab12) & ":N" & (604 + addRowsTab12)).Copy(D_EXL_SHT1.Cells("B" & (604 + i + addRowsTab12 + pageTab12) & ":N" & (604 + i + addRowsTab12 + pageTab12)))

                        flagPageTab12 += 1
                        If D_ROW_CNT_TAB12_4 >= 41 And D_ROW_CNT_TAB12_4 <= 42 Then
                            If i = D_ROW_CNT_TAB12_4 - 1 Then
                                If flagPageTab12 = 41 Then
                                    pageTab12 += 6
                                    Dim sourceRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (589 + add_rows) & ":O" & (592 + add_rows))
                                    Dim destinationRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (599 + i + addRowsTab12 + pageTab12 + rowsHeader) & ":O" & (602 + i + addRowsTab12 + pageTab12 + rowsHeader))
                                    sourceRange.Copy(destinationRange)
                                    D_EXL_SHT1.Row(599 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightHeader
                                    D_EXL_SHT1.Row(601 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightSmall
                                    flagPageTab12 = 0
                                ElseIf flagPageTab12 = 42 Then
                                    pageTab12 += 5
                                    Dim sourceRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (589 + add_rows) & ":O" & (592 + add_rows))
                                    Dim destinationRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (599 + i + addRowsTab12 + pageTab12 + rowsHeader) & ":O" & (602 + i + addRowsTab12 + pageTab12 + rowsHeader))
                                    sourceRange.Copy(destinationRange)
                                    D_EXL_SHT1.Row(599 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightHeader
                                    D_EXL_SHT1.Row(601 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightSmall
                                    flagPageTab12 = 0
                                ElseIf flagPageTab12 = 43 Then
                                    pageTab12 += 4
                                    Dim sourceRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (589 + add_rows) & ":O" & (592 + add_rows))
                                    Dim destinationRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (599 + i + addRowsTab12 + pageTab12 + rowsHeader) & ":O" & (602 + i + addRowsTab12 + pageTab12 + rowsHeader))
                                    sourceRange.Copy(destinationRange)
                                    D_EXL_SHT1.Row(599 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightHeader
                                    D_EXL_SHT1.Row(601 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightSmall
                                    flagPageTab12 = 0
                                End If

                            Else
                                If flagPageTab12 = 43 Then
                                    pageTab12 += 6
                                    Dim sourceRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (589 + add_rows) & ":O" & (591 + add_rows))
                                    Dim destinationRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (597 + i + addRowsTab12 + pageTab12 + rowsHeader) & ":O" & (600 + i + addRowsTab12 + pageTab12 + rowsHeader))
                                    sourceRange.Copy(destinationRange)
                                    D_EXL_SHT1.Row(597 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightHeader
                                    D_EXL_SHT1.Row(599 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightSmall
                                    Dim sourceRange23 As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (602 + addRowsTab12) & ":O" & (603 + addRowsTab12))
                                    Dim destinationRange23 As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (603 + i + addRowsTab12 + pageTab12) & ":O" & (604 + i + addRowsTab12 + pageTab12))
                                    sourceRange23.Copy(destinationRange23)
                                    flagPageTab12 = 0
                                End If
                            End If
                        Else
                            If i = D_ROW_CNT_TAB12_4 - 1 Then
                                If flagPageTab12 = 41 Then
                                    pageTab12 += 6
                                    Dim sourceRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (589 + add_rows) & ":O" & (592 + add_rows))
                                    Dim destinationRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (599 + i + addRowsTab12 + pageTab12 + rowsHeader) & ":O" & (602 + i + addRowsTab12 + pageTab12 + rowsHeader))
                                    sourceRange.Copy(destinationRange)
                                    D_EXL_SHT1.Row(599 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightHeader
                                    D_EXL_SHT1.Row(601 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightSmall
                                    flagPageTab12 = 0
                                ElseIf flagPageTab12 = 42 Then
                                    pageTab12 += 5
                                    Dim sourceRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (589 + add_rows) & ":O" & (592 + add_rows))
                                    Dim destinationRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (599 + i + addRowsTab12 + pageTab12 + rowsHeader) & ":O" & (602 + i + addRowsTab12 + pageTab12 + rowsHeader))
                                    sourceRange.Copy(destinationRange)
                                    D_EXL_SHT1.Row(599 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightHeader
                                    D_EXL_SHT1.Row(601 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightSmall
                                    flagPageTab12 = 0
                                ElseIf flagPageTab12 = 43 And i <> D_ROW_CNT_TAB12_4 - 1 Then
                                    pageTab12 += 4
                                    Dim sourceRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (589 + add_rows) & ":O" & (592 + add_rows))
                                    Dim destinationRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (599 + i + addRowsTab12 + pageTab12 + rowsHeader) & ":O" & (602 + i + addRowsTab12 + pageTab12 + rowsHeader))
                                    sourceRange.Copy(destinationRange)
                                    D_EXL_SHT1.Row(599 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightHeader
                                    D_EXL_SHT1.Row(601 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightSmall
                                    flagPageTab12 = 0
                                End If
                            Else

                                If flagPageTab12 = 43 Then
                                    pageTab12 += 6
                                    Dim sourceRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (589 + add_rows) & ":O" & (592 + add_rows))
                                    Dim destinationRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (597 + i + addRowsTab12 + pageTab12 + rowsHeader) & ":O" & (600 + i + addRowsTab12 + pageTab12 + rowsHeader))
                                    sourceRange.Copy(destinationRange)
                                    D_EXL_SHT1.Row(597 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightHeader
                                    D_EXL_SHT1.Row(599 + i + addRowsTab12 + pageTab12 + rowsHeader).Height = sampleRowHeightSmall
                                    Dim sourceRange23 As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (602 + addRowsTab12) & ":O" & (603 + addRowsTab12))
                                    Dim destinationRange23 As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (603 + i + addRowsTab12 + pageTab12) & ":O" & (604 + i + addRowsTab12 + pageTab12))
                                    sourceRange23.Copy(destinationRange23)
                                    flagPageTab12 = 0
                                End If
                            End If
                        End If


                    Next
                    addRowsTab12 += D_ROW_CNT_TAB12_4 - 1 + pageTab12
                End If
                'fill data
                '20
                pageTab12 = 0
                flagPageTab12 = 0
                addRowsTab12 = add_rows
                If D_ROW_CNT_TAB12_1 > 0 Then
                    For i = 0 To D_ROW_CNT_TAB12_1 - 1
                        D_EXL_SHT1.Cells(595 + i + addRowsTab12 + pageTab12, 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(23).Rows(i).Item("joining_date"), "")
                        D_EXL_SHT1.Cells(595 + i + addRowsTab12 + pageTab12, 4).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(23).Rows(i).Item("date_of_loss"), "")
                        D_EXL_SHT1.Cells(595 + i + addRowsTab12 + pageTab12, 6).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(23).Rows(i).Item("reason_for_loss_kbn"), "")
                        flagPageTab12 += 1

                        If D_ROW_CNT_TAB12_1 = 41 Then
                            If flagPageTab12 = 41 Then
                                pageTab12 += 6
                                pageTab12_2 += 6
                                flagPageTab12 = 0
                            End If
                        ElseIf D_ROW_CNT_TAB12_1 = 42 Then
                            If flagPageTab12 = 42 Then
                                pageTab12 += 5
                                pageTab12_2 += 5
                                flagPageTab12 = 0
                            End If
                        ElseIf D_ROW_CNT_TAB12_1 = 43 Then
                            If flagPageTab12 = 43 Then
                                pageTab12 += 4
                                pageTab12_2 += 4
                                flagPageTab12 = 0
                            End If
                        Else
                            If flagPageTab12 = 43 Then
                                pageTab12 += 6
                                pageTab12_2 += 6
                                flagPageTab12 = 0

                            End If
                        End If

                    Next
                    addRowsTab12 += D_ROW_CNT_TAB12_1 - 1 + pageTab12
                End If
                '21  
                pageTab12 = 0
                If flagPageTab12 = 0 Then
                    flagPageTab12 = 0
                Else
                    flagPageTab12 += 2
                End If
                If D_ROW_CNT_TAB12_2 > 0 Then
                    For i = 0 To D_ROW_CNT_TAB12_2 - 1


                        D_EXL_SHT1.Cells(598 + i + addRowsTab12 + pageTab12, 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(24).Rows(i).Item("joining_date"), "")
                        D_EXL_SHT1.Cells(598 + i + addRowsTab12 + pageTab12, 4).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(24).Rows(i).Item("date_of_loss"), "")
                        D_EXL_SHT1.Cells(598 + i + addRowsTab12 + pageTab12, 6).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(24).Rows(i).Item("reason_for_loss"), "")
                        flagPageTab12 += 1


                        If D_ROW_CNT_TAB12_2 >= 41 And D_ROW_CNT_TAB12_2 <= 42 Then
                            If i = D_ROW_CNT_TAB12_2 - 1 Then
                                If flagPageTab12 = 41 Then
                                    pageTab12 += 6
                                    pageTab12_2 += 6
                                    flagPageTab12 = 0
                                ElseIf flagPageTab12 = 42 Then
                                    pageTab12 += 5
                                    pageTab12_2 += 5
                                    flagPageTab12 = 0
                                ElseIf flagPageTab12 = 43 Then
                                    pageTab12 += 4
                                    pageTab12_2 += 4
                                    flagPageTab12 = 0
                                End If

                            Else
                                If flagPageTab12 = 43 Then
                                    pageTab12 += 6
                                    flagPageTab12 = 0

                                End If
                            End If
                        Else
                            If i = D_ROW_CNT_TAB12_2 - 1 Then
                                If flagPageTab12 = 41 Then
                                    pageTab12 += 6
                                    pageTab12_2 += 6
                                    flagPageTab12 = 0
                                ElseIf flagPageTab12 = 42 Then
                                    pageTab12 += 5
                                    pageTab12_2 += 5
                                    flagPageTab12 = 0
                                ElseIf flagPageTab12 = 43 Then
                                    pageTab12 += 4
                                    pageTab12_2 += 4
                                    flagPageTab12 = 0
                                End If

                            Else
                                If flagPageTab12 = 43 Then
                                    pageTab12 += 6
                                    pageTab12_2 += 6
                                    flagPageTab12 = 0

                                End If
                            End If
                        End If
                    Next
                    addRowsTab12 += D_ROW_CNT_TAB12_2 - 1 + pageTab12
                End If
                '22
                pageTab12 = 0
                If flagPageTab12 = 0 Then
                    flagPageTab12 = 0
                Else
                    flagPageTab12 += 2
                End If
                If D_ROW_CNT_TAB12_3 > 0 Then
                    For i = 0 To D_ROW_CNT_TAB12_3 - 1


                        D_EXL_SHT1.Cells(601 + i + addRowsTab12 + pageTab12, 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(25).Rows(i).Item("joining_date"), "")
                        D_EXL_SHT1.Cells(601 + i + addRowsTab12 + pageTab12, 4).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(25).Rows(i).Item("date_of_loss"), "")
                        D_EXL_SHT1.Cells(601 + i + addRowsTab12 + pageTab12, 6).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(25).Rows(i).Item("reason_for_loss"), "")
                        flagPageTab12 += 1

                        If D_ROW_CNT_TAB12_3 >= 41 And D_ROW_CNT_TAB12_3 <= 42 Then
                            If i = D_ROW_CNT_TAB12_3 - 1 Then
                                If flagPageTab12 = 41 Then
                                    pageTab12 += 6
                                    pageTab12_2 += 6
                                    flagPageTab12 = 0
                                ElseIf flagPageTab12 = 42 Then
                                    pageTab12 += 5
                                    pageTab12_2 += 5
                                    flagPageTab12 = 0
                                ElseIf flagPageTab12 = 43 Then
                                    pageTab12 += 4
                                    pageTab12_2 += 4
                                    flagPageTab12 = 0
                                End If

                            Else
                                If flagPageTab12 = 43 Then
                                    pageTab12 += 6
                                    pageTab12_2 += 6
                                    flagPageTab12 = 0

                                End If
                            End If
                        Else
                            If i = D_ROW_CNT_TAB12_3 - 1 Then
                                If flagPageTab12 = 41 Then
                                    pageTab12 += 6
                                    pageTab12_2 += 6
                                    flagPageTab12 = 0
                                ElseIf flagPageTab12 = 42 Then
                                    pageTab12 += 5
                                    pageTab12_2 += 5
                                    flagPageTab12 = 0
                                ElseIf flagPageTab12 = 43 Then
                                    pageTab12 += 4
                                    pageTab12_2 += 4
                                    flagPageTab12 = 0
                                End If

                            Else
                                If flagPageTab12 = 43 Then
                                    pageTab12 += 6
                                    pageTab12_2 += 6
                                    flagPageTab12 = 0

                                End If
                            End If
                        End If
                    Next
                    addRowsTab12 += D_ROW_CNT_TAB12_3 - 1 + pageTab12
                End If
                '23

                pageTab12 = 0
                If flagPageTab12 = 0 Then
                    flagPageTab12 = 0
                Else
                    flagPageTab12 += 2
                End If
                If D_ROW_CNT_TAB12_4 > 0 Then

                    For i = 0 To D_ROW_CNT_TAB12_4 - 1


                        D_EXL_SHT1.Cells(604 + i + addRowsTab12 + pageTab12, 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(26).Rows(i).Item("joining_date"), "")
                        D_EXL_SHT1.Cells(604 + i + addRowsTab12 + pageTab12, 4).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(26).Rows(i).Item("date_of_loss"), "")
                        D_EXL_SHT1.Cells(604 + i + addRowsTab12 + pageTab12, 6).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(26).Rows(i).Item("reason_for_loss"), "")
                        flagPageTab12 += 1

                        If D_ROW_CNT_TAB12_4 >= 41 And D_ROW_CNT_TAB12_4 <= 42 Then
                            If i = D_ROW_CNT_TAB12_4 - 1 Then
                                If flagPageTab12 = 41 Then
                                    pageTab12 += 6
                                    pageTab12_2 += 6
                                    flagPageTab12 = 0
                                ElseIf flagPageTab12 = 42 Then
                                    pageTab12 += 5
                                    pageTab12_2 += 5
                                    flagPageTab12 = 0
                                ElseIf flagPageTab12 = 43 Then
                                    pageTab12 += 4
                                    pageTab12_2 += 4
                                    flagPageTab12 = 0
                                End If

                            Else
                                If flagPageTab12 = 43 Then
                                    pageTab12 += 6
                                    pageTab12_2 += 6
                                    flagPageTab12 = 0

                                End If
                            End If
                        Else
                            If i = D_ROW_CNT_TAB12_4 - 1 Then
                                If flagPageTab12 = 41 Then
                                    pageTab12 += 6
                                    pageTab12_2 += 6
                                    flagPageTab12 = 0
                                ElseIf flagPageTab12 = 42 Then
                                    pageTab12 += 5
                                    pageTab12_2 += 5
                                    flagPageTab12 = 0
                                ElseIf flagPageTab12 = 43 And i <> D_ROW_CNT_TAB12_4 - 1 Then
                                    pageTab12 += 4
                                    pageTab12_2 += 4
                                    flagPageTab12 = 0
                                End If

                            Else
                                If flagPageTab12 = 43 Then
                                    pageTab12 += 6
                                    pageTab12_2 += 6
                                    flagPageTab12 = 0

                                End If
                            End If
                        End If
                    Next
                    addRowsTab12 += D_ROW_CNT_TAB12_4 - 1 + pageTab12


                End If
                delStart33Rows = 605 + addRowsTab12
                add_rows = addRowsTab12
                If D_ROW_CNT_TAB12 > 0 And (D_ROW_CNT_TAB12_1 = 0 Or D_ROW_CNT_TAB12_2 = 0 Or D_ROW_CNT_TAB12_3 = 0 Or D_ROW_CNT_TAB12_4 = 0) Then
                    If rowsDelHeader < 0 Then
                        rowsDelHeader = 0
                    End If
                    If D_ROW_CNT_TAB12_1 = 0 Then
                        D_EXL_SHT1.InsertRow(606 + add_rows, 2)
                        For h = 0 To 1
                            D_EXL_SHT1.Row(606 + add_rows + h).Height = sampleRowHeight
                        Next
                        add_rows += 2
                        rowsDelHeader += 2
                    End If
                    If D_ROW_CNT_TAB12_2 = 0 Then
                        D_EXL_SHT1.InsertRow(606 + add_rows, 2)
                        For h = 0 To 1
                            D_EXL_SHT1.Row(606 + add_rows + h).Height = sampleRowHeight
                        Next
                        add_rows += 2
                        rowsDelHeader += 2
                    End If
                    If D_ROW_CNT_TAB12_3 = 0 Then
                        D_EXL_SHT1.InsertRow(606 + add_rows, 2)
                        For h = 0 To 1
                            D_EXL_SHT1.Row(606 + add_rows + h).Height = sampleRowHeight
                        Next
                        add_rows += 2
                        rowsDelHeader += 2
                    End If
                    If D_ROW_CNT_TAB12_4 = 0 Then
                        D_EXL_SHT1.InsertRow(606 + add_rows, 2)
                        For h = 0 To 1
                            D_EXL_SHT1.Row(606 + add_rows + h).Height = sampleRowHeight
                        Next
                        add_rows += 2
                        rowsDelHeader += 2
                    End If
                    delStart33Rows += rowsDelHeader
                End If
                countPageTab12 = Math.Ceiling((delStart33Rows - rowHeader) / 49.0)

                If D_ROW_CNT_TAB12_1 <> 0 Or D_ROW_CNT_TAB12_2 <> 0 Or D_ROW_CNT_TAB12_3 <> 0 Or D_ROW_CNT_TAB12_4 <> 0 Then

                    If pageTab12_2 = 0 Then


                        D_EXL_SHT1.InsertRow(delStart33Rows, 49 - rowsDelHeader)

                        D_EXL_SHT1.Cells("B" & (delStart33Rows - 1) & ":N" & (delStart33Rows - 1)).Style.Border.Bottom.Style = ExcelBorderStyle.Medium
                        If D_ROW_CNT_TAB12_1 = 0 Or D_ROW_CNT_TAB12_2 = 0 Or D_ROW_CNT_TAB12_3 = 0 Or D_ROW_CNT_TAB12_4 = 0 Then
                            ' This removes the bottom border from the specified range of cells
                            D_EXL_SHT1.Cells("B" & (delStart33Rows - 1) & ":N" & (delStart33Rows - 1)).Style.Border.Bottom.Style = ExcelBorderStyle.None

                        End If
                        For h = 0 To (49 - rowsDelHeader) - 1
                            D_EXL_SHT1.Row(delStart33Rows + h).Height = sampleRowHeight
                        Next
                        del33Rows = delStart33Rows + (49 - rowsDelHeader)
                        add_rows += 49 - rowsDelHeader
                    Else
                        D_EXL_SHT1.InsertRow(delStart33Rows, (rowHeader + 49 * countPageTab12) - delStart33Rows)
                        D_EXL_SHT1.Cells("B" & (delStart33Rows - 1) & ":N" & (delStart33Rows - 1)).Style.Border.Bottom.Style = ExcelBorderStyle.Medium
                        For h = 0 To ((rowHeader + 49 * countPageTab12) - delStart33Rows) - 1
                            D_EXL_SHT1.Row(delStart33Rows + h).Height = sampleRowHeight
                        Next
                        del33Rows = delStart33Rows + (rowHeader + 49 * countPageTab12) - delStart33Rows
                        add_rows += (rowHeader + 49 * countPageTab12) - delStart33Rows
                    End If
                End If

                'delete tab 12
                Dim delTab12 As Integer = 0
                If D_ROW_CNT_TAB12 = 0 And D_ROW_CNT_TAB12_1 = 0 And D_ROW_CNT_TAB12_2 = 0 And D_ROW_CNT_TAB12_3 = 0 And D_ROW_CNT_TAB12_4 = 0 Then
                    delTab12 = 589 + add_rows
                End If

                'fill 給与
                Dim delTab13 As Integer = 0
                Dim D_ROW_CNT_TAB13 = D_DAT.Tables(27).Rows.Count
                If D_ROW_CNT_TAB13 > 0 Then
                    D_EXL_SHT1.Cells(639 + add_rows, 2).Value = sourceValue
                    D_EXL_SHT1.Cells(641 + add_rows, 4).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(27).Rows(0).Item("base_salary"), "")
                    D_EXL_SHT1.Cells(641 + add_rows, 10).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(27).Rows(0).Item("basic_annual_income"), "")
                Else
                    delTab13 = 638 + add_rows
                End If

                'fill 賞罰
                Dim delTab14 As Integer = 0
                Dim D_ROW_CNT_TAB14 = D_DAT.Tables(28).Rows.Count
                If D_ROW_CNT_TAB14 > 0 Then
                    Dim countPage As Integer = Math.Ceiling(D_ROW_CNT_TAB14 / 45.0)
                    D_EXL_SHT1.InsertRow(736 + add_rows, 49 * (countPage - 1))
                    For h As Integer = 0 To 49 * (countPage - 1) - 1
                        D_EXL_SHT1.Row(736 + add_rows + h).Height = sampleRowHeight
                    Next
                    D_EXL_SHT1.Cells(688 + add_rows, 2).Value = sourceValue
                    If countPage <> 0 Then
                        For i = 0 To countPage - 1
                            If i <> 0 Then
                                Dim sourceRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (687 + add_rows) & ":O" & (690 + add_rows))
                                Dim destinationRange As ExcelRangeBase = D_EXL_SHT1.Cells("A" & (687 + i * 49 + add_rows) & ":O" & (690 + i * 49 + add_rows))
                                sourceRange.Copy(destinationRange)
                                D_EXL_SHT1.Row(687 + i * 49 + add_rows).Height = sampleRowHeightHeader
                                D_EXL_SHT1.Row(689 + i * 49 + add_rows).Height = sampleRowHeightSmall
                            End If
                        Next
                    End If

                    Dim page As Integer = 0
                    For j = 0 To D_ROW_CNT_TAB14 - 1
                        If countPage <> 0 Then
                            If j Mod 45 = 0 And j <> 0 Then
                                page += 4
                            End If
                        End If
                        D_EXL_SHT1.Cells("B" & (691 + add_rows) & ":N" & (691 + add_rows)).Copy(D_EXL_SHT1.Cells("B" & (691 + j + add_rows + page) & ":N" & (691 + j + add_rows + page)))
                        D_EXL_SHT1.Cells(691 + j + add_rows + page, 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(28).Rows(j).Item("id"), "")
                        D_EXL_SHT1.Cells(691 + j + add_rows + page, 3).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(28).Rows(j).Item("reward_punishment_typ"), "")
                        D_EXL_SHT1.Cells(691 + j + add_rows + page, 5).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(28).Rows(j).Item("decision_date"), "")
                        D_EXL_SHT1.Cells(691 + j + add_rows + page, 7).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(28).Rows(j).Item("reason"), "")
                        D_EXL_SHT1.Cells(691 + j + add_rows + page, 11).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(28).Rows(j).Item("remarks"), "")
                    Next
                    add_rows += 49 * (countPage - 1)
                Else
                    delTab14 = 687 + add_rows
                End If

                'fill 任意情報
                Dim delTab15 As Integer = 0
                Dim D_ROW_CNT_TAB15 = D_DAT.Tables(29).Rows.Count
                Dim valueType As String
                Dim countPageTab15 As Integer = Math.Ceiling(D_ROW_CNT_TAB15 / 46.0)
                If D_ROW_CNT_TAB15 > 0 Then
                    D_EXL_SHT1.InsertRow(784 + add_rows, 49 * (countPageTab15 - 1))
                    For h As Integer = 0 To 49 * (countPageTab15 - 1) - 1
                        D_EXL_SHT1.Row(784 + add_rows + h).Height = sampleRowHeight
                    Next
                    D_EXL_SHT1.Cells(737 + add_rows, 2).Value = sourceValue
                    'copy header

                    Dim page As Integer = 0
                    For i = 0 To D_ROW_CNT_TAB15 - 1
                        If countPageTab15 <> 0 Then
                            If i Mod 46 = 0 And i <> 0 Then
                                page += 3
                            End If

                        End If

                        D_EXL_SHT1.Cells("B" & (739 + add_rows) & ":N" & (739 + add_rows)).Copy(D_EXL_SHT1.Cells("B" & (739 + i + add_rows + page) & ":N" & (739 + i + add_rows + page)))
                        'fill data                      

                        D_EXL_SHT1.Cells(739 + i + add_rows + page, 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(29).Rows(i).Item("item_nm"), "")
                        D_EXL_SHT1.Cells(739 + i + add_rows + page, 5).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(29).Rows(i).Item("value_name"), "")
                        valueType = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(29).Rows(i).Item("value_type"), "")
                        Select Case valueType
                            Case "text"
                                D_EXL_SHT1.Cells(739 + i + add_rows + page, 5).Style.HorizontalAlignment = ExcelHorizontalAlignment.Left
                            Case "number"
                                D_EXL_SHT1.Cells(739 + i + add_rows + page, 5).Style.HorizontalAlignment = ExcelHorizontalAlignment.Right
                            Case "date"
                                D_EXL_SHT1.Cells(739 + i + add_rows + page, 5).Style.HorizontalAlignment = ExcelHorizontalAlignment.Center
                            Case Else
                                D_EXL_SHT1.Cells(739 + i + add_rows + page, 5).Style.HorizontalAlignment = ExcelHorizontalAlignment.General
                        End Select
                    Next
                    If countPageTab15 <> 0 Then
                        For j As Integer = 0 To countPageTab15 - 1
                            If j <> 0 Then
                                D_EXL_SHT1.Cells("A" & (737 + add_rows) & ":O" & (737 + add_rows)).Copy(D_EXL_SHT1.Cells("A" & (737 + 49 * j + add_rows) & ":O" & (737 + 49 * j + add_rows)))
                                D_EXL_SHT1.Cells("B" & (736 + add_rows) & ":N" & (736 + add_rows)).Copy(D_EXL_SHT1.Cells("B" & (736 + 49 * j + add_rows) & ":N" & (736 + 49 * j + add_rows)))
                                'D_EXL_SHT1.Cells(736 + 49 * j + add_rows, 2).Value = D_EXL_SHT1.Cells(736 + add_rows, 2)
                                Dim mergeRange As ExcelRange = D_EXL_SHT1.Cells("B" & (736 + j * 49 + add_rows) & ":N" & (736 + j * 49 + add_rows))
                                mergeRange.Merge = True
                                D_EXL_SHT1.Row(736 + 49 * j + add_rows).Height = sampleRowHeightHeader
                                D_EXL_SHT1.Row(738 + 49 * j + add_rows).Height = sampleRowHeightSmall
                            End If
                        Next
                    End If
                Else
                    delTab15 = 736 + add_rows
                End If

                'Range delete
                If D_ROW_CNT_TAB1 = 0 Then
                    D_EXL_SHT1.DeleteRow(delTab1, 49)
                    del_rows -= 49
                End If
                If D_ROW_CNT_TAB2 = 0 Then
                    For i As Integer = 0 To 48
                        D_EXL_SHT1.DeleteRow(delTab2 + del_rows)
                    Next
                    del_rows -= 49
                End If
                If D_ROW_CNT_TAB3_2 = 0 Then
                    For i As Integer = 0 To 48
                        D_EXL_SHT1.DeleteRow(delTab3 + del_rows)
                    Next
                    del_rows -= 49
                End If
                If D_ROW_CNT_TAB4 = 0 Then
                    For i As Integer = 0 To 48
                        D_EXL_SHT1.DeleteRow(delTab4 + del_rows)
                    Next
                    del_rows -= 49
                End If
                If D_ROW_CNT_TAB5_2 > 0 And D_ROW_CNT_TAB5_1 > 0 Then
                    If CInt(D_DAT.Tables(12).Rows(0).Item("detail_no")) > 0 AndAlso CInt(D_DAT.Tables(13).Rows(0).Item("detail_no")) > 0 Then
                        If del_rows <> 0 Then
                            D_EXL_SHT1.DeleteRow(del40Rows + del_rows, 40 + delRows0)
                            del_rows -= 40 + delRows0
                        Else
                            D_EXL_SHT1.DeleteRow(del40Rows + del_rows, 40)
                            del_rows -= 40
                        End If
                    End If

                    If CInt(D_DAT.Tables(13).Rows(0).Item("detail_no")) > 0 And CInt(D_DAT.Tables(12).Rows(0).Item("detail_no")) = 0 Then
                        D_EXL_SHT1.DeleteRow(del9 + del_rows, 3)
                        del_rows -= 3
                        D_EXL_SHT1.DeleteRow(del40Rows + del_rows, 40)
                        del_rows -= 40
                    End If

                    If CInt(D_DAT.Tables(12).Rows(0).Item("detail_no")) > 0 And CInt(D_DAT.Tables(13).Rows(0).Item("detail_no")) = 0 Then
                        D_EXL_SHT1.DeleteRow(del10 + del_rows, 3)
                        del_rows -= 3
                        D_EXL_SHT1.DeleteRow(del40Rows + del_rows, 40)
                        del_rows -= 40
                    End If

                    If CInt(D_DAT.Tables(12).Rows(0).Item("detail_no")) = 0 And CInt(D_DAT.Tables(13).Rows(0).Item("detail_no")) = 0 Then
                        For i As Integer = 0 To 48
                            D_EXL_SHT1.DeleteRow(del910 + del_rows)
                        Next
                        del_rows -= 49
                    End If
                End If
                If D_ROW_CNT_TAB5_1 = 0 And D_ROW_CNT_TAB5_2 > 0 Then
                    If CInt(D_DAT.Tables(13).Rows(0).Item("detail_no")) > 0 Then
                        For i As Integer = 0 To 2
                            D_EXL_SHT1.DeleteRow(del9 + del_rows)
                        Next
                        del_rows -= 3
                        For i As Integer = 0 To 39
                            D_EXL_SHT1.DeleteRow(del40Rows + del_rows)
                        Next
                        del_rows -= 40
                    End If
                End If
                If D_ROW_CNT_TAB5_2 = 0 And D_ROW_CNT_TAB5_1 > 0 Then
                    If CInt(D_DAT.Tables(12).Rows(0).Item("detail_no")) > 0 Then
                        D_EXL_SHT1.DeleteRow(del10 + del_rows, 3)
                        del_rows -= 3
                        D_EXL_SHT1.DeleteRow(del40Rows + del_rows, 40)
                        del_rows -= 40
                    End If
                End If
                If D_ROW_CNT_TAB5_2 = 0 And D_ROW_CNT_TAB5_1 = 0 Then
                    For i As Integer = 0 To 48
                        D_EXL_SHT1.DeleteRow(del910 + del_rows)
                    Next
                    del_rows -= 49
                End If
                If D_DAT.Tables(14).Rows.Count = 0 Then
                    For i As Integer = 0 To 48
                        D_EXL_SHT1.DeleteRow(delTab6 + del_rows, 49)
                    Next
                    del_rows -= 49
                End If
                If D_ROW_CNT_TAB7 = 0 Then
                    For i As Integer = 0 To 48
                        D_EXL_SHT1.DeleteRow(delTab7 + del_rows)
                    Next
                    del_rows -= 49
                End If
                If D_ROW_CNT_TAB8 = 0 Then
                    For i As Integer = 0 To 48
                        D_EXL_SHT1.DeleteRow(delTab8 + del_rows)
                    Next
                    del_rows -= 49
                End If
                If D_ROW_CNT_TAB9 = 0 Then
                    For i As Integer = 0 To 48
                        D_EXL_SHT1.DeleteRow(delTab9 + del_rows)
                    Next
                    del_rows -= 49
                End If
                If D_ROW_CNT_TAB10 = 0 Then
                    For i As Integer = 0 To 48
                        D_EXL_SHT1.DeleteRow(delTab10 + del_rows)
                    Next
                    del_rows -= 49
                End If
                If D_ROW_CNT_TAB11 = 0 Then
                    For i As Integer = 0 To 48
                        D_EXL_SHT1.DeleteRow(delTab11 + del_rows)
                    Next
                    del_rows -= 49
                Else
                    D_EXL_SHT1.DeleteRow(del44Rows + del_rows, 44)
                    del_rows -= 44
                End If
                If D_ROW_CNT_TAB12 <> 0 Then
                    If D_ROW_CNT_TAB12_1 = 0 Then
                        D_EXL_SHT1.DeleteRow(delTab12_1 + del_rows, 2)
                        del_rows -= 2
                    End If
                    If D_ROW_CNT_TAB12_2 = 0 Then
                        D_EXL_SHT1.DeleteRow(delTab12_2 + del_rows, 2)
                        del_rows -= 2
                    End If
                    If D_ROW_CNT_TAB12_3 = 0 Then
                        D_EXL_SHT1.DeleteRow(delTab12_3 + del_rows, 2)
                        del_rows -= 2
                    End If
                    If D_ROW_CNT_TAB12_4 = 0 Then
                        D_EXL_SHT1.DeleteRow(delTab12_4 + del_rows, 2)
                        del_rows -= 2
                    End If
                    If D_ROW_CNT_TAB12_1 <> 0 Or D_ROW_CNT_TAB12_2 <> 0 Or D_ROW_CNT_TAB12_3 <> 0 Or D_ROW_CNT_TAB12_4 <> 0 Then
                        D_EXL_SHT1.DeleteRow(del33Rows + del_rows, 33)
                        del_rows -= 33
                    End If
                End If
                If D_ROW_CNT_TAB12 = 0 And D_ROW_CNT_TAB12_1 = 0 And D_ROW_CNT_TAB12_2 = 0 And D_ROW_CNT_TAB12_3 = 0 And D_ROW_CNT_TAB12_4 = 0 Then
                    For i As Integer = 0 To 48
                        D_EXL_SHT1.DeleteRow(delTab12 + del_rows)
                    Next
                    del_rows -= 49
                End If
                If D_ROW_CNT_TAB13 = 0 Then
                    For i As Integer = 0 To 48
                        D_EXL_SHT1.DeleteRow(delTab13 + del_rows)
                    Next
                    del_rows -= 49
                End If
                If D_ROW_CNT_TAB14 = 0 Then
                    For i As Integer = 0 To 48                        D_EXL_SHT1.DeleteRow(delTab14 + del_rows)                    Next
                    del_rows -= 49
                End If
                If D_ROW_CNT_TAB15 = 0 Then
                    For i As Integer = 0 To 48
                        D_EXL_SHT1.DeleteRow(delTab15 + del_rows)
                    Next
                    del_rows -= 49
                End If

                'release memory
                add_rows = Nothing
                del_rows = Nothing
                sampleRow = Nothing
                sampleRowHeight = Nothing
                sampleRowHeader = Nothing
                sampleRowSmall = Nothing
                sampleRowHeightHeader = Nothing
                sampleRowHeightSmall = Nothing
                D_ROW_CNT_TAB1 = Nothing
                D_ROW_CNT_TAB2 = Nothing
                D_ROW_CNT_TAB3_2 = Nothing
                D_ROW_CNT_TAB4 = Nothing
                D_ROW_CNT_TAB5_1 = Nothing
                D_ROW_CNT_TAB5_2 = Nothing
                D_ROW_CNT_TAB6 = Nothing
                D_ROW_CNT_TAB7 = Nothing
                'D_ROW_CNT_TAB8 = Nothing
                'D_ROW_CNT_TAB9 = Nothing
                'D_ROW_CNT_TAB10 = Nothing
                'D_ROW_CNT_TAB11 = Nothing
                'D_ROW_CNT_TAB12 = Nothing
                'D_ROW_CNT_TAB13 = Nothing
                'D_ROW_CNT_TAB14 = Nothing
                'D_ROW_CNT_TAB15 = Nothing
                'count = Nothing
                'count2 = Nothing
                'countChange = Nothing
                'countChange2 = Nothing
                'countLine = Nothing
                'countLine2 = Nothing
                'lineDetail = Nothing
                'lineDetailMax = Nothing
                'quantityDetail = Nothing
                'addRows = Nothing
                'addLine = Nothing
                'lineP1 = Nothing
                'lineP2 = Nothing
                'delTab1 = Nothing
                'delTab2 = Nothing
                'delTab3 = Nothing
                'delTab4 = Nothing
                'delTab6 = Nothing
                'delTab7 = Nothing
                ''delTab8 = Nothing
                'delTab9 = Nothing
                'delTab10 = Nothing
                'delTab11 = Nothing
                'delTab12 = Nothing
                'delTab13 = Nothing
                'delTab14 = Nothing
                'delTab15 = Nothing
                'del9P1 = Nothing
                'del10 = Nothing
                'del910 = Nothing
                'del40Rows = Nothing
                'delTab12 = Nothing
                'rowsStart40P2 = Nothing
                'rowsStart40P1 = Nothing


ACTIVE:
                'Save file
                D_EXL_BOK.Save()
            End Using
        Catch ex As Exception
            Utl_ERR.WriteLogReport(ex.ToString(), "eQ0101")
            message = "FNC_EXL_eQ0101: " & ex.ToString()
            status = "250"
        Finally
            D_DAT.Clear()
            '
        End Try
EXIT_FUNCTION:
        FNC_EXL_eQ0101 = "{" + """" + "status" + """" + ":" + status + "," + """" + "filename" + """" + ":" + """" + fileName + """," + """" + "message" + """" + ":" + """" + message + """}"
        Exit Function

    End Function

End Class