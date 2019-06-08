Imports System.Data.SqlClient
Public Class PlanTrip
    Public sql_connection As SqlConnection
    Public sql_command As SqlCommand
    Dim sql_data_reader As SqlDataReader
    Private Sub PlanTrip_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        sql_connection = RailwayModule.my_sql_connection.getConnection
        sql_command = New SqlCommand()
        sql_command.Connection = sql_connection

        sql_command.CommandText = "EXEC Railway.pr_get_stations;"
        sql_data_reader = sql_command.ExecuteReader
        Console.WriteLine("RAILWAY LOG: Getting stations names")
        While sql_data_reader.Read
            ComboBox1.Items.Add(sql_data_reader.Item("station_name"))
            ComboBox2.Items.Add(sql_data_reader.Item("station_name"))
        End While
        sql_data_reader.Close()
        Console.WriteLine("RAILWAY LOG: Closing sql_data_reader")
    End Sub
    'Go back button
    Private Sub PictureBox1_Click(sender As Object, e As EventArgs) Handles PictureBox1.Click
        Me.Close()
        HomePage.Show()
    End Sub

    'Search Button
    Private Sub Button2_Click(sender As Object, e As EventArgs) Handles Button2.Click
        If ComboBox1.SelectedItem = ComboBox2.SelectedItem Then
            MsgBox("Departure and arrival stations can not be the same.", MsgBoxStyle.Information)
            Return
        End If

        If ComboBox1.SelectedItem = "" Or ComboBox2.SelectedItem = "" Then
            MsgBox("You need to specify one departure and one arrival stations", MsgBoxStyle.Information)
            Return
        End If

        RailwayModule.dep_station = ComboBox1.SelectedItem
        RailwayModule.arr_station = ComboBox2.SelectedItem
        RailwayModule.trip_date = DateTimePicker1.Value.ToString("yyyy-MM-dd")
        Console.WriteLine("RAILWAY LOG: Finding trips from " + dep_station + " to " + arr_station)
        Me.Close()
        DisplaySearch.Show()
    End Sub
    ' If departure and arrival are the same
    Private Sub ComboBox1_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ComboBox1.SelectedIndexChanged
        If ComboBox1.SelectedItem = ComboBox2.SelectedItem Then
            MsgBox("Departure and arrival stations can not be the same.", MsgBoxStyle.Information)
        End If
    End Sub
    ' If departure and arrival are the same
    Private Sub ComboBox2_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ComboBox2.SelectedIndexChanged
        If ComboBox1.SelectedItem = ComboBox2.SelectedItem Then
            MsgBox("Departure and arrival stations can not be the same.", MsgBoxStyle.Information)
        End If
    End Sub

End Class