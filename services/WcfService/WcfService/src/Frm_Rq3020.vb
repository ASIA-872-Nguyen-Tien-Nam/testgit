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

Public Class Frm_Rq3020
    Public Function FNC_EXL_Rq3020(
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
            D_ROW_CNT = D_DAT.Tables(0).Rows.Count
            D_CELL_CNT = D_DAT.Tables(1).Rows.Count
            '
            If D_ROW_CNT = 0 Then
                status = "203"
                message = "FNC_EXL_Rq3020: Data is empty"
                GoTo EXIT_FUNCTION
            End If
            '
            If Utl_Com.FNC_CNV_NUL(D_DAT.Tables(1).Rows(0).Item("language"), "") = "en" Then
                D_EXL_TML = ConfigurationManager.AppSettings("FIL_TEM_EXL") & "\Rq3020_en.xlsx"
            Else
                D_EXL_TML = ConfigurationManager.AppSettings("FIL_TEM_EXL") & "\Rq3020.xlsx"
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
                D_EXL_SHT1.Cells(3, 1).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(2).Rows(0).Item("organization_hd_1"), "")
                D_EXL_SHT1.Cells(4, 1).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(2).Rows(0).Item("organization_hd_2"), "")
                D_EXL_SHT1.Cells(5, 1).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(2).Rows(0).Item("organization_hd_3"), "")
                D_EXL_SHT1.Cells(6, 1).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(2).Rows(0).Item("organization_hd_4"), "")
                D_EXL_SHT1.Cells(7, 1).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(2).Rows(0).Item("organization_hd_5"), "")
                'fill search conditions                                         
                D_EXL_SHT1.Cells(1, 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(2).Rows(0).Item("fiscal_year_nm"), "")
                D_EXL_SHT1.Cells(2, 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(2).Rows(0).Item("group_cd_nm"), "")
                D_EXL_SHT1.Cells(3, 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(2).Rows(0).Item("organization_nm_1"), "")
                D_EXL_SHT1.Cells(4, 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(2).Rows(0).Item("organization_nm_2"), "")
                D_EXL_SHT1.Cells(5, 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(2).Rows(0).Item("organization_nm_3"), "")
                D_EXL_SHT1.Cells(6, 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(2).Rows(0).Item("organization_nm_4"), "")
                D_EXL_SHT1.Cells(7, 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(2).Rows(0).Item("organization_nm_5"), "")
                D_EXL_SHT1.Cells(8, 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(2).Rows(0).Item("position_nm"), "")
                D_EXL_SHT1.Cells(9, 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(2).Rows(0).Item("job_nm"), "")
                D_EXL_SHT1.Cells(10, 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(2).Rows(0).Item("grade_nm"), "")
                D_EXL_SHT1.Cells(11, 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(2).Rows(0).Item("employee_typ_nm"), "")
                D_EXL_SHT1.Cells(12, 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(2).Rows(0).Item("field_3020_nm"), "")
                ' fill data
                'HEARDER
                For i = 0 To D_CELL_CNT - 1
                    D_EXL_SHT1.Cells(14, 2 + i).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(1).Rows(i).Item("title"), "")
                Next

                If Utl_Com.FNC_CNV_NUL(D_DAT.Tables(1).Rows(0).Item("language"), 0) = "en" Then
                    D_EXL_SHT1.Cells(14, D_CELL_CNT + 2).Value = "Yearly Average"
                Else
                    D_EXL_SHT1.Cells(14, D_CELL_CNT + 2).Value = "年度平均"
                End If

                'SET WIDTH
                If D_CELL_CNT <= 13 Then
                    D_EXL_SHT1.Column(1).Width = 25
                    D_EXL_SHT1.Column(D_CELL_CNT + 2).Width = 20
                    For i = 2 To D_CELL_CNT + 1
                        D_EXL_SHT1.Column(i).Width = 13.5
                    Next
                Else
                    D_EXL_SHT1.Column(1).Width = 12
                    D_EXL_SHT1.Column(D_CELL_CNT + 2).Width = 8
                    For i = 2 To D_CELL_CNT + 1
                        D_EXL_SHT1.Column(i).Width = (205 - 20) / D_CELL_CNT
                    Next
                End If
                'DELETE COLUMNS
                D_EXL_SHT1.DeleteColumn(D_CELL_CNT + 3, 55)
                'BODY
                For i = 0 To D_ROW_CNT - 1

                    D_EXL_SHT1.Cells("A15:BC15").Copy(D_EXL_SHT1.Cells("A" & (15 + i) & ":BC" & (15 + i)))

                    D_EXL_SHT1.Cells(15 + i, 1).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("target_nm"), "")

                    For j = 0 To D_CELL_CNT - 1
                        Dim header_a As String = ""
                        header_a = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(1).Rows(j).Item("year_month_times"), "")
                        D_EXL_SHT1.Cells(15 + i, 2 + j).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item(header_a), "")
                    Next

                    D_EXL_SHT1.Cells(15 + i, D_CELL_CNT + 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("year_adequacy_score_avg"), "")
                Next
                'FOOTER
                D_EXL_SHT1.Cells("A15:BC15").Copy(D_EXL_SHT1.Cells("A" & (15 + D_ROW_CNT) & ":BC" & (15 + D_ROW_CNT)))
                If Utl_Com.FNC_CNV_NUL(D_DAT.Tables(1).Rows(0).Item("language"), 0) = "en" Then
                    D_EXL_SHT1.Cells(15 + D_ROW_CNT, 1).Value = "Average"
                Else
                    D_EXL_SHT1.Cells(15 + D_ROW_CNT, 1).Value = "平均"
                End If

                For j = 0 To D_CELL_CNT - 1
                    D_EXL_SHT1.Cells(15 + D_ROW_CNT, 2 + j).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(3).Rows(j).Item("adequacy_score_avg"), "")
                Next
                D_EXL_SHT1.Cells(15 + D_ROW_CNT, D_CELL_CNT + 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(3).Rows(0).Item("year_footer_adequacy_score_avg"), "")
                '
                'D_EXL_SHT1.Cells("A" & (15 + D_ROW_CNT) & ":BC" & (15 + D_ROW_CNT)).Style.Font.Bold = True
                'SET style
                If D_CELL_CNT > 22 Then
                    For i = 2 To D_CELL_CNT + 1
                        D_EXL_SHT1.Column(i).Style.Font.Bold = False
                        D_EXL_SHT1.Column(i).Style.Font.Size = 6
                    Next
                    For i = 1 To 13
                        D_EXL_SHT1.Cells(i, 2).Style.Font.Size = 11
                    Next
                End If
                D_EXL_SHT1.Cells("A" & (15 + D_ROW_CNT) & ":BC" & (15 + D_ROW_CNT)).Style.Font.Bold = True
ACTIVE:
                'Save file
                D_EXL_BOK.Save()
            End Using
        Catch ex As Exception
            Utl_ERR.WriteLogReport(ex.ToString(), "Rq3020")
            message = "FNC_EXL_Rq3020: " & ex.ToString()
            status = "201"
        Finally
            D_DAT.Clear()
            '
        End Try
EXIT_FUNCTION:
        FNC_EXL_Rq3020 = "{" + """" + "status" + """" + ":" + status + "," + """" + "filename" + """" + ":" + """" + fileName + """," + """" + "message" + """" + ":" + """" + message + """}"
        Exit Function

    End Function

End Class