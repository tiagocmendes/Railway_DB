Imports System.Data.SqlClient
Public Class MySqlConnection

    Private _sql_connection As SqlConnection

    Public Sub New()
        Dim dbServer = "tcp:mednat.ieeta.pt\SQLSERVER,8101"
        Dim dbName = "p6g10"
        Dim userName = "p6g10"
        Dim userPass = "#RECONQUISTA2019"
        Me._sql_connection = New SqlConnection("Data Source = " + dbServer + " ;" + "Initial Catalog = " + dbName + "; uid = " + userName + "; password = " + userPass)

        Try
            Me._sql_connection.Open()
            If Me._sql_connection.State = ConnectionState.Open Then
                Console.WriteLine("RAILWAY LOG: Successful connection to database " + Me._sql_connection.Database + " on the " + Me._sql_connection.DataSource + " server.")
            End If

        Catch ex As Exception
            Console.WriteLine("RAILWAY LOG: FAILED TO OPEN CONNECTION TO DATABASE DUE TO THE FOLLOWING ERROR" + vbCrLf + ex.Message)
            Application.Exit()
        End Try
    End Sub

    Public Property getConnection() As SqlConnection
        Get
            Return Me._sql_connection
        End Get
        Set(ByVal value As SqlConnection)
            Me._sql_connection = value
        End Set
    End Property

    Public Shared Function close_sql_connection(sql_connection As SqlConnection)
        If sql_connection.State = ConnectionState.Open Then sql_connection.Close()
        Console.WriteLine("RAILWAY LOG: Succesfull closed connection to database " + sql_connection.Database + " on the " + sql_connection.DataSource + " server.")
    End Function
End Class