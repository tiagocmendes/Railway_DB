Imports System.Data.SqlClient
Public Class Registo
    Public sql_connection As SqlConnection
    Private Sub Registo_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        sql_connection = MySqlConnection.open_sql_connection()
    End Sub
    Private Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        Me.Hide()
        Login.Show()
    End Sub
End Class