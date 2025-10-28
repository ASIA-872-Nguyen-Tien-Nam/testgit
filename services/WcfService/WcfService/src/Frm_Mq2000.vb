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

Public Class Frm_Mq2000
    Public Function FNC_EXL_Mq2000(
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
        Dim D_is_rater_admin As Integer = 0 '0. suppoter <> 0 : rater or admin
        Dim D_multireview_authority_typ As Integer = 0
        Dim D_EXL_SHT1 As ExcelWorksheet = Nothing
        Dim D_EXL_SHT2 As ExcelWorksheet = Nothing
        Dim D_PT As String = "点"
        Try
            D_DAT = New DataSet
            Dim D_UTL_RDB As Utl_RDB = New Utl_RDB()
            D_DAT = D_UTL_RDB.FNC_GET_DAT(sql)
            D_ROW_CNT = D_DAT.Tables(0).Rows.Count
            D_is_rater_admin = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(1).Rows(0).Item("is_rater_admin"), 0)
            D_multireview_authority_typ = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(1).Rows(0).Item("multireview_authority_typ"), 0)
            '
            If D_ROW_CNT = 0 Then
                status = "203"
                message = "FNC_EXL_Q2010: Data is empty"
                GoTo EXIT_FUNCTION
            End If
            'ADMIN
            If Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(0).Item("language"), 0) = "en" Then
                D_PT = "PT"
                If D_multireview_authority_typ >= 3 Then
                    D_EXL_TML = ConfigurationManager.AppSettings("FIL_TEM_EXL") & "\Mq2000_admin_en.xlsx"
                Else
                    D_EXL_TML = ConfigurationManager.AppSettings("FIL_TEM_EXL") & "\Mq2000_en.xlsx"
                End If
            Else
                If D_multireview_authority_typ >= 3 Then
                    D_EXL_TML = ConfigurationManager.AppSettings("FIL_TEM_EXL") & "\Mq2000_admin.xlsx"
                Else
                    D_EXL_TML = ConfigurationManager.AppSettings("FIL_TEM_EXL") & "\Mq2000.xlsx"
                End If
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

                'WHEN ADMIN
                If D_multireview_authority_typ >= 3 Then
                    For i = 0 To D_ROW_CNT - 1
                        If i <> 0 Then
                            D_EXL_SHT1.Cells("A2:M2").Copy(D_EXL_SHT1.Cells("A" & (2 + i) & ":M" & (2 + i)))
                        End If
                        D_EXL_SHT1.Cells(2 + i, 1).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("employee_cd"), "")
                        D_EXL_SHT1.Cells(2 + i, 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("employee_nm"), "")
                        D_EXL_SHT1.Cells(2 + i, 3).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("review_date"), "")
                        D_EXL_SHT1.Cells(2 + i, 4).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("supporter_cd"), "")
                        D_EXL_SHT1.Cells(2 + i, 5).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("supporter_nm"), "")
                        D_EXL_SHT1.Cells(2 + i, 6).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("project_title"), "")
                        D_EXL_SHT1.Cells(2 + i, 7).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("comment"), "")
                        D_EXL_SHT1.Cells(2 + i, 8).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("comment_date"), "")
                        D_EXL_SHT1.Cells(2 + i, 9).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("evaluation_point"), "")
                        D_EXL_SHT1.Cells(2 + i, 10).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("rater_employee_nm_1"), "")
                        D_EXL_SHT1.Cells(2 + i, 11).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("rater_employee_comment_1"), "")
                        D_EXL_SHT1.Cells(2 + i, 12).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("importance_point"), "")
                        D_EXL_SHT1.Cells(2 + i, 13).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("point"), "")
                    Next
                    D_ROW_CNT = D_ROW_CNT + 3
                    D_EXL_SHT2.Cells("L4:M4").Copy(D_EXL_SHT1.Cells("L" & D_ROW_CNT & ":M" & D_ROW_CNT))
                    D_EXL_SHT1.Cells(D_ROW_CNT, 13).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(0).Item("avg_point"), "") & D_PT
                    ' DELETE SHEET 2
                    D_EXL_BOK.Workbook.Worksheets.Delete(2)

                End If
                'WHEN SUPPOTER & RATER
                If D_multireview_authority_typ = 2 Then
                    For i = 0 To D_ROW_CNT - 1
                        If i <> 0 Then
                            D_EXL_SHT1.Cells("A2:M2").Copy(D_EXL_SHT1.Cells("A" & (2 + i) & ":M" & (2 + i)))
                        End If
                        D_EXL_SHT1.Cells(2 + i, 1).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("employee_cd"), "")
                        D_EXL_SHT1.Cells(2 + i, 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("employee_nm"), "")
                        D_EXL_SHT1.Cells(2 + i, 3).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("review_date"), "")
                        D_EXL_SHT1.Cells(2 + i, 4).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("supporter_cd"), "")
                        D_EXL_SHT1.Cells(2 + i, 5).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("supporter_nm"), "")
                        D_EXL_SHT1.Cells(2 + i, 6).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("project_title"), "")
                        D_EXL_SHT1.Cells(2 + i, 7).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("comment"), "")
                        D_EXL_SHT1.Cells(2 + i, 8).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("comment_date"), "")
                        D_EXL_SHT1.Cells(2 + i, 9).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("evaluation_point"), "")
                        D_EXL_SHT1.Cells(2 + i, 10).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("rater_employee_comment_1"), "")
                        D_EXL_SHT1.Cells(2 + i, 11).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("importance_point"), "")
                        D_EXL_SHT1.Cells(2 + i, 12).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("point"), "")
                    Next
                    D_ROW_CNT = D_ROW_CNT + 3
                    D_EXL_SHT2.Cells("K4:L4").Copy(D_EXL_SHT1.Cells("K" & D_ROW_CNT & ":L" & D_ROW_CNT))
                    D_EXL_SHT1.Cells(D_ROW_CNT, 12).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(0).Item("avg_point"), "") & D_PT
                    ' DELETE SHEET 2
                    D_EXL_BOK.Workbook.Worksheets.Delete(2)

                    'DELETE CELL OF RATER 
                    If D_is_rater_admin = 0 Then
                        D_EXL_SHT1.DeleteColumn(10)
                        D_EXL_SHT1.DeleteColumn(10)
                        D_EXL_SHT1.DeleteColumn(10)
                        D_EXL_SHT1.DeleteRow(D_ROW_CNT)
                    End If
                End If
ACTIVE:
                'Save file
                D_EXL_BOK.Save()
            End Using
        Catch ex As Exception
            Utl_ERR.WriteLogReport(ex.ToString(), "Mq2000")
            message = "FNC_EXL_Mq2000: " & ex.ToString()
            status = "201"
        Finally
            D_DAT.Clear()
            '
        End Try
EXIT_FUNCTION:
        FNC_EXL_Mq2000 = "{" + """" + "status" + """" + ":" + status + "," + """" + "filename" + """" + ":" + """" + fileName + """," + """" + "message" + """" + ":" + """" + message + """}"
        Exit Function

    End Function

End Class