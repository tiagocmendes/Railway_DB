Imports System.Data.SqlClient
Imports System.Text.RegularExpressions
Public Class EditProfile
    Public sql_connection As SqlConnection
    Public sql_command As SqlCommand
    Public changedPic = ""
    Private Sub EditProfile_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        sql_connection = RailwayModule.my_sql_connection.getConnection
        sql_command = New SqlCommand()
        sql_command.Connection = sql_connection
        PictureBox3.Image = SaveImages.Base64ToImage(RailwayModule.currentUser.profilePicture)
    End Sub
    ' Cancel
    Private Sub Button2_Click(sender As Object, e As EventArgs) Handles Button2.Click
        Dim modal As New Modal
        modal.ShowDialog()
    End Sub
    'Confirm
    Private Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        sql_command.CommandText = "Railway.pr_edit_profile "
        sql_command.CommandType = CommandType.StoredProcedure
        sql_command.Parameters.Add("@email", SqlDbType.VarChar, 50).Value = RailwayModule.currentUser.email
        sql_command.Parameters.Add("@nif", SqlDbType.Int).Value = RailwayModule.currentUser.nif

        Dim fn_text = fname.Text
        Dim ln_text = lname.Text
        Dim gender_text = gender.SelectedItem
        Dim postal_code = pcode.Text
        Dim city_text = city.Text
        Dim country_text = country.Text
        Dim phone_text = phone.Text
        Dim password_text = password.Text
        Dim password_confirm_text = password_confirm.Text

        If Not fn_text = "" Then
            If Regex.Match(fn_text, "[^a-zA-Z]").Success Then
                MsgBox("Invalid first name!", MsgBoxStyle.Exclamation)
                Return
            End If
            sql_command.Parameters.Add("@fname", SqlDbType.VarChar, 30).Value = fn_text
            RailwayModule.currentUser.fname = fn_text
        Else
            sql_command.Parameters.Add("@fname", SqlDbType.VarChar, 30).Value = "NULL"
        End If
        Console.WriteLine("fn_text: " + fn_text)

        If Not ln_text = "" Then
            If Regex.Match(ln_text, "[^a-zA-Z]").Success Then
                MsgBox("Invalid last name!", MsgBoxStyle.Exclamation)
                Return
            End If
            sql_command.Parameters.Add("@lname", SqlDbType.VarChar, 30).Value = ln_text
            RailwayModule.currentUser.lname = ln_text
        Else
            sql_command.Parameters.Add("@lname", SqlDbType.VarChar, 30).Value = "NULL"
        End If
        Console.WriteLine("ln_text: " + ln_text)

        If gender_text = "" Then
            sql_command.Parameters.Add("@gender", SqlDbType.Char).Value = "N"
        ElseIf gender_text = "Male" Then
            gender_text = "M"
            sql_command.Parameters.Add("@gender", SqlDbType.Char).Value = gender_text
        ElseIf gender_text = "Female" Then
            gender_text = "F"
            sql_command.Parameters.Add("@gender", SqlDbType.Char).Value = gender_text
            RailwayModule.currentUser.gender = gender_text
        End If
        Console.WriteLine("gender_text: " + gender_text)

        If Not postal_code = "" Then
            If Regex.Match(postal_code, "[^-0-9]").Success Then
                MsgBox("Invalid postal code!", MsgBoxStyle.Exclamation)
                Return
            End If
            sql_command.Parameters.Add("@postal_code", SqlDbType.VarChar, 50).Value = postal_code
            RailwayModule.currentUser.postalCode = postal_code
        Else
            sql_command.Parameters.Add("@postal_code", SqlDbType.VarChar, 50).Value = "NULL"
        End If
        Console.WriteLine("postal_code: " + postal_code)

        If Not city_text = "" Then
            If Regex.Match(city_text, "[^a-zA-Z\s]").Success Then
                MsgBox("Invalid city!", MsgBoxStyle.Exclamation)
                Return
            End If
            sql_command.Parameters.Add("@city", SqlDbType.VarChar, 30).Value = city_text
            RailwayModule.currentUser.city = city_text
        Else
            sql_command.Parameters.Add("@city", SqlDbType.VarChar, 30).Value = "NULL"
        End If
        Console.WriteLine("city_text: " + city_text)

        If Not country_text = "" Then
            If Regex.Match(country_text, "[^a-zA-Z\s]").Success Then
                MsgBox("Invalid country!", MsgBoxStyle.Exclamation)
                Return
            End If
            sql_command.Parameters.Add("@country", SqlDbType.VarChar, 30).Value = country_text
            RailwayModule.currentUser.country = country_text
        Else
            sql_command.Parameters.Add("@country", SqlDbType.VarChar, 30).Value = "NULL"
        End If
        Console.WriteLine("country_text: " + country_text)

        If Not phone_text = "" Then
            If Regex.Match(phone_text, "[^0-9]").Success Or phone_text < 900000000 Or phone_text > 999999999 Then
                MsgBox("Invalid phone number!", MsgBoxStyle.Exclamation)
                Return
            End If
            sql_command.Parameters.Add("@phone", SqlDbType.Int).Value = phone_text
        Else
            sql_command.Parameters.Add("@phone", SqlDbType.Int).Value = 0
            RailwayModule.currentUser.phone = phone_text
        End If
        Console.WriteLine("phone_text: " + phone_text)

        If Not password_text = "" Then
            If Not Regex.Match(password_text, "^[a-zA-Z0-9_!@£§€#$%&/?^~-]").Success Then
                MsgBox("Invalid password!", MsgBoxStyle.Exclamation)
                Return
            End If
            If Not password_text = password_confirm_text Then
                MsgBox("The passwords Do Not match!", MsgBoxStyle.Exclamation)
                Return
            End If
            sql_command.Parameters.Add("@new_password", SqlDbType.VarChar, 50).Value = password_text
        Else
            sql_command.Parameters.Add("@new_password", SqlDbType.VarChar, 50).Value = "NULL"
        End If
        Console.WriteLine("password_text: " + password_text)

        sql_command.ExecuteNonQuery()

        If Not changedPic = "" Then
            sql_command.CommandText = "Railway.pr_insert_image"
            sql_command.CommandType = CommandType.StoredProcedure
            sql_command.Parameters.Clear()
            sql_command.Parameters.Add("@passenger_id", SqlDbType.Int).Value = RailwayModule.currentUser.user_id
            sql_command.Parameters.Add("@img_base64", SqlDbType.VarChar, changedPic.ToString.Length).Value = changedPic
            RailwayModule.currentUser.profilePicture = changedPic
            sql_command.ExecuteScalar()
        End If


        MsgBox("Changes completed. You will be redirected to your profile page.", MsgBoxStyle.OkOnly)

        Me.Close()
        Profile.Show()
    End Sub

    Private Sub Button3_Click(sender As Object, e As EventArgs) Handles Button3.Click
        Dim ofd As New OpenFileDialog()

        ofd.ShowDialog()
        changedPic = SaveImages.ToBase64String(ofd.FileName)

        PictureBox3.Image = SaveImages.Base64ToImage(changedPic)
    End Sub

End Class