USE p6g10;
GO
ALTER PROC Railway.pr_delete_profile (	@user_id INT,
										@nif INT)
AS
BEGIN
	DELETE FROM Railway.Ticket WHERE nif = @nif;
	DELETE FROM Railway.Passenger WHERE passenger_id = @user_id;
	DELETE FROM Railway.Person WHERE id = @user_id;
END
GO