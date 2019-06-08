Imports System.Data.SqlClient
Public Class ChooseClass
    Public sql_connection As SqlConnection
    Public sql_command As SqlCommand
    Public sql_data_reader As SqlDataReader
    Public currentPrice As Double
    Private Sub ChooseClass_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        sql_connection = RailwayModule.my_sql_connection.getConnection
        sql_command = New SqlCommand("SELECT Railway.f_insert_trip_instance(" + RailwayModule.chosen_trip + ", '" + RailwayModule.trip_date + "');", sql_connection)
        currentPrice = CDbl(RailwayModule.price)
        Label2.Text = "Current price: " + currentPrice.ToString + " €"
        If sql_command.ExecuteScalar = 1 Then
            sql_command.CommandText = "EXEC Railway.pr_insert_trip_instance " + RailwayModule.chosen_trip + ",'" + RailwayModule.trip_date + "';"
            sql_command.ExecuteScalar()
        End If

        sql_command.CommandText = "EXEC Railway.pr_get_train_no " + RailwayModule.chosen_trip + ";"
        RailwayModule.train_no = sql_command.ExecuteScalar

        sql_command.CommandText = "EXEC Railway.pr_get_train_classes " + RailwayModule.train_no + ";"
        sql_data_reader = sql_command.ExecuteReader
        While sql_data_reader.Read
            ComboBox1.Items.Add(sql_data_reader.Item("class"))
        End While
        sql_data_reader.Close()
    End Sub



    Private Sub PictureBox1_Click(sender As Object, e As EventArgs) Handles PictureBox1.Click
        Me.Close()
        DisplaySearch.Show()
    End Sub

    Private Sub PictureBox5_Click(sender As Object, e As EventArgs) Handles PictureBox5.Click
        If Not ComboBox1.Text = "" And Not ComboBox2.Text = "" And Not ComboBox3.Text = "" Then
            RailwayModule.carriage_class = ComboBox1.Text
            RailwayModule.tickets_quantity = ComboBox2.Text
            RailwayModule.carriage_no = ComboBox3.Text
            RailwayModule.price = currentPrice
            RailwayModule.baseprice = currentPrice
            Me.Hide()
            ChooseSeat.Show()
        Else
            MsgBox("You need to specify a class, number of the carriage and quantity of tickets!", MsgBoxStyle.Information)
        End If
    End Sub

    Private Sub ComboBox1_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ComboBox1.SelectedIndexChanged
        If ComboBox1.Text = "E" Then
            currentPrice = RailwayModule.price
        Else
            currentPrice += 5
        End If
        Label2.Text = "Current price: " + currentPrice.ToString + " €"
        ComboBox3.Items.Clear()
        sql_command.CommandText = "EXEC Railway.pr_get_train_carriages " + RailwayModule.train_no + ", '" + ComboBox1.Text + "';"
        sql_data_reader = sql_command.ExecuteReader
        While sql_data_reader.Read
            ComboBox3.Items.Add(sql_data_reader.Item("carriage_no"))
        End While
        sql_data_reader.Close()
    End Sub

    Private Sub ComboBox2_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ComboBox2.SelectedIndexChanged
        currentPrice = RailwayModule.price
        currentPrice *= CInt(ComboBox2.Text)
        Label2.Text = "Current price: " + currentPrice.ToString + " €"
    End Sub
End Class