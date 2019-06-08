Imports System.Data.SqlClient
Public Class DeleteAccModal
    Public sql_connection As SqlConnection
    Public sql_command As SqlCommand
    Private Sub DeleteAccModal_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        sql_connection = RailwayModule.my_sql_connection.getConnection
        sql_command = New SqlCommand()
        sql_command.Connection = sql_connection
    End Sub
    ' No
    Private Sub Button4_Click(sender As Object, e As EventArgs) Handles Button4.Click
        Me.Close()
        Profile.Show()
    End Sub
    ' Yes
    Private Sub Button3_Click(sender As Object, e As EventArgs) Handles Button3.Click
        sql_command.CommandText = "Railway.pr_delete_profile "
        sql_command.CommandType = CommandType.StoredProcedure
        sql_command.Parameters.Add("@user_id", SqlDbType.Int).Value = RailwayModule.currentUser.user_id
        sql_command.ExecuteNonQuery()
        MsgBox("Account Deleted. You will be redirected to the Home Page.", MsgBoxStyle.OkOnly)
        Me.Close()
        HomePage.Show()
    End Sub
End Class