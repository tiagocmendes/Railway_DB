-- Tem de checkar id do atual user
--	
USE p6g10;
GO


ALTER PROC Railway.pr_edit_profile @email VARCHAR(50), @nif INT, @fname VARCHAR(30), @lname VARCHAR(30), @bdate DATE, @gender CHAR, @postal_code VARCHAR(50), 
									@city VARCHAR(50), @country VARCHAR(50), @new_password VARCHAR(50)
AS
BEGIN
	-- Change fname
	IF (@fname <> NULL)
		UPDATE Railway.Person SET fname = @fname WHERE nif = @nif;
	-- Change lname
	IF (@lname <> NULL)
		UPDATE Railway.Person SET lname = @lname WHERE nif = @nif;
	-- Change bdate
	IF (@bdate <> NULL)
		UPDATE Railway.Person SET fname = @bdate WHERE nif = @nif;
	-- Change gender
	IF (@gender <> NULL)
		UPDATE Railway.Person SET gender = @gender WHERE nif = @nif;
	-- Change postal code
	IF (@postal_code <> NULL)
		UPDATE Railway.Person SET postal_code = @postal_code WHERE nif = @nif;
	-- Change city
	IF (@city <> NULL)
		UPDATE Railway.Person SET city = @city WHERE nif = @nif;
	-- Change country
	IF (@country <> NULL)
		UPDATE Railway.Person SET country = @country WHERE nif = @nif;
	-- Change password
	IF (@new_password  <> NULL)
		UPDATE Railway.Passenger SET pw = @new_password  WHERE email = @email;
END
GO

