Imports System.Data.SqlClient
Public Class Profile
    Public sql_connection As SqlConnection
    Public sql_command As SqlCommand
    'Edit Profile
    Private Sub Button2_Click(sender As Object, e As EventArgs) Handles Button2.Click
        Me.Close()
        EditProfile.Show()
    End Sub

    'End Session
    Private Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        Me.Enabled = False
        Confirm.Show()
    End Sub

    Private Sub Profile_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        sql_connection = RailwayModule.my_sql_connection.getConnection
        sql_command = New SqlCommand()
        sql_command.Connection = sql_connection

        fname.Enabled = False
        lname.Enabled = False
        bdate.Enabled = False
        nif.Enabled = False
        gender.Enabled = False
        email.Enabled = False
        pcode.Enabled = False
        city.Enabled = False
        country.Enabled = False

        fname.Text = RailwayModule.currentUser.fname
        lname.Text = RailwayModule.currentUser.lname
        bdate.Text = RailwayModule.currentUser.birthdate
        nif.Text = RailwayModule.currentUser.nif
        gender.Text = RailwayModule.currentUser.gender
        email.Text = RailwayModule.currentUser.email
        pcode.Text = RailwayModule.currentUser.postalCode
        city.Text = RailwayModule.currentUser.city
        country.Text = RailwayModule.currentUser.country

        sql_command.CommandText = "SELECT Railway.f_check_profile_picture(" + RailwayModule.currentUser.user_id + ");"

        If sql_command.ExecuteScalar = 0 Then
            If RailwayModule.currentUser.gender = "M" Then
                sql_command.CommandText = "EXEC Railway.pr_get_default_picture 4;"
            Else
                sql_command.CommandText = "EXEC Railway.pr_get_default_picture 5;"
            End If
        Else
            sql_command.CommandText = "EXEC Railway.pr_get_profile_picture " + RailwayModule.currentUser.user_id + ";"

        End If
        RailwayModule.currentUser.profilePicture = sql_command.ExecuteScalar
        PictureBox3.Image = SaveImages.Base64ToImage(RailwayModule.currentUser.profilePicture)

    End Sub
    'Go back
    Private Sub PictureBox1_Click_1(sender As Object, e As EventArgs) Handles PictureBox1.Click
        Me.Close()
        HomePage.Show()
    End Sub

End Class