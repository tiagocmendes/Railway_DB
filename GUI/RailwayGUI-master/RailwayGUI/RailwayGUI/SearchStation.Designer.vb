<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class SearchStation
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
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(SearchStation))
        Me.Label1 = New System.Windows.Forms.Label()
        Me.search_box = New System.Windows.Forms.TextBox()
        Me.PictureBox2 = New System.Windows.Forms.PictureBox()
        Me.PictureBox1 = New System.Windows.Forms.PictureBox()
        Me.Label2 = New System.Windows.Forms.Label()
        Me.PictureBox5 = New System.Windows.Forms.PictureBox()
        Me.stations = New System.Windows.Forms.ListView()
        Me.station_name = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        Me.locality = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        Me.zone_number = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        Me.zone_name = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        Me.director_name = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        CType(Me.PictureBox2, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.PictureBox1, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.PictureBox5, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Font = New System.Drawing.Font("Microsoft Sans Serif", 12.0!)
        Me.Label1.ForeColor = System.Drawing.Color.White
        Me.Label1.Location = New System.Drawing.Point(111, 115)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(64, 20)
        Me.Label1.TabIndex = 58
        Me.Label1.Text = "Search:"
        '
        'search_box
        '
        Me.search_box.BackColor = System.Drawing.Color.White
        Me.search_box.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.search_box.Location = New System.Drawing.Point(140, 92)
        Me.search_box.Name = "search_box"
        Me.search_box.Size = New System.Drawing.Size(474, 20)
        Me.search_box.TabIndex = 59
        '
        'PictureBox2
        '
        Me.PictureBox2.Image = CType(resources.GetObject("PictureBox2.Image"), System.Drawing.Image)
        Me.PictureBox2.Location = New System.Drawing.Point(637, 87)
        Me.PictureBox2.Name = "PictureBox2"
        Me.PictureBox2.Size = New System.Drawing.Size(32, 32)
        Me.PictureBox2.SizeMode = System.Windows.Forms.PictureBoxSizeMode.CenterImage
        Me.PictureBox2.TabIndex = 62
        Me.PictureBox2.TabStop = False
        '
        'PictureBox1
        '
        Me.PictureBox1.BackColor = System.Drawing.Color.FromArgb(CType(CType(8, Byte), Integer), CType(CType(147, Byte), Integer), CType(CType(68, Byte), Integer))
        Me.PictureBox1.Image = Global.RailwayGUI.My.Resources.Resources.back_icon_white
        Me.PictureBox1.Location = New System.Drawing.Point(18, 7)
        Me.PictureBox1.Name = "PictureBox1"
        Me.PictureBox1.Size = New System.Drawing.Size(50, 50)
        Me.PictureBox1.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom
        Me.PictureBox1.TabIndex = 72
        Me.PictureBox1.TabStop = False
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.BackColor = System.Drawing.Color.FromArgb(CType(CType(8, Byte), Integer), CType(CType(147, Byte), Integer), CType(CType(68, Byte), Integer))
        Me.Label2.Font = New System.Drawing.Font("Montserrat SemiBold", 14.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label2.ForeColor = System.Drawing.Color.White
        Me.Label2.Location = New System.Drawing.Point(80, 19)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(155, 26)
        Me.Label2.TabIndex = 73
        Me.Label2.Text = "Search Station"
        '
        'PictureBox5
        '
        Me.PictureBox5.BackColor = System.Drawing.Color.FromArgb(CType(CType(8, Byte), Integer), CType(CType(147, Byte), Integer), CType(CType(68, Byte), Integer))
        Me.PictureBox5.Location = New System.Drawing.Point(-10, -1)
        Me.PictureBox5.Name = "PictureBox5"
        Me.PictureBox5.Size = New System.Drawing.Size(818, 65)
        Me.PictureBox5.TabIndex = 74
        Me.PictureBox5.TabStop = False
        '
        'stations
        '
        Me.stations.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.station_name, Me.locality, Me.zone_number, Me.zone_name, Me.director_name})
        Me.stations.Location = New System.Drawing.Point(41, 138)
        Me.stations.MultiSelect = False
        Me.stations.Name = "stations"
        Me.stations.Size = New System.Drawing.Size(723, 300)
        Me.stations.TabIndex = 77
        Me.stations.UseCompatibleStateImageBehavior = False
        Me.stations.View = System.Windows.Forms.View.Details
        '
        'station_name
        '
        Me.station_name.Text = "Station Name"
        Me.station_name.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
        Me.station_name.Width = 160
        '
        'locality
        '
        Me.locality.Text = "Locality"
        Me.locality.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
        Me.locality.Width = 160
        '
        'zone_number
        '
        Me.zone_number.Text = "Zone Number"
        Me.zone_number.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
        Me.zone_number.Width = 80
        '
        'zone_name
        '
        Me.zone_name.Text = "Zone Name"
        Me.zone_name.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
        Me.zone_name.Width = 160
        '
        'director_name
        '
        Me.director_name.Text = "Director Name"
        Me.director_name.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
        Me.director_name.Width = 160
        '
        'SearchStation
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.BackColor = System.Drawing.Color.White
        Me.ClientSize = New System.Drawing.Size(800, 450)
        Me.Controls.Add(Me.stations)
        Me.Controls.Add(Me.PictureBox1)
        Me.Controls.Add(Me.Label2)
        Me.Controls.Add(Me.PictureBox5)
        Me.Controls.Add(Me.PictureBox2)
        Me.Controls.Add(Me.search_box)
        Me.Controls.Add(Me.Label1)
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.Name = "SearchStation"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Railway | SearchStation"
        CType(Me.PictureBox2, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.PictureBox1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.PictureBox5, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents Label1 As Label
    Friend WithEvents search_box As TextBox
    Friend WithEvents PictureBox2 As PictureBox
    Friend WithEvents PictureBox1 As PictureBox
    Friend WithEvents Label2 As Label
    Friend WithEvents PictureBox5 As PictureBox
    Friend WithEvents stations As ListView
    Friend WithEvents zone_number As ColumnHeader
    Friend WithEvents zone_name As ColumnHeader
    Friend WithEvents station_name As ColumnHeader
    Friend WithEvents locality As ColumnHeader
    Friend WithEvents director_name As ColumnHeader
End Class
