Imports System.Globalization
Imports System.IO
Imports System.Threading
Imports System.Data.DataTable

Public Class Service1
	Implements IService1

	Public Sub New()
	End Sub


	Public Function GetData(ByVal value As Integer) As String Implements IService1.GetData
		Return String.Format("You entered: {0}", value)
	End Function
	Public Function GetDataUsingDataContract(ByVal composite As CompositeType) As CompositeType Implements IService1.GetDataUsingDataContract
		If composite Is Nothing Then
			Throw New ArgumentNullException("composite")
		End If
		If composite.BoolValue Then
			composite.StringValue &= "Suffix"
		End If
		Return composite
	End Function
	Private D_DAT As DataSet
    '
    ''' <summary>
    ''' Funtion output XLS
    ''' </summary>
    ''' <param name="sql"></param>
    ''' <param name="screen"></param>
    ''' <param name="fileName"></param>
    ''' <param name="P5"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Private Function FNC_WEB_XLS(
       ByVal sql As String,
       ByVal screen As String,
       ByVal fileName As String,
       Optional ByVal P5 As String = ""
    ) As String Implements IService1.FNC_OUT_EXL

        Dim status As String = "200"
        Dim pathFile As String = ""
        Dim message As String = "File created success."
        Dim json_output As String = ""
        Dim D_PDF As Utl_PDF = Nothing
        '
        Try
            'Trace Log SQL                 
            Utl_ERR.WriteLogFile(sql, "Function Name: FNC_OUT_EXL", False)
            '
            D_PDF = New Utl_PDF()
            pathFile = D_PDF.FNC_GET_DIR & P5 & fileName
            ' do stuff
            Select Case screen
                Case "Q2010_LIST"
                    Dim objecExecl As New Frm_Q2010_LIST
                    json_output = objecExecl.FNC_EXL_Q2010_LIST(sql, screen, fileName, pathFile)
                Case "OQ3020_LIST"
                    Dim objecExecl As New Frm_OQ3020_LIST
                    json_output = objecExecl.FNC_EXL_OQ3020_LIST(sql, screen, fileName, pathFile)
                Case "Q2010"
                    Dim objecExecl As New Frm_Q2010
                    json_output = objecExecl.FNC_EXL_Q2010(sql, screen, fileName, pathFile)
                Case "Q2010_EVAL"
                    Dim objecExecl As New Frm_Q2010_EVAL
                    json_output = objecExecl.FNC_EXL_Q2010_EVAL(sql, screen, fileName, pathFile)
                Case "OQ2030"
                    Dim objecExecl As New Frm_Oq2030
                    json_output = objecExecl.FNC_EXL_Oq2030(sql, screen, fileName, pathFile)
                Case "OQ2031"
                    Dim objecExecl As New Frm_Oq2031
                    json_output = objecExecl.FNC_EXL_Oq2031(sql, screen, fileName, pathFile)
                Case "OQ2032"
                    Dim objecExecl As New Frm_Oq2032
                    json_output = objecExecl.FNC_EXL_Oq2032(sql, screen, fileName, pathFile)
                Case "OQ2033_12"
                    Dim objecExecl As New Frm_Oq2033_12
                    json_output = objecExecl.FNC_EXL_Oq2033_12(sql, screen, fileName, pathFile, P5)
                Case "OQ2033_13"
                    Dim objecExecl As New Frm_Oq2033_13
                    json_output = objecExecl.FNC_EXL_Oq2033_13(sql, screen, fileName, pathFile, P5)
                Case "OQ2033_21"
                    Dim objecExecl As New Frm_Oq2033_21
                    json_output = objecExecl.FNC_EXL_Oq2033_21(sql, screen, fileName, pathFile, P5)
                Case "OQ2033_23"
                    Dim objecExecl As New Frm_Oq2033_23
                    json_output = objecExecl.FNC_EXL_Oq2033_23(sql, screen, fileName, pathFile, P5)
                Case "OQ2033_31"
                    Dim objecExecl As New Frm_Oq2033_31
                    json_output = objecExecl.FNC_EXL_Oq2033_31(sql, screen, fileName, pathFile, P5)
                Case "OQ2033_32"
                    Dim objecExecl As New Frm_Oq2033_32
                    json_output = objecExecl.FNC_EXL_Oq2033_32(sql, screen, fileName, pathFile, P5)
                Case "MI1010"
                    Dim objecExecl As New Frm_MI1010
                    json_output = objecExecl.FNC_EXL_MI1010(sql, screen, fileName, pathFile)
                Case "Mq2000"
                    Dim objecExecl As New Frm_Mq2000
                    json_output = objecExecl.FNC_EXL_Mq2000(sql, screen, fileName, pathFile)
                Case "Mq2000_AVG"
                    Dim objecExecl As New Frm_Mq2000_AVG
                    json_output = objecExecl.FNC_EXL_Mq2000_AVG(sql, screen, fileName, pathFile)
                Case "OI2010"
                    Dim objecExecl As New Frm_oI2010
                    json_output = objecExecl.FNC_EXL_oI2010(sql, screen, fileName, pathFile)
                Case "Q9001"
                    Dim objecExecl As New Frm_Q9001
                    json_output = objecExecl.FNC_EXL_Q9001(sql, screen, fileName, pathFile)
                Case "RQ3010"
                    Dim objecExecl As New Frm_Rq3010
                    json_output = objecExecl.FNC_EXL_Rq3010(sql, screen, fileName, pathFile)
                Case "RQ3020"
                    Dim objecExecl As New Frm_Rq3020
                    json_output = objecExecl.FNC_EXL_Rq3020(sql, screen, fileName, pathFile)
                Case "RQ3030"
                    Dim objecExecl As New Frm_Rq3030
                    json_output = objecExecl.FNC_EXL_Rq3030(sql, screen, fileName, pathFile)
                Case "RQ3040_12"
                    Dim objecExecl As New Frm_Rq3040_12
                    json_output = objecExecl.FNC_EXL_Rq3040_12(sql, screen, fileName, pathFile, P5)
                Case "RQ3040_13"
                    Dim objecExecl As New Frm_Rq3040_13
                    json_output = objecExecl.FNC_EXL_Rq3040_13(sql, screen, fileName, pathFile, P5)
                Case "RQ3040_21"
                    Dim objecExecl As New Frm_Rq3040_21
                    json_output = objecExecl.FNC_EXL_Rq3040_21(sql, screen, fileName, pathFile, P5)
                Case "RQ3040_31"
                    Dim objecExecl As New Frm_Rq3040_31
                    json_output = objecExecl.FNC_EXL_Rq3040_31(sql, screen, fileName, pathFile, P5)
                Case "RQ3040_23"
                    Dim objecExecl As New Frm_Rq3040_23
                    json_output = objecExecl.FNC_EXL_Rq3040_23(sql, screen, fileName, pathFile, P5)
                Case "RQ3040_32"
                    Dim objecExecl As New Frm_Rq3040_32
                    json_output = objecExecl.FNC_EXL_Rq3040_32(sql, screen, fileName, pathFile, P5)
                Case "EQ0101"
                    Dim objecExecl As New Frm_eQ0101
                    json_output = objecExecl.FNC_EXL_eQ0101(sql, screen, fileName, pathFile)
                Case "EQ0200"
                    Dim objecExecl As New Frm_eQ0200
                    json_output = objecExecl.FNC_EXL_eQ0200(sql, screen, fileName, pathFile)
                Case Else
                    status = "203"
                    message = "FNC_OUT_EXL: Screen " & screen & " not found"
                    json_output = "{" + """" + "status" + """" + ":" + status + "," + """" + "filename" + """" + ":" + """" + fileName + """," + """" + "message" + """" + ":" + """" + message + """}"
                    GoTo EXIT_FUNCTION
            End Select
        Catch ex As Exception
            Utl_ERR.FNC_ERR_RTN(ex, sql)
            status = "201"
            ' 
        End Try
EXIT_FUNCTION:
        FNC_WEB_XLS = json_output
        Exit Function
    End Function

    '''*********************************************************************************************************
    ''' <summary>
    ''' Function Export CSV
    ''' </summary>
    ''' <param name="P1">SQL</param>
    ''' <param name="P2">File name</param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    '''*********************************************************************************************************
    Public Function FNC_OUT_CSV( _
        ByVal P1 As String, _
        ByVal P2 As String, _
        Optional ByVal P3 As String = "" _
    ) As String Implements IService1.FNC_OUT_CSV

        Dim D_FullName As String = String.Empty
        '
        Try
            Select Case P3
                Case "RL340"
                    D_FullName = Utl_Rpt.FNC_OUP_CSV_CUS(P_SQL:=P1, P_Name:=P2)
                Case Else
                    D_FullName = Utl_Rpt.FNC_OUP_CSV(P_SQL:=P1, P_Name:=P2)
            End Select
            
        Catch ex As Exception
            Utl_ERR.FNC_ERR_RTN(ex)
            '
        End Try
EXIT_FUNCTION:
        FNC_OUT_CSV = D_FullName
        Exit Function
EXIT_SUB:
    End Function

End Class