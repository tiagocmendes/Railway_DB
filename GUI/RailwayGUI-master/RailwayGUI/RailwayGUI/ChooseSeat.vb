Imports System.Data.SqlClient
Public Class ChooseSeat
    Public sql_connection As SqlConnection
    Public sql_command As SqlCommand
    Public sql_data_reader As SqlDataReader
    Private Sub ChooseSeat_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Label1.Text = "Choose seat - Carriage no. " + RailwayModule.carriage_no + ", class " + RailwayModule.carriage_class

        If RailwayModule.tickets_quantity >= 2 Then
            PictureBox4.Visible = True
            ComboBox2.Visible = True
        End If

        If RailwayModule.tickets_quantity = 3 Then
            PictureBox5.Visible = True
            ComboBox3.Visible = True
        End If

        sql_connection = RailwayModule.my_sql_connection.getConnection
        sql_command = New SqlCommand("EXEC Railway.pr_get_seats_no " + RailwayModule.train_no + "," + RailwayModule.carriage_no + ";", sql_connection)
        Dim seats_no = sql_command.ExecuteScalar
        Label2.Text = "Max seats: " + seats_no.ToString

        Dim occupied_seats(seats_no) As Integer

        sql_command.CommandText = "EXEC Railway.pr_get_reserved_seats " + RailwayModule.chosen_trip + ", '" + RailwayModule.trip_date + "', " + RailwayModule.carriage_no + ";"
        sql_data_reader = sql_command.ExecuteReader
        Dim s = 0
        While sql_data_reader.Read
            occupied_seats(s) = sql_data_reader.Item("seat_no")
            s += 1
        End While
        sql_data_reader.Close()

        Dim i = 1
        While Not i > seats_no
            If Not occupied_seats.Contains(i) Then
                ComboBox1.Items.Add(i)
                ComboBox2.Items.Add(i)
                ComboBox3.Items.Add(i)
            End If
            i += 1
        End While

    End Sub
    Private Sub PictureBox1_Click(sender As Object, e As EventArgs) Handles PictureBox1.Click
        Me.Close()
        ChooseClass.Show()
    End Sub

    Private Sub PictureBox6_Click(sender As Object, e As EventArgs) Handles PictureBox6.Click
        If ComboBox1.Text = "" Or ComboBox1.Text = ComboBox2.Text Or ComboBox1.Text = ComboBox3.Text Then
            MsgBox("You need to choose a different seat.", MsgBoxStyle.Information)
            Return
        End If
        RailwayModule.seat01 = ComboBox1.Text

        If ComboBox2.Visible = True Then
            If ComboBox2.Text = "" Or ComboBox2.Text = ComboBox1.Text Or ComboBox2.Text = ComboBox3.Text Then
                MsgBox("You need to choose a different seat.", MsgBoxStyle.Information)
                Return
            End If
        End If

        RailwayModule.seat02 = ComboBox2.Text
        If ComboBox3.Visible = True Then
            If ComboBox3.Text = "" Or ComboBox3.Text = ComboBox1.Text Or ComboBox3.Text = ComboBox2.Text Then
                MsgBox("You need to choose a different seat.", MsgBoxStyle.Information)
                Return
            End If
        End If

        RailwayModule.seat03 = ComboBox3.Text
        Me.Hide()
        Discount.Show()
    End Sub
End Class