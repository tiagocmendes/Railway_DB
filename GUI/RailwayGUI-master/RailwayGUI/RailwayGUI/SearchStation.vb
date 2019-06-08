Imports System.Data.SqlClient
Public Class SearchStation
    Public sql_connection As SqlConnection
    Public sql_command As SqlCommand
    Private Sub SearchStation_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        sql_connection = RailwayModule.my_sql_connection.getConnection

    End Sub
    'Go Back
    Private Sub PictureBox1_Click_1(sender As Object, e As EventArgs) Handles PictureBox1.Click
        Me.Close()
        HomePage.Show()
    End Sub

    Private Sub search_box_TextChanged(sender As Object, e As EventArgs) Handles search_box.TextChanged
        stations.Items.Clear()
        sql_connection = RailwayModule.my_sql_connection.getConnection
        Dim sql_data_reader As SqlDataReader
        sql_command = New SqlCommand()
        sql_command.Connection = sql_connection
        sql_command.CommandText = "Railway.pr_search_station "
        sql_command.CommandType = CommandType.StoredProcedure
        sql_command.Parameters.Add("@station_name", SqlDbType.VarChar, 50).Value = search_box.Text

        sql_data_reader = sql_command.ExecuteReader
        Dim i = 0
        While sql_data_reader.Read
            stations.Items.Add(sql_data_reader.Item("station_name").ToString)
            stations.Items(i).SubItems.Add(sql_data_reader.Item("locality_name").ToString)
            stations.Items(i).SubItems.Add(sql_data_reader.Item("zone_no").ToString)
            stations.Items(i).SubItems.Add(sql_data_reader.Item("zone_name").ToString)
            Dim name = sql_data_reader.Item("fname").ToString + " " + sql_data_reader.Item("lname").ToString
            stations.Items(i).SubItems.Add(name)
            i += 1
        End While

        sql_data_reader.Close()
    End Sub
End Class