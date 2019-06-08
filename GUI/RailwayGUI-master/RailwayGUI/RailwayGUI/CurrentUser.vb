Public Class CurrentUser
    Private _userID As String
    Private _fname As String
    Private _lname As String
    Private _birthdate As String
    Private _nif As String
    Private _gender As String
    Private _postalCode As String
    Private _city As String
    Private _country As String
    Private _phone As String
    Private _passengerID As String
    Private _email As String
    Private _profilePic As String

    'Constructor
    Public Sub New(
        ByVal _userID As String,
        ByVal _fname As String,
        ByVal _lname As String,
        ByVal _birthdate As String,
        ByVal _nif As String,
        ByVal _gender As String,
        ByVal _postalCode As String,
        ByVal _city As String,
        ByVal _country As String,
        ByVal _phone As String,
        ByVal _passengerID As String,
        ByVal _email As String)

        Me._userID = _userID
        Me._fname = _fname
        Me._lname = _lname
        Me._birthdate = _birthdate
        Me._nif = _nif
        Me._gender = _gender
        Me._postalCode = _postalCode
        Me._city = _city
        Me._country = _country
        Me._phone = _phone
        Me._passengerID = _passengerID
        Me._email = _email

    End Sub
    Public Property user_id() As String
        Get
            Return Me._userID
        End Get
        Set(ByVal value As String)
            Me._userID = value
        End Set
    End Property

    Public Property fname() As String
        Get
            Return Me._fname
        End Get
        Set(ByVal value As String)
            Me._fname = value
        End Set
    End Property

    Public Property lname() As String
        Get
            Return Me._lname
        End Get
        Set(ByVal value As String)
            Me._lname = value
        End Set
    End Property

    Public Property birthdate() As String
        Get
            Return Me._birthdate
        End Get
        Set(ByVal value As String)
            Me._birthdate = value
        End Set
    End Property

    Public Property nif() As String
        Get
            Return Me._nif
        End Get
        Set(ByVal value As String)
            Me._nif = value
        End Set
    End Property

    Public Property gender() As String
        Get
            Return Me._gender
        End Get
        Set(ByVal value As String)
            Me._gender = value
        End Set
    End Property

    Public Property postalCode() As String
        Get
            Return Me._postalCode
        End Get
        Set(ByVal value As String)
            Me._postalCode = value
        End Set
    End Property

    Public Property city() As String
        Get
            Return Me._city
        End Get
        Set(ByVal value As String)
            Me._city = value
        End Set
    End Property

    Public Property country() As String
        Get
            Return Me._country
        End Get
        Set(ByVal value As String)
            Me._country = value
        End Set
    End Property

    Public Property phone() As String
        Get
            Return Me._phone
        End Get
        Set(ByVal value As String)
            Me._phone = value
        End Set
    End Property

    Public Property passengerID() As String
        Get
            Return Me._passengerID
        End Get
        Set(ByVal value As String)
            Me._passengerID = value
        End Set
    End Property

    Public Property email() As String
        Get
            Return Me._email
        End Get
        Set(ByVal value As String)
            Me._email = value
        End Set
    End Property

    Public Property profilePicture() As String
        Get
            Return Me._profilePic
        End Get
        Set(ByVal value As String)
            Me._profilePic = value
        End Set
    End Property

    Overrides Function ToString() As String
        Return "ID: " + _userID +
            ", First Name: " + _fname + ", Last Name: " + _lname +
            ", Birthdate: " + _birthdate + ", NIF: " + _nif + ", Gender: " + _gender +
            ", Postal Code: " + _postalCode + ", City: " + _city + ", Country: " + _country +
            ", Phone: " + _phone + ", Passenger ID: " + _passengerID + ", Email: " + email
    End Function
End Class
