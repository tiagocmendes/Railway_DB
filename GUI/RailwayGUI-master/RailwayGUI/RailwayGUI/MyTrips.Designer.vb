<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class MyTrips
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        Try
            If disposing AndAlso components IsNot Nothing Then
                components.Dispose()
            End If
        Finally
            MyBase.Dispose(disposing)
        End Try
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(MyTrips))
        Me.ListView1 = New System.Windows.Forms.ListView()
        Me.Ticket_no = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        Me.From = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        Me.To_Station = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        Me.Departure = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        Me.Arrival = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        Me.Train = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        Me.Carriage = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        Me.Seat = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        Me.Price = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        Me.Trip_date = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        Me.Duration = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        Me.TripType = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        Me.PictureBox1 = New System.Windows.Forms.PictureBox()
        Me.Label7 = New System.Windows.Forms.Label()
        Me.PictureBox5 = New System.Windows.Forms.PictureBox()
        CType(Me.PictureBox1, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.PictureBox5, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'ListView1
        '
        Me.ListView1.BackColor = System.Drawing.Color.White
        Me.ListView1.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.Ticket_no, Me.From, Me.To_Station, Me.Departure, Me.Arrival, Me.Train, Me.Carriage, Me.Seat, Me.Price, Me.Trip_date, Me.Duration, Me.TripType})
        Me.ListView1.Location = New System.Drawing.Point(9, 117)
        Me.ListView1.MultiSelect = False
        Me.ListView1.Name = "ListView1"
        Me.ListView1.Size = New System.Drawing.Size(780, 268)
        Me.ListView1.TabIndex = 80
        Me.ListView1.UseCompatibleStateImageBehavior = False
        Me.ListView1.View = System.Windows.Forms.View.Details
        '
        'Ticket_no
        '
        Me.Ticket_no.Text = "Ticket no."
        Me.Ticket_no.Width = 62
        '
        'From
        '
        Me.From.Text = "From"
        Me.From.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
        Me.From.Width = 92
        '
        'To_Station
        '
        Me.To_Station.Text = "To"
        Me.To_Station.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
        Me.To_Station.Width = 102
        '
        'Departure
        '
        Me.Departure.Text = "Departure"
        Me.Departure.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
        Me.Departure.Width = 59
        '
        'Arrival
        '
        Me.Arrival.Text = "Arrival"
        Me.Arrival.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
        Me.Arrival.Width = 47
        '
        'Train
        '
        Me.Train.Text = "Train no."
        Me.Train.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
        '
        'Carriage
        '
        Me.Carriage.Text = "Carriage"
        Me.Carriage.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
        Me.Carriage.Width = 52
        '
        'Seat
        '
        Me.Seat.Text = "Seat "
        Me.Seat.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
        Me.Seat.Width = 41
        '
        'Price
        '
        Me.Price.Text = "Price"
        Me.Price.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
        Me.Price.Width = 44
        '
        'Trip_date
        '
        Me.Trip_date.Text = "Trip date"
        Me.Trip_date.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
        Me.Trip_date.Width = 62
        '
        'Duration
        '
        Me.Duration.Text = "Duration"
        Me.Duration.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
        Me.Duration.Width = 66
        '
        'TripType
        '
        Me.TripType.Text = "Trip type"
        Me.TripType.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
        Me.TripType.Width = 94
        '
        'PictureBox1
        '
        Me.PictureBox1.BackColor = System.Drawing.Color.FromArgb(CType(CType(8, Byte), Integer), CType(CType(147, Byte), Integer), CType(CType(68, Byte), Integer))
        Me.PictureBox1.Image = Global.RailwayGUI.My.Resources.Resources.back_icon_white
        Me.PictureBox1.Location = New System.Drawing.Point(14, 5)
        Me.PictureBox1.Name = "PictureBox1"
        Me.PictureBox1.Size = New System.Drawing.Size(50, 50)
        Me.PictureBox1.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom
        Me.PictureBox1.TabIndex = 77
        Me.PictureBox1.TabStop = False
        '
        'Label7
        '
        Me.Label7.AutoSize = True
        Me.Label7.BackColor = System.Drawing.Color.FromArgb(CType(CType(8, Byte), Integer), CType(CType(147, Byte), Integer), CType(CType(68, Byte), Integer))
        Me.Label7.Font = New System.Drawing.Font("Montserrat SemiBold", 14.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label7.ForeColor = System.Drawing.Color.White
        Me.Label7.Location = New System.Drawing.Point(73, 19)
        Me.Label7.Name = "Label7"
        Me.Label7.Size = New System.Drawing.Size(93, 26)
        Me.Label7.TabIndex = 78
        Me.Label7.Text = "My Trips"
        '
        'PictureBox5
        '
        Me.PictureBox5.BackColor = System.Drawing.Color.FromArgb(CType(CType(8, Byte), Integer), CType(CType(147, Byte), Integer), CType(CType(68, Byte), Integer))
        Me.PictureBox5.Location = New System.Drawing.Point(-1, 1)
        Me.PictureBox5.Name = "PictureBox5"
        Me.PictureBox5.Size = New System.Drawing.Size(803, 60)
        Me.PictureBox5.TabIndex = 79
        Me.PictureBox5.TabStop = False
        '
        'MyTrips
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.BackColor = System.Drawing.Color.White
        Me.ClientSize = New System.Drawing.Size(800, 450)
        Me.Controls.Add(Me.ListView1)
        Me.Controls.Add(Me.PictureBox1)
        Me.Controls.Add(Me.Label7)
        Me.Controls.Add(Me.PictureBox5)
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.Name = "MyTrips"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Railway | MyTrips"
        CType(Me.PictureBox1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.PictureBox5, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub

    Friend WithEvents ListView1 As ListView
    Friend WithEvents Ticket_no As ColumnHeader
    Friend WithEvents PictureBox1 As PictureBox
    Friend WithEvents Label7 As Label
    Friend WithEvents PictureBox5 As PictureBox
    Friend WithEvents From As ColumnHeader
    Friend WithEvents To_Station As ColumnHeader
    Friend WithEvents Departure As ColumnHeader
    Friend WithEvents Arrival As ColumnHeader
    Friend WithEvents Train As ColumnHeader
    Friend WithEvents Carriage As ColumnHeader
    Friend WithEvents Seat As ColumnHeader
    Friend WithEvents Price As ColumnHeader
    Friend WithEvents Trip_date As ColumnHeader
    Friend WithEvents Duration As ColumnHeader
    Friend WithEvents TripType As ColumnHeader
End Class
