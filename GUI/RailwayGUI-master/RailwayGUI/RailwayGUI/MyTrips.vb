Imports System.Data.SqlClient
Public Class MyTrips
    Public sql_connection As SqlConnection
    Public sql_command As SqlCommand
    Public sql_data_reader As SqlDataReader
    ' Back button
    Private Sub MyTrips_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        sql_connection = RailwayModule.my_sql_connection.getConnection
        sql_command = New SqlCommand("EXEC Railway.pr_get_passenger_tickets " + RailwayModule.currentUser.user_id + ";", sql_connection)

        sql_data_reader = sql_command.ExecuteReader
        Dim i = 0
        While sql_data_reader.Read
            ListView1.Items.Add(sql_data_reader.Item("ticket_no").ToString)
            ListView1.Items(i).SubItems.Add(sql_data_reader.Item("dep_station").ToString)
            ListView1.Items(i).SubItems.Add(sql_data_reader.Item("arr_station").ToString)
            ListView1.Items(i).SubItems.Add(sql_data_reader.Item("dep_timestamp").ToString.Substring(0, 5))
            ListView1.Items(i).SubItems.Add(sql_data_reader.Item("arr_timestamp").ToString.Substring(0, 5))
            ListView1.Items(i).SubItems.Add(sql_data_reader.Item("train_no").ToString)
            ListView1.Items(i).SubItems.Add(sql_data_reader.Item("carriage_no").ToString)
            ListView1.Items(i).SubItems.Add(sql_data_reader.Item("seat_no").ToString)
            Dim priceLength = sql_data_reader.Item("price").ToString.Length
            ListView1.Items(i).SubItems.Add(sql_data_reader.Item("price").ToString.Substring(0, priceLength - 2) + " €")
            ListView1.Items(i).SubItems.Add(sql_data_reader.Item("trip_date").ToString)
            ListView1.Items(i).SubItems.Add(sql_data_reader.Item("duration").ToString.Substring(0, 5))
            ListView1.Items(i).SubItems.Add(sql_data_reader.Item("trip_type").ToString)
            i += 1
        End While

        sql_data_reader.Close()
    End Sub
    Private Sub PictureBox1_Click(sender As Object, e As EventArgs) Handles PictureBox1.Click
        Me.Close()
        HomePage.Show()
    End Sub
End Class