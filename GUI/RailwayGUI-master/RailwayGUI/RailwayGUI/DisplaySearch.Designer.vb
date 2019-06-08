<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
Partial Class DisplaySearch
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()>
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
    <System.Diagnostics.DebuggerStepThrough()>
    Private Sub InitializeComponent()
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(DisplaySearch))
        Me.Label7 = New System.Windows.Forms.Label()
        Me.ListView1 = New System.Windows.Forms.ListView()
        Me.Trip_number = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        Me.Category = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        Me.Departure = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        Me.Arrival = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        Me.Duration = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        Me.Price = CType(New System.Windows.Forms.ColumnHeader(), System.Windows.Forms.ColumnHeader)
        Me.PictureBox1 = New System.Windows.Forms.PictureBox()
        Me.PictureBox5 = New System.Windows.Forms.PictureBox()
        CType(Me.PictureBox1, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.PictureBox5, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'Label7
        '
        Me.Label7.AutoSize = True
        Me.Label7.BackColor = System.Drawing.Color.FromArgb(CType(CType(8, Byte), Integer), CType(CType(147, Byte), Integer), CType(CType(68, Byte), Integer))
        Me.Label7.Font = New System.Drawing.Font("Montserrat SemiBold", 14.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label7.ForeColor = System.Drawing.Color.White
        Me.Label7.Location = New System.Drawing.Point(81, 16)
        Me.Label7.Name = "Label7"
        Me.Label7.Size = New System.Drawing.Size(133, 26)
        Me.Label7.TabIndex = 73
        Me.Label7.Text = "Display trips"
        '
        'ListView1
        '
        Me.ListView1.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.Trip_number, Me.Category, Me.Departure, Me.Arrival, Me.Duration, Me.Price})
        Me.ListView1.Location = New System.Drawing.Point(125, 108)
        Me.ListView1.MultiSelect = False
        Me.ListView1.Name = "ListView1"
        Me.ListView1.Size = New System.Drawing.Size(540, 268)
        Me.ListView1.TabIndex = 76
        Me.ListView1.UseCompatibleStateImageBehavior = False
        Me.ListView1.View = System.Windows.Forms.View.Details
        '
        'Trip_number
        '
        Me.Trip_number.Text = "Trip number"
        Me.Trip_number.Width = 90
        '
        'Category
        '
        Me.Category.Text = "Category"
        Me.Category.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
        Me.Category.Width = 90
        '
        'Departure
        '
        Me.Departure.Text = "Departure"
        Me.Departure.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
        Me.Departure.Width = 90
        '
        'Arrival
        '
        Me.Arrival.Text = "Arrival"
        Me.Arrival.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
        Me.Arrival.Width = 90
        '
        'Duration
        '
        Me.Duration.Text = "Duration"
        Me.Duration.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
        Me.Duration.Width = 90
        '
        'Price
        '
        Me.Price.Text = "Price"
        Me.Price.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
        Me.Price.Width = 90
        '
        'PictureBox1
        '
        Me.PictureBox1.BackColor = System.Drawing.Color.FromArgb(CType(CType(8, Byte), Integer), CType(CType(147, Byte), Integer), CType(CType(68, Byte), Integer))
        Me.PictureBox1.Image = Global.RailwayGUI.My.Resources.Resources.back_icon_white
        Me.PictureBox1.Location = New System.Drawing.Point(19, 4)
        Me.PictureBox1.Name = "PictureBox1"
        Me.PictureBox1.Size = New System.Drawing.Size(50, 50)
        Me.PictureBox1.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom
        Me.PictureBox1.TabIndex = 72
        Me.PictureBox1.TabStop = False
        '
        'PictureBox5
        '
        Me.PictureBox5.BackColor = System.Drawing.Color.FromArgb(CType(CType(8, Byte), Integer), CType(CType(147, Byte), Integer), CType(CType(68, Byte), Integer))
        Me.PictureBox5.Location = New System.Drawing.Point(0, -2)
        Me.PictureBox5.Name = "PictureBox5"
        Me.PictureBox5.Size = New System.Drawing.Size(803, 60)
        Me.PictureBox5.TabIndex = 74
        Me.PictureBox5.TabStop = False
        '
        'DisplaySearch
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.BackColor = System.Drawing.Color.White
        Me.ClientSize = New System.Drawing.Size(784, 441)
        Me.Controls.Add(Me.ListView1)
        Me.Controls.Add(Me.PictureBox1)
        Me.Controls.Add(Me.Label7)
        Me.Controls.Add(Me.PictureBox5)
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.Name = "DisplaySearch"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "DisplaySearch"
        CType(Me.PictureBox1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.PictureBox5, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents PictureBox1 As PictureBox
    Friend WithEvents Label7 As Label
    Friend WithEvents PictureBox5 As PictureBox
    Friend WithEvents ListView1 As ListView
    Friend WithEvents Trip_number As ColumnHeader
    Friend WithEvents Category As ColumnHeader
    Friend WithEvents Departure As ColumnHeader
    Friend WithEvents Arrival As ColumnHeader
    Friend WithEvents Duration As ColumnHeader
    Friend WithEvents Price As ColumnHeader
End Class
