Public Class Modal
    ' No
    Private Sub Button4_Click(sender As Object, e As EventArgs) Handles Button4.Click
        Me.Close()
        EditProfile.Show()
    End Sub
    ' Yes
    Private Sub Button3_Click(sender As Object, e As EventArgs) Handles Button3.Click
        Me.Close()
        EditProfile.Close()
        Profile.Show()
    End Sub
End Class