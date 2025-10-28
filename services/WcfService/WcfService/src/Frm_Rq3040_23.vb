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

Public Class Frm_Rq3040_23
    Public Function FNC_EXL_Rq3040_23(
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
        Dim D_total_item_no_1 As Integer = 0
        Dim D_total_item_no_2 As Integer = 0
        Dim D_total_item_no_3 As Integer = 0
        Dim D_total_item_no_4 As Integer = 0
        'Dim D_total_item_no_5 As Integer = 0
        Dim D_total_percent_1 As Double = 0
        Dim D_total_percent_2 As Double = 0
        Dim D_total_percent_3 As Double = 0
        Dim D_total_percent_4 As Double = 0
        'Dim D_total_percent_5 As Double = 0
        Dim D_total_number As Integer = 0
        Dim D_point_typ_1 As Double = 0
        Dim D_point_typ_2 As Double = 0
        Dim D_point_typ_3 As Double = 0
        Dim D_point_typ_4 As Double = 0
        'Dim D_point_typ_5 As Double = 0
        Dim D_point_average As Double = 0
        Dim D_Person As String = "人"
        Try
            Dim D_data_detail As Newtonsoft.Json.Linq.JArray
            D_data_detail = JsonConvert.DeserializeObject(P5)
            D_ROW_CNT = D_data_detail.Count
            '
            If D_ROW_CNT = 0 Then
                status = "203"
                message = "FNC_EXL_Rq3040_23: Data is empty"
                GoTo EXIT_FUNCTION
            End If
            '
            If Mid(sql, 8, 2) = "en" Then
                D_Person = " Person(s)"
                '
                D_EXL_TML = ConfigurationManager.AppSettings("FIL_TEM_EXL") & "\Rq3040_23_en.xlsx"
            Else
                D_EXL_TML = ConfigurationManager.AppSettings("FIL_TEM_EXL") & "\Rq3040_23.xlsx"
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
                D_EXL_SHT1.Cells(4, 1).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(12)("organization_hd_1").ToString(), "")
                D_EXL_SHT1.Cells(5, 1).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(12)("organization_hd_2").ToString(), "")
                D_EXL_SHT1.Cells(6, 1).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(12)("organization_hd_3").ToString(), "")
                D_EXL_SHT1.Cells(7, 1).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(12)("organization_hd_4").ToString(), "")
                D_EXL_SHT1.Cells(8, 1).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(12)("organization_hd_5").ToString(), "")
                'fill search conditions                                           2
                D_EXL_SHT1.Cells(1, 2).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(12)("fiscal_year_nm").ToString(), "")
                D_EXL_SHT1.Cells(2, 2).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(12)("combination_vertical").ToString(), "")
                D_EXL_SHT1.Cells(3, 2).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(12)("combination_horizontal").ToString(), "")
                D_EXL_SHT1.Cells(4, 2).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(12)("organization_nm_1").ToString(), "")
                D_EXL_SHT1.Cells(5, 2).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(12)("organization_nm_2").ToString(), "")
                D_EXL_SHT1.Cells(6, 2).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(12)("organization_nm_3").ToString(), "")
                D_EXL_SHT1.Cells(7, 2).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(12)("organization_nm_4").ToString(), "")
                D_EXL_SHT1.Cells(8, 2).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(12)("organization_nm_5").ToString(), "")
                D_EXL_SHT1.Cells(9, 2).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(12)("group_cd_nm").ToString(), "")
                D_EXL_SHT1.Cells(10, 2).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(12)("position_nm").ToString(), "")
                D_EXL_SHT1.Cells(11, 2).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(12)("grade_nm").ToString(), "")
                D_EXL_SHT1.Cells(12, 2).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(12)("job_nm").ToString(), "")
                'D_EXL_SHT1.Cells(13, 2).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(14)("coach_nm").ToString(), "")
                Dim D_cl As Integer = 0
                'picture
                For j = 8 To D_data_detail.Count - 2
                    D_file_nm = Utl_Com.FNC_CNV_NUL(D_data_detail(j)("remark1").ToString(), "")
                    Dim img = Image.FromFile(ConfigurationManager.AppSettings("FIL_WEE_IMG") & "\" & D_file_nm)
                    Dim pic = D_EXL_SHT1.Drawings.AddPicture("Untitled-1" + D_cl.ToString(), img)
                    pic.SetPosition(14, 3, 2 + D_cl, 25)
                    pic.AdjustPositionAndSize()
                    pic.SetSize(60, 30)
                    'point
                    If j = 8 Then
                        D_point_typ_1 = Utl_Com.FNC_CNV_NUL(D_data_detail(j)("point").ToString(), 0)
                    End If
                    If j = 9 Then
                        D_point_typ_2 = Utl_Com.FNC_CNV_NUL(D_data_detail(j)("point").ToString(), 0)
                    End If
                    If j = 10 Then
                        D_point_typ_3 = Utl_Com.FNC_CNV_NUL(D_data_detail(j)("point").ToString(), 0)
                    End If
                    If j = 11 Then
                        D_point_typ_4 = Utl_Com.FNC_CNV_NUL(D_data_detail(j)("point").ToString(), 0)
                    End If
                    '
                    D_cl = D_cl + 1
                Next
                Dim D_cr As Integer = 0
                'picture
                For j = 4 To D_data_detail.Count - 6
                    D_file_nm = Utl_Com.FNC_CNV_NUL(D_data_detail(j)("remark1").ToString(), "")
                    Dim img = Image.FromFile(ConfigurationManager.AppSettings("FIL_WEE_IMG") & "\" & D_file_nm)
                    Dim pic = D_EXL_SHT1.Drawings.AddPicture("Untitled-2" + D_cr.ToString(), img)
                    pic.SetPosition(15 + D_cr, 10, 1, 25)
                    pic.AdjustPositionAndSize()
                    pic.SetSize(30, 30)
                    '
                    D_cr = D_cr + 2
                Next
                ' fill data
                For i = 0 To 3
                    '
                    D_point_average = 0
                    '
                    D_EXL_SHT1.Cells(16 + (i * 2), 3).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("reactions_1").ToString(), "") & D_Person
                    D_EXL_SHT1.Cells(16 + (i * 2), 4).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("reactions_2").ToString(), "") & D_Person
                    D_EXL_SHT1.Cells(16 + (i * 2), 5).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("reactions_3").ToString(), "") & D_Person
                    D_EXL_SHT1.Cells(16 + (i * 2), 6).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("reactions_4").ToString(), "") & D_Person
                    ' D_EXL_SHT1.Cells(16 + (i * 2), 7).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("item_no_5").ToString(), "") & D_Person
                    D_EXL_SHT1.Cells(16 + (i * 2), 8).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("sub_total").ToString(), "") & D_Person
                    '
                    D_EXL_SHT1.Cells(17 + (i * 2), 3).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("reactions_percent_1").ToString(), "") & "%"
                    D_EXL_SHT1.Cells(17 + (i * 2), 4).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("reactions_percent_2").ToString(), "") & "%"
                    D_EXL_SHT1.Cells(17 + (i * 2), 5).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("reactions_percent_3").ToString(), "") & "%"
                    D_EXL_SHT1.Cells(17 + (i * 2), 6).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("reactions_percent_4").ToString(), "") & "%"
                    'D_EXL_SHT1.Cells(17 + (i * 2), 7).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("item_no_percent5").ToString(), "") & "%"
                    'average point
                    If Utl_Com.FNC_CNV_NUL(D_data_detail(i)("sub_total").ToString(), 0) > 0 Then
                        D_point_average = (((Utl_Com.FNC_CNV_NUL(D_data_detail(i)("reactions_1").ToString(), 0) * D_point_typ_1) + (Utl_Com.FNC_CNV_NUL(D_data_detail(i)("reactions_2").ToString(), 0) * D_point_typ_2) + (Utl_Com.FNC_CNV_NUL(D_data_detail(i)("reactions_3").ToString(), 0) * D_point_typ_3) + (Utl_Com.FNC_CNV_NUL(D_data_detail(i)("reactions_4").ToString(), 0) * D_point_typ_4)) / (Utl_Com.FNC_CNV_NUL(D_data_detail(i)("sub_total").ToString(), 0)))
                        D_point_average = Math.Round(D_point_average, 2)
                    End If
                    D_EXL_SHT1.Cells(16 + (i * 2), 7).Value = D_point_average
                    '
                    'total
                    D_total_item_no_1 = D_total_item_no_1 + D_data_detail(i)("reactions_1").ToString()
                    D_total_item_no_2 = D_total_item_no_2 + D_data_detail(i)("reactions_2").ToString()
                    D_total_item_no_3 = D_total_item_no_3 + D_data_detail(i)("reactions_3").ToString()
                    D_total_item_no_4 = D_total_item_no_4 + D_data_detail(i)("reactions_4").ToString()
                    'D_total_item_no_5 = D_total_item_no_5 + D_data_detail(i)("item_no_5").ToString()
                    D_total_number = D_total_number + D_data_detail(i)("sub_total").ToString()
                    D_total_percent_1 = D_total_percent_1 + D_data_detail(i)("reactions_percent_1").ToString()
                    D_total_percent_2 = D_total_percent_2 + D_data_detail(i)("reactions_percent_2").ToString()
                    D_total_percent_3 = D_total_percent_3 + D_data_detail(i)("reactions_percent_3").ToString()
                    D_total_percent_4 = D_total_percent_4 + D_data_detail(i)("reactions_percent_4").ToString()
                    'D_total_percent_5 = D_total_percent_5 + D_data_detail(i)("item_no_percent5").ToString()
                    '
                Next
                '             Dim k As Integer = 10
                '             'total
                '             'fill data total
                D_EXL_SHT1.Cells(24, 3).Value = D_total_item_no_1 & D_Person
                D_EXL_SHT1.Cells(24, 4).Value = D_total_item_no_2 & D_Person
                D_EXL_SHT1.Cells(24, 5).Value = D_total_item_no_3 & D_Person
                D_EXL_SHT1.Cells(24, 6).Value = D_total_item_no_4 & D_Person
                'D_EXL_SHT1.Cells(36, 7).Value = D_total_item_no_5 & D_Person
                D_EXL_SHT1.Cells(24, 8).Value = D_total_number & D_Person
                '
                D_EXL_SHT1.Cells(25, 3).Value = D_total_percent_1 & "%"
                D_EXL_SHT1.Cells(25, 4).Value = D_total_percent_2 & "%"
                D_EXL_SHT1.Cells(25, 5).Value = D_total_percent_3 & "%"
                D_EXL_SHT1.Cells(25, 6).Value = D_total_percent_4 & "%"
                'D_EXL_SHT1.Cells(37, 7).Value = D_total_percent_5 & "%"
                '
                'Save file
                D_EXL_BOK.Save()
            End Using
        Catch ex As Exception
            Utl_ERR.WriteLogReport(ex.ToString(), "Rq3040_23")
            message = "FNC_EXL_Rq3040_23: " & ex.ToString()
            status = "201"
        Finally
            '
        End Try
EXIT_FUNCTION:
        FNC_EXL_Rq3040_23 = "{" + """" + "status" + """" + ":" + status + "," + """" + "filename" + """" + ":" + """" + fileName + """," + """" + "message" + """" + ":" + """" + message + """}"
        Exit Function

    End Function

End Class