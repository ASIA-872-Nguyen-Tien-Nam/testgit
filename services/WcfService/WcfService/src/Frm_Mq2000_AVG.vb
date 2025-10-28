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

Public Class Frm_Mq2000_AVG
    Public Function FNC_EXL_Mq2000_AVG(
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
        Dim D_EXL_SHT1 As ExcelWorksheet = Nothing
        Try
            D_DAT = New DataSet
            Dim D_UTL_RDB As Utl_RDB = New Utl_RDB()
            D_DAT = D_UTL_RDB.FNC_GET_DAT(sql)
            D_ROW_CNT = D_DAT.Tables(0).Rows.Count
            '
            If D_ROW_CNT = 0 Then
                status = "203"
                message = "FNC_EXL_Q2010: Data is empty"
                GoTo EXIT_FUNCTION
            End If
            '
            If Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(0).Item("language"), 0) = "en" Then
                D_EXL_TML = ConfigurationManager.AppSettings("FIL_TEM_EXL") & "\Mq2000_AVG_en.xlsx"
            Else
                D_EXL_TML = ConfigurationManager.AppSettings("FIL_TEM_EXL") & "\Mq2000_AVG.xlsx"
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
                ' fill data
                For i = 0 To D_ROW_CNT - 1
                    If i <> 0 Then
                        D_EXL_SHT1.Cells("A2:D2").Copy(D_EXL_SHT1.Cells("A" & (2 + i) & ":D" & (2 + i)))
                    End If
                    D_EXL_SHT1.Cells(2 + i, 1).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("employee_cd"), "")
                    D_EXL_SHT1.Cells(2 + i, 2).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("employee_nm"), "")
                    D_EXL_SHT1.Cells(2 + i, 3).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("evaluation_point"), "")
                    'If D_DAT.Tables(0).Rows(i).Item("evaluation_point") = 99 Then
                    '    D_EXL_SHT1.Cells(2 + i, 3).Value = "-"
                    'Else
                    '    D_EXL_SHT1.Cells(2 + i, 3).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("evaluation_point"), "")
                    'End If

                    D_EXL_SHT1.Cells(2 + i, 4).Value = Utl_Com.FNC_CNV_NUL(D_DAT.Tables(0).Rows(i).Item("times_of_evaluation"), "")
                Next
                '
ACTIVE:

                'Save file
                D_EXL_BOK.Save()
            End Using
        Catch ex As Exception
            Utl_ERR.WriteLogReport(ex.ToString(), "Mq2000_AVG")
            message = "FNC_EXL_Mq2000_AVG: " & ex.ToString()
            status = "201"
        Finally
            D_DAT.Clear()
            '
        End Try
EXIT_FUNCTION:
        FNC_EXL_Mq2000_AVG = "{" + """" + "status" + """" + ":" + status + "," + """" + "filename" + """" + ":" + """" + fileName + """," + """" + "message" + """" + ":" + """" + message + """}"
        Exit Function

    End Function

End Class