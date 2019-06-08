Imports System.Data.SqlClient
Public Class DisplaySearch
    Public sql_connection As SqlConnection
    Public sql_command As SqlCommand

    Private Sub DisplaySearch_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Label7.Text = "Trips from " + RailwayModule.dep_station + " to " + RailwayModule.arr_station + " - " + RailwayModule.trip_date
        sql_connection = RailwayModule.my_sql_connection.getConnection
        Dim sql_data_reader As SqlDataReader
        sql_command = New SqlCommand("SELECT * FROM Railway.f_get_trips('" + RailwayModule.dep_station + "', '" + RailwayModule.arr_station + "');", sql_connection)

        sql_data_reader = sql_command.ExecuteReader
        Dim i = 0
        While sql_data_reader.Read
            ListView1.Items.Add(sql_data_reader.Item("trip_no").ToString)
            ListView1.Items(i).SubItems.Add(sql_data_reader.Item("trip_type").ToString)
            ListView1.Items(i).SubItems.Add(sql_data_reader.Item("dep_timestamp").ToString.Substring(0, 5))
            ListView1.Items(i).SubItems.Add(sql_data_reader.Item("arr_timestamp").ToString.Substring(0, 5))
            ListView1.Items(i).SubItems.Add(sql_data_reader.Item("duration").ToString.Substring(0, 5))
            Dim priceLength = sql_data_reader.Item("price").ToString.Length
            RailwayModule.price = sql_data_reader.Item("price").ToString.Substring(0, priceLength - 2)
            ListView1.Items(i).SubItems.Add(RailwayModule.price + " €")
            ListView1.Items(i).SubItems.Add(New Button().ToString)
            i += 1
        End While

        sql_data_reader.Close()
        Console.WriteLine("RAILWAY LOG: Readed all trips")
    End Sub
    Private Sub PictureBox1_Click(sender As Object, e As EventArgs)
        Me.Hide()
        HomePage.Show()
    End Sub
    'Go back
    Private Sub PictureBox1_Click_1(sender As Object, e As EventArgs) Handles PictureBox1.Click
        Me.Close()
        PlanTrip.Show()
    End Sub

    Private Sub ListView1_MouseClick(sender As Object, e As MouseEventArgs) Handles ListView1.MouseClick
        RailwayModule.chosen_trip = ListView1.Items(ListView1.FocusedItem.Index).SubItems(0).Text
        RailwayModule.trip_type = ListView1.Items(ListView1.FocusedItem.Index).SubItems(1).Text
        RailwayModule.dep_timestamp = ListView1.Items(ListView1.FocusedItem.Index).SubItems(2).Text
        RailwayModule.arr_timestamp = ListView1.Items(ListView1.FocusedItem.Index).SubItems(3).Text
        RailwayModule.duration = ListView1.Items(ListView1.FocusedItem.Index).SubItems(4).Text
        Me.Hide()
        ChooseClass.Show()
    End Sub

End Class