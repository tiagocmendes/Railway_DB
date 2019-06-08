Public Class SaveImages
    Public Shared Function ToBase64String(filePath As String) As String
        Dim aImage = New Bitmap(filePath)
        Dim aspectRatio As Double = aImage.Height / aImage.Width
        Dim imgThumb = New Bitmap(aImage, 200, CInt(Math.Round(200 * aspectRatio)))
        Using stream = New IO.MemoryStream
            Using img As Image = Image.FromFile(filePath)
                If img.RawFormat.Equals(Imaging.ImageFormat.Jpeg) Then
                    imgThumb.Save(stream, Imaging.ImageFormat.Jpeg)
                ElseIf img.RawFormat.Equals(Imaging.ImageFormat.Png) Then
                    imgThumb.Save(stream, Imaging.ImageFormat.Png)
                ElseIf img.RawFormat.Equals(Imaging.ImageFormat.Icon) Then
                    imgThumb.Save(stream, Imaging.ImageFormat.Icon)
                End If
            End Using
            Return Convert.ToBase64String(stream.ToArray)
        End Using
    End Function

    Public Shared Function Base64ToImage(ByVal base64string As String) As System.Drawing.Image
        'Setup image and get data stream together
        Dim img As System.Drawing.Image
        Dim MS As System.IO.MemoryStream = New System.IO.MemoryStream
        Dim b64 As String = base64string.Replace(" ", "+")
        Dim b() As Byte

        'Converts the base64 encoded msg to image data
        b = Convert.FromBase64String(b64)
        MS = New System.IO.MemoryStream(b)

        'creates image
        img = System.Drawing.Image.FromStream(MS)

        Return img
    End Function

End Class
