Imports System.Data.SqlClient
Imports System.Text.RegularExpressions
Public Class Registo
    Public sql_connection As SqlConnection

    Private Sub Registo_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        sql_connection = RailwayModule.my_sql_connection.getConnection
    End Sub
    'Sign in
    Private Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        Me.Close()
        Login.Show()
    End Sub
    ' Sign up
    Private Sub Button2_Click(sender As Object, e As EventArgs) Handles Button2.Click
        Dim fname = TextBox1.Text
        Dim lname = TextBox2.Text
        Dim birthdate = DateTimePicker1.Value.ToString("yyyy-MM-dd")
        Dim nif = TextBox3.Text
        Dim gender = ComboBox1.SelectedItem
        Dim postal_code = TextBox4.Text
        Dim city = TextBox5.Text
        Dim country = TextBox6.Text
        Dim phone = TextBox7.Text
        Dim email = TextBox8.Text
        Dim password = TextBox9.Text

        If Regex.Match(fname, "[^a-zA-Z]").Success Or fname = "" Then
            MsgBox("Invalid first name!", MsgBoxStyle.Exclamation)
            Return
        End If

        If Regex.Match(lname, "[^a-zA-Z]").Success Or lname = "" Then
            MsgBox("Invalid last name!", MsgBoxStyle.Exclamation)
            Return
        End If

        If Regex.Match(nif, "[^0-9]").Success Or Not nif.Length = 9 Then
            MsgBox("Invalid nif!", MsgBoxStyle.Exclamation)
            Return
        End If

        If gender = "" Then
            gender = "M"
        End If

        If gender = "Male" Then
            gender = "M"
        ElseIf gender = "Female" Then
            gender = "F"
        End If

        If Regex.Match(postal_code, "[^-0-9]").Success Or postal_code = "" Then
            MsgBox("Invalid postal code!", MsgBoxStyle.Exclamation)
            Return
        End If

        If Regex.Match(city, "[^a-zA-Z\s]").Success Or city = "" Then
            MsgBox("Invalid city!", MsgBoxStyle.Exclamation)
            Return
        End If

        If Regex.Match(country, "[^a-zA-Z\s]").Success Or country = "" Then
            MsgBox("Invalid country!", MsgBoxStyle.Exclamation)
            Return
        End If

        If Regex.Match(phone, "[^0-9]").Success Or Not phone.Length = 9 Then
            MsgBox("Invalid phone number!", MsgBoxStyle.Exclamation)
            Return
        End If

        If Regex.Match(email, "[^a-z0-9_@.]").Success Then
            MsgBox("Invalid email!", MsgBoxStyle.Exclamation)
            Return
        End If

        Try
            Dim a = New System.Net.Mail.MailAddress(email)
        Catch ex As Exception
            MsgBox("Invalid email!", MsgBoxStyle.Exclamation)
            Return
        End Try

        If Not Regex.Match(password, "^[a-zA-Z0-9_!@£§€#$%&/?^~-]").Success Then
            MsgBox("Invalid password!", MsgBoxStyle.Exclamation)
            Return
        End If

        If Not password = TextBox10.Text Then
            MsgBox("The passwords do not match!", MsgBoxStyle.Exclamation)
            Return
        End If


        Dim sql_command As New SqlCommand("SELECT Railway.f_check_nif (" + nif + ");", sql_connection)
        Dim exists_nif = sql_command.ExecuteScalar
        If exists_nif = 1 Then
            MsgBox("NIF " + nif + " is already associated with another user in the database.", MsgBoxStyle.Information)
            Return
        End If

        sql_command.CommandText = "SELECT Railway.f_check_login ('" + email + "');"
        Dim exists_email = sql_command.ExecuteScalar
        If exists_email = 1 Then
            MsgBox("Email " + email + " is already registered in the database.", MsgBoxStyle.Information)
            Return
        End If


        sql_command.CommandText = "Railway.pr_sign_up"
        sql_command.CommandType = CommandType.StoredProcedure
        sql_command.Parameters.Add("@fname", SqlDbType.VarChar, 30).Value = fname
        sql_command.Parameters.Add("@lname", SqlDbType.VarChar, 30).Value = lname
        sql_command.Parameters.Add("@birthdate", SqlDbType.Date).Value = birthdate
        sql_command.Parameters.Add("@nif", SqlDbType.Int).Value = nif
        sql_command.Parameters.Add("@gender", SqlDbType.Char).Value = gender
        sql_command.Parameters.Add("@postal_code", SqlDbType.VarChar, 50).Value = postal_code
        sql_command.Parameters.Add("@city", SqlDbType.VarChar, 30).Value = city
        sql_command.Parameters.Add("@country", SqlDbType.VarChar, 30).Value = country
        sql_command.Parameters.Add("@phone", SqlDbType.Int).Value = phone
        sql_command.Parameters.Add("@email", SqlDbType.VarChar, 50).Value = email
        sql_command.Parameters.Add("@pw", SqlDbType.VarChar, 50).Value = password

        sql_command.ExecuteNonQuery()

        MsgBox("Sign up completed. You will be redirected to sign in page.", MsgBoxStyle.OkOnly)
        Login.Show()
        Me.Close()
    End Sub
End Class