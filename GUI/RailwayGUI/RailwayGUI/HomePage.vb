Public Class HomePage

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
        Me.Hide()
        DisplaySearch.Show()
    End Sub

    ' Planear Viagem
    Private Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        Me.Hide()
        PlanTrip.Show()
    End Sub
End Class