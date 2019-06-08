Imports System.Data.SqlClient
Public Class CheckOut
    Public sql_connection As SqlConnection
    Public sql_command As SqlCommand
    Public sql_data_reader As SqlDataReader
    Private Sub CheckOut_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Label30.Text = RailwayModule.trip_type
        Label3.Text = RailwayModule.dep_station
        Label6.Text = RailwayModule.arr_station
        Label8.Text = RailwayModule.trip_date
        Label10.Text = RailwayModule.dep_timestamp
        Label12.Text = RailwayModule.arr_timestamp
        Label16.Text = RailwayModule.duration
        Label26.Text = RailwayModule.train_no
        Label24.Text = RailwayModule.carriage_class
        Label22.Text = RailwayModule.carriage_no
        Label20.Text = RailwayModule.seat01

        If Not RailwayModule.seat02 = "" Then
            Label18.Visible = True
            Label19.Visible = True
            Label18.Text = RailwayModule.seat02
        End If

        If Not RailwayModule.seat03 = "" Then
            Label15.Visible = True
            Label14.Visible = True
            Label14.Text = RailwayModule.seat03
        End If



        sql_connection = RailwayModule.my_sql_connection.getConnection
        sql_command = New SqlCommand("EXEC Railway.get_next_ticket_no;", sql_connection)

        RailwayModule.ticket_no = sql_command.ExecuteScalar
        Label40.Text = RailwayModule.ticket_no

        Label38.Text = RailwayModule.currentUser.nif
        Label36.Text = RailwayModule.baseprice + " €"
        If Not RailwayModule.promocode = "" Then
            Label45.Visible = True
            Label33.Visible = True
            Label44.Visible = True
            Label32.Visible = True
            Label44.Text = RailwayModule.promocode
            Label32.Text = RailwayModule.discount + " %"
        End If

        Label34.Text = RailwayModule.price + " €"

        sql_command.CommandText = "EXEC Railway.pr_get_station_no '" + RailwayModule.dep_station + "';"
        RailwayModule.dep_station_name = sql_command.ExecuteScalar
        sql_command.CommandText = "EXEC Railway.pr_get_station_no '" + RailwayModule.arr_station + "';"
        RailwayModule.arr_station_name = sql_command.ExecuteScalar

    End Sub
    ' Go back
    Private Sub PictureBox1_Click(sender As Object, e As EventArgs) Handles PictureBox1.Click
        Me.Close()
        Discount.Show()
    End Sub

    Private Sub PictureBox4_Click(sender As Object, e As EventArgs) Handles PictureBox4.Click
        DisplaySearch.Close()
        ChooseClass.Close()
        ChooseSeat.Close()
        Discount.Close()
        Me.Close()
        HomePage.Show()
    End Sub

    Private Sub PictureBox3_Click(sender As Object, e As EventArgs) Handles PictureBox3.Click
        Dim each_price = CDbl(RailwayModule.price)
        If Not RailwayModule.seat02 = "" And Not RailwayModule.seat03 = "" Then
            each_price = CDbl(RailwayModule.price) / 3
        ElseIf Not RailwayModule.seat02 = "" Then
            each_price = CDbl(RailwayModule.price) / 2
        End If

        sql_command.CommandText = "EXEC Railway.pr_buy_ticket " + RailwayModule.currentUser.nif.ToString + "," + RailwayModule.dep_station_name + "," + RailwayModule.arr_station_name + ", '" + RailwayModule.dep_timestamp + "', '" + RailwayModule.arr_timestamp + "', " + RailwayModule.train_no + ", " + RailwayModule.carriage_no + ", " + RailwayModule.seat01 + ", " + each_price.ToString.Split(",")(0) + "." + each_price.ToString.Split(",")(1) + ", " + RailwayModule.chosen_trip + ", '" + RailwayModule.trip_date + "', " + RailwayModule.currentUser.user_id.ToString + ", '" + RailwayModule.duration + "', '" + RailwayModule.trip_type + "';"
        sql_command.ExecuteScalar()

        If Not RailwayModule.seat02 = "" Then
            sql_command.CommandText = "EXEC Railway.pr_buy_ticket " + RailwayModule.currentUser.nif.ToString + "," + RailwayModule.dep_station_name + "," + RailwayModule.arr_station_name + ", '" + RailwayModule.dep_timestamp + "', '" + RailwayModule.arr_timestamp + "', " + RailwayModule.train_no + ", " + RailwayModule.carriage_no + ", " + RailwayModule.seat02 + ", " + each_price.ToString.Split(",")(0) + "." + each_price.ToString.Split(",")(1) + ", " + RailwayModule.chosen_trip + ", '" + RailwayModule.trip_date + "', " + RailwayModule.currentUser.user_id.ToString + ", '" + RailwayModule.duration + "', '" + RailwayModule.trip_type + "';"
            sql_command.ExecuteScalar()
        End If

        If Not RailwayModule.seat03 = "" Then
            sql_command.CommandText = "EXEC Railway.pr_buy_ticket " + RailwayModule.currentUser.nif.ToString + "," + RailwayModule.dep_station_name + "," + RailwayModule.arr_station_name + ", '" + RailwayModule.dep_timestamp + "', '" + RailwayModule.arr_timestamp + "', " + RailwayModule.train_no + ", " + RailwayModule.carriage_no + ", " + RailwayModule.seat03 + ", " + each_price.ToString.Split(",")(0) + "." + each_price.ToString.Split(",")(1) + ", " + RailwayModule.chosen_trip + ", '" + RailwayModule.trip_date + "', " + RailwayModule.currentUser.user_id.ToString + ", '" + RailwayModule.duration + "', '" + RailwayModule.trip_type + "';"
            sql_command.ExecuteScalar()
        End If

        DisplaySearch.Close()
        ChooseClass.Close()
        ChooseSeat.Close()
        Discount.Close()
        Me.Close()
        CompleteBuy.Show()

    End Sub

End Class