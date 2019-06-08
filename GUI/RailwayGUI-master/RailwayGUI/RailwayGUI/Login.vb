Imports System.Data.SqlClient
Imports System.Text.RegularExpressions
Public Class Login
    Public sql_connection As SqlConnection
    Public sql_command As SqlCommand
    Dim sql_data_reader As SqlDataReader
    Private Sub Login_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        RailwayModule.my_sql_connection = New MySqlConnection
        sql_connection = RailwayModule.my_sql_connection.getConnection
        sql_command = New SqlCommand()
        sql_command.Connection = sql_connection
    End Sub
    ' Sign in
    Private Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        Dim email = TextBox1.Text
        Dim password = TextBox2.Text

        If email = "" Or password = "" Then
            MsgBox("Please fill all the fields!", MsgBoxStyle.Exclamation)
            Return
        End If

        If Regex.Match(email, "^[']").Success Then
            MsgBox("Invalid email!", MsgBoxStyle.Exclamation)
            Return
        End If

        Try
            Dim a = New System.Net.Mail.MailAddress(email)
        Catch ex As Exception
            MsgBox("Invalid email!", MsgBoxStyle.Exclamation)
            Return
        End Try

        Console.WriteLine("RAILWAY LOG: Valid email")

        If Not Regex.Match(password, "^[a-zA-Z0-9_!@£§€#$%&/?^~-]").Success Then
            MsgBox("Invalid password!", MsgBoxStyle.Exclamation)
            Return
        End If

        Console.WriteLine("RAILWAY LOG: Valid password")

        sql_command.CommandText = "SELECT Railway.f_check_login ('" + email + "');"
        Dim exists_email = sql_command.ExecuteScalar
        If Not exists_email = 1 Then
            MsgBox(email + " does not exist in the database. Please, sign up.", MsgBoxStyle.Information)
            Return
        End If

        Console.WriteLine("RAILWAY LOG: " + email + " exist in the database")

        sql_command.CommandText = "SELECT Railway.f_check_password ('" + email + "', '" + password + "');"
        Dim correct_password = sql_command.ExecuteScalar

        If Not correct_password = 1 Then
            MsgBox("Password is incorrect!", MsgBoxStyle.Exclamation)
            Return
        End If

        Console.WriteLine("RAILWAY LOG: correct password for " + email)

        sql_command.CommandText = "SELECT * FROM Railway.f_return_login ('" + email + "', '" + password + "');"

        sql_data_reader = sql_command.ExecuteReader

        While sql_data_reader.Read
            Dim _userID = sql_data_reader.Item("id")
            Dim _fname = sql_data_reader.Item("fname")
            Dim _lname = sql_data_reader.Item("lname")
            Dim _birthdate = sql_data_reader.Item("birthdate")
            Dim _nif = sql_data_reader.Item("nif")
            Dim _gender = sql_data_reader.Item("gender")
            Dim _postalCode = sql_data_reader.Item("postal_code")
            Dim _city = sql_data_reader.Item("city")
            Dim _country = sql_data_reader.Item("country")
            Dim _phone = sql_data_reader.Item("phone")
            Dim _passengerID = sql_data_reader.Item("passenger_id")
            Dim _email = sql_data_reader.Item("email")

            RailwayModule.currentUser = New CurrentUser(
                _userID,
                _fname,
                _lname,
                _birthdate,
                _nif,
                _gender,
                _postalCode,
                _city,
                _country,
                _phone,
                _passengerID,
                _email)
        End While
        sql_data_reader.Close()
        Console.WriteLine("RAILWAY LOG: user sucessful logged in. Current user: " + RailwayModule.currentUser.ToString)
        TextBox1.Text = ""
        TextBox2.Text = ""
        Me.Hide()
        HomePage.Show()

    End Sub
    'Sign Up
    Private Sub Button2_Click(sender As Object, e As EventArgs) Handles Button2.Click
        Me.Hide()
        Registo.Show()
    End Sub
    ' Forgot Password
    Private Sub Label3_Click(sender As Object, e As EventArgs) Handles Label3.Click
        Me.Hide()
        ForgotPassword.Show()
    End Sub
End Class
