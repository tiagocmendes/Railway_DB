Imports System.Data.SqlClient
Public Class HomePage
    Public sql_connection As SqlConnection
    Public sql_command As SqlCommand
    Public sql_data_reader As SqlDataReader
    Private Sub HomePage_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        sql_connection = RailwayModule.my_sql_connection.getConnection
        Label2.Text = "Welcome, " + RailwayModule.currentUser.fname + " " + RailwayModule.currentUser.lname + "!"

        'Console.WriteLine(SaveImages.ToBase64String("C:\Users\Tiago\Desktop\male.jpg"))
        'Console.WriteLine(SaveImages.ToBase64String("C:\Users\Tiago\Desktop\female.jpg"))
        RailwayModule.chosen_trip = ""
        RailwayModule.dep_station = ""
        RailwayModule.arr_station = ""
        RailwayModule.trip_date = ""
        RailwayModule.trip_type = ""
        RailwayModule.dep_timestamp = ""
        RailwayModule.arr_timestamp = ""
        RailwayModule.duration = ""
        RailwayModule.price = ""
        RailwayModule.train_no = ""
        RailwayModule.carriage_class = ""
        RailwayModule.carriage_no = ""
        RailwayModule.tickets_quantity = ""
        RailwayModule.promocode = ""
        RailwayModule.discount = ""
        RailwayModule.seat01 = ""
        RailwayModule.seat02 = ""
        RailwayModule.seat03 = ""
        RailwayModule.dep_station_name = ""
        RailwayModule.arr_station_name = ""
        RailwayModule.baseprice = ""
        RailwayModule.ticket_no = ""

        sql_command = New SqlCommand("EXEC Railway.pr_get_ticket_basic_info " + RailwayModule.currentUser.user_id + ";", sql_connection)
        sql_data_reader = sql_command.ExecuteReader
        Dim i = 0
        While sql_data_reader.Read
            Label6.Visible = False
            Label7.Visible = True
            Label8.Visible = True
            Label9.Visible = True
            Label10.Visible = True
            Label11.Visible = True
            Label12.Visible = True
            Label13.Visible = True
            Label14.Visible = True
            Label15.Visible = True
            Label16.Visible = True
            Label16.Text = sql_data_reader.Item("dep_station").ToString
            Label15.Text = sql_data_reader.Item("arr_station").ToString
            Label14.Text = sql_data_reader.Item("dep_timestamp").ToString.Substring(0, 5)
            Label13.Text = sql_data_reader.Item("arr_timestamp").ToString.Substring(0, 5)
            Label12.Text = sql_data_reader.Item("trip_date").ToString.Substring(0, 10)
        End While
        sql_data_reader.Close()


    End Sub
    ' Pesquisar Estação
    Private Sub Button2_Click(sender As Object, e As EventArgs) Handles Button2.Click
        Me.Hide()
        SearchStation.Show()
    End Sub
    ' Ver Perfil
    Private Sub Button3_Click(sender As Object, e As EventArgs) Handles Button3.Click
        Me.Hide()
        Profile.Show()
    End Sub
    ' Minhas Viagens
    Private Sub Button4_Click(sender As Object, e As EventArgs) Handles Button4.Click
        Me.Close()
        MyTrips.Show()
    End Sub
    ' Planear Viagem
    Private Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        Me.Close()
        PlanTrip.Show()
    End Sub
    ' Log out
    Private Sub PictureBox2_Click(sender As Object, e As EventArgs) Handles PictureBox2.Click
        Me.Close()
        Login.Show()
    End Sub
    ' Log out no label
    Private Sub Label3_Click(sender As Object, e As EventArgs) Handles Label3.Click
        Me.Close()
        Login.Show()
    End Sub

End Class