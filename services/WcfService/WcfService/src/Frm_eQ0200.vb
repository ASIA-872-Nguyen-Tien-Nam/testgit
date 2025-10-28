Imports System.IO
Imports System.Globalization
Imports System.Drawing

'*********************************************************************************************************
'*
'*  処理概要：Function create Excel
'*  目標一覧表
'*  作成日：	    2024/05/02
'*  作成者：　　 hainn
'*
'*********************************************************************************************************
Imports OfficeOpenXml
Imports Newtonsoft.Json
Imports OfficeOpenXml.Style
Imports OfficeOpenXml.FormulaParsing.Excel.Functions.Logical

Public Class Frm_eQ0200
    Public Function FNC_EXL_eQ0200(
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

        Dim D_and As String = ""
        Dim D_Row As Integer = 1
        Dim D_step_col As Integer = 1
        Dim D_step_row As Integer = 0
        Dim D_ROW_CNT As Integer = 0
        Dim D_ROW_CNT1 As Integer = 0
        Dim D_EXL_SHT1 As ExcelWorksheet = Nothing
        Dim D_EXL_SHT2 As ExcelWorksheet = Nothing

        Dim D_data_body As Newtonsoft.Json.Linq.JArray
        Try
            'data sql
            D_DAT = New DataSet
            Dim D_UTL_RDB As Utl_RDB = New Utl_RDB()
            D_DAT = D_UTL_RDB.FNC_GET_DAT(sql)
            D_ROW_CNT = D_DAT.Tables(0).Rows.Count
            D_ROW_CNT1 = D_DAT.Tables(1).Rows.Count

            If Utl_Com.FNC_CNV_NUL(D_DAT.Tables(2).Rows(0).Item("language"), "") = "en" Then
                D_and = " (sub) "
            Else
                D_and = " (兼務) "
            End If

            If D_ROW_CNT = 0 And D_ROW_CNT1 = 0 Then
                status = "203"
                message = "FNC_EXL_eQ0200: Data is empty"
                GoTo EXIT_FUNCTION
            End If

            D_EXL_TML = ConfigurationManager.AppSettings("FIL_TEM_EXL") & "\eQ0200.xlsx"
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
                'fill employee
                If D_DAT.Tables(0).Rows.Count > 0 Then
                    For i = 0 To D_ROW_CNT - 1
                        If i Mod 14 = 0 Then
                            D_step_row = D_step_row + 4
                            D_step_col = 1
                        End If
                        D_EXL_SHT2.Cells("A4:G6").Copy(D_EXL_SHT1.Cells(D_step_row - 2, D_step_col))
                        If D_DAT.Tables(0).Rows(i).Item("sub") = "1" Then
                            D_EXL_SHT1.Cells(D_step_row - 1, D_step_col).Value = D_and + Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("employee_cd"), "") + " : " + Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("employee_nm"), "")
                        Else
                            D_EXL_SHT1.Cells(D_step_row - 1, D_step_col).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("employee_cd"), "") + " : " + Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("employee_nm"), "")
                        End If
                        D_EXL_SHT1.Cells(D_step_row - 2, D_step_col).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("position_nm"), "")
                        D_step_col = D_step_col + 6
                    Next
                End If

                If D_DAT.Tables(1).Rows.Count > 0 Then
                    D_step_row = D_step_row + 2
                    D_step_col = 7
                    For i = 0 To D_ROW_CNT1 - 1
                        D_data_body = JsonConvert.DeserializeObject(Utl_Com.FNC_CNV_NUL(D_DAT.Tables(1).Rows(i)("employee_info"), ""))

                        If Utl_Com.FNC_CNV_NUL(D_DAT.Tables(1).Rows(i).Item("organization_typ"), 0) = 1 Then
                            D_EXL_SHT2.Cells("A1:G2").Copy(D_EXL_SHT1.Cells(D_step_row, D_step_col))
                            D_EXL_SHT1.Cells(D_step_row, D_step_col).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(1).Rows(i).Item("organization_nm"), "")
                            Dim i_remenber_1 As Integer = D_step_col
                            Dim j1 As Integer = 0
                            If D_data_body IsNot Nothing Then
                                For j1 = 0 To D_data_body.Count - 1
                                    If j1 Mod 13 = 0 Then
                                        D_step_row = D_step_row + 4
                                        D_step_col = 7
                                    End If
                                    D_EXL_SHT2.Cells("A4:G6").Copy(D_EXL_SHT1.Cells(D_step_row - 1, D_step_col))
                                    If Utl_Com.FNC_CNV_NUL(D_data_body(j1)("sub").ToString(), "") = "1" Then
                                        D_EXL_SHT1.Cells(D_step_row, D_step_col).Value = D_and + Utl_Com.FNC_CNV_NUL(D_data_body(j1)("employee_cd").ToString(), "") + " : " + Utl_Com.FNC_CNV_NUL(D_data_body(j1)("employee_nm").ToString(), "")
                                    Else
                                        D_EXL_SHT1.Cells(D_step_row, D_step_col).Value = Utl_Com.FNC_CNV_NUL(D_data_body(j1)("employee_cd").ToString(), "") + " : " + Utl_Com.FNC_CNV_NUL(D_data_body(j1)("employee_nm").ToString(), "")
                                    End If
                                    D_EXL_SHT1.Cells(D_step_row - 1, D_step_col).Value = Utl_Com.FNC_CNV_NUL(D_data_body(j1)("position_nm").ToString(), "")
                                    D_step_col = D_step_col + 6
                                Next
                            End If

                            D_step_col = i_remenber_1
                        End If

                        If Utl_Com.FNC_CNV_NUL(D_DAT.Tables(1).Rows(i).Item("organization_typ"), 0) = 2 Then
                            D_step_col = D_step_col * 2
                            D_EXL_SHT2.Cells("A1:G2").Copy(D_EXL_SHT1.Cells(D_step_row, D_step_col - 1))
                            D_EXL_SHT1.Cells(D_step_row, D_step_col - 1).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(1).Rows(i).Item("organization_nm"), "")
                            Dim i_remenber_2 As Integer = D_step_col
                            Dim j2 As Integer = 0

                            If D_data_body IsNot Nothing Then
                                For j2 = 0 To D_data_body.Count - 1
                                    If j2 Mod 12 = 0 Then
                                        D_step_row = D_step_row + 4
                                        D_step_col = 13
                                    End If
                                    D_EXL_SHT2.Cells("A4:G6").Copy(D_EXL_SHT1.Cells(D_step_row - 1, D_step_col))
                                    If Utl_Com.FNC_CNV_NUL(D_data_body(j2)("sub").ToString(), "") = "1" Then
                                        D_EXL_SHT1.Cells(D_step_row, D_step_col).Value = D_and + Utl_Com.FNC_CNV_NUL(D_data_body(j2)("employee_cd").ToString(), "") + " : " + Utl_Com.FNC_CNV_NUL(D_data_body(j2)("employee_nm").ToString(), "")
                                    Else
                                        D_EXL_SHT1.Cells(D_step_row, D_step_col).Value = Utl_Com.FNC_CNV_NUL(D_data_body(j2)("employee_cd").ToString(), "") + " : " + Utl_Com.FNC_CNV_NUL(D_data_body(j2)("employee_nm").ToString(), "")
                                    End If
                                    D_EXL_SHT1.Cells(D_step_row - 1, D_step_col).Value = Utl_Com.FNC_CNV_NUL(D_data_body(j2)("position_nm").ToString(), "")
                                    D_step_col = D_step_col + 6
                                Next
                            End If
                            D_step_col = i_remenber_2

                            D_step_col = D_step_col / 2
                        End If

                        If Utl_Com.FNC_CNV_NUL(D_DAT.Tables(1).Rows(i).Item("organization_typ"), 0) = 3 Then
                            D_step_col = D_step_col * 3
                            D_EXL_SHT2.Cells("A1:G2").Copy(D_EXL_SHT1.Cells(D_step_row, D_step_col - 2))
                            D_EXL_SHT1.Cells(D_step_row, D_step_col - 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(1).Rows(i).Item("organization_nm"), "")

                            Dim i_remenber_3 As Integer = D_step_col
                            Dim j3 As Integer = 0

                            If D_data_body IsNot Nothing Then
                                For j3 = 0 To D_data_body.Count - 1
                                    If j3 Mod 11 = 0 Then
                                        D_step_row = D_step_row + 4
                                        D_step_col = 19
                                    End If
                                    D_EXL_SHT2.Cells("A4:G6").Copy(D_EXL_SHT1.Cells(D_step_row - 1, D_step_col))
                                    If Utl_Com.FNC_CNV_NUL(D_data_body(j3)("sub").ToString(), "") = "1" Then
                                        D_EXL_SHT1.Cells(D_step_row, D_step_col).Value = D_and + Utl_Com.FNC_CNV_NUL(D_data_body(j3)("employee_cd").ToString(), "") + " : " + Utl_Com.FNC_CNV_NUL(D_data_body(j3)("employee_nm").ToString(), "")
                                    Else
                                        D_EXL_SHT1.Cells(D_step_row, D_step_col).Value = Utl_Com.FNC_CNV_NUL(D_data_body(j3)("employee_cd").ToString(), "") + " : " + Utl_Com.FNC_CNV_NUL(D_data_body(j3)("employee_nm").ToString(), "")
                                    End If
                                    D_EXL_SHT1.Cells(D_step_row - 1, D_step_col).Value = Utl_Com.FNC_CNV_NUL(D_data_body(j3)("position_nm").ToString(), "")
                                    D_step_col = D_step_col + 6
                                Next
                            End If
                            D_step_col = i_remenber_3

                            D_step_col = D_step_col / 3
                        End If

                        If Utl_Com.FNC_CNV_NUL(D_DAT.Tables(1).Rows(i).Item("organization_typ"), 0) = 4 Then
                            D_step_col = D_step_col * 4
                            D_EXL_SHT2.Cells("A1:G2").Copy(D_EXL_SHT1.Cells(D_step_row, D_step_col - 3))
                            D_EXL_SHT1.Cells(D_step_row, D_step_col - 3).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(1).Rows(i).Item("organization_nm"), "")

                            Dim i_remenber_4 As Integer = D_step_col
                            Dim j4 As Integer = 0

                            If D_data_body IsNot Nothing Then
                                For j4 = 0 To D_data_body.Count - 1
                                    If j4 Mod 10 = 0 Then
                                        D_step_row = D_step_row + 4
                                        D_step_col = 25
                                    End If
                                    D_EXL_SHT2.Cells("A4:G6").Copy(D_EXL_SHT1.Cells(D_step_row - 1, D_step_col))
                                    If Utl_Com.FNC_CNV_NUL(D_data_body(j4)("sub").ToString(), "") = "1" Then
                                        D_EXL_SHT1.Cells(D_step_row, D_step_col).Value = D_and + Utl_Com.FNC_CNV_NUL(D_data_body(j4)("employee_cd").ToString(), "") + " : " + Utl_Com.FNC_CNV_NUL(D_data_body(j4)("employee_nm").ToString(), "")
                                    Else
                                        D_EXL_SHT1.Cells(D_step_row, D_step_col).Value = Utl_Com.FNC_CNV_NUL(D_data_body(j4)("employee_cd").ToString(), "") + " : " + Utl_Com.FNC_CNV_NUL(D_data_body(j4)("employee_nm").ToString(), "")
                                    End If
                                    D_EXL_SHT1.Cells(D_step_row - 1, D_step_col).Value = Utl_Com.FNC_CNV_NUL(D_data_body(j4)("position_nm").ToString(), "")
                                    D_step_col = D_step_col + 6
                                Next
                            End If
                            D_step_col = i_remenber_4

                            D_step_col = D_step_col / 4
                        End If

                        If Utl_Com.FNC_CNV_NUL(D_DAT.Tables(1).Rows(i).Item("organization_typ"), 0) = 5 Then
                            D_step_col = D_step_col * 5
                            D_EXL_SHT2.Cells("A1:G2").Copy(D_EXL_SHT1.Cells(D_step_row, D_step_col - 4))
                            D_EXL_SHT1.Cells(D_step_row, D_step_col - 4).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(1).Rows(i).Item("organization_nm"), "")

                            Dim i_remenber_5 As Integer = D_step_col
                            Dim j5 As Integer = 0

                            If D_data_body IsNot Nothing Then
                                For j5 = 0 To D_data_body.Count - 1
                                    If j5 Mod 9 = 0 Then
                                        D_step_row = D_step_row + 4
                                        D_step_col = 31
                                    End If
                                    D_EXL_SHT2.Cells("A4:G6").Copy(D_EXL_SHT1.Cells(D_step_row - 1, D_step_col))
                                    If Utl_Com.FNC_CNV_NUL(D_data_body(j5)("sub").ToString(), "") = "1" Then
                                        D_EXL_SHT1.Cells(D_step_row, D_step_col).Value = D_and + Utl_Com.FNC_CNV_NUL(D_data_body(j5)("employee_cd").ToString(), "") + " : " + Utl_Com.FNC_CNV_NUL(D_data_body(j5)("employee_nm").ToString(), "")
                                    Else
                                        D_EXL_SHT1.Cells(D_step_row, D_step_col).Value = Utl_Com.FNC_CNV_NUL(D_data_body(j5)("employee_cd").ToString(), "") + " : " + Utl_Com.FNC_CNV_NUL(D_data_body(j5)("employee_nm").ToString(), "")
                                    End If
                                    D_EXL_SHT1.Cells(D_step_row - 1, D_step_col).Value = Utl_Com.FNC_CNV_NUL(D_data_body(j5)("position_nm").ToString(), "")
                                    D_step_col = D_step_col + 6
                                Next
                            End If
                            D_step_col = i_remenber_5

                            D_step_col = D_step_col / 5
                        End If

                        D_step_row = D_step_row + 3
                    Next
                End If

ACTIVE:
                'delete sheet copy
                D_EXL_BOK.Workbook.Worksheets.Delete(2)
                D_EXL_BOK.Workbook.Worksheets.Delete(2)
                'Save file
                D_EXL_BOK.Save()

            End Using
        Catch ex As Exception
            Utl_ERR.WriteLogReport(ex.ToString(), "eQ0200")
            message = "FNC_EXL_eQ0200: " & ex.ToString()
            status = "201"
        Finally
            D_DAT.Clear()
            '
        End Try
EXIT_FUNCTION:
        FNC_EXL_eQ0200 = "{" + """" + "status" + """" + ":" + status + "," + """" + "filename" + """" + ":" + """" + fileName + """," + """" + "message" + """" + ":" + """" + message + """}"
        Exit Function

    End Function

End Class