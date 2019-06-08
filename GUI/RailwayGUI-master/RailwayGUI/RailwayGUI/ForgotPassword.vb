Imports System.Data.SqlClient
Imports System.Text.RegularExpressions
Public Class ForgotPassword
    Public sql_connection As SqlConnection
    Public sql_command As SqlCommand
    Dim sql_data_reader As SqlDataReader
    ' Confirm
    Private Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        Dim pw = password.Text
        Dim pw_confirm = password_confirm.Text
        Dim e_mail = email.Text

        If e_mail = "" Or pw = "" Or pw_confirm = "" Then
            MsgBox("Please fill all the fields!", MsgBoxStyle.Exclamation)
            Return
        End If

        If Regex.Match(e_mail, "^[']").Success Then
            MsgBox("Invalid email!", MsgBoxStyle.Exclamation)
            Return
        End If

        Try
            Dim a = New System.Net.Mail.MailAddress(e_mail)
        Catch ex As Exception
            MsgBox("Invalid email!", MsgBoxStyle.Exclamation)
            Return
        End Try

        Console.WriteLine("RAILWAY LOG: Valid email")

        If Not Regex.Match(pw, "^[a-zA-Z0-9_!@£§€#$%&/?^~-]").Success Then
            MsgBox("Invalid password!", MsgBoxStyle.Exclamation)
            Return
        End If

        If Not pw = pw_confirm Then
            MsgBox("The passwords Do Not match!", MsgBoxStyle.Exclamation)
            Return
        End If

        Console.WriteLine("RAILWAY LOG: Valid password")

        sql_command.CommandText = "SELECT Railway.f_check_login ('" + e_mail + "');"
        Dim exists_email = sql_command.ExecuteScalar
        If Not exists_email = 1 Then
            MsgBox(e_mail + " does not exist in the database. Please, provide a valid email.", MsgBoxStyle.Information)
            Return
        End If

        Console.WriteLine("RAILWAY LOG: " + e_mail + " exist in the database")

        sql_command.CommandText = "SELECT Railway.f_check_password ('" + e_mail + "', '" + pw + "');"
        Dim correct_password = sql_command.ExecuteScalar

        If Not correct_password = 0 Then
            MsgBox("You inserted the correct password!", MsgBoxStyle.Exclamation)
            Return
        End If

        Console.WriteLine("RAILWAY LOG: correct password for " + e_mail)

        sql_command.CommandText = "Railway.pr_forgot_password"
        sql_command.CommandType = CommandType.StoredProcedure
        sql_command.Parameters.Add("@email", SqlDbType.VarChar, 50).Value = e_mail
        sql_command.Parameters.Add("@password", SqlDbType.VarChar, 50).Value = pw

        sql_command.ExecuteNonQuery()
        MsgBox("Changes completed. You will be redirected to your profile page.", MsgBoxStyle.OkOnly)

        Me.Close()
        Login.Show()
    End Sub
    'Cancel
    Private Sub Button2_Click(sender As Object, e As EventArgs) Handles Button2.Click
        Me.Close()
        Login.Show()
    End Sub
    Private Sub ForgotPassword_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        RailwayModule.my_sql_connection = New MySqlConnection
        sql_connection = RailwayModule.my_sql_connection.getConnection
        sql_command = New SqlCommand()
        sql_command.Connection = sql_connection
    End Sub
End Class