Imports System.Data.SqlClient
Public Class Confirm
    Public sql_connection As SqlConnection
    Public sql_command As SqlCommand
    Public sql_command_photo As SqlCommand
    Private Sub Button3_Click(sender As Object, e As EventArgs) Handles Button3.Click
        sql_connection = RailwayModule.my_sql_connection.getConnection
        sql_command = New SqlCommand()
        sql_command_photo = New SqlCommand()
        sql_command_photo.Connection = sql_connection
        sql_command.Connection = sql_connection
        sql_command_photo.CommandText = "Railway.pr_delete_image"
        sql_command.CommandText = "Railway.pr_delete_profile "
        sql_command_photo.CommandType = CommandType.StoredProcedure
        sql_command.CommandType = CommandType.StoredProcedure
        sql_command_photo.Parameters.Add("@passenger_id", SqlDbType.Int).Value = RailwayModule.currentUser.user_id
        sql_command.Parameters.Add("@user_id", SqlDbType.Int).Value = RailwayModule.currentUser.user_id
        sql_command.Parameters.Add("@nif", SqlDbType.Int).Value = RailwayModule.currentUser.nif
        sql_command_photo.ExecuteNonQuery()
        sql_command.ExecuteNonQuery()
        MsgBox("Account Deleted. You will be redirected to the Home Page.", MsgBoxStyle.OkOnly)
        Me.Close()
        Profile.Close()
        Login.Show()
    End Sub

    Private Sub Button4_Click(sender As Object, e As EventArgs) Handles Button4.Click
        Me.Close()
        Profile.Enabled = True
    End Sub
End Class