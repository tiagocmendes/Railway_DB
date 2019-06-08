Public Class CompleteBuy
    Private Sub CompleteBuy_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Timer1.Interval = 3000
        Timer1.Start()
    End Sub

    Private Sub Timer1_Tick(sender As Object, e As EventArgs) Handles Timer1.Tick
        Timer1.Stop()
        Me.Close()
        HomePage.Show()
    End Sub
End Class