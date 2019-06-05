USE p6g10;
GO
ALTER PROC Railway.pr_forgot_password (@email VARCHAR(50),
										@password VARCHAR(50))
AS
BEGIN
	UPDATE Railway.Passenger SET email = @email WHERE email = @email;
	UPDATE Railway.Passenger SET pw = HASHBYTES('SHA1', @password) WHERE email = @email;
END
GO

