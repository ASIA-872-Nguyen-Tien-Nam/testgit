Imports System.IO
Imports System.Globalization
Imports System.Drawing
Imports Newtonsoft.Json
Imports OfficeOpenXml.Drawing
'*********************************************************************************************************
'*
'*  処理概要：Function create Excel
'*  目標一覧表
'*  作成日：	    2020/10/12
'*  作成者：　　 namnb
'*
'*********************************************************************************************************
Imports OfficeOpenXml
Imports Newtonsoft.Json.Linq

Public Class Frm_Oq2033_21
    Public Function FNC_EXL_Oq2033_21(
       ByVal sql As String,
       ByVal screen As String,
       ByVal fileName As String,
       ByVal pathFile As String,
       ByVal P5 As String
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
        Dim D_file_nm As String = ""
        Dim D_total_no_0 As Integer = 0
        Dim D_total_no_1 As Integer = 0
        Dim D_total_no_2 As Integer = 0
        Dim D_total_no_3 As Integer = 0
        Dim D_total_no_4 As Integer = 0
        Dim D_total_no_5 As Integer = 0
        Dim D_total_no_6 As Integer = 0
        Dim D_total_no_7 As Integer = 0
        Dim D_total_no_8 As Integer = 0
        Dim D_total_no_9 As Integer = 0
        Dim D_total_percent_0 As Double = 0
        Dim D_total_percent_1 As Double = 0
        Dim D_total_percent_2 As Double = 0
        Dim D_total_percent_3 As Double = 0
        Dim D_total_percent_4 As Double = 0
        Dim D_total_percent_5 As Double = 0
        Dim D_total_percent_6 As Double = 0
        Dim D_total_percent_7 As Double = 0
        Dim D_total_percent_8 As Double = 0
        Dim D_total_percent_9 As Double = 0
        Dim D_total_number As Integer = 0
        Dim D_Person As String = "人"
        Try
            Dim D_data_detail As Newtonsoft.Json.Linq.JArray
            D_data_detail = JsonConvert.DeserializeObject(P5)
            '
            If Mid(sql, 8, 2) = "en" Then
                D_Person = " Person(s)"
                '
                D_EXL_TML = ConfigurationManager.AppSettings("FIL_TEM_EXL") & "\Oq2033_21_en.xlsx"
            Else
                D_EXL_TML = ConfigurationManager.AppSettings("FIL_TEM_EXL") & "\Oq2033_21.xlsx"
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
                'fill organization header
                D_EXL_SHT1.Cells(4, 1).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(10)("organization_hd_1").ToString(), "")
                D_EXL_SHT1.Cells(5, 1).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(10)("organization_hd_2").ToString(), "")
                D_EXL_SHT1.Cells(6, 1).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(10)("organization_hd_3").ToString(), "")
                D_EXL_SHT1.Cells(7, 1).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(10)("organization_hd_4").ToString(), "")
                D_EXL_SHT1.Cells(8, 1).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(10)("organization_hd_5").ToString(), "")
                'fill search conditions
                D_EXL_SHT1.Cells(1, 2).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(10)("fiscal_year_nm").ToString(), "")
                D_EXL_SHT1.Cells(2, 2).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(10)("combination_vertical").ToString(), "")
                D_EXL_SHT1.Cells(3, 2).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(10)("combination_horizontal").ToString(), "")
                D_EXL_SHT1.Cells(4, 2).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(10)("organization_nm_1").ToString(), "")
                D_EXL_SHT1.Cells(5, 2).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(10)("organization_nm_2").ToString(), "")
                D_EXL_SHT1.Cells(6, 2).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(10)("organization_nm_3").ToString(), "")
                D_EXL_SHT1.Cells(7, 2).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(10)("organization_nm_4").ToString(), "")
                D_EXL_SHT1.Cells(8, 2).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(10)("organization_nm_5").ToString(), "")
                D_EXL_SHT1.Cells(9, 2).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(10)("group_cd_1on1_nm").ToString(), "")
                D_EXL_SHT1.Cells(10, 2).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(10)("position_nm").ToString(), "")
                D_EXL_SHT1.Cells(11, 2).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(10)("grade_nm").ToString(), "")
                D_EXL_SHT1.Cells(12, 2).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(10)("job_nm").ToString(), "")
                D_EXL_SHT1.Cells(13, 2).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(10)("coach_nm").ToString(), "")
                Dim D_cl As Integer = 0
                'picture
                For j = 5 To D_data_detail.Count - 2
                    D_file_nm = Utl_Com.FNC_CNV_NUL(D_data_detail(j)("remark1").ToString(), "")
                    Dim img = Image.FromFile(ConfigurationManager.AppSettings("FIL_TEM_IMG") & "\" & D_file_nm)
                    Dim pic = D_EXL_SHT1.Drawings.AddPicture("Untitled-1" + D_cl.ToString(), img)
                    pic.SetPosition(15 + D_cl, 10, 1, 25)
                    pic.AdjustPositionAndSize()
                    pic.SetSize(30, 30)
                    '
                    D_cl = D_cl + 2
                Next
                ' fill data
                For i = 0 To 4
                    '
                    If i <> 0 Then
                        D_EXL_BOK.Workbook.Worksheets(2).Cells("A3:M4").Copy(D_EXL_SHT1.Cells("A" & (16 + (i * 2)) & ":M" & (17 + (i * 2))))
                    End If
                    D_EXL_SHT1.Cells(16 + (i * 2), 3).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("90").ToString(), "") & D_Person
                    D_EXL_SHT1.Cells(16 + (i * 2), 4).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("80").ToString(), "") & D_Person
                    D_EXL_SHT1.Cells(16 + (i * 2), 5).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("70").ToString(), "") & D_Person
                    D_EXL_SHT1.Cells(16 + (i * 2), 6).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("60").ToString(), "") & D_Person
                    D_EXL_SHT1.Cells(16 + (i * 2), 7).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("50").ToString(), "") & D_Person
                    D_EXL_SHT1.Cells(16 + (i * 2), 8).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("40").ToString(), "") & D_Person
                    D_EXL_SHT1.Cells(16 + (i * 2), 9).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("30").ToString(), "") & D_Person
                    D_EXL_SHT1.Cells(16 + (i * 2), 10).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("20").ToString(), "") & D_Person
                    D_EXL_SHT1.Cells(16 + (i * 2), 11).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("10").ToString(), "") & D_Person
                    D_EXL_SHT1.Cells(16 + (i * 2), 12).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("0").ToString(), "") & D_Person
                    D_EXL_SHT1.Cells(16 + (i * 2), 13).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("sub_total").ToString(), "") & D_Person
                    '
                    D_EXL_SHT1.Cells(17 + (i * 2), 3).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("90_percent").ToString(), "") & "%"
                    D_EXL_SHT1.Cells(17 + (i * 2), 4).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("80_percent").ToString(), "") & "%"
                    D_EXL_SHT1.Cells(17 + (i * 2), 5).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("70_percent").ToString(), "") & "%"
                    D_EXL_SHT1.Cells(17 + (i * 2), 6).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("60_percent").ToString(), "") & "%"
                    D_EXL_SHT1.Cells(17 + (i * 2), 7).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("50_percent").ToString(), "") & "%"
                    D_EXL_SHT1.Cells(17 + (i * 2), 8).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("40_percent").ToString(), "") & "%"
                    D_EXL_SHT1.Cells(17 + (i * 2), 9).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("30_percent").ToString(), "") & "%"
                    D_EXL_SHT1.Cells(17 + (i * 2), 10).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("20_percent").ToString(), "") & "%"
                    D_EXL_SHT1.Cells(17 + (i * 2), 11).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("10_percent").ToString(), "") & "%"
                    D_EXL_SHT1.Cells(17 + (i * 2), 12).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("0_percent").ToString(), "") & "%"
                    'total
                    D_total_no_0 = D_total_no_0 + Utl_Com.FNC_CNV_NUL(D_data_detail(i)("0").ToString(), 0)
                    D_total_no_1 = D_total_no_1 + Utl_Com.FNC_CNV_NUL(D_data_detail(i)("10").ToString(), 0)
                    D_total_no_2 = D_total_no_2 + Utl_Com.FNC_CNV_NUL(D_data_detail(i)("20").ToString(), 0)
                    D_total_no_3 = D_total_no_3 + Utl_Com.FNC_CNV_NUL(D_data_detail(i)("30").ToString(), 0)
                    D_total_no_4 = D_total_no_4 + Utl_Com.FNC_CNV_NUL(D_data_detail(i)("40").ToString(), 0)
                    D_total_no_5 = D_total_no_5 + Utl_Com.FNC_CNV_NUL(D_data_detail(i)("50").ToString(), 0)
                    D_total_no_6 = D_total_no_6 + Utl_Com.FNC_CNV_NUL(D_data_detail(i)("60").ToString(), 0)
                    D_total_no_7 = D_total_no_7 + Utl_Com.FNC_CNV_NUL(D_data_detail(i)("70").ToString(), 0)
                    D_total_no_8 = D_total_no_8 + Utl_Com.FNC_CNV_NUL(D_data_detail(i)("80").ToString(), 0)
                    D_total_no_9 = D_total_no_9 + Utl_Com.FNC_CNV_NUL(D_data_detail(i)("90").ToString(), 0)
                    D_total_number = D_total_number + D_data_detail(i)("sub_total").ToString()
                    D_total_percent_0 = D_total_percent_0 + Utl_Com.FNC_CNV_NUL(D_data_detail(i)("0_percent").ToString(), 0)
                    D_total_percent_1 = D_total_percent_1 + Utl_Com.FNC_CNV_NUL(D_data_detail(i)("10_percent").ToString(), 0)
                    D_total_percent_2 = D_total_percent_2 + Utl_Com.FNC_CNV_NUL(D_data_detail(i)("20_percent").ToString(), 0)
                    D_total_percent_3 = D_total_percent_3 + Utl_Com.FNC_CNV_NUL(D_data_detail(i)("30_percent").ToString(), 0)
                    D_total_percent_4 = D_total_percent_4 + Utl_Com.FNC_CNV_NUL(D_data_detail(i)("40_percent").ToString(), 0)
                    D_total_percent_5 = D_total_percent_5 + Utl_Com.FNC_CNV_NUL(D_data_detail(i)("50_percent").ToString(), 0)
                    D_total_percent_6 = D_total_percent_6 + Utl_Com.FNC_CNV_NUL(D_data_detail(i)("60_percent").ToString(), 0)
                    D_total_percent_7 = D_total_percent_7 + Utl_Com.FNC_CNV_NUL(D_data_detail(i)("70_percent").ToString(), 0)
                    D_total_percent_8 = D_total_percent_8 + Utl_Com.FNC_CNV_NUL(D_data_detail(i)("80_percent").ToString(), 0)
                    D_total_percent_9 = D_total_percent_9 + Utl_Com.FNC_CNV_NUL(D_data_detail(i)("90_percent").ToString(), 0)
                    '
                Next
                Dim k As Integer = 5
                'total
                D_EXL_BOK.Workbook.Worksheets(2).Cells("A5:M6").Copy(D_EXL_SHT1.Cells("A" & (16 + (k * 2)) & ":M" & (17 + (k * 2))))
                '
                'fill data total
                D_EXL_SHT1.Cells(26, 3).Value = D_total_no_9 & D_Person
                D_EXL_SHT1.Cells(26, 4).Value = D_total_no_8 & D_Person
                D_EXL_SHT1.Cells(26, 5).Value = D_total_no_7 & D_Person
                D_EXL_SHT1.Cells(26, 6).Value = D_total_no_6 & D_Person
                D_EXL_SHT1.Cells(26, 7).Value = D_total_no_5 & D_Person
                D_EXL_SHT1.Cells(26, 8).Value = D_total_no_4 & D_Person
                D_EXL_SHT1.Cells(26, 9).Value = D_total_no_3 & D_Person
                D_EXL_SHT1.Cells(26, 10).Value = D_total_no_2 & D_Person
                D_EXL_SHT1.Cells(26, 11).Value = D_total_no_1 & D_Person
                D_EXL_SHT1.Cells(26, 12).Value = D_total_no_0 & D_Person
                D_EXL_SHT1.Cells(26, 13).Value = D_total_number & D_Person
                '
                D_EXL_SHT1.Cells(27, 3).Value = D_total_percent_9 & "%"
                D_EXL_SHT1.Cells(27, 4).Value = D_total_percent_8 & "%"
                D_EXL_SHT1.Cells(27, 5).Value = D_total_percent_7 & "%"
                D_EXL_SHT1.Cells(27, 6).Value = D_total_percent_6 & "%"
                D_EXL_SHT1.Cells(27, 7).Value = D_total_percent_5 & "%"
                D_EXL_SHT1.Cells(27, 8).Value = D_total_percent_4 & "%"
                D_EXL_SHT1.Cells(27, 9).Value = D_total_percent_3 & "%"
                D_EXL_SHT1.Cells(27, 10).Value = D_total_percent_2 & "%"
                D_EXL_SHT1.Cells(27, 11).Value = D_total_percent_1 & "%"
                D_EXL_SHT1.Cells(27, 12).Value = D_total_percent_0 & "%"
                '
                'meger cell
                D_EXL_SHT1.Cells("A16:A27").Merge = True
                'delete sheet copy
                D_EXL_BOK.Workbook.Worksheets.Delete(2)
                'Save file
                D_EXL_BOK.Save()
            End Using
        Catch ex As Exception
            Utl_ERR.WriteLogReport(ex.ToString(), "Oq2033_21")
            message = "FNC_EXL_Oq2033_21: " & ex.ToString()
            status = "201"
        Finally
            '
        End Try
EXIT_FUNCTION:
        FNC_EXL_Oq2033_21 = "{" + """" + "status" + """" + ":" + status + "," + """" + "filename" + """" + ":" + """" + fileName + """," + """" + "message" + """" + ":" + """" + message + """}"
        Exit Function

    End Function

End Class