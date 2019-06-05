USE p6g10;
GO


ALTER PROC Railway.pr_edit_profile	@email VARCHAR(50), 
									@nif INT, 
									@fname VARCHAR(30), 
									@lname VARCHAR(30), 
									--@bdate DATE, 
									@gender CHAR, 
									@postal_code VARCHAR(50), 
									@city VARCHAR(50), 
									@country VARCHAR(50), 
									@phone INT,
									@new_password VARCHAR(50)
AS
BEGIN
	-- Change fname
	IF NOT (@fname LIKE 'NULL')
		UPDATE Railway.Person SET fname = @fname WHERE nif = @nif;
	-- Change lname
	IF NOT (@lname LIKE 'NULL')
		UPDATE Railway.Person SET lname = @lname WHERE nif = @nif;
	-- Change gender
	IF NOT (@gender LIKE 'N')
		UPDATE Railway.Person SET gender = @gender WHERE nif = @nif;
	-- Change postal code
	IF NOT (@postal_code LIKE 'NULL')
		UPDATE Railway.Person SET postal_code = @postal_code WHERE nif = @nif;
	-- Change city
	IF NOT (@city LIKE 'NULL')
		UPDATE Railway.Person SET city = @city WHERE nif = @nif;
	-- Change country
	IF NOT (@country LIKE 'NULL')
		UPDATE Railway.Person SET country = @country WHERE nif = @nif;
	-- Change phone
	IF NOT (@phone = 0)
		UPDATE Railway.Person SET phone = @phone WHERE nif = @nif;
	-- Change password
	IF NOT (@new_password LIKE 'NULL')
		UPDATE Railway.Passenger SET pw = HASHBYTES('SHA1', @new_password) WHERE email = @email;
END
GO

