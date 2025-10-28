Imports System.IO
Imports System.Globalization
Imports System.Drawing
Imports Newtonsoft.Json
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

Public Class Frm_Oq2033_13
    Public Function FNC_EXL_Oq2033_13(
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
        Dim D_percent_info As String = ""
        Dim D_total_questionnaire_10 As Integer = 0
        Dim D_total_questionnaire_9 As Integer = 0
        Dim D_total_questionnaire_8 As Integer = 0
        Dim D_total_questionnaire_7 As Integer = 0
        Dim D_total_questionnaire_6 As Integer = 0
        Dim D_total_questionnaire_5 As Integer = 0
        Dim D_total_questionnaire_4 As Integer = 0
        Dim D_total_questionnaire_3 As Integer = 0
        Dim D_total_questionnaire_2 As Integer = 0
        Dim D_total_questionnaire_1 As Integer = 0
        Dim D_total_percent_1 As Double = 0
        Dim D_total_percent_2 As Double = 0
        Dim D_total_percent_3 As Double = 0
        Dim D_total_percent_4 As Double = 0
        Dim D_total_percent_5 As Double = 0
        Dim D_total_percent_6 As Double = 0
        Dim D_total_percent_7 As Double = 0
        Dim D_total_percent_8 As Double = 0
        Dim D_total_percent_9 As Double = 0
        Dim D_total_percent_10 As Double = 0
        Dim D_total_number As Integer = 0
        Dim D_More As String = "以上"
        Dim D_Less As String = "未満"
        Dim D_Person As String = "人"
        Try
            Dim D_data_detail As Newtonsoft.Json.Linq.JArray
            D_data_detail = JsonConvert.DeserializeObject(P5)
            '
            If Mid(sql, 8, 2) = "en" Then
                D_More = " More "
                D_Less = " Less"
                D_Person = " Person(s)"
                '
                D_EXL_TML = ConfigurationManager.AppSettings("FIL_TEM_EXL") & "\Oq2033_13_en.xlsx"
            Else
                D_EXL_TML = ConfigurationManager.AppSettings("FIL_TEM_EXL") & "\Oq2033_13.xlsx"
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
                D_EXL_SHT1.Cells(4, 1).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(15)("organization_hd_1").ToString(), "")
                D_EXL_SHT1.Cells(5, 1).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(15)("organization_hd_2").ToString(), "")
                D_EXL_SHT1.Cells(6, 1).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(15)("organization_hd_3").ToString(), "")
                D_EXL_SHT1.Cells(7, 1).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(15)("organization_hd_4").ToString(), "")
                D_EXL_SHT1.Cells(8, 1).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(15)("organization_hd_5").ToString(), "")
                'fill search conditions
                D_EXL_SHT1.Cells(1, 2).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(15)("fiscal_year_nm").ToString(), "")
                D_EXL_SHT1.Cells(2, 2).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(15)("combination_vertical").ToString(), "")
                D_EXL_SHT1.Cells(3, 2).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(15)("combination_horizontal").ToString(), "")
                D_EXL_SHT1.Cells(4, 2).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(15)("organization_nm_1").ToString(), "")
                D_EXL_SHT1.Cells(5, 2).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(15)("organization_nm_2").ToString(), "")
                D_EXL_SHT1.Cells(6, 2).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(15)("organization_nm_3").ToString(), "")
                D_EXL_SHT1.Cells(7, 2).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(15)("organization_nm_4").ToString(), "")
                D_EXL_SHT1.Cells(8, 2).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(15)("organization_nm_5").ToString(), "")
                D_EXL_SHT1.Cells(9, 2).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(15)("group_cd_1on1_nm").ToString(), "")
                D_EXL_SHT1.Cells(10, 2).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(15)("position_nm").ToString(), "")
                D_EXL_SHT1.Cells(11, 2).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(15)("grade_nm").ToString(), "")
                D_EXL_SHT1.Cells(12, 2).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(15)("job_nm").ToString(), "")
                D_EXL_SHT1.Cells(13, 2).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(15)("coach_nm").ToString(), "")
                ' fill data
                For i = 0 To 9
                    '
                    If i = 0 Then
                        D_percent_info = "90％" + D_More
                    End If
                    If i = 1 Then
                        D_percent_info = "80％" + D_More + "90％" + D_Less
                    End If
                    If i = 2 Then
                        D_percent_info = "70％" + D_More + "80％" + D_Less
                    End If
                    If i = 3 Then
                        D_percent_info = "60％" + D_More + "70％" + D_Less
                    End If
                    If i = 4 Then
                        D_percent_info = "50％" + D_More + "60％" + D_Less
                    End If
                    If i = 5 Then
                        D_percent_info = "40％" + D_More + "50％" + D_Less
                    End If
                    If i = 6 Then
                        D_percent_info = "30％" + D_More + "40％" + D_Less
                    End If
                    If i = 7 Then
                        D_percent_info = "20％" + D_More + "30％" + D_Less
                    End If
                    If i = 8 Then
                        D_percent_info = "10％" + D_More + "20％" + D_Less
                    End If
                    If i = 9 Then
                        D_percent_info = "10％" + D_Less
                    End If
                    '
                    If i <> 0 Then
                        D_EXL_BOK.Workbook.Worksheets(2).Cells("A3:M4").Copy(D_EXL_SHT1.Cells("A" & (16 + (i * 2)) & ":M" & (17 + (i * 2))))
                    End If
                    D_EXL_SHT1.Cells(16 + (i * 2), 2).Value = D_percent_info
                    D_EXL_SHT1.Cells(16 + (i * 2), 3).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("questionnaire_10").ToString(), "") & D_Person
                    D_EXL_SHT1.Cells(16 + (i * 2), 4).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("questionnaire_9").ToString(), "") & D_Person
                    D_EXL_SHT1.Cells(16 + (i * 2), 5).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("questionnaire_8").ToString(), "") & D_Person
                    D_EXL_SHT1.Cells(16 + (i * 2), 6).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("questionnaire_7").ToString(), "") & D_Person
                    D_EXL_SHT1.Cells(16 + (i * 2), 7).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("questionnaire_6").ToString(), "") & D_Person
                    D_EXL_SHT1.Cells(16 + (i * 2), 8).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("questionnaire_5").ToString(), "") & D_Person
                    D_EXL_SHT1.Cells(16 + (i * 2), 9).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("questionnaire_4").ToString(), "") & D_Person
                    D_EXL_SHT1.Cells(16 + (i * 2), 10).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("questionnaire_3").ToString(), "") & D_Person
                    D_EXL_SHT1.Cells(16 + (i * 2), 11).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("questionnaire_2").ToString(), "") & D_Person
                    D_EXL_SHT1.Cells(16 + (i * 2), 12).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("questionnaire_1").ToString(), "") & D_Person
                    D_EXL_SHT1.Cells(16 + (i * 2), 13).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("sub_total").ToString(), "") & D_Person
                    '
                    D_EXL_SHT1.Cells(17 + (i * 2), 3).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("questionnaire_percent_10").ToString(), "") & "%"
                    D_EXL_SHT1.Cells(17 + (i * 2), 4).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("questionnaire_percent_9").ToString(), "") & "%"
                    D_EXL_SHT1.Cells(17 + (i * 2), 5).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("questionnaire_percent_8").ToString(), "") & "%"
                    D_EXL_SHT1.Cells(17 + (i * 2), 6).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("questionnaire_percent_7").ToString(), "") & "%"
                    D_EXL_SHT1.Cells(17 + (i * 2), 7).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("questionnaire_percent_6").ToString(), "") & "%"
                    D_EXL_SHT1.Cells(17 + (i * 2), 8).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("questionnaire_percent_5").ToString(), "") & "%"
                    D_EXL_SHT1.Cells(17 + (i * 2), 9).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("questionnaire_percent_4").ToString(), "") & "%"
                    D_EXL_SHT1.Cells(17 + (i * 2), 10).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("questionnaire_percent_3").ToString(), "") & "%"
                    D_EXL_SHT1.Cells(17 + (i * 2), 11).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("questionnaire_percent_2").ToString(), "") & "%"
                    D_EXL_SHT1.Cells(17 + (i * 2), 12).Value = Utl_Com.FNC_CNV_NUL(D_data_detail(i)("questionnaire_percent_1").ToString(), "") & "%"
                    'total
                    D_total_questionnaire_10 = D_total_questionnaire_10 + D_data_detail(i)("questionnaire_10").ToString()
                    D_total_questionnaire_9 = D_total_questionnaire_9 + D_data_detail(i)("questionnaire_9").ToString()
                    D_total_questionnaire_8 = D_total_questionnaire_8 + D_data_detail(i)("questionnaire_8").ToString()
                    D_total_questionnaire_7 = D_total_questionnaire_7 + D_data_detail(i)("questionnaire_7").ToString()
                    D_total_questionnaire_6 = D_total_questionnaire_6 + D_data_detail(i)("questionnaire_6").ToString()
                    D_total_questionnaire_5 = D_total_questionnaire_5 + D_data_detail(i)("questionnaire_5").ToString()
                    D_total_questionnaire_4 = D_total_questionnaire_4 + D_data_detail(i)("questionnaire_4").ToString()
                    D_total_questionnaire_3 = D_total_questionnaire_3 + D_data_detail(i)("questionnaire_3").ToString()
                    D_total_questionnaire_2 = D_total_questionnaire_2 + D_data_detail(i)("questionnaire_2").ToString()
                    D_total_questionnaire_1 = D_total_questionnaire_1 + D_data_detail(i)("questionnaire_1").ToString()
                    D_total_number = D_total_number + D_data_detail(i)("sub_total").ToString()
                    D_total_percent_1 = D_total_percent_1 + D_data_detail(i)("questionnaire_percent_1").ToString()
                    D_total_percent_2 = D_total_percent_2 + D_data_detail(i)("questionnaire_percent_2").ToString()
                    D_total_percent_3 = D_total_percent_3 + D_data_detail(i)("questionnaire_percent_3").ToString()
                    D_total_percent_4 = D_total_percent_4 + D_data_detail(i)("questionnaire_percent_4").ToString()
                    D_total_percent_5 = D_total_percent_5 + D_data_detail(i)("questionnaire_percent_5").ToString()
                    D_total_percent_6 = D_total_percent_6 + D_data_detail(i)("questionnaire_percent_6").ToString()
                    D_total_percent_7 = D_total_percent_7 + D_data_detail(i)("questionnaire_percent_7").ToString()
                    D_total_percent_8 = D_total_percent_8 + D_data_detail(i)("questionnaire_percent_8").ToString()
                    D_total_percent_9 = D_total_percent_9 + D_data_detail(i)("questionnaire_percent_9").ToString()
                    D_total_percent_10 = D_total_percent_10 + D_data_detail(i)("questionnaire_percent_10").ToString()
                    '
                Next
                Dim k As Integer = 10
                'total
                D_EXL_BOK.Workbook.Worksheets(2).Cells("A5:M6").Copy(D_EXL_SHT1.Cells("A" & (16 + (k * 2)) & ":M" & (17 + (k * 2))))
                '
                'fill data total
                D_EXL_SHT1.Cells(36, 3).Value = D_total_questionnaire_10 & D_Person
                D_EXL_SHT1.Cells(36, 4).Value = D_total_questionnaire_9 & D_Person
                D_EXL_SHT1.Cells(36, 5).Value = D_total_questionnaire_8 & D_Person
                D_EXL_SHT1.Cells(36, 6).Value = D_total_questionnaire_7 & D_Person
                D_EXL_SHT1.Cells(36, 7).Value = D_total_questionnaire_6 & D_Person
                D_EXL_SHT1.Cells(36, 8).Value = D_total_questionnaire_5 & D_Person
                D_EXL_SHT1.Cells(36, 9).Value = D_total_questionnaire_4 & D_Person
                D_EXL_SHT1.Cells(36, 10).Value = D_total_questionnaire_3 & D_Person
                D_EXL_SHT1.Cells(36, 11).Value = D_total_questionnaire_2 & D_Person
                D_EXL_SHT1.Cells(36, 12).Value = D_total_questionnaire_1 & D_Person
                D_EXL_SHT1.Cells(36, 13).Value = D_total_number & D_Person
                '
                D_EXL_SHT1.Cells(37, 3).Value = D_total_percent_10 & "%"
                D_EXL_SHT1.Cells(37, 4).Value = D_total_percent_9 & "%"
                D_EXL_SHT1.Cells(37, 5).Value = D_total_percent_8 & "%"
                D_EXL_SHT1.Cells(37, 6).Value = D_total_percent_7 & "%"
                D_EXL_SHT1.Cells(37, 7).Value = D_total_percent_6 & "%"
                D_EXL_SHT1.Cells(37, 8).Value = D_total_percent_5 & "%"
                D_EXL_SHT1.Cells(37, 9).Value = D_total_percent_4 & "%"
                D_EXL_SHT1.Cells(37, 10).Value = D_total_percent_3 & "%"
                D_EXL_SHT1.Cells(37, 11).Value = D_total_percent_2 & "%"
                D_EXL_SHT1.Cells(37, 12).Value = D_total_percent_1 & "%"
                '
                'meger cell
                D_EXL_SHT1.Cells("A16:A37").Merge = True
                'delete sheet copy
                D_EXL_BOK.Workbook.Worksheets.Delete(2)
                'Save file
                D_EXL_BOK.Save()
            End Using
        Catch ex As Exception
            Utl_ERR.WriteLogReport(ex.ToString(), "Oq2033_13")
            message = "FNC_EXL_Oq2033_13: " & ex.ToString()
            status = "201"
        Finally
            '
        End Try
EXIT_FUNCTION:
        FNC_EXL_Oq2033_13 = "{" + """" + "status" + """" + ":" + status + "," + """" + "filename" + """" + ":" + """" + fileName + """," + """" + "message" + """" + ":" + """" + message + """}"
        Exit Function

    End Function

End Class