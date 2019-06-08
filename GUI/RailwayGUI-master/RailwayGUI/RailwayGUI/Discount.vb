Imports System.Data.SqlClient
Public Class Discount
    Public sql_connection As SqlConnection
    Public sql_command As SqlCommand
    Public sql_data_reader As SqlDataReader
    Public discount As String
    Public finalprice As Double

    Private Sub Discount_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Label3.Text = "" + RailwayModule.price + " €"
        sql_connection = RailwayModule.my_sql_connection.getConnection
        sql_command = New SqlCommand()
        sql_command.Connection = sql_connection
        finalprice = RailwayModule.price
    End Sub

    Private Sub TextBox1_TextChanged(sender As Object, e As EventArgs) Handles TextBox1.TextChanged
        sql_command.CommandText = "SELECT Railway.f_check_discount('" + TextBox1.Text + "');"
        If sql_command.ExecuteScalar = 1 Then
            RailwayModule.promocode = TextBox1.Text
            finalprice = CDbl(RailwayModule.price)
            sql_command.CommandText = "EXEC Railway.pr_get_discount '" + TextBox1.Text + "';"
            discount = sql_command.ExecuteScalar
            RailwayModule.discount = discount.ToString
            Label5.Text = "" + discount.ToString + " %"
            Label5.Visible = True
            finalprice = CDbl(RailwayModule.price) * (1 - CDbl(discount) / 100)
            Label3.Text = "" + finalprice.ToString + " €"
        End If
    End Sub

    Private Sub PictureBox1_Click(sender As Object, e As EventArgs) Handles PictureBox1.Click
        Me.Close()
        ChooseSeat.Show()
    End Sub

    Private Sub PictureBox3_Click(sender As Object, e As EventArgs) Handles PictureBox3.Click
        RailwayModule.price = finalprice
        Me.Hide()
        CheckOut.Show()
    End Sub
End Class